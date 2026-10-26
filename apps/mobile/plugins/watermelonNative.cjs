// Pure transforms kept separate from Expo APIs so prebuild changes can be
// checked without an Android SDK, Xcode, or installed Expo dependencies.
function insertAfter(source, anchor, addition, marker) {
  if (source.includes(marker)) return source;
  if (!anchor.test(source)) throw new Error(`WatermelonDB prebuild: missing anchor for ${marker}`);
  return source.replace(anchor, (match) => `${match}\n${addition}`);
}

function podfile(source) {
  return insertAfter(source, /^\s*use_expo_modules!.*$/m,
    "  pod 'simdjson', path: '../node_modules/@nozbe/simdjson', modular_headers: true", "pod 'simdjson'");
}

function settingsGradle(source) {
  if (source.includes("include ':watermelondb-jsi'")) return source;
  return `${source}\ninclude ':watermelondb-jsi'\nproject(':watermelondb-jsi').projectDir = new File(rootProject.projectDir, '../node_modules/@nozbe/watermelondb/native/android-jsi')\n`;
}

function appBuildGradle(source) {
  source = insertAfter(source, /dependencies\s*\{/,
    "    implementation project(':watermelondb-jsi')", "implementation project(':watermelondb-jsi')");
  return insertAfter(source, /android\s*\{/,
    "    packagingOptions { jniLibs { pickFirsts += ['**/libc++_shared.so'] } }", "pickFirsts += ['**/libc++_shared.so']");
}

function mainApplication(source, language) {
  if (language !== 'kt') throw new Error('WatermelonDB prebuild expects the Expo Kotlin MainApplication template');
  source = insertAfter(source, /^package\s+[^\n]+/m,
    'import com.nozbe.watermelondb.jsi.WatermelonDBJSIPackage', 'import com.nozbe.watermelondb.jsi.WatermelonDBJSIPackage');
  return insertAfter(source, /PackageList\(this\)\.packages\.apply\s*\{/,
    '              add(WatermelonDBJSIPackage())', 'add(WatermelonDBJSIPackage())');
}

module.exports = { podfile, settingsGradle, appBuildGradle, mainApplication };
