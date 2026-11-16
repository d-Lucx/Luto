import test from 'node:test';
import assert from 'node:assert/strict';
import { SerialQueue } from '../src/engine/SerialQueue.ts';
test('session operations serialize and recover after a rejected operation', async () => {
  const queue = new SerialQueue(); const events = [];
  let release; const gate = new Promise((resolve) => { release = resolve; });
  const first = queue.run('session', async () => { events.push('start'); await gate; events.push('scheduled'); throw new Error('native failure'); });
  const second = queue.run('session', async () => { events.push('cancelled'); return 42; });
  await Promise.resolve(); release();
  await assert.rejects(first, /native failure/);
  assert.equal(await second, 42);
  assert.deepEqual(events, ['start', 'scheduled', 'cancelled']);
});
