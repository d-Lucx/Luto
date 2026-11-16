// Conversions stay within a dimension. Cups require an explicit regional
// convention; mass/volume conversions require ingredient-specific density.
const units: Record<string, { dimension: string; factor: number }> = {
  g: { dimension: 'mass', factor: 1 }, kg: { dimension: 'mass', factor: 1000 },
  ml: { dimension: 'volume', factor: 1 }, l: { dimension: 'volume', factor: 1000 },
  tsp: { dimension: 'volume', factor: 5 }, tbsp: { dimension: 'volume', factor: 15 },
};

export function convertQuantity(quantity: number, from: string, to: string): number | null {
  if (!Number.isFinite(quantity) || quantity < 0) return null;
  const source = from.trim().toLowerCase();
  const target = to.trim().toLowerCase();
  if (!source || !target) return null;
  if (source === target) return quantity;
  const a = units[source];
  const b = units[target];
  if (!a || !b || a.dimension !== b.dimension) return null;
  const converted = quantity * a.factor / b.factor;
  return Number.isFinite(converted) ? converted : null;
}
