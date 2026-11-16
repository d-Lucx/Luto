# Android cookbook foundation

Implementation scope following the owner's “get started” instruction. Product decisions remain recorded in [the brief](../../luto-product-prompt.md). This is the first implementation slice, not the entire launch release.

## Intent and approach

Give beginners a recipe overview before entering kitchen mode and establish the approved warm-paper visual direction. Extend the existing Expo Router and WatermelonDB app: the working local data and native bridge make a rewrite unnecessary. A backend-first start would not resolve the missing local recipe overview; public publishing remains required for launch and will follow as a separately verified slice.

Keep Expo SDK 54, React Native 0.81.5, WatermelonDB 0.28, and the current native architecture configuration. No schema changes are needed. Bundling revealed a missing required Expo Router peer: install only `expo-linking` using the installed SDK's bundled version constraint (`~8.0.12`). Babel's existing CommonJS configuration also needs a `.cjs` extension because this package uses ES modules. Leave the six untested editorial drafts in documentation.

## User flow

- Recipes opens a warm-paper library with honest loading, empty, search-empty, and retryable error states. The empty library offers the existing opt-in offline sample.
- Selecting a recipe opens `/recipes/[id]`, showing its description, base servings, canonical ingredient names and quantities, optional ingredient labels, and ordered step preview.
- Missing nutrition or equipment relationships are described as unavailable; do not invent metadata, dietary ratings, or review counts. The local schema does not yet associate recipe equipment.
- “Start cooking” opens the existing `/cook/[id]` route. A recipe without usable steps/ingredients cannot be started from detail. Missing dictionary entries show an explicit warning instead of a generic ingredient name.
- Back navigation returns to the library; invalid/missing local IDs show an understandable unavailable state.
- This slice shows base servings only. Serving controls wait until detail, matching, kitchen mode, and deduction can share a scaled session snapshot.

## Visual and accessibility choices

Use a shared native theme: paper background, slightly lighter panels, dark brown ink, muted brown supporting text, and a dark terracotta action color. These exact colors are implementation choices within the owner's warm-paper direction. Use system serif recipe headings and system sans-serif controls so text works offline without font downloads. No fake food images or decorative textures.

Use native Pressable controls with at least 48dp targets, readable labels, pressed feedback, accessible roles/states, Android back support, safe-area layout, and flexible wrapping for large text. Respect scroll insets. Apply the shared paper palette to the existing fridge, creator, cooking screen, and completion modal where existing colors would clash. The new detail layout is a read-only recipe page, not a marketing website; website layout gates do not validate this native app.

## Pantry correction

Audit finding: `calculatePantryDecrement` subtracts numbers without converting units, while `evaluatePantryMatch` already understands compatible mass and volume dimensions. Example: 0.5kg minus 100g must produce 0.4kg, not zero.

Extract the existing conversion rules into a shared pure unit helper. Keep g/kg and ml/l/5ml-tsp/15ml-tbsp support, same-unit normalized matching, and rejection of dimensional conversions without density. Do not introduce an ambiguous cup conversion.

The deduction calculation must validate finite nonnegative pantry stock, finite nonnegative selected usage, compatible units, sufficient combined stock, and unique stock ingredient records. Unselected rows are ignored; zero selected usage is a no-op. Missing selected stock or insufficient stock returns an actionable error rather than silently pretending the requested amount was deducted. Repeated usage rows consume shared stock sequentially in the calculation; no partial database write occurs on validation failure.

Read current pantry and calculate inside the database writer before batching updates. On failure, keep the completion modal open with an error. Prevent simultaneous submissions while the modal is saving. Remove the unbacked “verified” review claim and review fields that are not saved anywhere; explain that public reviews require an account when connected in a later slice. Keep completion usable for guests.

This does not establish durable session replay protection, undo, saved recipes, sync, native notification delivery, or crash-restored cooking timers; those remain required launch follow-ups.

## Verification

- Tests reproduce kg/g and tbsp/ml errors, incompatible units, non-finite and negative inputs, shortages, repeated usage, deselected rows, and input immutability before fixing the engine.
- Keep the existing matching suite green after sharing conversion rules.
- Test recipe-overview completeness derivation against missing ingredients and steps using real pure data fixtures.
- Run the complete Node suite and strict TypeScript check.
- Attempt Android tooling discovery and native bundling where available. Device-only checks (TalkBack, large text, offline persistence, touch targets, visual layout) must be reported as unverified until actually exercised.

## Launch follow-ups

1. Persistent cooking sessions, idempotent consumption, wake lock, and local notification delivery.
2. Recipe/version storage, serving scaling, dual-unit display, aliases, and offline technique relationships.
3. Guest cookbook saves and verified media downloads.
4. Authenticated publishing with automated checks and flagged review; ratings remain authenticated.
5. Original recipe kitchen tests and content promotion only after review.
