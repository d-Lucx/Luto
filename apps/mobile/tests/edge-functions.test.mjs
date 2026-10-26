import { test } from 'node:test';
import assert from 'node:assert/strict';
import { calculateRecipeNutrition, convertToGrams } from '../../../supabase/functions/nutrition-calc/calculator.ts';
import { moderateRecipeDraft } from '../../../supabase/functions/recipe-moderation/moderator.ts';

// -----------------------------------------------------------------------------
// 1. Nutritional Calculator Tests
// -----------------------------------------------------------------------------

test('convertToGrams accurately converts common kitchen units', () => {
  assert.equal(convertToGrams(250, 'g', 'flour'), 250);
  assert.equal(convertToGrams(1, 'kg', 'chicken_breast'), 1000);
  assert.equal(convertToGrams(2, 'tbsp', 'olive_oil'), 30);
  assert.equal(convertToGrams(1, 'cup', 'milk_whole'), 240);
  assert.equal(convertToGrams(2, 'piece', 'eggs'), 100); // 2 eggs * 50g = 100g
});

test('calculateRecipeNutrition calculates recipe total and per-serving macros', () => {
  const ingredients = [
    { name: 'Chicken Breast', amount: 500, unit: 'g' }, // 500g -> 5 * 165 = 825 kcal, 155g protein
    { name: 'Olive Oil', amount: 2, unit: 'tbsp' },     // 30g -> 0.3 * 884 = 265 kcal, 30g fat
    { name: 'Garlic', amount: 3, unit: 'clove' },       // 15g -> 0.15 * 149 = 22 kcal
  ];

  const result = calculateRecipeNutrition(ingredients, 4);

  assert.equal(result.servings, 4);
  assert.ok(result.recipeTotal.calories > 1000);
  assert.ok(result.recipeTotal.proteinG > 150);
  assert.ok(result.recipeTotal.fatG > 30);

  // Per serving should be approximately total / 4
  assert.equal(result.perServing.calories, Math.round(result.recipeTotal.calories / 4));
  assert.equal(result.perServing.proteinG, Number((result.recipeTotal.proteinG / 4).toFixed(1)));
  assert.equal(result.itemized.length, 3);
});

// -----------------------------------------------------------------------------
// 2. Automated Recipe Moderation Tests
// -----------------------------------------------------------------------------

test('recipe moderation approves valid culinary recipes', () => {
  const cleanRecipe = {
    title: 'Garlic Butter Spaghetti',
    description: 'A comforting late-night classic.',
    ingredients: [
      { name: 'Spaghetti', amount: 400, unit: 'g' },
      { name: 'Butter', amount: 50, unit: 'g' },
      { name: 'Garlic', amount: 4, unit: 'clove' },
    ],
    steps: [
      { stepNumber: 1, instruction: 'Boil salted water and cook spaghetti until al dente.' },
      { stepNumber: 2, instruction: 'Gently melt butter with minced garlic in a wide pan.' },
      { stepNumber: 3, instruction: 'Toss pasta in garlic butter and serve immediately.' },
    ],
  };

  const result = moderateRecipeDraft(cleanRecipe);
  assert.equal(result.approved, true);
  assert.equal(result.severity, 'clean');
  assert.equal(result.flags.length, 0);
});

test('recipe moderation rejects recipes with hazardous chemicals or explosion risks', () => {
  const hazardousRecipe = {
    title: 'Disinfected Soup',
    ingredients: [
      { name: 'Water', amount: 500, unit: 'ml' },
      { name: 'Bleach', amount: 50, unit: 'ml' }, // Toxic chemical
    ],
    steps: [
      { stepNumber: 1, instruction: 'Heat unopened can directly over the stove burner.' }, // Explosion hazard
    ],
  };

  const result = moderateRecipeDraft(hazardousRecipe);
  assert.equal(result.approved, false);
  assert.equal(result.severity, 'rejected');
  assert.ok(result.flags.includes('SAFETY_VIOLATION'));
  assert.ok(result.reasons.some(r => r.includes('toxic')));
});

test('recipe moderation flags external commercial links and missing fields', () => {
  const spamRecipe = {
    title: 'AB', // Too short (min 3 chars)
    ingredients: [], // Empty ingredients
    steps: [
      { stepNumber: 1, instruction: 'Visit https://crypto-casino.example.com to win big prizes!' },
    ],
  };

  const result = moderateRecipeDraft(spamRecipe);
  assert.equal(result.approved, false);
  assert.ok(result.flags.includes('INVALID_TITLE'));
  assert.ok(result.flags.includes('MISSING_INGREDIENTS'));
  assert.ok(result.flags.includes('SPAM_DETECTED'));
});
