import test from 'node:test';
import assert from 'node:assert/strict';
import { scaleIngredients, restoreTimers, planCompletion, planUndo } from '../src/engine/cookingSession.ts';

test('scaled ingredients preserve exact quantities and reject invalid servings', () => {
  const original = [{ ingredientId: 'egg', amount: 2, unit: 'piece', name: 'Eggs' }];
  assert.equal(scaleIngredients(original, 2, 3)[0].amount, 3);
  assert.equal(original[0].amount, 2);
  for (const n of [0, -1, NaN, Infinity, 101]) assert.throws(() => scaleIngredients(original, 2, n));
  assert.throws(() => scaleIngredients(original, 0, 2));
});

test('restored timers use persisted deadlines and preserve paused time', () => {
  const timers = [
    { id: 'a', status: 'running', remainingSeconds: 60, targetEndTimeMs: 60000 },
    { id: 'b', status: 'paused', remainingSeconds: 20, targetEndTimeMs: null },
  ];
  assert.equal(restoreTimers(timers, 45000)[0].remainingSeconds, 15);
  assert.equal(restoreTimers(timers, 65000)[0].status, 'completed');
  assert.equal(restoreTimers(timers, 65000)[1].remainingSeconds, 20);
  assert.equal(timers[0].remainingSeconds, 60);
});

test('completed sessions cannot deduct twice and failed validation leaves stock intact', () => {
  const stock = [{ id: 's', ingredientId: 'egg', quantity: 4, unit: 'piece', storageLocation: 'fridge' }];
  const usage = [{ ingredientId: 'egg', amount: 2, unit: 'piece', name: 'Eggs', selected: true }];
  assert.equal(planCompletion('active', stock, usage).consumed[0].quantity, 2);
  assert.equal(planCompletion('completed', stock, usage), null);
  assert.equal(planCompletion('undone', stock, usage), null);
  assert.throws(() => planCompletion('active', stock, [{ ...usage[0], amount: 5 }]));
  assert.equal(stock[0].quantity, 4);
});

test('undo adds only consumed stock to current inventory with compatible units once', () => {
  const consumed = [{ ingredientId: 'tomato', quantity: 100, unit: 'g', storageLocation: 'fridge' }];
  const stock = [{ id: 's', ingredientId: 'tomato', quantity: 0.5, unit: 'kg' }];
  assert.equal(planUndo('completed', stock, consumed)[0].quantity, 0.6);
  assert.equal(planUndo('undone', stock, consumed), null);
  assert.equal(planUndo('completed', [], consumed)[0].quantity, 100);
  assert.throws(() => planUndo('completed', [{ ...stock[0], unit: 'piece' }], consumed));
});

test('completion supports persisted model fields exposed through getters', () => {
  class Stock {
    get id() { return 'stock'; } get ingredientId() { return 'onion'; }
    get quantity() { return 100; } get unit() { return 'g'; } get storageLocation() { return 'fridge'; }
  }
  const result = planCompletion('active', [new Stock()], [{ ingredientId: 'onion', amount: 100, unit: 'g', selected: true }]);
  assert.deepEqual(result.deletedStockIds, ['stock']);
  assert.deepEqual(result.consumed, [{ ingredientId: 'onion', quantity: 100, unit: 'g', storageLocation: 'fridge' }]);
});
