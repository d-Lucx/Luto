# Isolated 500-fixture SQLite performance harness

Status: Harness implemented; native measurements are pending. Pure fixture tests and TypeScript checks do not establish device performance.

## Isolation and enablement

Build the test APK with `EXPO_PUBLIC_DEVICE_TESTS=1` present while bundling JavaScript. This is an Expo public build-time flag, not a secret or a runtime toggle. Open `luto://test-kitchen` only in the test build. A build without the exact value `1` renders “Device tests unavailable”; the route does not import or initialize the harness. The native runner checks the flag again before creating its adapter.

The harness creates a separate WatermelonDB SQLite adapter named **`luto-benchmark`**, using the app's current schema, migrations, and model classes. It never imports the production database singleton, demo loader, pantry helpers, cookbook helpers, or sessions, and never writes/deletes production `luto`. The app's shared root layout may independently initialize production services; that is outside the harness. No database reset or delete operation is provided.

The first run creates one transaction containing 500 synthetic recipe records, 2,000 canonical requirements, 1,000 steps, four dictionary items, and four pantry rows (3,508 total). IDs and all content use a benchmark prefix. These are performance fixtures, with no media, cooking claims, publishing, or timers. Quantities cover stock ratios 0.5, 1, 1.5, 2, and 2.5; 200 of 500 records match fully. Subsequent process launches query the existing dataset and perform no seed writes. Unexpected row counts fail visibly rather than deleting or overwriting the database.

## What the JSON measures

The route autostarts one run per JavaScript process and displays compact JSON in native Text with `testID="benchmark-result"` and accessibility content description beginning `Benchmark result ` followed by the JSON. Capture both the UI tree and screenshot. The error node is labeled `Benchmark error`.

All durations use monotonic `performance.now()` and describe component operations only:

| Field in `timingsMs` | Operation |
| --- | --- |
| `databaseOpenAndCount` | Adapter/database construction plus initial recipe count; includes setup/first query work |
| `seed` | First-run synthetic generation and one native batch; zero on existing-dataset runs |
| `recipeFetch` | Native query and hydration of all 500 recipes |
| `dictionaryFetch` | Native query and hydration of four dictionary rows |
| `requirementsFetch` | Native query and hydration of 2,000 requirement rows |
| `pantryFetch` | Indexed test-user query and hydration of four pantry rows |
| `scoringAndSort` | Canonical mapping, grouping, 500 actual `evaluatePantryMatch` calls, and sorting |
| `indexedRecipeDetail` | Three concurrent SQL queries: recipe primary key, indexed requirements by recipe ID, indexed steps by recipe ID sorted by step number |

The fetch timings run sequentially, rather than overlapping and misrepresenting their individual costs. Indexed detail queries run after list hydration, so the detail number describes a warm-model-cache detail read; SQL queries still execute. Setup/count precedes list queries and can warm SQLite/OS caches. Force-stopping produces a new app process, not a guaranteed cold disk cache.

`nativeMemoryBytes` is explicitly `null`: this JS harness has no supported native process-memory reader. Collect Android PSS separately using `adb shell dumpsys meminfo com.luto.app` and retain the raw output. Do not substitute JavaScript heap data for native process memory.

These numbers do **not** measure Activity startup, time until interactive UI, frame pacing, scrolling, real media memory, or all production rendering paths. They do not establish the full 500-recipe product gate. The small four-ingredient dictionary is the requested controlled fixture, not evidence for a varied production dataset.

## Device collection procedure

Use a named reference device and standalone native build with Metro disconnected. Record APK checksum, build mode, engine, architecture, OS, available storage, screen/font scale, connectivity, thermal/battery conditions, and schema/fixture versions. Do not clear app data: the benchmark is already in a separate database, and clearing app data would erase production test state too.

1. Verify the disabled route in a regular build before installing the flagged test build. It must show unavailable. Verify existing production pantry and cookbook records before and after benchmark work.
2. Open the enabled route once. Wait for `Benchmark complete`; save the JSON with `seededThisRun:true`, screenshot, XML, and meminfo. Record seed separately from later runs.
3. Force-stop and launch the route ten times, waiting for completion before capturing each JSON and memory snapshot. Each existing-dataset run must say `seededThisRun:false` and report exact fixture counts. Keep raw results, report median and max, and identify the sample count. Do not call same-process remounts cold launches; the runner intentionally caches its first result.
4. Separately collect Android Activity launch/display data with `adb shell am start -W ...` using the actual resolved Activity/deep link. Label Android's `ThisTime`, `TotalTime`, and `WaitTime` accurately; none is a verified full interactive-startup metric. Keep development launcher time separate if using a development client.
5. Run a separate real UI scrolling/frame-pacing check with a realistic 500-recipe production-shaped dataset before accepting a scrolling target. This fixture harness supplies no pass/fail threshold for that gate.

Example read-only collection commands (adapt artifact destinations and actual launch Activity):

```powershell
adb shell am force-stop com.luto.app
adb shell am start -W -a android.intent.action.VIEW -d 'luto://test-kitchen' com.luto.app
adb shell uiautomator dump /sdcard/luto-benchmark.xml
adb pull /sdcard/luto-benchmark.xml .
adb shell dumpsys meminfo com.luto.app
```

For XML parsing, find the node whose `content-desc` begins `Benchmark result `, remove that exact prefix, XML-decode the attribute through an XML parser, then JSON-parse it. Do not scrape visible numeric text or infer results from a screenshot alone. Screenshots remain useful confirmation of the actual route and completion state.

## Report template

- Status/date: pending / measured; operator:
- Reference device / Android / API / RAM:
- APK SHA256 / app version / commit:
- Build mode / Hermes / architecture / flag:
- Schema version / fixture version / database name:
- Production test data unchanged before/after:
- Connectivity / storage / thermal state / font scale:
- First seed result and raw artifact links:
- Existing-dataset process launches: count; JSON/XML/screenshot links:

| Component (ms) | Median | Maximum | Samples | Notes |
| --- | --- | --- | --- | --- |
| Database open + count | Pending | Pending | 0 | |
| Recipe fetch (500) | Pending | Pending | 0 | |
| Dictionary fetch (4) | Pending | Pending | 0 | |
| Requirement fetch (2,000) | Pending | Pending | 0 | |
| Pantry fetch (4) | Pending | Pending | 0 | |
| Score + sort (500) | Pending | Pending | 0 | |
| Indexed detail (1 + 4 + 2 rows) | Pending | Pending | 0 | Warm model cache |

- Native memory: raw meminfo link; TOTAL PSS and unit; collection point; pending until measured.
- Activity launch/display: raw `am start -W` output and exact field names; pending until measured.
- Interactive startup/scrolling gate: **not measured by this harness**.
- Observed errors, outliers, and limitations:
- Performance targets agreed separately; no inferred pass from an unapproved target.

## Automated checks

```powershell
node --experimental-strip-types --test apps/mobile/tests/performance.test.mjs
npm --prefix apps/mobile run typecheck
npm --prefix apps/mobile test
```

Pure tests verify deterministic globally unique IDs, exact dataset ratios, canonical relations, per-recipe record counts, no promoted/sample media, and quantity-aware scoring/sorting through the actual engine. Native SQLite hydration and performance require the device run above.
