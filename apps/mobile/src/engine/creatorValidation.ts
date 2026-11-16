export function validateCreator(draft: {
  title: string; servings: string; prepMinutes: string; cookMinutes: string;
  selectedIngredients: { amount: string; unit: string }[]; recipeSteps: { instruction: string; timerMinutes: string }[];
}): string | null {
  if (draft.title.trim().length < 3) return 'Enter a recipe title of at least 3 characters.';
  const whole = (value: string, min: number, max: number) => value.trim() !== '' && Number.isInteger(Number(value)) && Number(value) >= min && Number(value) <= max;
  if (!whole(draft.servings, 1, 100)) return 'Servings must be a whole number from 1 to 100.';
  if (![draft.prepMinutes, draft.cookMinutes].every((n) => whole(n, 0, 10080))) return 'Preparation and cooking minutes must be whole numbers from 0 to 10080.';
  if (!draft.selectedIngredients.length || draft.selectedIngredients.some((i) => !Number.isFinite(Number(i.amount)) || Number(i.amount) <= 0 || !i.unit.trim()))
    return 'Add ingredients with a positive quantity and a unit.';
  if (!draft.recipeSteps.length || draft.recipeSteps.some((s) => !s.instruction.trim() || !whole(s.timerMinutes, 0, 10080)))
    return 'Each step needs instructions and a whole timer duration from 0 to 10080 minutes.';
  return null;
}
