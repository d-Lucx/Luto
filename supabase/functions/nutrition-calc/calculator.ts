// ==============================================================================
// LUTO (Logo: Lu2) — Nutritional Calculator Engine
// Universal Nutrition Reference & Gravimetric Macro Calculator
// ==============================================================================

export interface IngredientInput {
  name: string;
  canonicalId?: string;
  amount: number;
  unit: string;
}

export interface MacroProfile {
  calories: number;        // kcal
  proteinG: number;        // grams
  carbsG: number;          // grams
  fatG: number;            // grams
  fiberG: number;          // grams
  sodiumMg: number;        // milligrams
}

export interface NutritionResult {
  recipeTotal: MacroProfile;
  perServing: MacroProfile;
  servings: number;
  itemized: Array<{
    name: string;
    weightGrams: number;
    macros: MacroProfile;
  }>;
}

export const NUTRITIONAL_DENSITY_TABLE: Record<string, MacroProfile> = {
  // Proteins
  chicken_breast: { calories: 165, proteinG: 31.0, carbsG: 0.0, fatG: 3.6, fiberG: 0.0, sodiumMg: 74 },
  beef_sirloin: { calories: 244, proteinG: 26.1, carbsG: 0.0, fatG: 15.0, fiberG: 0.0, sodiumMg: 56 },
  pork_tenderloin: { calories: 143, proteinG: 26.0, carbsG: 0.0, fatG: 3.5, fiberG: 0.0, sodiumMg: 53 },
  guanciale: { calories: 655, proteinG: 9.0, carbsG: 0.0, fatG: 69.0, fiberG: 0.0, sodiumMg: 1100 },
  bacon: { calories: 541, proteinG: 37.0, carbsG: 1.4, fatG: 42.0, fiberG: 0.0, sodiumMg: 1717 },
  eggs: { calories: 143, proteinG: 12.6, carbsG: 0.7, fatG: 9.5, fiberG: 0.0, sodiumMg: 142 },
  tofu_firm: { calories: 144, proteinG: 17.3, carbsG: 2.8, fatG: 8.7, fiberG: 2.3, sodiumMg: 14 },
  red_lentils: { calories: 358, proteinG: 23.9, carbsG: 63.1, fatG: 2.2, fiberG: 10.8, sodiumMg: 6 },
  shrimp: { calories: 99, proteinG: 24.0, carbsG: 0.2, fatG: 0.3, fiberG: 0.0, sodiumMg: 111 },
  salmon: { calories: 208, proteinG: 20.4, carbsG: 0.0, fatG: 13.4, fiberG: 0.0, sodiumMg: 59 },

  // Dairy & Cheeses
  pecorino_romano: { calories: 387, proteinG: 32.0, carbsG: 3.6, fatG: 27.0, fiberG: 0.0, sodiumMg: 1800 },
  parmesan: { calories: 431, proteinG: 38.5, carbsG: 4.1, fatG: 28.6, fiberG: 0.0, sodiumMg: 1529 },
  heavy_cream: { calories: 340, proteinG: 2.8, carbsG: 2.7, fatG: 36.1, fiberG: 0.0, sodiumMg: 38 },
  butter: { calories: 717, proteinG: 0.9, carbsG: 0.1, fatG: 81.1, fiberG: 0.0, sodiumMg: 643 },
  milk_whole: { calories: 61, proteinG: 3.2, carbsG: 4.8, fatG: 3.3, fiberG: 0.0, sodiumMg: 43 },

  // Produce
  onion: { calories: 40, proteinG: 1.1, carbsG: 9.3, fatG: 0.1, fiberG: 1.7, sodiumMg: 4 },
  garlic: { calories: 149, proteinG: 6.4, carbsG: 33.1, fatG: 0.5, fiberG: 2.1, sodiumMg: 17 },
  tomato: { calories: 18, proteinG: 0.9, carbsG: 3.9, fatG: 0.2, fiberG: 1.2, sodiumMg: 5 },
  bell_pepper: { calories: 26, proteinG: 1.0, carbsG: 6.0, fatG: 0.3, fiberG: 2.1, sodiumMg: 4 },
  avocado: { calories: 160, proteinG: 2.0, carbsG: 8.5, fatG: 14.7, fiberG: 6.7, sodiumMg: 7 },
  eggplant: { calories: 25, proteinG: 1.0, carbsG: 5.9, fatG: 0.2, fiberG: 3.0, sodiumMg: 2 },
  zucchini: { calories: 17, proteinG: 1.2, carbsG: 3.1, fatG: 0.3, fiberG: 1.0, sodiumMg: 8 },
  spinach: { calories: 23, proteinG: 2.9, carbsG: 3.6, fatG: 0.4, fiberG: 2.2, sodiumMg: 79 },
  cilantro: { calories: 23, proteinG: 2.1, carbsG: 3.7, fatG: 0.5, fiberG: 2.8, sodiumMg: 46 },
  lime_juice: { calories: 25, proteinG: 0.4, carbsG: 8.4, fatG: 0.1, fiberG: 0.4, sodiumMg: 2 },

  // Grains & Pantry Dry
  spaghetti: { calories: 371, proteinG: 13.0, carbsG: 74.7, fatG: 1.5, fiberG: 3.2, sodiumMg: 6 },
  jasmine_rice: { calories: 365, proteinG: 7.1, carbsG: 80.0, fatG: 0.7, fiberG: 1.3, sodiumMg: 5 },
  all_purpose_flour: { calories: 364, proteinG: 10.3, carbsG: 76.3, fatG: 1.0, fiberG: 2.7, sodiumMg: 2 },
  sourdough_bread: { calories: 247, proteinG: 8.4, carbsG: 47.5, fatG: 1.2, fiberG: 2.4, sodiumMg: 482 },

  // Fats & Oils
  olive_oil: { calories: 884, proteinG: 0.0, carbsG: 0.0, fatG: 100.0, fiberG: 0.0, sodiumMg: 2 },
  sesame_oil: { calories: 884, proteinG: 0.0, carbsG: 0.0, fatG: 100.0, fiberG: 0.0, sodiumMg: 0 },
  vegetable_oil: { calories: 884, proteinG: 0.0, carbsG: 0.0, fatG: 100.0, fiberG: 0.0, sodiumMg: 0 },

  // Condiments & Seasonings
  soy_sauce: { calories: 53, proteinG: 8.1, carbsG: 4.9, fatG: 0.6, fiberG: 0.8, sodiumMg: 5493 },
  fish_sauce: { calories: 35, proteinG: 5.1, carbsG: 3.6, fatG: 0.0, fiberG: 0.0, sodiumMg: 7851 },
  cane_vinegar: { calories: 18, proteinG: 0.0, carbsG: 0.9, fatG: 0.0, fiberG: 0.0, sodiumMg: 5 },
  coconut_milk: { calories: 230, proteinG: 2.3, carbsG: 5.5, fatG: 23.8, fiberG: 2.2, sodiumMg: 15 },
  black_pepper: { calories: 251, proteinG: 10.4, carbsG: 64.0, fatG: 3.3, fiberG: 25.3, sodiumMg: 20 },
  salt: { calories: 0, proteinG: 0.0, carbsG: 0.0, fatG: 0.0, fiberG: 0.0, sodiumMg: 38758 },

  // Generic fallback
  default_vegetable: { calories: 30, proteinG: 1.5, carbsG: 6.0, fatG: 0.2, fiberG: 2.0, sodiumMg: 10 },
  default_dry: { calories: 350, proteinG: 10.0, carbsG: 70.0, fatG: 2.0, fiberG: 3.0, sodiumMg: 10 },
};

