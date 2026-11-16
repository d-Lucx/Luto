import { test } from 'node:test';
import assert from 'node:assert/strict';
import native from '../plugins/watermelonNative.cjs';
import { existsSync } from 'node:fs';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

test('Metro can load the Babel config in the ES module package', () => {
  const cjs = new URL('../babel.config.cjs', import.meta.url);
  const path = existsSync(cjs) ? cjs : new URL('../babel.config.js', import.meta.url);
  const configFactory = createRequire(import.meta.url)(fileURLToPath(path));
  const config = configFactory({ cache() {} });
  assert.ok(config.presets.includes('babel-preset-expo'));
});

test('native transforms insert JSI and simdjson configuration idempotently', () => {
  const inputs = {
    podfile: "target 'Luto' do\n  use_expo_modules!\nend\n",
    settingsGradle: "include ':app'\n",
    appBuildGradle: 'android {\n}\ndependencies {\n}\n',
    mainApplication: 'package com.luto.app\nclass MainApplication {\nval packages = PackageList(this).packages.apply {\n}\n}',
  };
  for (const [name, source] of Object.entries(inputs)) {
    const transformed = native[name](source, 'kt');
    assert.notEqual(transformed, source);
    assert.equal(native[name](transformed, 'kt'), transformed);
  }
  assert.match(native.mainApplication(inputs.mainApplication, 'kt'), /add\(WatermelonDBJSIPackage\(\)\)/);
});

test('native template changes fail clearly instead of silently skipping configuration', () => {
  assert.throws(() => native.podfile(''), /missing anchor/);
  assert.throws(() => native.appBuildGradle(''), /missing anchor/);
  assert.throws(() => native.mainApplication('package com.luto.app', 'kt'), /missing anchor/);
  assert.throws(() => native.mainApplication('', 'java'), /Kotlin/);
});
