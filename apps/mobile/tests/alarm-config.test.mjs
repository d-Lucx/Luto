import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import vm from 'node:vm';
import ts from 'typescript';

const source = fs.readFileSync(new URL('../src/services/timer/alarmSettings.ts', import.meta.url), 'utf8');
const compiled = ts.transpileModule(source, { compilerOptions: { target: ts.ScriptTarget.ES2022, module: ts.ModuleKind.CommonJS } }).outputText;
const config = JSON.parse(fs.readFileSync(new URL('../app.json', import.meta.url), 'utf8')).expo;
function settings(os, version, failure) {
  const calls = [];
  const exports = {};
  vm.runInNewContext(compiled, { exports, require(name) {
    if (name === 'react-native') return { Platform: { OS: os, Version: version }, Linking: { openSettings: async () => calls.push('app-settings') } };
    if (name === 'expo-intent-launcher') return { startActivityAsync: async (action, options) => {
      calls.push({ action, options: JSON.parse(JSON.stringify(options)) });
      if (failure) throw failure;
    } };
    throw new Error(`Unexpected module ${name}`);
  } });
  return { open: exports.openAlarmSettings, calls };
}

test('Android 12+ opens the user-controlled alarm page for this application', async () => {
  assert.ok(config.android.permissions.includes('android.permission.SCHEDULE_EXACT_ALARM'));
  for (const version of [31, 35, '36']) {
    const target = settings('android', version);
    await target.open();
    assert.deepEqual(target.calls, [{ action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM', options: { data: `package:${config.android.package}` } }]);
  }
});

test('older Android does not launch an unavailable special permission screen', async () => {
  const target = settings('android', 30);
  await target.open();
  assert.deepEqual(target.calls, []);
});

test('iOS opens app settings and unsupported Android intents reach the caller', async () => {
  const ios = settings('ios', '18.0');
  await ios.open();
  assert.deepEqual(ios.calls, ['app-settings']);
  const error = new Error('No matching activity');
  await assert.rejects(settings('android', 35, error).open(), (cause) => cause === error);
});

test('startup replaces an existing alarm and does not replay expired deadlines', async () => {
  const notificationsSource = fs.readFileSync(new URL('../src/services/timer/notifications.ts', import.meta.url), 'utf8');
  const notificationsCode = ts.transpileModule(notificationsSource, { compilerOptions: { target: ts.ScriptTarget.ES2022, module: ts.ModuleKind.CommonJS } }).outputText;
  const deadline = Date.now() + 60000;
  const row = { id: 'session', recipeId: 'recipe', status: 'active', payload: JSON.stringify({ title: 'Soup', timers: [
    { id: 'timer', status: 'running', targetEndTimeMs: deadline, label: 'Soup timer' },
    { id: 'expired', status: 'running', targetEndTimeMs: Date.now() - 1000, label: 'Expired timer' },
  ] }) };
  const pending = [{ identifier: 'lu2-session-timer', content: { data: { lu2: true, sessionId: 'session', deadline } } }];
  const events = [];
  const exports = {};
  const native = {
    setNotificationHandler() {}, getPermissionsAsync: async () => ({ granted: true }),
    getAllScheduledNotificationsAsync: async () => [...pending],
    cancelScheduledNotificationAsync: async (id) => { events.push(['cancel', id]); pending.splice(pending.findIndex((n) => n.identifier === id), 1); },
    scheduleNotificationAsync: async (alert) => events.push(['schedule', alert.identifier, alert.trigger.date]),
    SchedulableTriggerInputTypes: { DATE: 'date' },
  };
  vm.runInNewContext(notificationsCode, { exports, require(name) {
    if (name === 'expo-notifications') return native;
    if (name === 'react-native') return { Platform: { OS: 'ios' } };
    if (name === '@nozbe/watermelondb') return { Q: { where: () => ({}) } };
    if (name === '../../database') return { database: { get: () => ({ query: () => ({ fetch: async () => [row] }), find: async () => row }) } };
    if (name === '../../database/models') return {};
    if (name === '../../engine/SerialQueue') return { SerialQueue: class { run(key, work) { return work(); } } };
    throw new Error(`Unexpected module ${name}`);
  } });
  await exports.reconcileAlerts();
  assert.deepEqual(events, [['cancel', 'lu2-session-timer'], ['schedule', 'lu2-session-timer', deadline]]);
});