export function convertToGrams(amount: number, unit: string, ingredientKey: string): number {
  const normUnit = unit.trim().toLowerCase();
  switch (normUnit) {
    case 'g':
    case 'gram':
    case 'grams':
      return amount;
    case 'kg':
    case 'kilogram':
    case 'kilograms':
      return amount * 1000;
    case 'oz':
    case 'ounce':
    case 'ounces':
      return amount * 28.3495;
    case 'lb':
    case 'lbs':
    case 'pound':
    case 'pounds':
      return amount * 453.592;
    case 'ml':
    case 'milliliter':
    case 'milliliters':
      return amount * 1.0;
    case 'l':
    case 'liter':
    case 'liters':
      return amount * 1000.0;
    case 'tbsp':
    case 'tablespoon':
    case 'tablespoons':
      return amount * 15.0;
    case 'tsp':
    case 'teaspoon':
    case 'teaspoons':
      return amount * 5.0;
    case 'cup':
    case 'cups':
      return amount * 240.0;
    case 'clove':
    case 'cloves':
      return amount * 5.0;
    case 'pinch':
    case 'pinches':
      return amount * 0.5;
    case 'piece':
    case 'item':
    case 'whole':
      if (ingredientKey.includes('egg')) return amount * 50.0;
      if (ingredientKey.includes('onion')) return amount * 150.0;
      if (ingredientKey.includes('tomato')) return amount * 120.0;
      if (ingredientKey.includes('avocado')) return amount * 150.0;
      if (ingredientKey.includes('lime') || ingredientKey.includes('lemon')) return amount * 60.0;
      return amount * 100.0;
    default:
      return amount * 1.0;
  }
}

