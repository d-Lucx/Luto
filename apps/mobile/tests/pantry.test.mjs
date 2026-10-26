import { test } from 'node:test';
import assert from 'node:assert/strict';
import { evaluatePantryMatch, matchLabel } from '../src/engine/evaluatePantryMatch.ts';

const req = (id, tier = 1, extra = {}) => ({ id, name: id, isStaple: false, isOptional: false, tier, amount: 100, unit: 'g', ...extra });
const stock = (...items) => new Map(items.map(([id, quantity = 100, unit = 'g']) => [id, { ingredientId: id, quantity, unit }]));
const evaluate = (requirements, pantry = new Map(), rules = new Map(), context) => evaluatePantryMatch('recipe', requirements, pantry, rules, context);
const rule = (extra = {}) => ({ substituteIngredientId: 'tofu', conversionRatio: 1, isEmergency: false, ...extra });

test('empty and staple-only recipes are ready', () => {
  assert.equal(evaluate([]).matchScore, 100);
  assert.equal(evaluate([req('salt', 0)]).canCookNow, true);
  assert.equal(evaluate([req('oil', 2, { isStaple: true })]).matchScore, 100);
});

test('exact sufficient stock scores 100 without changing pantry', () => {
  const pantry = stock(['chicken']);
  const result = evaluate([req('chicken')], pantry);
  assert.equal(result.matchScore, 100);
  assert.equal(result.canCookNow, true);
  assert.equal(pantry.get('chicken').quantity, 100);
});

test('quantity and compatible units matter; incompatible units do not match', () => {
  assert.equal(evaluate([req('chicken')], stock(['chicken', 0.1, 'kg'])).matchScore, 100);
  assert.equal(evaluate([req('chicken')], stock(['chicken', 99])).matchScore, 0);
  assert.equal(evaluate([req('chicken')], stock(['chicken', 100, 'ml'])).matchScore, 0);
  assert.equal(evaluate([req('oil', 2, { unit: 'ml', amount: 15 })], stock(['oil', 1, 'tbsp'])).matchScore, 100);
});

test('critical missing penalty follows weighted equation', () => {
  const result = evaluate([req('chicken'), req('onion', 2)], stock(['onion']));
  assert.equal(result.matchScore, 9); // (2 - 1.5) / 5.5 * 100
  assert.equal(result.canCookNow, false);
  assert.equal(result.missingIngredients[0].id, 'chicken');
});

test('optional items earn half weight without being listed as missing', () => {
  const result = evaluate([req('chicken'), req('parsley', 3, { isOptional: true })], stock(['chicken']));
  assert.equal(result.matchScore, 91);
  assert.equal(result.missingIngredients.length, 0);
  assert.equal(result.canCookNow, true);
  assert.match(matchLabel(result), /Optional/);
});

test('approved substitutes need ratio-adjusted quantity and prefer non-emergency', () => {
  const matrix = new Map([['chicken', [rule({ isEmergency: true }), rule({ conversionRatio: 2 })]]]);
  assert.equal(evaluate([req('chicken')], stock(['tofu', 200]), matrix).matchScore, 90);
  assert.equal(evaluate([req('chicken')], stock(['tofu', 100]), matrix).matchScore, 75);
  assert.equal(evaluate([req('chicken')], stock(['tofu', 99]), matrix).matchScore, 0);
});

test('context-limited substitutes require a context and respect forbidden contexts', () => {
  const matrix = new Map([['chicken', [rule({ applicableContexts: ['baking'], forbiddenContexts: ['boiling'] })]]]);
  assert.equal(evaluate([req('chicken')], stock(['tofu']), matrix).matchScore, 0);
  assert.equal(evaluate([req('chicken')], stock(['tofu']), matrix, 'boiling').matchScore, 0);
  assert.equal(evaluate([req('chicken')], stock(['tofu']), matrix, 'baking').matchScore, 90);
});

test('repeated requirements and substitutions cannot double-spend stock', () => {
  assert.equal(evaluate([req('chicken'), req('chicken')], stock(['chicken'])).missingIngredients.length, 1);
  const matrix = new Map([['chicken', [rule()]], ['beef', [rule()]]]);
  assert.equal(evaluate([req('chicken'), req('beef')], stock(['tofu']), matrix).missingIngredients.length, 1);
});

test('exact required stock is reserved before substitute use', () => {
  const result = evaluate([req('chicken'), req('tofu')], stock(['tofu']), new Map([['chicken', [rule()]]]));
  assert.deepEqual(result.missingIngredients.map((item) => item.id), ['chicken']);
  assert.equal(result.substitutedIngredients.length, 0);
});

test('bad quantities and ratios do not produce false positives', () => {
  for (const quantity of [NaN, Infinity, -1, 0]) {
    assert.equal(evaluate([req('chicken')], stock(['chicken', quantity])).matchScore, 0);
  }
  assert.equal(evaluate([req('chicken')], stock(['tofu']), new Map([['chicken', [rule({ conversionRatio: -1 })]]])).matchScore, 0);
  assert.throws(() => evaluate([req('chicken', 1, { amount: NaN })]), RangeError);
});

test('required substitutions take priority over optional exact matches', () => {
  const result = evaluate([req('tofu', 3, { isOptional: true }), req('chicken')], stock(['tofu']), new Map([['chicken', [rule()]]]));
  assert.equal(result.missingIngredients.length, 0);
  assert.equal(result.substitutedIngredients.length, 1);
  assert.equal(result.matchScore, 83);
});
