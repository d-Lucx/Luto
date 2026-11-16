import test from 'node:test';
import assert from 'node:assert/strict';
import { canEditRecipe } from '../src/engine/recipePermissions.ts';
test('guest-owned recipes are editable regardless of their title or missing legacy metadata', () => {
  assert.equal(canEditRecipe('local-recipe', undefined), true);
  assert.equal(canEditRecipe('local-recipe', 'local'), true);
});
test('sample identity and community ownership prevent local editing', () => {
  assert.equal(canEditRecipe('demo-shakshuka', undefined), false);
  assert.equal(canEditRecipe('published-recipe', 'community'), false);
});
