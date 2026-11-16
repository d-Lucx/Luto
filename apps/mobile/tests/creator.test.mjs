import test from 'node:test';
import assert from 'node:assert/strict';
import { validateCreator } from '../src/engine/creatorValidation.ts';
const draft = { title: 'Egg dish', servings: '2', prepMinutes: '5', cookMinutes: '10',
  selectedIngredients: [{ amount: '2', unit: 'piece' }], recipeSteps: [{ instruction: 'Cook eggs', timerMinutes: '1' }] };
test('creator accepts explicit quantities and whole serving/timer counts', () => assert.equal(validateCreator(draft), null));
test('creator rejects malformed numbers rather than silently replacing them', () => {
  for (const servings of ['0', '-2', '2junk', '2.5', '101']) assert.ok(validateCreator({ ...draft, servings }));
  for (const amount of ['', '-1', '0', 'Infinity', '1junk']) assert.ok(validateCreator({ ...draft, selectedIngredients: [{ amount, unit: 'g' }] }));
  assert.ok(validateCreator({ ...draft, recipeSteps: [{ instruction: 'Cook', timerMinutes: '-1' }] }));
});
