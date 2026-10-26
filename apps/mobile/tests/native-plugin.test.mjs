import { test } from 'node:test';
import assert from 'node:assert/strict';
import native from '../plugins/watermelonNative.cjs';

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
