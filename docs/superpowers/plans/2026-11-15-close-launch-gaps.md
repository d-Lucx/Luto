# Close local kitchen and launch integration gaps

> **For agentic workers:** Use superpowers:executing-plans, test-driven-development, and verification-before-completion. Execute in the current checkout; obtain independent final review.

**Goal:** Replace documented placeholders with durable local cooking, serving controls, saved recipes, native timer delivery, and a deployable community integration.

**Architecture:** Extend the approved Android/WatermelonDB design. Schema v2 adds session snapshots and cookbook state without deleting v1 data. Session completion and inventory changes share one transaction. Native notifications use persisted deadlines; the screen stays awake only while focused in cooking mode. Keep all guest data local. Use a separate Luto Supabase project as requested.

**Tech Stack:** Existing Expo SDK 54, React Native 0.81.5, WatermelonDB 0.28; SDK-compatible Expo notification/keep-awake/file-system/crypto modules.

**Spec:** [Product brief](../../luto-product-prompt.md) and [approved foundation/follow-ups](../specs/2026-11-15-android-cookbook-foundation-design.md).

## Global constraints

- Preserve installed local data through explicit migrations; no database resets.
- Scale a frozen session snapshot; later recipe edits cannot alter used quantities.
- Never upload guest pantry or sample IDs; no service-role key in the mobile app.
- Permissions are contextual; denial preserves cooking and explains notification limits.
- Recipe kitchen testing and audible TalkBack require human verification.

## Review focus

- Concurrent/replayed completion must deduct once, including after process restart.
- Undo adds the exact consumed amount to current compatible stock, once.
- Paused/restored timers retain deadlines and cancel stale scheduled notifications.
- Invalid servings and unconvertible household units cannot silently change quantities.
- Failed downloads or publishing attempts retain local recipes and actionable errors.

## Task 1 — Durable sessions, scaling, and consumption

- [ ] Add failing pure tests for scaling, snapshot validation, restart deadlines, idempotent completion and additive undo.
- [ ] Add v1→v2 migration and session/cookbook models; share table declarations between schema and migration.
- [ ] Implement `startOrResumeSession`, `saveSession`, `finishSession`, and `undoSession` behind the database writer.
- [ ] Wire recipe serving controls, cooking resume, step/timer persistence, and completion receipt/undo.
- [ ] Run Node tests and strict TypeScript check.

## Task 2 — Native timer delivery and cookbook

- [ ] Add SDK-compatible local notifications, focused-screen keep-awake, notification-tap resume, and contextual permission feedback.
- [ ] Add saved-only cookbook filter, durable save state, alias search and supported dual quantities.
- [ ] Implement verified media downloads with persistent manifests, failure cleanup and explicit removal.
- [ ] Rebuild APK, upgrade installed app, verify migration and process-death cooking recovery.

## Task 3 — Community integration and release verification

- [ ] Inspect existing Supabase policies/functions, implement authenticated publishing through server moderation, and private flagged submission status.
- [ ] Configure separate Luto project if project billing/creation requirements permit; never use BejHub.
- [ ] Exercise 500-recipe profiling with isolated test fixtures, document measured scope.
- [ ] Independent review, address findings, run full checks and device retests; update limitations with evidence.
