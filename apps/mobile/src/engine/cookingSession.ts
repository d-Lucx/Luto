import { calculatePantryDecrement, type PantryStockItem, type UsedIngredientItem } from './decrementPantry.ts';
import { convertQuantity } from './units.ts';

export type SessionStatus = 'active' | 'completed' | 'undone';
export interface ConsumedStock { ingredientId: string; quantity: number; unit: string; storageLocation: string }

export function scaleIngredients<T extends { amount: number }>(items: T[], base: number, servings: number): T[] {
  if (!Number.isFinite(base) || base <= 0 || !Number.isFinite(servings) || servings < 1 || servings > 100)
    throw new Error('Choose between 1 and 100 servings.');
  return items.map((item) => {
    if (!Number.isFinite(item.amount) || item.amount <= 0) throw new Error('Ingredient quantity is invalid.');
    return { ...item, amount: item.amount * servings / base };
  });
}

export function restoreTimers<T extends { status: string; remainingSeconds: number; targetEndTimeMs: number | null }>(timers: T[], now: number): T[] {
  return timers.map((timer) => {
    if (timer.status !== 'running' || timer.targetEndTimeMs === null) return { ...timer };
    const remainingSeconds = Math.max(0, Math.ceil((timer.targetEndTimeMs - now) / 1000));
    return { ...timer, remainingSeconds, status: remainingSeconds ? 'running' : 'completed',
      targetEndTimeMs: remainingSeconds ? timer.targetEndTimeMs : null };
  });
}

export function planCompletion(status: SessionStatus, stock: (PantryStockItem & { storageLocation?: string })[], used: UsedIngredientItem[]) {
  if (status !== 'active') return null;
  const result = calculatePantryDecrement(stock, used);
  const consumed: ConsumedStock[] = [];
  for (const item of stock) {
    const after = item.id && result.deletedStockIds.includes(item.id) ? 0 : result.updatedStock.get(item.ingredientId) ?? item.quantity;
    if (after < item.quantity) consumed.push({ ingredientId: item.ingredientId, quantity: item.quantity - after,
      unit: item.unit, storageLocation: item.storageLocation ?? 'pantry' });
  }
  return { ...result, consumed };
}

export function planUndo(status: SessionStatus, stock: PantryStockItem[], consumed: ConsumedStock[]) {
  if (status !== 'completed') return null;
  return consumed.map((item) => {
    const matches = stock.filter((s) => s.ingredientId === item.ingredientId);
    if (matches.length > 1) throw new Error('Duplicate pantry entries must be resolved before undo.');
    const current = matches[0];
    const added = current ? convertQuantity(item.quantity, item.unit, current.unit) : item.quantity;
    if (added === null || !Number.isFinite(added) || added < 0 || (current && (!Number.isFinite(current.quantity) || current.quantity < 0)))
      throw new Error('Pantry units changed. Restore compatible units before undoing.');
    return { ...item, id: current?.id, unit: current?.unit ?? item.unit, quantity: (current?.quantity ?? 0) + added };
  });
}
