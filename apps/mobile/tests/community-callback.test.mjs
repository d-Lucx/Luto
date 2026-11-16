import test from 'node:test';
import assert from 'node:assert/strict';
import { callbackFromRoute } from '../src/services/community/callbackRoute.ts';
test('warm Android callback uses the routed code when initial Linking URL is stale', () => {
  assert.equal(callbackFromRoute('luto:///community', { code: 'one-use-code' }), 'luto://auth/callback?code=one-use-code');
  assert.equal(callbackFromRoute(null, { code: 'cold-code' }), 'luto://auth/callback?code=cold-code');
});
test('incomplete callback waits instead of showing a false sign-in error', () => {
  assert.equal(callbackFromRoute('luto:///community', {}), null);
});
test('callback resolution preserves exact validation and rejects implicit/ambiguous tokens', () => {
  assert.equal(callbackFromRoute('luto://auth/callback?code=live', { code: 'live' }), 'luto://auth/callback?code=live');
  assert.throws(() => callbackFromRoute(null, { code: ['a', 'b'] }));
  assert.throws(() => callbackFromRoute(null, { code: 'a', access_token: 'b' }));
  assert.throws(() => callbackFromRoute(null, { '#': 'access_token=bad' }));
});
test('old error/implicit fragments cannot override a new routed callback or consume a new flow', () => {
  assert.equal(callbackFromRoute('luto://auth/callback#error=access_denied', {}), null);
  assert.equal(callbackFromRoute('luto://auth/callback#access_token=old', { code: 'new' }), 'luto://auth/callback?code=new');
  assert.equal(callbackFromRoute('luto://auth/callback?code=old', { code: 'new' }), 'luto://auth/callback?code=new');
});
