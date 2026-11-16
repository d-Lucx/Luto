// ==============================================================================
// LUTO (Logo: Lu2) — Pantry Auto-Decrement Engine
// Target: Validated Post-Cooking Inventory Deduction in Pantry Units
// ==============================================================================

import { convertQuantity } from './units.ts';

export interface PantryStockItem {
  id?: string;
  ingredientId: string;
  quantity: number;
  unit: string;
}

export interface UsedIngredientItem {
  ingredientId: string;
  name?: string;
  amount: number;
  unit: string;
  selected: boolean;
}

export interface DecrementResult {
  updatedStock: Map<string, number>; // ingredientId -> new quantity
  deletedStockIds: string[];         // Stock items reduced to 0
  summary: Array<{
    ingredientId: string;
    previousQuantity: number;
    newQuantity: number;
    deductedAmount: number;
  }>;
}

/**
 * Calculates new pantry quantities after cooking completion.
 * Only deducts items that the user has checked (selected: true).
 * Validates the entire calculation before the caller writes any changes.
 * Throws for shortages and unknown conversions; never mutates input stock.
 */
export function calculatePantryDecrement(
  currentPantry: PantryStockItem[],
  usedIngredients: UsedIngredientItem[]
): DecrementResult {
  const stockMap = new Map<string, PantryStockItem>();
  for (const item of currentPantry) {
    if (!Number.isFinite(item.quantity) || item.quantity < 0) {
      throw new RangeError('Pantry stock quantity must be a finite nonnegative number.');
    }
    if (stockMap.has(item.ingredientId)) {
      throw new Error('Duplicate pantry stock for an ingredient. Update your pantry before deducting.');
    }
    stockMap.set(item.ingredientId, { id: item.id, ingredientId: item.ingredientId, quantity: item.quantity, unit: item.unit });
  }

  const updatedStock = new Map<string, number>();
  const deletedStockIds: string[] = [];
  const summary: DecrementResult['summary'] = [];

  for (const used of usedIngredients) {
    if (!used.selected) continue;
    if (!Number.isFinite(used.amount) || used.amount < 0) {
      throw new RangeError('Used ingredient amount must be a finite nonnegative number.');
    }
    if (used.amount === 0) continue;

    const stock = stockMap.get(used.ingredientId);
    const name = used.name || used.ingredientId;
    if (!stock) throw new Error(`No pantry stock for ${name}. Uncheck it or update your pantry.`);

    const prevQty = stock.quantity;
    const consumed = convertQuantity(used.amount, used.unit, stock.unit);
    if (consumed === null) {
      throw new Error(`Cannot convert ${used.unit} to ${stock.unit} for ${name}. Update the units in your pantry.`);
    }
    const tolerance = Math.max(1, prevQty, consumed) * 1e-12;
    if (consumed - prevQty > tolerance) {
      throw new Error(`Not enough stock for ${name}. Uncheck it or update your pantry.`);
    }
    const newQty = Number(Math.max(0, prevQty - consumed).toPrecision(15));

    stock.quantity = newQty;
    updatedStock.set(used.ingredientId, newQty);

    if (newQty === 0 && stock.id) {
      deletedStockIds.push(stock.id);
    }

    summary.push({
      ingredientId: used.ingredientId,
      previousQuantity: prevQty,
      newQuantity: newQty,
      deductedAmount: Number((prevQty - newQty).toPrecision(15)),
    });
  }

  return {
    updatedStock,
    deletedStockIds,
    summary,
  };
}
