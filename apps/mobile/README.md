# Luto mobile core

Expo SDK 54, Expo Router, Hermes, strict TypeScript, and WatermelonDB 0.28.
The native SQLite database holds recipes, steps, ingredient requirements,
canonical ingredients, guest pantry inventory, techniques, and equipment.

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

This workspace implements the mobile foundation and local pantry slice of
Milestone 3. It does **not** implement backend delta synchronization or media
download/hash verification (roadmap task 3.2). WatermelonDB tracks pending local
changes internally; no redundant sync queue is added. A server sync contract,
authenticated user mapping, deletion tombstones, and pantry conflict semantics
must be agreed before enabling network writes. The architecture documents differ
on additive pantry merging versus last-write-wins; this app makes no remote writes.

On the authoring Windows environment npm registry access failed with `EACCES`.
Dependency installation, full application type checking, Expo prebuild, native
compilation, simulator/emulator launch, airplane-mode persistence, and the
500-recipe/60-frames-per-second performance gate remain unverified. Local unit
tests and an isolated strict type check of the evaluator can run here.

Before release: install dependencies and commit the npm lockfile, run the commands
above, build both platforms, test persistence in airplane mode, and profile at
least 500 cached recipes on real hardware. The complete milestone and native
performance gate cannot be claimed from unit-test results alone.

References: [Expo SDK 54](https://expo.dev/changelog/sdk-54),
[WatermelonDB installation](https://watermelondb.dev/docs/Installation),
[WatermelonDB 0.28 changelog](https://github.com/Nozbe/WatermelonDB/blob/master/CHANGELOG.md).
