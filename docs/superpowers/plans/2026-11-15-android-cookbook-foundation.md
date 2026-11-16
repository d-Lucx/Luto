# Android Cookbook Foundation Implementation Plan

> **For agentic workers:** Use Superpowers test-driven development and verification. Implement sequentially in the current session; request a final independent review using the requesting-code-review skill.

**Goal:** Add a warm offline recipe overview and correct quantity-aware pantry deduction.

**Architecture:** Extend existing Expo Router screens and local WatermelonDB. Share pure unit conversion between matching and deduction. Add no schema changes; repair the missing SDK-compatible Expo Router dependency if bundling requires it.

**Tech Stack:** Expo SDK 54, React Native 0.81.5, WatermelonDB 0.28, strict TypeScript, Node test runner.

**Spec:** [Android cookbook foundation](../specs/2026-11-15-android-cookbook-foundation-design.md).

## Global Constraints

- Android first; retain existing native architecture configuration.
- All sample and guest data remain local; no remote writes or untested draft imports.
- Base servings only until scaling is integrated end to end.
- Native UI uses warm paper tones and at least 48dp control targets.

## Review Focus

- Mixed units and multiple rows must never overconsume inventory.
- Failed deductions must preserve the user's modal and selections.
- Missing local data must not produce a misleading complete recipe overview.
- Navigation and large text must remain usable on narrow Android screens.
- The UI must not claim public reviews, media downloads, or content verification that do not exist.

## Task 1 — Units and deduction

- [x] Add regression tests in `apps/mobile/tests/features.test.mjs`; watch them fail on compatible-unit deductions, invalid input, incompatible dimensions, and shortages.
- [x] Add `src/engine/units.ts` with `convertQuantity(quantity: number, from: string, to: string): number | null`; consume it from `evaluatePantryMatch.ts` and `decrementPantry.ts`.
- [x] Update deduction validation and literal expectations for shortages. Preserve caller data and current quantities in original units.
- [x] Calculate against current pantry inside the cooking screen's database writer. Preserve modal on failure and display actionable feedback in `CookedItModal.tsx`; block duplicate concurrent submit.
- [x] Run full unit suite and typecheck.

## Task 2 — Cookbook overview and theme

- [x] Test `getRecipeReadiness(ingredients, steps)` with complete, missing dictionary, invalid quantity, and missing-step fixtures before implementing `src/engine/recipeReadiness.ts`.
- [x] Add shared tokens in `src/theme.ts`; apply to tab shell and affected recipe/pantry/cooking screens.
- [x] Add `app/recipes/[id].tsx` with local loading/retry/not-found states, base serving ingredients, step preview, and guarded Start Cooking.
- [x] Update library to navigate into detail and offer the existing sample loader from its empty state. Keep `/recipes/new` reachable.
- [x] Remove unsupported search promises and fake verification/review UI; use truthful local-data copy.

## Task 3 — Verification and handoff

- [x] Run `npm test` and `npm run typecheck` from `apps/mobile`.
- [x] Inspect Android tooling and attempt bundling without adding dependencies.
- [x] Obtain independent review, address important findings, and re-run relevant checks after changes.
- [x] Update `apps/mobile/README.md` with changes, evidence, and remaining native/release limitations.

## Progress

- Baseline: 22/22 Node tests pass; strict TypeScript check passes.
- Branch: `codex/android-cookbook-foundation`.

- Task 1 complete: unit/shortage regression tests observed RED, then GREEN; modal retains errors, writer reads current stock.
- Task 2 complete: readiness regression tests, recipe overview, warm theme, and truthful local-save UI implemented.
- Task 3 complete: 31/31 Node tests, strict TypeScript check, Android JS export (1,319 modules) pass. No native device attached; runtime/visual tests remain unverified.
- Review: independent reviewer found fridge ink-on-ink backgrounds and indistinguishable storage chips; both corrected. No remaining reported findings against this slice.
- Build ruling: corrected preexisting Babel config module mismatch and installed SDK-compatible expo-linking; no schema, SDK major, or native architecture changes.
- Native limitation: ADB runs outside sandbox but reports no attached devices; no APK, TalkBack, or airplane-mode device verification is claimed.
