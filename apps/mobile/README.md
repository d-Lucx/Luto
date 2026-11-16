# Luto mobile core

Expo SDK 54, Expo Router, Hermes, strict TypeScript, and WatermelonDB 0.28.
The native SQLite database holds recipes, steps, ingredient requirements,
canonical ingredients, guest pantry inventory, techniques, and equipment.

## Cookbook foundation

The library, fridge, local creator, cooking screen, and completion modal share
a warm paper palette. Open **Recipes**, load the opt-in offline sample if the
library is empty, and tap a recipe to read its ingredients and method before
starting cooking. Choose servings, save recipes to your cookbook, and download
optional verified media separately. Metric spoon equivalents appear where
supported; pantry quantities have explicit units. The six editorial drafts are not
imported as curated content.

Pantry deduction now converts compatible units (for example, 100g used from
0.5kg leaves 0.4kg). Invalid units or insufficient stock keep the completion
modal open with an explanation. Uncheck untracked ingredients, or choose
**Finish without deduction**. The current writer reads stock and applies one
batch under the database write lock. A durable cooking snapshot freezes the
selected servings, ingredient quantities, steps and timer deadlines. Completion
and deduction commit together, prevent replay, and offer additive undo against
current compatible stock. Completed sessions remain accessible from recipe history.

The creator saves drafts locally and supports editing your own recipes. Existing
cooking sessions keep their original snapshot after edits. Publishing is a separate
signed-in action on the recipe page. The separate Luto backend publishes automated
passes and privately holds flagged submissions. Community browsing/text saves work
as a guest; reviews and reports require sign-in.

Google sign-in uses a browser PKCE flow and SecureStore. Provider credentials live
in Supabase, never the app. The free support site is
[lu2-cooking.vercel.app](https://lu2-cooking.vercel.app). Email sign-in remains
limited by the configured sender; the free Google flow does not require SMTP.

Cooking mode keeps the screen awake while focused. Timer deadlines survive process
restart; local notifications can alert in the background. Android 12+ precise
delivery requires the user-controlled **Alarms & reminders** permission, opened
from the timer's **Android alarm settings** button. Device restrictions can still
delay delivery, and force-stop disables app alarms until reopening.

The CommonJS Babel configuration is named `babel.config.cjs` because this
package uses ES modules. `expo-linking` is declared at the installed Expo SDK's
compatible version for Expo Router.

## Run

Requires Node.js 22.18+ and npm. From this directory:

```powershell
npm install
npx expo install --check
npm run typecheck
npm test
npm run android
# macOS with Xcode:
npm run ios
```

Use a development build, not Expo Go: WatermelonDB contains native code.
Expo SDK 54 supports the legacy React Native architecture;
`newArchEnabled: false` is deliberate. Do not upgrade the Expo major version
without checking WatermelonDB compatibility. The local config plugin adds
the iOS simdjson pod and Android JSI module, registration, and packaging rule.
Generated native directories are build artifacts; regenerate with
`npx expo prebuild --clean` when changing native configuration.

The JavaScript Interface (JSI) SQLite adapter is enabled on both platforms.
The database is device-local and requires no Supabase credentials to start.
`expo-sqlite` is not used: WatermelonDB owns its SQLite adapter and connection.

## Offline fridge

Open My Fridge and choose **Try an offline sample recipe** on the empty database.
This explicitly creates device-only sample data; no network request is made.
Search Eggs, Tomatoes, or Onion, choose the canonical result, enter the **total**
quantity on hand, choose a storage location, and save. Two eggs, 400 g tomatoes,
and 100 g onion yield a 100% match for the sample shakshuka. Salt is exempt.
Low matches are hidden by default; use the switch to see them.
Inventory persists in SQLite across restarts. Saving zero or choosing Remove
deletes an inventory entry. The list updates from database change observations.

Guest inventory uses `local-guest`; it must stay on the device. Sample IDs have
a `demo-` prefix and must never be uploaded as backend canonical UUIDs.
When connecting a backend, use a separate authenticated database or explicitly
migrate guest inventory and delete sample records before enabling sync.

## Pantry evaluation

`src/engine/evaluatePantryMatch.ts` implements the specification's weighted
equation, critical ingredient penalties, staple exemption, optional half credit,
90% approved substitutions, and 75% emergency substitutions. Formula scores
take precedence over the prose suggestion that direct substitutes score 100%.

Matching requires sufficient quantities and supports g/kg, ml/l, and metric
tsp/tbsp (5/15 ml). Other units match only when equal after trimming and lowercasing.
There are no inferred density, cup-size, or piece-to-mass conversions. Substitute
ratios are expressed in the requirement's unit. Converting to another dimension
requires an explicit ingredient-specific conversion before calling this engine.

The evaluator reserves exact required ingredients first, then tries required
substitutions, then optional requirements. This prevents double spending stock
but is a deterministic greedy allocation, not a global optimization solver.
Each recipe is evaluated independently because recommendations are alternatives.
Context-limited substitutions require an explicit applicable cooking context;
forbidden contexts always win. The fridge screen currently uses exact matching;
the evaluator accepts a canonical-ID substitution matrix for future ingestion.

## Verification and remaining integration

`npm test` uses Node's built-in test runner and TypeScript stripping; it works
without installed packages. It covers scoring, quantity/unit checks, substitution
ratios and contexts, shared stock, priority, and native configuration transforms.

The app now integrates verified persistent media downloads and complete community
recipe snapshots. Remote pantry synchronization remains disabled. WatermelonDB
tracks pending local changes internally; no redundant sync queue is added. A server sync contract,
authenticated user mapping, deletion tombstones, and pantry conflict semantics
must be agreed before enabling network writes. The architecture documents differ
on additive pantry merging versus last-write-wins; this app makes no remote pantry writes.

Verification on November 15, 2026: 91 Node tests and the full strict TypeScript
check pass. Theme color calculations give at least 5.11:1 for the checked text
pairs, including supporting text on the inset surface. Independent code review
identified fridge contrast/selection issues; both were corrected.

Android JavaScript export passes using `npx expo export --platform android
--output-dir .expo/cookbook-preview` (1,319 modules, 3.08MB Hermes bundle).
The standalone Android APK was built and installed on an Infinix X6852 running
Android 16. Physical-device checks passed for offline launch, SQLite persistence,
pantry matching, selected deduction/error handling, cooking navigation, timer
controls, and sample cooking/completion at 200% system text. Device testing found
and corrected pantry contrast, keyboard selection, missing tab glyphs, and an
overflowing completion modal. See the [device test report](../../docs/testing/2026-11-15-android-device-test.md)
for the initial evidence. The [launch-gap report](../../docs/testing/2026-11-15-launch-gaps.md)
records subsequent native recovery, completion/undo, background alert, media
restart/removal, and synthetic 500-recipe results. Audible TalkBack, long-sleep/reboot,
tablet coverage and realistic cookbook scrolling still require verification.

The latest audit reports 21 npm advisories (1 low, 16 moderate, 4 high), down
from 25 after narrow Babel runtime, Forge and PostCSS patches. Remaining findings
need further triage; no forced native-stack major upgrade was applied.

Before the Android release, complete the remaining native accessibility and
background behavior checks and extend the synthetic 500-recipe profile to a realistic cookbook.
Verify iOS separately before its later release. The complete milestone and
native performance gate cannot be claimed from unit-test results alone.

References: [Expo SDK 54](https://expo.dev/changelog/sdk-54),
[WatermelonDB installation](https://watermelondb.dev/docs/Installation),
[WatermelonDB 0.28 changelog](https://github.com/Nozbe/WatermelonDB/blob/master/CHANGELOG.md).
