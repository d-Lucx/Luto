# Launch-gap implementation and verification

Status: Final native verification in progress. This is not a full-product release claim.

## Implemented

- Schema v1→v2 migration preserves installed data. Shared declarations align migrations and fresh installations.
- Immutable cooking snapshots preserve selected servings, quantities, steps, and timer deadlines. Step changes and timer actions persist locally.
- Completion and pantry deduction commit together; completed/undone sessions cannot consume again. Undo adds consumed quantities to current compatible stock once.
- Native timer alerts, contextual notification permission, cancellation on pause/reset/completion, notification-tap recovery, focused-screen wake protection.
- Serving controls, supported dual spoon/metric quantities, explicit pantry units, saved cookbook filter and Filipino ingredient aliases.
- Offline ingredient/equipment dictionaries and technique explainers; source taxonomy clip specifications are not presented as videos.
- Persistent creator drafts and atomic local editing, preserving recipe identity, media and existing cooking snapshots.
- Separate Luto backend; guest discovery/text caching; authenticated publishing, reviews and reports. Automated passes publish; flagged submissions remain private. BejHub was not changed.
- Persistent verified media bundles with HTTPS/SHA256/size/MIME/signature checks, staging cleanup, 50 MiB/file and 250 MiB total limits, explicit removal and local image/video playback.
- Original Lu2 logo saved in `apps/mobile/assets/brand/lu2-logo.png` and shown in the cookbook library.

## Verification ledger

| Check | Result | Evidence / scope |
| --- | --- | --- |
| Engine/service regression suite | Pass | 91 tests and strict TypeScript passed, including stale OAuth callback and edit-permission regressions |
| Native build with new modules | Pass | Corrected normal APK built in 1m50s and installed with data preserved; SHA256 `BD80D79E250315593189C72B5B49AC02612C2130E24492FAE9CE2437B4FE2F64` |
| Upgrade preserves SQLite | Pass | Existing 100g onion and recipes retained after v1→v2 upgrade |
| Step recovery after force-stop | Pass | Sample returns to step 2; captures 30–31 |
| Cooking wake protection | Pass | Android window reports `KEEP_SCREEN_ON` |
| Completion/undo/replay | Pass | 100g onion deducted once, completed receipt survived restart, undo restored 100g; captures 39–42 |
| Native alert delivery/recovery | Pass with precise-alarm permission | One-minute timer delivered while app was backgrounded; tapping its notification resumed the correct session at 00:00; capture 47. Sound not verified |
| Verified media/restart/removal | Pass for image | Original logo downloaded, rendered after offline restart, removed and stayed removed; captures 34–38. Video not exercised |
| 500-recipe SQLite profile | Pass within measured scope | Separate database: two cold runs scored all recipes in 95.761ms and 93.738ms; indexed detail 1.260ms and 1.038ms. Not full startup/scrolling performance |
| Normal build test gate | Pass | `/test-kitchen` unavailable with device tests disabled; capture 46 |
| Google native sign-in | Pass, owner-confirmed | Corrected installed callback shows “Welcome to Lu2” (capture 49). On November 15, the owner confirmed a fresh Google sign-in and return to the signed-in community page. Four callback regressions cover stale initial URLs and error fragments |
| Draft restoration/editing | Pending on device | Mapping/validation tests pass; transaction reviewed |
| Audible TalkBack/tablets | Outstanding | Native semantics are not audible screen-reader certification |

## Review corrections

Corrected stale cooking screens after notification navigation, alert cancellation races, resume depending on mutable source completeness, stale overview after editing, and server/mobile serving-range mismatch. Existing cached larger recipes select a supported serving count without throwing during render.

The physical device also exposed object spreading of WatermelonDB getter-backed pantry fields. Deduction now copies explicit fields; the regression test reproduces the failure and passes with the correction. The failed device attempt did not complete the session.

Google and Supabase are configured with the exact native redirect `luto://auth/callback`. The free support/privacy site is https://lu2-cooking.vercel.app. Following explicit owner approval on November 16, Google Auth Platform confirmed External / In production, enabling basic Google sign-in beyond the test-user list. A second Google account has not been tested on-device. No domain or email service was purchased; Google Play publication remains separate.

## Remaining release work

- Kitchen-test and review the six original recipe drafts before curated promotion; software cannot verify taste, yield or physical cooking safety.
- Supply reviewed nutrition sources and ingredient/form-specific conversions. Unknown nutrition remains unavailable; the legacy heuristic calculator does not populate the UI.
- Produce/license tutorial footage and provide trusted server digest manifests. Missing verified assets leave text usable and media unavailable.
- Test long sleep, reboot, manufacturer battery restrictions, exact-alarm policy and low-storage conditions on target devices. Android force-stop disables alarms until reopening; persisted deadlines support recovery.
- Finish audible accessibility, tablet and realistic cookbook scrolling/memory checks. Synthetic component measurements do not establish full startup or scrolling performance.
- Remote pantry synchronization stays disabled until ownership/conflict semantics are agreed; guest stock remains local.
- Dependency audit: 21 advisories (1 low, 16 moderate, 4 high), reduced from 25 with patched Babel runtime, Forge and PostCSS dependencies. No forced Expo major upgrade or WatermelonDB downgrade was applied.

## Reproduction

From `apps/mobile`: `npm test`, `npm run typecheck`, `npx expo install --check` (SDK-local map fallback in offline environments). Native build uses Android SDK 36, NDK 27.1.12297006, JDK 17 and arm64-v8a. `EXPO_PUBLIC_DEVICE_TESTS=1` enables `/test-kitchen` in the dedicated test APK; omit it for the normal build. Artifacts remain under Git-ignored `.expo/device-tests`.

See [media checks](media-downloads.md), [performance harness](performance-harness.md), and [earlier device tests](2026-11-15-android-device-test.md).
