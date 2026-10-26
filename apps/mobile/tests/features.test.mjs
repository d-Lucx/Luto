import { test } from 'node:test';
import assert from 'node:assert/strict';
import { calculatePantryDecrement } from '../src/engine/decrementPantry.ts';
import { TimerManager } from '../src/services/timer/TimerManager.ts';
import { OfflineMediaManager } from '../src/services/media/OfflineMediaManager.ts';
import { SyncService } from '../src/services/sync/SyncService.ts';
import { LOCAL_GUEST_ID } from '../src/database/constants.ts';

// -----------------------------------------------------------------------------
// 1. Pantry Auto-Decrement Engine Tests
// -----------------------------------------------------------------------------

test('pantry decrement accurately deducts selected ingredients and clamps to zero', () => {
  const stock = [
    { id: 'stock-1', ingredientId: 'eggs', quantity: 6, unit: 'piece' },
    { id: 'stock-2', ingredientId: 'butter', quantity: 50, unit: 'g' },
    { id: 'stock-3', ingredientId: 'flour', quantity: 500, unit: 'g' },
  ];

  const used = [
    { ingredientId: 'eggs', amount: 2, unit: 'piece', selected: true },
    { ingredientId: 'butter', amount: 60, unit: 'g', selected: true }, // exceeds stock
    { ingredientId: 'flour', amount: 200, unit: 'g', selected: false }, // unselected
  ];

  const result = calculatePantryDecrement(stock, used);

  // Eggs: 6 - 2 = 4
  assert.equal(result.updatedStock.get('eggs'), 4);

  // Butter: 50 - 60 = 0 (clamped, never negative)
  assert.equal(result.updatedStock.get('butter'), 0);
  assert.ok(result.deletedStockIds.includes('stock-2'));

  // Flour: unselected, must NOT be decremented
  assert.equal(result.updatedStock.has('flour'), false);

  // Summary checks
  const eggSummary = result.summary.find((s) => s.ingredientId === 'eggs');
  assert.equal(eggSummary.previousQuantity, 6);
  assert.equal(eggSummary.newQuantity, 4);
  assert.equal(eggSummary.deductedAmount, 2);
});

// -----------------------------------------------------------------------------
// 2. Kitchen Multi-Timer Engine Tests
// -----------------------------------------------------------------------------

test('timer manager creates, starts, pauses, resets, and formats time correctly', () => {
  const manager = new TimerManager();

  const timer = manager.createTimer('t1', 1, 'Simmer Sauce', 180);
  assert.equal(timer.status, 'idle');
  assert.equal(timer.remainingSeconds, 180);

  // Format check: 180 seconds -> 03:00
  assert.equal(TimerManager.formatTime(180), '03:00');
  assert.equal(TimerManager.formatTime(65), '01:05');
  assert.equal(TimerManager.formatTime(9), '00:09');

  // Start timer
  manager.startTimer('t1');
  const started = manager.getTimer('t1');
  assert.equal(started.status, 'running');
  assert.ok(started.targetEndTimeMs !== null);
  assert.ok(started.targetEndTimeMs > Date.now());

  // Pause timer
  manager.pauseTimer('t1');
  const paused = manager.getTimer('t1');
  assert.equal(paused.status, 'paused');
  assert.equal(paused.targetEndTimeMs, null);

  // Reset timer
  manager.resetTimer('t1');
  const reset = manager.getTimer('t1');
  assert.equal(reset.status, 'idle');
  assert.equal(reset.remainingSeconds, 180);

  // Cleanup
  manager.stopClock();
});

// -----------------------------------------------------------------------------
// 3. Offline Media Manager Tests
// -----------------------------------------------------------------------------

test('offline media manager generates safe file paths, tracks size, and evicts LRU', () => {
  OfflineMediaManager.clearCache();
  OfflineMediaManager.setMaxCacheSize(1000); // 1000 bytes max

  const filename = OfflineMediaManager.generateLocalFilename('https://example.com/media/chicken-adobo.webp?query=1');
  assert.match(filename, /^media_[a-z0-9]+\.webp$/);

  // Register asset 1
  OfflineMediaManager.registerMedia('https://example.com/img1.webp', 'file:///cache/img1.webp', 400);
  assert.equal(OfflineMediaManager.isCached('https://example.com/img1.webp'), true);

  // Register asset 2
  OfflineMediaManager.registerMedia('https://example.com/img2.webp', 'file:///cache/img2.webp', 400);
  assert.equal(OfflineMediaManager.getTotalCachedBytes(), 800);

  // Touch asset 1 so asset 2 becomes the least recently used
  OfflineMediaManager.getLocalUri('https://example.com/img1.webp');

  // Register asset 3 (requires 500 bytes -> 800 + 500 = 1300 > 1000, needs 300 freed)
  // asset 2 is LRU and has 400 bytes, so asset 2 gets evicted!
  OfflineMediaManager.registerMedia('https://example.com/img3.webp', 'file:///cache/img3.webp', 500);

  // img2 was LRU and got evicted; img1 was recently accessed and preserved!
  assert.equal(OfflineMediaManager.isCached('https://example.com/img2.webp'), false);
  assert.equal(OfflineMediaManager.isCached('https://example.com/img1.webp'), true);
  assert.equal(OfflineMediaManager.isCached('https://example.com/img3.webp'), true);
  assert.ok(OfflineMediaManager.getTotalCachedBytes() <= 1000);

  OfflineMediaManager.clearCache();
});

// -----------------------------------------------------------------------------
// 4. Privacy & Sync Boundaries Test
// -----------------------------------------------------------------------------

test('sync service strictly filters out guest inventory to preserve offline privacy', async () => {
  // Guest ID should return null payload for push
  const guestPayload = await SyncService.preparePantryPushPayload(LOCAL_GUEST_ID);
  assert.equal(guestPayload, null);

  const emptyUserPayload = await SyncService.preparePantryPushPayload('');
  assert.equal(emptyUserPayload, null);
});
