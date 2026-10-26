export interface IngredientRequirement {
  id: string;
  name: string;
  isStaple: boolean;
  isOptional: boolean;
  tier: 0 | 1 | 2 | 3;
  amount: number;
  unit: string;
}

export interface PantryItem {
  ingredientId: string;
  quantity: number;
  unit: string;
}

export interface SubstitutionRule {
  substituteIngredientId: string;
  conversionRatio: number;
  isEmergency: boolean;
  applicableContexts?: readonly string[];
  forbiddenContexts?: readonly string[];
}

export interface MatchResult {
  recipeId: string;
  matchScore: number;
  missingIngredients: IngredientRequirement[];
  substitutedIngredients: Array<{
    original: IngredientRequirement;
    substituteId: string;
    ratio: number;
  }>;
  canCookNow: boolean;
}

// Mass and volume conversions are safe within a dimension only. A density or
// ingredient-specific conversion is required before comparing g against ml.
const units: Record<string, { dimension: string; factor: number }> = {
  g: { dimension: 'mass', factor: 1 }, kg: { dimension: 'mass', factor: 1000 },
  ml: { dimension: 'volume', factor: 1 }, l: { dimension: 'volume', factor: 1000 },
  tsp: { dimension: 'volume', factor: 5 }, tbsp: { dimension: 'volume', factor: 15 },
};

function normalizeUnit(unit: string): string {
  return unit.trim().toLowerCase();
}

function convert(quantity: number, from: string, to: string): number | null {
  if (!Number.isFinite(quantity) || quantity < 0) return null;
  const source = normalizeUnit(from);
  const target = normalizeUnit(to);
  if (!source || !target) return null;
  if (source === target) return quantity;
  const a = units[source];
  const b = units[target];
  return a && b && a.dimension === b.dimension ? quantity * a.factor / b.factor : null;
}

function supportsContext(rule: SubstitutionRule, context?: string): boolean {
  const forbidden = rule.forbiddenContexts ?? [];
  const applicable = rule.applicableContexts ?? ['all'];
  if (!context) return forbidden.length === 0 && applicable.includes('all');
  return !forbidden.includes(context) && !forbidden.includes('all') &&
    (applicable.includes('all') || applicable.includes(context));
}

export function evaluatePantryMatch(
  recipeId: string,
  requirements: readonly IngredientRequirement[],
  pantry: ReadonlyMap<string, PantryItem>,
  substitutionMatrix: ReadonlyMap<string, readonly SubstitutionRule[]>,
  context?: string,
): MatchResult {
  let totalWeight = 0;
  let earned = 0;
  let missingCritical = 0;
  const missingIngredients: IngredientRequirement[] = [];
  const substitutedIngredients: MatchResult['substitutedIngredients'] = [];
  // A substitute shared by two requirements must not be spent twice.
  const remaining = new Map([...pantry].map(([id, item]) => [id, { ...item }]));
  const consume = (id: string, amount: number, unit: string): boolean => {
    const item = remaining.get(id);
    if (!item) return false;
    const available = convert(item.quantity, item.unit, unit);
    if (available === null || available + 1e-9 < amount) return false;
    const consumed = convert(amount, unit, item.unit);
    if (consumed === null) return false;
    item.quantity = Math.max(0, item.quantity - consumed);
    return true;
  };
  // Reserve exact matches first so optional items and substitutions cannot
  // consume an ingredient needed by a required exact match.
  const ordered = requirements.map((req, index) => ({ req, index }))
    .sort((a, b) => Number(a.req.isOptional) - Number(b.req.isOptional) || a.req.tier - b.req.tier);
  const exact = new Set<number>();
  for (const { req, index } of ordered) {
    if (!Number.isFinite(req.amount) || req.amount <= 0) throw new RangeError('Requirement amount must be positive');
    if (req.isStaple || req.tier === 0 || req.isOptional) continue;
    if (consume(req.id, req.amount, req.unit)) exact.add(index);
  }
  for (const { req, index } of ordered) {
    if (req.isStaple || req.tier === 0) continue;
    const weight = req.tier === 1 ? 3.5 : req.tier === 2 ? 2 : 0.8;
    totalWeight += weight;
    if (exact.has(index) || (req.isOptional && consume(req.id, req.amount, req.unit))) { earned += weight; continue; }
    const rules = [...(substitutionMatrix.get(req.id) ?? [])]
      .filter((rule) => rule.substituteIngredientId !== req.id &&
        Number.isFinite(rule.conversionRatio) && rule.conversionRatio > 0 && supportsContext(rule, context))
      .sort((a, b) => Number(a.isEmergency) - Number(b.isEmergency));
    const sub = rules.find((rule) => consume(rule.substituteIngredientId, req.amount * rule.conversionRatio, req.unit));
    if (sub) {
      earned += weight * (sub.isEmergency ? 0.75 : 0.9);
      substitutedIngredients.push({ original: req, substituteId: sub.substituteIngredientId, ratio: sub.conversionRatio });
    } else if (req.isOptional) {
      earned += weight * 0.5;
    } else {
      missingIngredients.push(req);
      if (req.tier === 1) missingCritical++;
    }
  }
  const matchScore = totalWeight === 0 ? 100 : Math.round(Math.max(0, (earned - 1.5 * missingCritical) / totalWeight) * 100);
  return { recipeId, matchScore, missingIngredients, substitutedIngredients, canCookNow: matchScore >= 80 && missingCritical === 0 };
}

export function matchLabel(result: MatchResult): string {
  if (result.substitutedIngredients.length && result.missingIngredients.length === 0) return `${result.matchScore}% With substitutions`;
  if (result.matchScore === 100 && result.missingIngredients.length === 0) return '100% Ready to Cook';
  if (result.missingIngredients.length === 0) return `${result.matchScore}% Optional items omitted`;
  return `${result.matchScore}% · Missing ${result.missingIngredients.length} item${result.missingIngredients.length === 1 ? '' : 's'}`;
}
