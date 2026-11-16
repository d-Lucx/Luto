import { Q, type Model } from '@nozbe/watermelondb';
import { database } from './index';
import { Ingredient, LocalDocument, Recipe, RecipeIngredient, RecipeStep } from './models';
import { readDocument } from './documents';
import type { RecipeMetadata } from './recipeMetadata';
import type { CommunityRecipe, RecipeSnapshot } from '../services/community';

const identity = (name: string) => {
  const normalized = name.trim().toLowerCase().replaceAll('_', ' ');
  return ({ egg: 'eggs', tomato: 'tomatoes' } as Record<string, string>)[normalized] ?? normalized;
};

export async function cacheCommunityRecipe(remote: CommunityRecipe): Promise<string> {
  if (remote.status !== 'published') throw new Error('Only published recipes can be added to the public cookbook.');
  return database.write(async () => {
    const recipes = database.get<Recipe>('local_recipes');
    const dictionary = database.get<Ingredient>('ingredients');
    const names = new Map((await dictionary.query().fetch()).map((item) => [identity(item.canonicalName), item]));
    const ops: Model[] = [];
    const snapshot = remote.snapshot;
    const existing = await recipes.query(Q.where('id', remote.id)).fetch();
    const assign = (r: Recipe) => { r.title = snapshot.title; r.description = snapshot.description; r.servings = snapshot.servings;
      r.heroImageUrl = snapshot.heroImageUrl ?? ''; r.updatedAt = new Date(remote.updated_at).getTime(); };
    const recipe = existing[0] ?? recipes.prepareCreate((r) => { r._raw.id = remote.id; assign(r); });
    if (existing[0]) {
      ops.push(recipe.prepareUpdate(assign));
      const [oldSteps, oldRequirements] = await Promise.all([recipe.steps.fetch(), recipe.ingredients.fetch()]);
      ops.push(...oldSteps.map((s: RecipeStep) => s.prepareMarkAsDeleted()), ...oldRequirements.map((r: RecipeIngredient) => r.prepareMarkAsDeleted()));
    } else ops.push(recipe);
    for (const item of snapshot.ingredients) {
      const key = identity(item.canonicalName);
      let canonical = names.get(key);
      if (!canonical) {
        canonical = dictionary.prepareCreate((r) => { r.canonicalName = item.canonicalName; r.displayName = item.name;
          r.category = 'uncategorized'; r.defaultUnit = item.unit; r.isStaple = false; });
        names.set(key, canonical); ops.push(canonical);
      }
      const canonicalId = canonical.id;
      ops.push(database.get<RecipeIngredient>('local_ingredients').prepareCreate((r) => { r.recipeId = recipe.id; r.ingredientId = canonicalId;
        r.amount = item.amount; r.unit = item.unit; r.isOptional = item.isOptional ?? false;
        r.tier = item.tier === 'critical' ? 1 : item.tier === 'optional' ? 3 : 2; }));
    }
    snapshot.steps.forEach((s, index) => ops.push(database.get<RecipeStep>('local_steps').prepareCreate((r) => {
      r.recipeId = recipe.id; r.stepNumber = index + 1; r.instruction = s.instruction; r.timerDurationSeconds = s.timerDurationSeconds ?? 0; r.mediaUrl = s.mediaUrl ?? null;
    })));
    const documents = database.get<LocalDocument>('local_documents');
    const metadataKey = `recipe-meta-${recipe.id}`;
    const previous = await documents.query(Q.where('key', metadataKey)).fetch();
    const payload: RecipeMetadata = { category: snapshot.category, difficulty: snapshot.difficulty, cuisineTags: snapshot.cuisineTags,
      prepTimeMinutes: snapshot.prepTimeMinutes, cookTimeMinutes: snapshot.cookTimeMinutes,
      equipment: snapshot.equipment, mediaAssets: snapshot.mediaAssets, source: 'community', remoteId: remote.id, remoteVersion: remote.version, publicationStatus: remote.status };
    const set = (r: LocalDocument) => { r.key = metadataKey; r.payload = JSON.stringify(payload); };
    ops.push(previous[0] ? previous[0].prepareUpdate(set) : documents.prepareCreate(set));
    await database.batch(ops);
    return recipe.id;
  });
}

export async function snapshotLocalRecipe(id: string): Promise<RecipeSnapshot> {
  const recipe = await database.get<Recipe>('local_recipes').find(id);
  if (id.startsWith('demo-') || recipe.title.startsWith('Device timer test')) throw new Error('Sample and device-test recipes stay on this device.');
  const [requirements, steps, dictionary, metadata] = await Promise.all([
    recipe.ingredients.fetch(), recipe.steps.fetch(), database.get<Ingredient>('ingredients').query().fetch(), readDocument<RecipeMetadata>(`recipe-meta-${id}`),
  ]);
  if (metadata?.source === 'community') throw new Error('This recipe belongs to its community author. Create your own recipe to publish.');
  if (!metadata?.category || !metadata.difficulty) throw new Error('Add a meal category and difficulty in the recipe creator before publishing.');
  const byId = new Map(dictionary.map((item) => [item.id, item]));
  return { title: recipe.title, description: recipe.description, servings: recipe.servings, category: metadata.category, difficulty: metadata.difficulty, cuisineTags: metadata.cuisineTags,
    heroImageUrl: recipe.heroImageUrl || undefined,
    prepTimeMinutes: metadata?.prepTimeMinutes ?? 0, cookTimeMinutes: metadata?.cookTimeMinutes ?? 0,
    equipment: metadata?.equipment ?? [], mediaAssets: metadata?.mediaAssets,
    ingredients: requirements.map((r: RecipeIngredient) => {
      const canonical = byId.get(r.ingredientId);
      if (!canonical) throw new Error('An ingredient is missing its canonical name.');
      return { canonicalName: canonical.canonicalName, name: canonical.displayName, amount: r.amount, unit: r.unit,
        isOptional: r.isOptional, tier: r.tier === 1 ? 'critical' : r.isOptional ? 'optional' : 'important' };
    }),
    steps: steps.sort((a: RecipeStep, b: RecipeStep) => a.stepNumber - b.stepNumber).map((s: RecipeStep) => ({ instruction: s.instruction, timerDurationSeconds: s.timerDurationSeconds, mediaUrl: s.mediaUrl ?? undefined })),
  };
}
