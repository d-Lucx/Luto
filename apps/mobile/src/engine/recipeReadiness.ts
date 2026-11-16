export interface OverviewIngredient {
  name: string | null;
  amount: number;
  unit: string;
}

export function getRecipeReadiness(
  ingredients: readonly OverviewIngredient[],
  steps: readonly { instruction: string }[],
): { ready: boolean; issues: string[] } {
  const issues: string[] = [];
  if (!ingredients.length) issues.push('Ingredient quantities have not been added yet.');
  if (ingredients.some((item) => !item.name?.trim())) {
    issues.push('Some ingredient names are missing from this device.');
  }
  if (ingredients.some((item) => !Number.isFinite(item.amount) || item.amount <= 0 || !item.unit.trim())) {
    issues.push('Some ingredient quantities or units are incomplete.');
  }
  if (!steps.length || steps.some((step) => !step.instruction.trim())) {
    issues.push('Complete cooking steps are not available yet.');
  }
  return { ready: issues.length === 0, issues };
}
