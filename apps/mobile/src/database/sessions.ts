import { Q, type Model } from '@nozbe/watermelondb';
import { database } from './index';
import { CookingSessionRecord, Ingredient, Recipe, RecipeIngredient, RecipeStep, UserPantry, type StorageLocation } from './models';
import { LOCAL_GUEST_ID } from './constants';
import { planCompletion, planUndo, scaleIngredients, type ConsumedStock } from '../engine/cookingSession';
import type { CookingTimer } from '../services/timer/TimerManager';
import { readDocument } from './documents';
import type { RecipeMetadata } from './recipeMetadata';

export interface SessionData {
  title: string; servings: number; startedAt: number; stepIndex: number;
  ingredients: { ingredientId: string; name: string; amount: number; unit: string }[];
  steps: { id: string; stepNumber: number; instruction: string; timerDurationSeconds: number; mediaUrl?: string; mimeType?: string }[];
  timers: CookingTimer[]; consumed: ConsumedStock[];
}
export interface Session { id: string; recipeId: string; status: CookingSessionRecord['status']; data: SessionData }
const asSession = (row: CookingSessionRecord): Session => ({ id: row.id, recipeId: row.recipeId, status: row.status, data: JSON.parse(row.payload) as SessionData });

export async function getSession(id: string): Promise<Session> {
  return asSession(await database.get<CookingSessionRecord>('cooking_sessions').find(id));
}

export async function startOrResumeSession(recipeId: string, servings?: number): Promise<Session> {
  return database.write(async () => {
    const sessions = database.get<CookingSessionRecord>('cooking_sessions');
    const existing = await sessions.query(Q.where('recipe_id', recipeId), Q.where('status', 'active')).fetch();
    if (existing[0]) return asSession(existing[0]);
    const recipe = await database.get<Recipe>('local_recipes').find(recipeId);
    const metadata = await readDocument<RecipeMetadata>(`recipe-meta-${recipeId}`);
    const [requirements, steps, dictionary] = await Promise.all([
      recipe.ingredients.fetch(), recipe.steps.fetch(), database.get<Ingredient>('ingredients').query().fetch(),
    ]);
    const names = new Map(dictionary.map((item) => [item.id, item.displayName]));
    const ingredients = scaleIngredients(requirements.map((r: RecipeIngredient) => {
      const name = names.get(r.ingredientId);
      if (!name) throw new Error('An ingredient name is missing. Repair this recipe before cooking.');
      return { ingredientId: r.ingredientId, name, amount: r.amount, unit: r.unit };
    }), recipe.servings, servings ?? recipe.servings);
    const ordered = steps.map((s: RecipeStep) => ({ id: s.id, stepNumber: s.stepNumber, instruction: s.instruction,
      timerDurationSeconds: s.timerDurationSeconds, mediaUrl: s.mediaUrl ?? undefined,
      mimeType: metadata?.mediaAssets?.find((a) => a.url === s.mediaUrl)?.mimeType })).sort((a, b) => a.stepNumber - b.stepNumber);
    if (!ingredients.length || !ordered.length || ordered.some((s) => !s.instruction.trim() || !Number.isFinite(s.timerDurationSeconds) || s.timerDurationSeconds < 0))
      throw new Error('This recipe needs complete ingredients, steps, and valid timers.');
    const data: SessionData = { title: recipe.title, servings: servings ?? recipe.servings, startedAt: Date.now(),
      stepIndex: 0, ingredients, steps: ordered, consumed: [], timers: ordered.filter((s) => s.timerDurationSeconds > 0).map((s) => ({
        id: `timer-step-${s.stepNumber}`, stepNumber: s.stepNumber, label: `Step ${s.stepNumber} Timer`,
        totalDurationSeconds: s.timerDurationSeconds, remainingSeconds: s.timerDurationSeconds, status: 'idle', targetEndTimeMs: null, pausedRemainingSeconds: null,
      })) };
    const row = await sessions.create((r) => { r.recipeId = recipeId; r.status = 'active'; r.payload = JSON.stringify(data); r.updatedAt = Date.now(); });
    return asSession(row);
  });
}

export async function saveSession(id: string, progress: { stepIndex?: number; timers?: CookingTimer[] }): Promise<void> {
  await database.write(async () => {
    const row = await database.get<CookingSessionRecord>('cooking_sessions').find(id);
    if (row.status !== 'active') throw new Error('This cooking session has already finished. Reopen the recipe to start again.');
    const data = asSession(row).data;
    if (progress.stepIndex !== undefined && (!Number.isInteger(progress.stepIndex) || progress.stepIndex < 0 || progress.stepIndex >= data.steps.length))
      throw new Error('Invalid cooking step.');
    await row.update((r) => { r.payload = JSON.stringify({ ...data, ...progress }); r.updatedAt = Date.now(); });
  });
}

export async function finishSession(id: string, selectedIds: string[]): Promise<void> {
  await database.write(async () => {
    const row = await database.get<CookingSessionRecord>('cooking_sessions').find(id);
    const session = asSession(row);
    const pantry = await database.get<UserPantry>('local_pantry').query(Q.where('user_id', LOCAL_GUEST_ID)).fetch();
    const plan = planCompletion(row.status, pantry, session.data.ingredients.map((item) => ({ ...item, selected: selectedIds.includes(item.ingredientId) })));
    if (!plan) return;
    const ops: Model[] = pantry.flatMap((record) => {
      if (plan.deletedStockIds.includes(record.id)) return [record.prepareMarkAsDeleted()];
      const quantity = plan.updatedStock.get(record.ingredientId);
      return quantity === undefined ? [] : [record.prepareUpdate((p) => { p.quantity = quantity; p.updatedAt = Date.now(); })];
    });
    ops.push(row.prepareUpdate((r) => { r.status = 'completed'; r.updatedAt = Date.now();
      r.payload = JSON.stringify({ ...session.data, consumed: plan.consumed, timers: [] }); }));
    await database.batch(ops);
  });
}

export async function undoSession(id: string): Promise<void> {
  await database.write(async () => {
    const row = await database.get<CookingSessionRecord>('cooking_sessions').find(id);
    const data = asSession(row).data;
    const collection = database.get<UserPantry>('local_pantry');
    const pantry = await collection.query(Q.where('user_id', LOCAL_GUEST_ID)).fetch();
    const plan = planUndo(row.status, pantry, data.consumed);
    if (!plan) return;
    const ops: Model[] = plan.map((item) => {
      const current = pantry.find((p) => p.id === item.id);
      if (current) return current.prepareUpdate((p) => { p.quantity = item.quantity; p.updatedAt = Date.now(); });
      return collection.prepareCreate((p) => { p.userId = LOCAL_GUEST_ID; p.ingredientId = item.ingredientId;
        p.quantity = item.quantity; p.unit = item.unit; p.storageLocation = item.storageLocation as StorageLocation; p.updatedAt = Date.now(); });
    });
    ops.push(row.prepareUpdate((r) => { r.status = 'undone'; r.updatedAt = Date.now(); }));
    await database.batch(ops);
  });
}
