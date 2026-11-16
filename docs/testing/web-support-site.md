# Lu2 static support website

Source: `apps/web`. No npm dependencies, installation, framework, build command, external fonts, JavaScript, analytics, account forms, or paid services. The existing native logo was copied unchanged into `assets/lu2-logo.png`. Site colors reuse the mobile paper/ink/terracotta palette; headings use system Georgia/serif and body text uses system sans-serif.

## Pages and deployment payload

- `/` — product introduction with clear Android prototype status.
- `/support` — public GitHub support and private-data warning.
- `/privacy` — local device vs Supabase community handling, providers, public content, and explicit unknowns.
- `/terms` — prototype/content use; automated publication does not mean kitchen-tested or curated.
- `/account-deletion` — honest missing self-service/private deletion workflow and safe contact-method guidance.
- `/auth/callback` — static explanatory fallback; does not consume, exchange, display, or forward OAuth codes/tokens.
- `404.html` — missing page fallback.

Upload only these seven HTML files, `styles.css`, `assets/lu2-logo.png`, and `vercel.json` (ten runtime/deployment files). The nested path is `auth/callback.html`. `.gitignore` and `.vercelignore` exclude any local preview/browser and Vercel metadata. No environment variables or secrets are required or included.

Use `apps/web` as the Vercel project root, Framework Preset **Other**, no build or install command, static output at that root. `vercel.json` enables clean URLs and disables trailing slashes, so `/privacy` serves `privacy.html` and `/auth/callback` serves `auth/callback.html`. It also sets a restrictive content-security policy, no-referrer policy, no-sniff header, and disables camera/microphone/geolocation permissions.

The parent task owns selection of the existing free personal account/team and any deployment. This work has not created a project, deployed, attached a domain, registered a domain, or selected a paid plan. Use only the included `*.vercel.app` hostname after the free target has been chosen. Confirm actual account eligibility and limits rather than assuming a target is free.

OAuth should continue to complete in the native app's configured callback/PKCE route. This website supplies the public support/privacy URLs needed for configuration; it is not an OAuth bridge. Do not register the static website callback as a working token-exchange handler. The static fallback ignores query and fragment parameters and sends no JavaScript requests. Hosting infrastructure may still receive query strings, so do not direct credentials here.

## Local validation

Completed filesystem-based checks:

- Seven complete HTML pages; each has one H1, English language metadata, viewport metadata, main landmark, and skip link.
- All 88 internal link/asset occurrences resolve to local files; nine external link occurrences point only to the requested GitHub repository or issue tracker.
- No scripts, forms, email addresses, phone links, external fonts, or external page assets were introduced.
- Copied logo bytes match the native asset exactly.
- Vercel configuration parses as JSON; clean URLs and no-referrer policy are present.
- Calculated text contrast: ink on paper **13.02:1**, muted on paper **5.77:1**, accent on paper **6.72:1**, white on accent **7.55:1**.

The CSS has a 700px mobile breakpoint, flexible widths, a single-column content layout, wrapping navigation, visible keyboard focus, 48px navigation targets, a 52px main button, and reduced-motion handling. These are implementation facts, not a browser accessibility certification.

A 390px browser preview was attempted but is **not verified**. The computer-use browser inventory returned no available browsers, and the direct local headless/CDP attempt did not provide a reachable preview. No screenshots of unrelated apps were taken. Isolated preview processes and their generated profile were closed/removed; no browser profile is part of the site payload. UI/UX Pro Max's search could not run because Python was unavailable; the skill's documented accessibility/layout guidance and existing brand tokens were applied directly. Design Taste was scoped to a small support/documentation site rather than its large promotional-site effects.

Before publishing, verify `/`, `/support`, and `/privacy` at 390px, plus every clean URL and 404 on the chosen Vercel deployment. Check no horizontal overflow, visible keyboard focus, intact logo, readable long paragraphs, and successful navigation. Confirm security headers are served and the OAuth provider points to the intended native flow.

## Content limitations to preserve

No legal entity, postal address, phone number, private support email, retention schedule, deletion deadline, compliance certification, or account-deletion UI has been invented. This accurately exposes a product limitation: a private contact/deletion process remains unfinished. The website does not make that workflow complete or establish app-store/privacy-law compliance.

The original draft collection is not represented as live, published community content is not called curated, and automated checks are not described as kitchen testing. A saved recipe is explicitly distinct from verified media availability. Guest pantry data is described as local without promising cloud backup or cross-device recovery.

## Live deployment and icon correction — November 16, 2026

The site is deployed at https://lu2-cooking.vercel.app. A previous 390px browser check verified the page layout without horizontal overflow. The old favicon incorrectly reused the wide wordmark; all seven pages now reference dedicated square pot-and-steam icons, including an ICO with 16/32/48px entries, a 32px PNG and a 180px Apple touch icon. Favicon URLs include `v=2` to refresh the old cached reference. The full wordmark remains unchanged in the page header.

Production deployment `dpl_C2CCZtbAFAwsTyu88c7T3pbNGTDE` reached READY and has the public alias. Its explicit fourteen-file payload includes the new square assets and the unchanged original logo; no environment files, credentials or mobile source were uploaded. The live favicon, 32px PNG and Apple touch icon returned HTTP 200 and SHA256 matched their local files. Browser DOM inspection verified the new references on the live homepage.

Regenerate icon sizes with `node scripts/build-brand-icons.mjs` from `apps/mobile`, using the existing locked image tooling. The source symbol was derived from the approved Lu2 logo. Expo configuration now references a 1024px opaque legacy launcher icon and a separate transparent adaptive foreground on the existing paper color. Regenerate Android resources with `npx expo prebuild --platform android --no-install` before rebuilding an existing native project; updating JavaScript alone cannot replace an installed launcher icon.

The Android icon APK built successfully in 2m57s with device-test features disabled. SHA256: `990469E679CEF53E261BB398A9317A8FC73AE0B4D9DE446C56FEA91B021D44E7`. Generated adaptive resources reference the separate foreground/paper background for both normal and round launchers. Painted foreground pixels fit inside the Android adaptive safe circle (244.10px maximum radius versus 312.89px permitted on the 1024px source). WatermelonDB integration, legacy architecture, SecureStore backup rules and precise-alarm permission survived prebuild. After USB reconnection, `adb install -r` succeeded on the Infinix X6852 without clearing data. Android App info visibly displays the new Lu2 pot-and-steam icon on paper; capture `lu2-icon-info.png` is in the ignored device-test artifacts.

Reopening the installed app returned to the community page; after account loading completed, “Your account” was present and the guest sign-in prompt was absent, confirming the saved session survived the upgrade.
