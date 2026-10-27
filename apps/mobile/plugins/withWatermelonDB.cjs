const { withPodfile, withSettingsGradle, withAppBuildGradle, withMainApplication } = require('expo/config-plugins');
const native = require('./watermelonNative.cjs');

// The SQLite bridge autolinks; Android's optional JSI bridge needs these additions.
module.exports = function withWatermelonDB(config) {
  config = withPodfile(config, (mod) => {
    mod.modResults.contents = native.podfile(mod.modResults.contents);
    return mod;
  });
  config = withSettingsGradle(config, (mod) => {
    mod.modResults.contents = native.settingsGradle(mod.modResults.contents);
    return mod;
  });
  config = withAppBuildGradle(config, (mod) => {
    mod.modResults.contents = native.appBuildGradle(mod.modResults.contents);
    return mod;
  });
  return withMainApplication(config, (mod) => {
    mod.modResults.contents = native.mainApplication(mod.modResults.contents, mod.modResults.language);
    return mod;
  });
};
