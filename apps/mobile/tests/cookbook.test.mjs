import test from 'node:test';
import assert from 'node:assert/strict';
import { ingredientMatches, displayQuantity } from '../src/engine/ingredientDisplay.ts';
test('Filipino aliases find canonical ingredients without changing identity', () => {
  assert.equal(ingredientMatches('Onion', 'onion', 'sibuyas'), true);
  assert.equal(ingredientMatches('Eggs', 'eggs', 'itlog'), true);
  assert.equal(ingredientMatches('Tomatoes', 'tomatoes', 'kamatis'), true);
  assert.equal(ingredientMatches('Salt', 'salt', 'kamatis'), false);
  assert.equal(ingredientMatches('Medium Yellow Onion', 'yellow_onion', 'sibuyas'), true);
  assert.equal(ingredientMatches('Ripe Roma Plum Tomatoes', 'roma_tomatoes', 'kamatis'), true);
});
test('dual measurements use defined metric spoons and avoid invented density/cup conversions', () => {
  assert.equal(displayQuantity(15, 'ml'), '15 ml · 1 tbsp (15 ml)');
  assert.equal(displayQuantity(1, 'tbsp'), '1 tbsp · 15 ml');
  assert.equal(displayQuantity(400, 'g'), '400 g');
  assert.equal(displayQuantity(2, 'piece'), '2 piece');
});
