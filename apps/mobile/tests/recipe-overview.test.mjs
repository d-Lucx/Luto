import { test } from 'node:test';
import assert from 'node:assert/strict';
import { getRecipeReadiness } from '../src/engine/recipeReadiness.ts';

const ingredient = { name: 'Eggs', amount: 2, unit: 'piece' };
const step = { instruction: 'Cook the eggs until the yolks and whites are firm.' };

test('a complete local recipe can enter cooking mode', () => {
  assert.deepEqual(getRecipeReadiness([ingredient], [step]), { ready: true, issues: [] });
});

test('missing ingredient names or quantities block cooking with an explanation', () => {
  for (const value of [null, '', '  ']) {
    const result = getRecipeReadiness([{ ...ingredient, name: value }], [step]);
    assert.equal(result.ready, false);
    assert.ok(result.issues.length > 0);
  }
  for (const amount of [0, -1, NaN, Infinity]) {
    assert.equal(getRecipeReadiness([{ ...ingredient, amount }], [step]).ready, false);
  }
  assert.equal(getRecipeReadiness([{ ...ingredient, unit: ' ' }], [step]).ready, false);
});

test('empty recipes and blank steps cannot appear ready to cook', () => {
  assert.equal(getRecipeReadiness([], [step]).ready, false);
  assert.equal(getRecipeReadiness([ingredient], []).ready, false);
  assert.equal(getRecipeReadiness([ingredient], [{ instruction: '  ' }]).ready, false);
  assert.equal(getRecipeReadiness([ingredient], [step, { instruction: '' }]).ready, false);
});