export function matchIngredientKey(name: string): string {
  const clean = name.toLowerCase().replace(/[^a-z0-9_ ]/g, ' ').trim().replace(/\s+/g, '_');
  for (const key of Object.keys(NUTRITIONAL_DENSITY_TABLE)) {
    if (clean.includes(key) || key.includes(clean)) return key;
  }
  if (clean.includes('pepper') || clean.includes('salt') || clean.includes('spice')) return 'black_pepper';
  if (clean.includes('oil') || clean.includes('fat')) return 'olive_oil';
  if (clean.includes('flour') || clean.includes('pasta') || clean.includes('rice') || clean.includes('noodle')) return 'spaghetti';
  if (clean.includes('beef') || clean.includes('steak')) return 'beef_sirloin';
  if (clean.includes('chicken') || clean.includes('poultry')) return 'chicken_breast';
  return 'default_vegetable';
}

export function calculateRecipeNutrition(
  ingredients: IngredientInput[],
  servings: number = 4
): NutritionResult {
  const safeServings = Math.max(1, servings);
  const total: MacroProfile = { calories: 0, proteinG: 0, carbsG: 0, fatG: 0, fiberG: 0, sodiumMg: 0 };
  const itemized: NutritionResult['itemized'] = [];

  for (const ing of ingredients) {
    const key = matchIngredientKey(ing.name);
    const density = NUTRITIONAL_DENSITY_TABLE[key] || NUTRITIONAL_DENSITY_TABLE.default_vegetable;
    const weightGrams = Math.max(0, convertToGrams(ing.amount, ing.unit, key));
    const factor = weightGrams / 100.0;

    const macros: MacroProfile = {
      calories: Math.round(density.calories * factor),
      proteinG: Number((density.proteinG * factor).toFixed(1)),
      carbsG: Number((density.carbsG * factor).toFixed(1)),
      fatG: Number((density.fatG * factor).toFixed(1)),
      fiberG: Number((density.fiberG * factor).toFixed(1)),
      sodiumMg: Math.round(density.sodiumMg * factor),
    };

    total.calories += macros.calories;
    total.proteinG += macros.proteinG;
    total.carbsG += macros.carbsG;
    total.fatG += macros.fatG;
    total.fiberG += macros.fiberG;
    total.sodiumMg += macros.sodiumMg;

    itemized.push({
      name: ing.name,
      weightGrams: Math.round(weightGrams),
      macros,
    });
  }

  total.proteinG = Number(total.proteinG.toFixed(1));
  total.carbsG = Number(total.carbsG.toFixed(1));
  total.fatG = Number(total.fatG.toFixed(1));
  total.fiberG = Number(total.fiberG.toFixed(1));

  const perServing: MacroProfile = {
    calories: Math.round(total.calories / safeServings),
    proteinG: Number((total.proteinG / safeServings).toFixed(1)),
    carbsG: Number((total.carbsG / safeServings).toFixed(1)),
    fatG: Number((total.fatG / safeServings).toFixed(1)),
    fiberG: Number((total.fiberG / safeServings).toFixed(1)),
    sodiumMg: Math.round(total.sodiumMg / safeServings),
  };

  return { recipeTotal: total, perServing, servings: safeServings, itemized };
}
