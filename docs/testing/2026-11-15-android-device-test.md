# Android device test — November 15, 2026

Status: Device smoke tests completed for the local cookbook foundation. Remaining release checks are listed separately.

## Device and build

- Infinix X6852, Android 16 / API 36, arm64-v8a.
- Physical display: 1080 × 2436, 480dpi (360dp wide), three-button navigation.
- Luto 0.1.0, package `com.luto.app`, local release-mode APK signed with the project's debug test key. This is a standalone test installation, not a production distribution.
- Expo SDK 54, React Native 0.81.5, Hermes, existing legacy architecture configuration, WatermelonDB 0.28.
- Initial native build: successful, 621 tasks, 12m 56s. Final viewport-fix build: successful, 2m 10s, exit code 0.
- Installed APK SHA-256: `A09ED3DE723BAABB7B83BCB9D5985F7498AEDD966630A2995F5BF79C5C029A9D`.
- Required SDK packages were installed from Google's official repository with published SHA-1 checksums verified: NDK 27.1.12297006, CMake 3.22.1, base Android API 36, and Build Tools 35. Build Tools 36 was already installed.
- Test artifacts and build logs are stored locally under `apps/mobile/.expo/device-tests/` (Git-ignored). No phone serial number or unrelated app content is included in this report.

## Observed results

| Check | Result | Evidence / limits |
| --- | --- | --- |
| Native APK build and installation | Pass | Release-mode APK built and installed on the physical device |
| Offline cold launch without Metro | Pass | Airplane mode enabled and Wi-Fi off; app opens without an account or development server |
| Explicit offline sample loading | Pass | Sample Shakshuka and its canonical ingredients load locally |
| Pantry entry and matching | Pass | 2 eggs, 400g tomatoes, 100g onion produce “100% Ready to Cook” |
| SQLite persistence | Pass | All three quantities and the sample recipe survive force-stop and cold restart offline; also survive APK updates |
| Recipe overview | Pass | Base servings, ingredient quantities, method, and missing equipment/nutrition text render locally |
| Cooking navigation | Pass | Step 1 → 2 → 1 → 2 works; first Previous control is disabled |
| Completion controls | Pass after fix | All three actions fully visible above Android navigation after scrolling; captures 17 and 24 |
| Finish without deduction | Pass | 2 eggs, 400g tomatoes, 100g onion remain unchanged; capture 18 |
| Missing-stock deduction error | Pass | Untracked Salt keeps modal open with an explanation. Subsequent successful deduction confirms the failed attempt did not consume eggs/tomatoes; capture 19 |
| Confirmed selected deduction | Pass | Selected eggs/tomatoes removed; unchecked onion remains 100g, including after force-stop/restart; captures 20–21 |
| Large system text | Pass for sample cooking/completion | At font scale 2.0, both sample steps remain readable and all completion actions are reachable by scrolling. Back to cooking works. Restored 1.0; captures 22–24. This is not whole-app large-text certification |
| Local recipe creation | Pass | Saved an explicitly labelled “Device timer test” with one step and a one-minute timer, offline. Fixture remains local and is not a tested food recipe |
| Foreground timer controls | Pass | Countdown observed, pause holds at 00:56, resume continues, reset returns to 01:00; captures 25–29 |
| Short background timer return | Pass within same process | Home for five seconds, return, pause at 00:50 from 00:56. Does not establish long sleep, process death, alarm delivery, or exact timing accuracy |
| Screen-reader semantics | Partial | Native UI tree exposes named inputs, selected tabs/storage choices, checkbox states, and disabled controls; audible TalkBack use is not verified |
| Landscape/tablet behavior | Not verified | Current app configuration locks portrait; this handset is not tablet coverage |
| 500-recipe performance | Not run | One sample recipe is not a performance benchmark |

Activity launch times reported by Android were approximately 0.4–0.9 seconds. These measure activity launch/display and must not be reported as full interactive-startup benchmarks.

## Device-found corrections

1. **Unreadable pantry hints and default text:** Explicit theme colors were missing from the ingredient placeholder and suggestion/storage text. Added readable colors; the updated placeholder and text were observed on-device.
2. **First suggestion tap consumed by the keyboard:** Set the fridge list's `keyboardShouldPersistTaps` to `handled`. Ingredient selection and entry were retested successfully.
3. **Missing tab glyphs:** Default tab icons displayed as boxes. Replaced them with clear text-only tab labels; the updated tabs were observed on-device.
4. **Completion scroll viewport:** At maximum scroll, the original completion modal left “Finish without deduction” partially behind Android's navigation bar and “Back to cooking” unreachable. A percentage-height attempt also failed physically. Added a numeric height calculated from window/safe-area dimensions, a flexing scroll viewport, and safe-area padding. Retested successfully at font scales 1.0 and 2.0.

The test automation also required corrections: it initially tapped the keyboard where an obscured Save button would have been, and fast ADB numeric typing dropped characters. Those were harness errors, not evidence of a SQLite save failure. Subsequent entry verifies actual field values, types at normal speed, and dismisses the keyboard before saving.

## Remaining release limitations

Backend publishing, guest saves/download management, serving scaling, durable cooking-session restoration/replay protection, background alarm delivery, and tested recipe-content promotion remain separate launch requirements. A native smoke-test pass does not establish those capabilities.

Fresh automated verification after the final source change: 31/31 Node tests pass, strict TypeScript check passes, and `git diff --check` passes with CRLF-aware settings.

Before testing, connectivity was airplane mode off, Wi-Fi on, mobile data enabled; font scale 1.0, fixed portrait rotation. Final restoration was verified: airplane mode `0`, Wi-Fi `1`, mobile data `1`, font scale `1.0`. Rotation was unchanged. The app remains installed; the timer was reset. Test pantry currently contains only 100g onion after the intentional deduction check.
