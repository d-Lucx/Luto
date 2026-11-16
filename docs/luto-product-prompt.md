# Luto / Lu2 — Product and Build Prompt

Status: Product/build brief. Confirmed decisions are recorded below; any remaining proposals stay labeled. For current implementation evidence and unresolved release gates, see the [launch-gap report](testing/2026-11-15-launch-gaps.md).
Updated: November 15, 2026.
Repository: [d-Lucx/Luto](https://github.com/d-Lucx/Luto).

## 1. Your role and objective

Act as a product, mobile engineering, and UX partner. Improve the existing Luto app incrementally, using the repository's working foundation. Explain consequential choices in plain language and ask focused questions with a recommendation when the owner needs help deciding.

Luto, visually branded **Lu2**, is a community-driven cooking app launching on **Android first**, with iOS as a future target. Its central promise is:

> Find something to cook, understand each step, and learn useful cooking skills—even when the kitchen has no internet connection.

The owner has confirmed:

- **Android first** for the initial release. Retain the cross-platform foundation for a future iOS release.
- Serve a **global audience** from launch, with English as the initial interface language.
- The primary audience is **beginners learning to cook**. Luto should also be a convenient everyday recipe tool.
- Teach through **guidance within recipe steps first, with optional technique explainers**. Separate lessons are outside the first-release learning scope.
- The starter collection should include **everyday recipes from several cuisines and Filipino home cooking**.
- Draft original recipe instructions and test formulations for review and kitchen testing, informed by reliable online recipe references with source links and explicit adaptation notes.
- The launch language is **English**, preserving Filipino dish names and searchable ingredient aliases.
- Show **both metric and household measurements** by default, using supported conversions.
- The **first release includes both a curated recipe collection and user recipe publishing**. Community publishing must not be deferred to a later release.
- **Recipes go live after passing automated checks; flagged submissions are held for review.** Human approval is not required for every submission.
- **Guest-first access:** browse, save/download recipes, manage the pantry, and cook without an account. Require sign-in to publish recipes or submit ratings/reviews.
- The experience should feel like using a cookbook.
- **Warm paper tones** are the confirmed cookbook visual direction.
- Offline operation, pantry matching, guided cooking, ingredient alternatives, and a minimalist Lu2 logo matter.

Do not assume that budget cooking is the exclusive focus. Treat the name's proposed origin as brand intent; do not publish the claim that it is a universal linguistic root without verification.

## 2. Inspect the existing product before changing it

Read applicable AGENTS.md instructions and inspect the actual code alongside:

- `README.md`
- `apps/mobile/README.md` and `apps/mobile/package.json`
- `docs/system-architecture.md`
- `docs/feature-spec.md`
- `docs/roadmap.md`
- `apps/mobile/app/`, `apps/mobile/src/`, and `apps/mobile/tests/`

The local package manifest currently declares Expo SDK 54, React Native 0.81.5, React 19.1, Expo Router, TypeScript, and WatermelonDB 0.28. Preserve the existing stack unless an explicit compatibility problem justifies a change. Check supported versions before upgrades; WatermelonDB requires a native development build.

The repository contains a local pantry implementation, matching evaluator, recipe list, cooking screen, completion modal, recipe authoring screen, and timer/sync/media helper code. Their presence does not establish release readiness. Some documentation predates these files. Audit the current implementation and report discrepancies rather than treating either old docs or code comments as proof.

In particular, verify native timers, persistent cooking sessions, real media file downloads, synchronization, review submission, and end-to-end navigation. Resolve the documented additive-pantry-versus-last-write-wins conflict before enabling remote pantry writes.

Classify each capability as implemented and verified, implemented but unverified, partial, or planned. Keep this classification current.

## 3. Product principles

1. **Teach through cooking.** Explain unfamiliar terms where they appear. Give observable cues such as color, texture, and consistency alongside timing.
2. **Keep recipes convenient.** Make search, ingredients, equipment, serving counts, and saved recipes easy to reach.
3. **Keep the kitchen working offline.** Local recipe text, pantry operations, matching, and downloaded cooking sessions must not depend on a server round trip.
4. **Make availability honest.** Distinguish saved recipes from downloaded recipes, and downloaded text from optional downloaded media.
5. **Respect user control.** Confirm ingredient consumption and substitutions. Preserve progress and drafts when operations fail.
6. **Show uncertainty.** Missing nutrition, unpriced ingredients, unknown conversions, and unavailable media must have explicit states.

## 4. First-release scope and delivery sequence

The first-release content model is confirmed: curated recipes and community publishing launch together. The implementation sequence below is proposed; its stages are dependencies within the release, not permission to ship without publishing. It does not change the existing roadmap's completion status.

| Stage | Outcome | Scope |
| --- | --- | --- |
| 1 — Complete beginner cooking loop | A beginner can choose and finish a recipe offline | Bundled curated starter recipes, browsing, recipe detail, pantry matching, serving scaling, equipment and technique explanations, cooking steps, timers, and confirmed pantry deduction |
| 2 — Launch publishing | Users can contribute recipes in the first release | Account access for public contribution, persistent local drafts, structured creator, ingredient mapping, media staging, server validation, publishing status, author editing/archiving, and reporting/moderation |
| 3 — Launch integration and verification | Curated and community recipes work in one everyday cookbook | Save/download published recipes, download status and storage controls, source labels, interrupted submission recovery, and end-to-end native tests of both cooking and publishing |

Retain useful existing work. Curated and community recipes should share the recipe detail, pantry evaluation, and cooking experience. Label their origin and author honestly; a community recipe is not automatically curated or tested by Luto. Offer simple discovery filters for both sources.

Publishing availability at launch and the publication policy are confirmed: submissions that pass automated checks go live; flagged submissions remain private pending review. Public visibility requires a successful server-side decision.

Broader filters, nutrition estimates, ratings/reviews, and richer learning features remain product goals. Confirm their release priority separately. Personal pantry cloud sync is a separate decision from the backend required to publish public recipes; it must not delay local pantry use.

Defer AI recipe generation, ingredient photo recognition, shopping integrations, social feeds, and shared household inventory unless explicitly requested. “Intelligent pantry” can begin with deterministic, explainable matching.

## 5. Recipe and learning requirements

Each recipe should support:

- Title, description, cuisine, meal type, base servings, preparation/cooking/total time, difficulty, and photo with a local fallback.
- Structured ingredients with canonical identity, quantity, unit, optional status, and preparation notes.
- Ordered steps with a clear action, quantities needed at that step, visual or sensory cues, associated techniques, and optional timers.
- Equipment, distinguishing essential tools from optional conveniences and explaining reviewed workarounds.
- Technique explanations for terms such as sauté, simmer, mince, and emulsify. Use plain text first; include video or short clips when available and licensed.
- Beginner notes on preparation order, common mistakes, and how to tell when a step is complete.
- Nutrition per serving when supported by a documented source or calculation. Mark estimates and missing values; never turn unknown values into zero.
- Ingredient alternatives with applicable cooking context, quantity ratio, expected flavor/texture changes, and allergen implications.
- Ratings, separate reported difficulty, review count, and notes when the community feature is available. Distinguish unrated recipes from zero-star recipes.

The confirmed learning approach is contextual: keep essential guidance in the step itself, including what to do and an observable completion cue. Offer unfamiliar techniques as optional “Learn this technique” help with a short explanation, key tips, and common mistakes. A locally available clip may supplement the text; learning must remain useful without video or internet. Closing an explainer must return to the same step without resetting progress or timers. Do not require lessons, quizzes, or course completion before cooking.

Propose an initial collection size after checking available content and licensing. Include approachable Filipino home cooking alongside other cuisines, explain unfamiliar ingredients, and preserve authentic dish names with searchable aliases. Do not invent authors, ratings, photographs, nutrition, or cultural provenance.

The [initial six recipe drafts and kitchen test plan](recipes/starter-collection-drafts.md) provide a proposed first review batch with online references, adaptation notes, and a reusable test record. All are untested; keep them separate from published curated recipes and existing seed fixtures until reviewed and cooked.

Use English for launch navigation, curated instructions, technique explanations, and system feedback. Preserve Filipino dish names and explain unfamiliar terms in English. Support Filipino and English ingredient aliases in recipe search, pantry search, and authoring autocomplete, including offline search. Aliases must resolve to the same reviewed canonical ingredient without duplicating stock or conflating distinct ingredients. A fully translated Filipino interface is not required for the first release. Community submission language requirements remain a separate policy decision.

The roadmap names ten reference recipes: Pasta Carbonara, Chicken Adobo, Thai Green Curry, Beef Stir Fry, French Omelet, Shakshuka, Lentil Dahl, Ratatouille, Guacamole, and Sourdough Bread. Treat these as a seed-content baseline to inspect, not proof of ten finished beginner lessons. Mark advanced recipes appropriately; propose more Filipino home dishes for owner review rather than presenting additions as confirmed.

Serving changes must update ingredient quantities, pantry evaluation, and consumption previews consistently. Keep original recipe quantities as the source of truth. Handle indivisible ingredients with practical guidance; do not imply that oven temperature or cooking duration scales linearly.

Show both metric and household measurements by default, with one primary quantity and a clearly associated equivalent where a supported conversion exists. Keep a single underlying quantity for scaling, pantry matching, and deduction; the two displayed values must never count as separate ingredients or inventory amounts. Use practical rounding for display without repeatedly rounding the underlying value.

Support compatible unit conversions. Mass-to-volume and piece-to-mass conversions require explicit ingredient-specific data, including preparation form when relevant. If a reliable equivalent is unavailable, show the known quantity with a concise explanation rather than inventing the second value. Declare cup and spoon conventions; do not silently mix regional measures. Both measurement systems and a global audience are confirmed; the default household convention remains open. Preserve each recipe's source convention and show the convention used for conversions. English is the confirmed launch language.

For global usability, avoid assuming a Philippine location, currency, or ingredient availability. Support reviewed regional ingredient aliases without conflating different foods. Propose a user-selectable household measurement convention and paired Celsius/Fahrenheit oven temperatures. These are implementation recommendations awaiting design review. A global audience does not imply that every translation or storefront country is launch-ready; verify distribution scope separately before release.

Filter by cuisine, meal type, preparation or total time, difficulty, and budget when data supports it. Budget needs a currency, region, and dated estimate; show “Cost unavailable” otherwise.

### First-release community publishing

- Provide a visible “Create recipe” entry from the recipe library and a way to return to My Recipes/drafts. Propose three stages matching the roadmap: recipe details; ingredients; equipment and steps, followed by a preview.
- Keep beginner-friendly authoring guidance: title, cuisine, servings, times, difficulty, ingredient quantities, equipment, ordered steps, and optional technique/timer links. Show errors next to their fields and preserve entered data.
- Persist drafts locally across app closure. Guests may prepare local drafts; public contribution uses an account under the documented ownership model. Keep guest pantry data separate during sign-in.
- Request sign-in when the user chooses to publish, preserving the draft and returning to that action after successful authentication. Cancelling sign-in must leave the local draft available.
- Canonical ingredient autocomplete must support pantry matching. If an ingredient is missing, preserve the draft and offer a canonical proposal with clear pending status. Define how it becomes eligible for publication; never silently map an unfamiliar Filipino ingredient to a different food.
- Validate the complete recipe on the server as well as in the app. The existing spec proposes at least two steps, 15 characters per instruction, and one cookware item; review these as quality rules rather than treating text length as proof of usefulness. Support appropriate equipment for uncooked recipes instead of forcing false cookware declarations.
- Route public uploads through the documented private quarantine stage, with file limits, upload progress, retry, and meaningful moderation results. A text-only draft must remain usable when a photo upload fails. Resolve whether a photo is mandatory before publishing because the architecture currently requires a hero image.
- Use an explicit lifecycle based on `draft`, `pending_review`, `published`, and `archived`. Show incomplete/rejected outcomes with actionable reasons; reconcile whether they are statuses or validation results before schema changes.
- Make publication a durable server-confirmed event. Offline drafts and queued submissions are not publicly published. Restore interrupted submissions without creating duplicate recipes or orphaned public media.
- Enforce author ownership and allowed status transitions on the server. Test that authors cannot publish by bypassing checks or promote their own content to curated status. Preserve authorship and provide edit/archive controls.
- Keep reported content reviewable by a moderator with authority enforced outside the client. Decide how edits to published recipes are reviewed; an active cooking session should retain the recipe version it started with.
- Provide report reasons, author-facing status feedback, and a practical review process. Automated text/image screening does not establish culinary correctness or recipe testing. The existing moderation helper must be evaluated against the documented contract before it is called a complete service.

Confirmed publishing policy:

- Publish a complete submission automatically after all required server-side checks pass.
- Hold flagged submissions in `pending_review`, keep them out of public discovery and public media access, and explain the pending status to the author.
- Give reviewers approve or return-for-changes actions with recorded reasons. Define the reviewer role and operating process before launch.
- Keep incomplete submissions editable with field-level errors. Failed, unavailable, or timed-out checks must never be treated as approval; preserve the submission for retry and show its actual status.
- Test clean, flagged, invalid, and unavailable-check outcomes separately. Repeated submission or moderation callbacks must not create duplicate publications.

## 6. Pantry matching and consumption

### Inventory and recommendations

- Allow canonical ingredient search and quantity entry for fridge, freezer, and dry pantry storage.
- Clearly distinguish setting the total quantity on hand from adding a new purchase.
- Update recommendations from local database changes and persist inventory across restarts.
- Evaluate enough stock for the selected serving count, not just the presence of ingredient names.
- Reuse the tested evaluator and document its weighting, staple exemptions, optional items, and substitution behavior.
- Explain results with available quantities, missing ingredients, and accepted substitutions. A weighted percentage alone does not prove that a meal is ready to cook.
- Do not spend the same stock twice within one recipe evaluation. Treat different recipe recommendations as alternatives.
- Make staple assumptions visible and adjustable. Surface missing essential items even when the score is high.
- Offer substitution choices explicitly and recompute matching and consumption after selection. Do not describe an unreviewed swap as equivalent.

Expiry tracking and “use soon” recommendations are a proposed later enhancement. Dates entered by users indicate planning information, not proof that food is safe to eat.

### Finish cooking

- Show a “Cooked It!” review with actual ingredients, substitutions, serving count, editable used quantities, and selected deductions.
- Deduct only after explicit confirmation. Cancelling, navigating away, or skipping deduction must leave inventory unchanged.
- Validate compatible units and current inventory before committing; explain shortages rather than silently consuming an impossible amount.
- Apply the consumption record and inventory changes atomically, with a persistent session identifier that prevents duplicate deductions after retries or double taps.
- Persist completion state across app restarts. Propose an undo mechanism that reverses the recorded change without overwriting later inventory edits.
- A review submission is optional and separate from pantry deduction. Cooking completion alone must not be presented as externally verified proof.
- Guests can finish cooking and confirm pantry deductions without signing in. Request sign-in only if they choose to submit a public rating/review; cancelling must not interrupt completion or repeat deductions.

## 7. Offline contract and kitchen mode

| Capability | Offline behavior |
| --- | --- |
| First launch | Guest access and an explicit bundled sample recipe work without authentication or downloaded data |
| Guest cookbook | Browse public recipes when connected, save/download without an account, and retain saved/downloaded recipes locally across restarts; offline browsing uses bundled or downloaded content |
| Pantry and matching | Read, edit, calculate, and persist locally |
| Recipes | Search and cook bundled or previously downloaded content; explain when a recipe is unavailable locally |
| Technique help | Always provide local text; play locally available clips and show a useful fallback for missing clips |
| Saved recipes and downloads | Show their different states, download size/progress, failure/retry, and storage management |
| Community and accounts | Create/edit local drafts offline; account creation, uploads, moderation, and public publication need connectivity; show pending and published as distinct states |

Kitchen mode must provide:

- High-contrast step instructions with a default size equivalent to at least 24sp, honoring system text scaling.
- Large Previous/Next controls, visible step position, ingredient references, and optional technique help.
- Screen-awake behavior while actively cooking, released when cooking ends.
- Concurrent named timers, with remaining time calculated from persisted deadlines rather than trusting JavaScript intervals.
- Restored step and timer state after interruption or relaunch. Define behavior for overdue timers and device clock changes.
- Platform-supported local notifications for background alerts; clear handling when notification, sound, or vibration permissions are unavailable. Verify on Android for launch, including app backgrounding and device battery restrictions. Repeat platform-specific verification before a future iOS release.
- Text instructions that remain usable when videos fail, pause, or have not been downloaded.

Guest inventory and demo identifiers must remain device-local. Any future account migration needs an explicit, reviewed mapping. Synchronization must define ownership, deletes/tombstones, conflict handling, retries, deduplication, and account-switch isolation before it writes remote data.

Guest-first use must not silently depend on a network-backed anonymous account. Keep guest saves, downloads, pantry inventory, and drafts on-device without claiming cloud backup or cross-device recovery. Sign-in for publishing or reviewing must not automatically upload unrelated guest data.

## 8. Cookbook visual direction

Confirmed direction: warm paper tones for the cookbook experience. Translate this into warm, flat background surfaces with readable dark text. Proposed supporting choices are restrained food-inspired accents, editorial recipe headings, clear sans-serif instructions, and real food photography where available and licensed. Keep cooking mode especially clear and calm. Avoid decorative paper textures behind instructions and low-contrast beige-on-beige controls.

Use one shared token system for color, typography, spacing, radii, and interaction states. Warm paper tones are approved; exact color values, fonts, dark-mode scope, and logo concept remain proposals pending design review. Bundle any essential fonts and assets for offline use.

- Organize the experience around Recipes, My Fridge, and a personal cookbook; confirm navigation before implementation and keep bottom navigation to five destinations or fewer.
- Give recipe detail a clear ingredients/equipment/steps hierarchy and a prominent “Start cooking” action.
- Make curated/community source labels, author identity, “Create recipe,” draft recovery, submission status, and reporting readable without turning the cookbook into a busy social feed.
- Create a minimalist, legible Lu2 mark with an accessible “Luto” name. Check it at app-icon size and in one color; present concepts before treating one as final.
- Use consistent vector icons, visible field labels, descriptive accessibility names, safe-area insets, and readable text widths.
- Target at least 48dp touch areas on Android. Enlarge cooking controls further where practical; retain a minimum 44pt target for future iOS work.
- Check normal text contrast of at least 4.5:1 and meaningful control/icon contrast of at least 3:1. Do not communicate status through color alone.
- Support screen readers, large text, reduced motion, small phones, tablets, and landscape. Preserve native back navigation.
- Keep animations brief and meaningful; avoid decorative motion while users cook.

Apply UI/UX Pro Max's mobile guidance. Apply Design Taste's visual consistency, plain copy, alignment, imagery, and restrained interaction principles to this native app. Its website hero, full-screen section, hover, shader, and browser-gate prescriptions are for website work; do not impose them on native recipe navigation or claim those gates validate a mobile app.

Planning note: the UI/UX design-system search could not run in this environment because Python was unavailable. This direction uses documented guidance and the owner's cookbook preference, not a generated database match.

## 9. Required empty, missing-data, and error states

| State | Useful response |
| --- | --- |
| Empty fridge | Explain ingredient entry and offer “Try an offline sample recipe” |
| Empty cookbook | Offer browsing and explain saving recipes; recommend downloaded starters when offline |
| No search results | Keep the query and offer clearing filters or searching other terms |
| No pantry matches | Explain missing ingredients and offer achievable alternatives |
| Missing image | Show a local fallback with stable layout dimensions |
| Missing nutrition | Show “Nutrition unavailable” |
| Loading | Use bounded skeletons or progress feedback, then success, empty, or retryable error |
| Offline discovery | Show available local recipes and explain how to download more when connected |
| Failed save or deduction | Preserve input and explain retry; never imply success before a durable write |
| Missing media or denied permissions | Keep text instructions and in-app timer status usable |
| Empty My Recipes | Offer “Create recipe” and explain that drafts can be written offline |
| Interrupted or rejected submission | Preserve the draft, identify what needs fixing, and offer retry or editing without claiming publication |

Do not recommend “trending dishes” unless there is actual community data and an available connection or clearly dated cache.

## 10. Acceptance scenarios

These are required future checks, not claims that the current app passes them.

1. **Fresh offline launch:** With a fresh local database and airplane mode enabled, open My Fridge and tap “Try an offline sample recipe.” Canonical sample ingredients and Shakshuka are created locally. Repeating the action does not duplicate records. No network is required.
2. **Quantity-aware matching:** At the sample recipe's base servings, save totals of 2 eggs, 400g tomatoes, and 100g onion. The sample scores 100% under its documented staple assumptions. Reducing a required quantity reveals the shortage and changes the result. Restarting retains inventory.
3. **Guided cooking:** Open the sample's detail and start cooking. Read steps at large text size, move backward and forward, open technique help, and start multiple timers. Confirm that essential guidance is visible within steps and optional explainers work offline as text. Closing an explainer restores the same step and leaves timers running. Relaunching restores the session. Test foreground and background timer behavior, Android battery restrictions, and denied-notification fallback on Android for launch. Future iOS release requires its own verification.
4. **Confirmed consumption:** Finish cooking, change a used quantity, deselect one ingredient, and confirm. Only the confirmed quantities are deducted. Cancel changes nothing. Double tapping, retrying, or relaunching cannot deduct twice. A failed write cannot leave partial changes.
5. **Scaling and substitutions:** Change servings and select a reviewed substitution. Detail, matching, and consumption agree on quantities. Incompatible units show an explanation. Optional and shared ingredients cannot consume stock twice.
   Verify paired metric/household values for supported conversions, practical display rounding, and a useful unavailable-conversion state. Changing servings repeatedly must not accumulate rounding drift or double pantry consumption.
6. **Downloads and resilience:** Interrupt a download, restart, retry, and cook with missing media. Text remains available. Verify storage-full handling and that cleanup respects any explicitly pinned offline content.
7. **Accessibility:** Exercise the main flow on Android with TalkBack, maximum system text size, reduced motion, portrait/landscape, and a small phone. Confirm reachable controls and no obscured steps or inputs. Perform VoiceOver checks before a future iOS release.
8. **Content integrity:** Check starter recipe licensing, completeness, ingredient aliases, substitution context, and honest missing-data labels. Community features require ownership/moderation checks before public writes.
   Verify English interface text and preserved Filipino dish names. With airplane mode enabled, searching a reviewed Filipino ingredient alias and its English equivalent must return the same canonical ingredient in pantry and authoring search, and relevant recipes in recipe search. Selecting either alias must not create duplicate pantry ingredients.
9. **Launch publishing:** Create a draft offline, restart, resume, preview, sign in when connected, and submit. A complete recipe that passes automated checks publishes without human approval, appears in community discovery, and can be downloaded and cooked offline. A flagged submission stays private in `pending_review` until a reviewer approves it or returns it for changes with reasons. Unavailable checks preserve a retryable submission and never publish it. The published recipe's source remains community until separately curated.
10. **Publishing failure and ownership:** Fail an upload or submission, retry, and confirm one recipe is created. Invalid canonical ingredients and rejected content retain actionable feedback. Unauthenticated clients and other authors cannot change ownership, publish bypassing moderation, read private drafts, or access quarantined uploads. Editing/archiving follows the agreed visibility and versioning rules.
11. **Guest-first access:** Without an account, browse available recipes, save/download one while connected, restart in airplane mode, edit pantry stock, cook, and confirm consumption. These actions must not require authentication. Publishing or submitting a rating/review prompts for sign-in and preserves the user's work; cancelling returns safely without publishing, losing a draft, or duplicating a deduction. Sign-in must not silently upload guest pantry data.

Use unit tests for matching, conversion, scaling, deadlines, and consumption invariants; database integration tests for atomicity, persistence, and replay protection; native device tests for kitchen behavior. Existing tests are a starting point. Report commands and results, including blocked checks. Unit tests alone do not establish native offline readiness.

Propose measurable startup, matching-latency, storage, and scrolling targets using named reference devices and a realistic dataset. Validate the existing 500-recipe performance goal before claiming it passes.

## 11. Important decisions to discuss

Ask these progressively, with simple options and a recommendation. Record answers here; never treat recommendations as owner decisions.

| Decision | Status / recommendation |
| --- | --- |
| Primary audience | Confirmed: beginners learning to cook, with convenient recipe access |
| Starter cuisines | Confirmed: everyday recipes from several cuisines plus Filipino home cooking |
| First release platform | Confirmed: Android first; retain the cross-platform foundation for future iOS support |
| First release depth | Confirmed: curated recipe collection and user recipe publishing both available at launch |
| Publication timing | Confirmed: publish automatically after checks pass; hold flagged submissions privately for review |
| Launch language | Confirmed: English first, preserving Filipino dish names and searchable ingredient aliases |
| Measurement display | Confirmed: both metric and household measurements by default, where supported conversions exist |
| Launch audience | Confirmed: global, with an English-first Android release |
| Regional defaults | Open: household measurement convention and regional currency handling if cost estimates are included |
| Recipe supply | Confirmed: draft original recipes for review and kitchen testing, using reliable online references. Reviewers, test cooks, and final collection size remain open |
| Learning style | Confirmed: guidance within recipe steps first, with optional technique explainers; no separate lessons required for launch |
| Account requirements | Confirmed: browse, save/download, manage pantry, and cook as a guest; sign in to publish recipes or submit ratings/reviews. Sign-in methods and later personal-data sync remain open |
| Dietary preferences and allergies | Open: define filtering and data coverage; missing data must remain visible |
| Visual direction | Confirmed: cookbook experience with warm paper tones |
| Remaining visual choices | Open: exact palette/fonts, dark-mode scope, cookbook references, and Lu2 logo concept |
| Nutrition and cost | Open: choose data sources and decide which estimates belong in the first release |
| Business model | Open: free, paid, or freemium; propose keeping the core downloaded cooking flow available offline |
| Release resources | Open: test devices, content/media budget, timeline, and who will maintain the app |

## 12. Working process and deliverables

Use Superpowers for discovery and, once the product approach is agreed, design and implementation planning. Keep questions understandable and relevant to the next decision. Produce a concrete design for review before product implementation, then implement agreed slices in the existing repository.

Use UI/UX Pro Max and Design Taste as scoped above. Use the Supabase skill when actual Supabase design, security, database, or integration work begins. Verify current official compatibility guidance when choosing or upgrading dependencies.

Expected deliverables as work proceeds:

1. This brief updated with confirmed decisions and remaining assumptions.
2. An evidence-based audit of current behavior and documentation conflicts.
3. Proposed navigation and cookbook design, with recipe detail and kitchen-mode mockups for review.
4. A phased implementation plan with dependencies and meaningful acceptance gates.
5. Incremental working changes, appropriate tests, and native verification evidence.
6. Updated setup instructions and an honest account of remaining limitations.

Do not describe planned capabilities as implemented, simulated services as connected, or untested device behavior as verified. Keep this prompt a product brief; it does not authorize publishing content or contacting other people.

## 13. Documentation context and decisions to reconcile

Read the linked sources with the code, and record decisions before implementing conflicting contracts. This section identifies documentation findings; it is not a completed runtime or backend security audit.

| Source | Context to preserve | Improvement or unresolved conflict |
| --- | --- | --- |
| [System architecture](system-architecture.md), sections 2 and 3 | React Native, local SQLite, authenticated authors, published-only public discovery, and private upload staging | The architecture says New Architecture is enabled, while `apps/mobile/app.json` deliberately disables it. Preserve the actual native configuration pending verified compatibility work. Distinguish offline local guests from network-backed anonymous accounts. |
| [System architecture](system-architecture.md), section 4; [feature spec](feature-spec.md), section 5 | Recipe statuses and moderation before public visibility | DDL has `draft/pending_review/published/archived`; the feature diagram also uses Incomplete/Rejected. Agree on persistent statuses versus validation outcomes, permitted transitions, edit review, and a workable reviewer process. Confirm RLS for child rows and server-controlled publication, not just the parent recipe. |
| [Feature spec](feature-spec.md), section 1 | Tier weights 3.5/2.0/0.8, staple exemption, required quantities, and optional low-match display | Its formula awards approved substitutions 90% while display text permits 100%; its pseudocode checks presence without quantities. Use the tested quantity-aware evaluator and define cookability separately from its weighted score. |
| [Feature spec](feature-spec.md), section 3; [roadmap](roadmap.md), task 3.2 | Durable local data, verified media, retries, and server deltas | Additive quantity merging conflicts with last-write-wins wording. Do not add absolute inventory totals together. Define set-total versus purchase/consumption changes, replay protection, and deletes. Avoid a redundant custom queue where WatermelonDB already tracks pending changes. |
| [Feature spec](feature-spec.md), section 3.2 | Download readiness only after complete verified recipe/media availability | If optional clips may be omitted, distinguish text-ready from a complete media bundle. Never show the documented `OFFLINE_READY` state for an incomplete bundle. |
| [Feature spec](feature-spec.md), section 4 | Large instructions, wake lock, concurrent timers, and optional hands-free interaction | Use local notifications for offline timer alerts; remote push cannot be an offline dependency. Voice/Bluetooth navigation are documented ideas whose launch priority and platform support need confirmation. |
| [System architecture](system-architecture.md), rating trigger; [feature spec](feature-spec.md), section 5.3 | One review per user/recipe, review count, and a cooking-completion marker | Raw average storage and Bayesian ranking differ. Label the displayed metric, calculate priors from real data, and avoid presenting the example 4.2 platform average as observed. “Cooked It!” denotes recorded app completion, not independent testing. |
| [Roadmap](roadmap.md), milestones 1–4 | Schema, access control, native storage, kitchen mode, and community creator dependencies | The milestones are an engineering sequence. The owner's first-release boundary now includes community publishing as well as curated content; completion of milestone 3 alone is not sufficient to release. |
| [Techniques](taxonomies/techniques.json), [equipment](taxonomies/equipment.json), [substitutions](taxonomies/substitutions.json) | Parsed files contain 20 techniques, 32 equipment items, and 35 substitution entries, including tips, mistakes, workarounds, and cooking contexts | Reuse this structured material. Technique clip specifications are production briefs, not delivered videos. Map taxonomy identifiers to canonical database IDs and normalize field names explicitly. Composite swaps such as milk plus lemon need multiple component requirements and quantities; a single ratio and substitute ID cannot model the full preparation. |

Before release, reconcile media formats and size limits across the architecture, roadmap, and actual storage configuration. Treat schema defaults and illustrative seed content as implementation inputs to review, not settled UX choices or ready-to-publish content.
