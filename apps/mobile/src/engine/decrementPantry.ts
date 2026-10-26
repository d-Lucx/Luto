// ==============================================================================
// LUTO (Logo: Lu2) — Pantry Auto-Decrement Engine
// Target: Post-Cooking Inventory Deduction with Unit Compatibility & Clamping
// ==============================================================================

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
 * Ensures quantities never become negative (clamped to 0).
 */
export function calculatePantryDecrement(
  currentPantry: PantryStockItem[],
  usedIngredients: UsedIngredientItem[]
): DecrementResult {
  const stockMap = new Map<string, PantryStockItem>();
  for (const item of currentPantry) {
    stockMap.set(item.ingredientId, { ...item });
  }

  const updatedStock = new Map<string, number>();
  const deletedStockIds: string[] = [];
  const summary: DecrementResult['summary'] = [];

  for (const used of usedIngredients) {
    if (!used.selected || used.amount <= 0) continue;

    const stock = stockMap.get(used.ingredientId);
    if (!stock) continue;

    const prevQty = stock.quantity;
    // Units match or standard assumption
    const newQty = Math.max(0, Number((prevQty - used.amount).toFixed(3)));

    stock.quantity = newQty;
    updatedStock.set(used.ingredientId, newQty);

    if (newQty === 0 && stock.id) {
      deletedStockIds.push(stock.id);
    }

    summary.push({
      ingredientId: used.ingredientId,
      previousQuantity: prevQty,
      newQuantity: newQty,
      deductedAmount: Number((prevQty - newQty).toFixed(3)),
    });
  }

  return {
    updatedStock,
    deletedStockIds,
    summary,
  };
}
