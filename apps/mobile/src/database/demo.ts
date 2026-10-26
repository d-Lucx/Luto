import { database } from './index';
import { Ingredient, Recipe, RecipeIngredient, RecipeStep } from './models';

// Explicit opt-in sample content. These device-only IDs are not backend UUIDs.
export async function loadDemoRecipes(): Promise<void> {
  await database.write(async () => {
    const recipes = database.get<Recipe>('local_recipes');
    if (await recipes.query().fetchCount()) return;
    const ingredients = database.get<Ingredient>('ingredients');
    const dictionary = [
      ['demo-eggs', 'Eggs', 'protein', 'piece', false],
      ['demo-tomato', 'Tomatoes', 'produce', 'g', false],
      ['demo-onion', 'Onion', 'produce', 'g', false],
      ['demo-salt', 'Salt', 'spice_seasoning', 'g', true],
    ] as const;
    const records = dictionary.map(([id, name, category, unit, staple]) => ingredients.prepareCreate((item) => {
      item._raw.id = id;
      item.canonicalName = name.toLowerCase();
      item.displayName = name;
      item.category = category;
      item.defaultUnit = unit;
      item.isStaple = staple;
    }));
    const recipe = recipes.prepareCreate((item) => {
      item._raw.id = 'demo-shakshuka';
      item.title = 'Sample: Shakshuka';
      item.description = 'Eggs poached in a simple tomato and onion sauce.';
      item.servings = 2;
      item.heroImageUrl = '';
      item.updatedAt = Date.now();
    });
    const requirements = [
      ['demo-eggs', 2, 'piece', 1], ['demo-tomato', 400, 'g', 2],
      ['demo-onion', 100, 'g', 2], ['demo-salt', 2, 'g', 0],
    ] as const;
    const lines = requirements.map(([id, amount, unit, tier]) => database.get<RecipeIngredient>('local_ingredients').prepareCreate((item) => {
      item.recipeId = recipe.id;
      item.ingredientId = id;
      item.amount = amount;
      item.unit = unit;
      item.tier = tier;
      item.isOptional = false;
    }));
    const steps = [
      'Chop the onion and tomatoes. Soften the onion in a pan, then add tomatoes and simmer into a thick sauce.',
      'Make two wells in the sauce, add the eggs, cover and cook until the whites are set. Season to taste.',
    ].map((instruction, index) => database.get<RecipeStep>('local_steps').prepareCreate((item) => {
      item.recipeId = recipe.id;
      item.stepNumber = index + 1;
      item.instruction = instruction;
      item.timerDurationSeconds = 0;
    }));
    await database.batch(...records, recipe, ...lines, ...steps);
  });
}
