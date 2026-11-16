# Community backend verification

Verified 2026-11-16 UTC against **Luto only**, project `jhkexctlzxyrumfopdcx`, organization `yxggxdszucdkdujxpjnd`. No BejHub project was queried or changed.

## Deployed implementation

`https://jhkexctlzxyrumfopdcx.supabase.co/functions/v1/community`, ACTIVE version 5. Public discovery and complete recipe snapshots share this endpoint; `verify_jwt=false` permits guests. Every mutation independently verifies the bearer with Supabase Auth's `/user` endpoint and rejects anonymous sessions. Author identity comes from that verified user, never from a request field.

Only the server can write publication/moderation state. RLS grants public reads solely for published community recipes, author reads of their held/archived recipes and revision history, and private report reads to the reporter. Direct client INSERT/UPDATE/DELETE and commit/moderation RPC access are denied. Legacy relational recipe child reads explicitly require a published parent or its author. There are no client publication-write policies.

`community_commit` is a service-only, security-invoker transaction. It locks author/local recipe ID, preserves stable remote identity, returns identical retries without adding revisions, and saves changed snapshots/version history atomically. Up to 30 changed submissions per author per hour are allowed. Unknown dictionary entries and screening flags are held privately. Clean submissions publish automatically. These keyword checks are automated screening, **not kitchen testing or a food-safety guarantee**. No kitchen-tested claim is stored from client input.

`community_moderate` requires a server-maintained moderator membership, prevents self-review, and changes state with its audit record in one transaction. No real moderator has been assigned by this implementation. Flagged recipe review remains pending until an operator explicitly assigns a reviewer. Ratings are authenticated, limited to one per user/recipe, disallow self-ratings, and hold flagged text. Reports are private and limited to one per user/recipe.

Snapshots preserve ingredients, units, optional tiers, equipment, ordered instructions, timers, technique slugs, HTTPS media references, and SHA256/size/MIME manifests. Server dictionary IDs are resolved by canonical names; local/guest IDs are not submitted as foreign UUIDs. The live dictionary contains **103 ingredients, 32 equipment items, 20 techniques**. The offline ingredient JSON was exported from those exact deployed rows. Demo aliases require `Eggs→eggs`, `Tomatoes→roma_tomatoes`, `Onion→yellow_onion`, `Salt→salt` to avoid duplicates.

The client uses only the public publishable key, native SecureStore for tokens, refresh-token rotation, 15-second request cancellation, guest discovery when refresh fails, and explicit retry errors preserving local content. Recipe bodies are read as bounded UTF8 streams (200,000 bytes), even without Content-Length. Servings are limited to 1–100.

## Executed checks

- `node --experimental-strip-types --test tests/community.test.mjs` from `apps/mobile`: **8 passed**. Includes malformed snapshots, unsafe client fields/local URLs, moderation holds, servings 101 rejection, media manifests, actual UTF8 byte limits/cancellation, network timeout.
- `npm run typecheck` from `apps/mobile`: **passed**.
- `community.integration.mjs` against the deployed backend with two pre-provisioned, reserved `example.invalid` users: **passed**. Checked guest rejection, authenticated publish, canonical IDs, idempotency, versioned edit to private hold, author/other-user privacy, forbidden direct writes/RPC, cross-author archive, authenticated review/report, self-review rejection, moderator denial and authorized moderation transaction.
- Initial and follow-up DDL applied only to Luto. `pg_trgm` moved to `extensions`; latest security advisor has no database RLS/function/extension findings. The remaining Auth warning is disabled leaked-password protection; this client uses email codes/links rather than user passwords.
- Native media fixture used the user-created Lu2 logo, SHA256 `ed658ab7a88fea8b600c0e942eb9afdaa3caa8bbe304c20594722cf02c32ab35`, 532529 bytes. Parent verified download, digest, display, airplane-mode restart, and persistent removal. The object was deleted through Storage API; its empty test bucket was made private and all temporary test policies disabled.

No test email was sent. Test recipes were temporary and not labeled kitchen tested. Parent removed the test accounts after final fixture cleanup; reserved fixture identities are `e461ac12-fd7f-40be-aed1-d073e327cc12` and `e461ac12-fd7f-40be-aed1-d073e327cc13`. Final read verified neither exact ID remains; their community content and moderator membership cascade on deletion.

The final deployed version passed public discovery, dictionary retrieval, and unauthenticated mutation rejection. Additional live oversized HTTP probes timed out before a response (including fixed-length and chunked transport); logs contained no completed requests for those probes. Stream size/cancellation is covered by the local unit test; a live oversized-body response remains unverified through this environment's HTTP path.

## External setup still required

Google OAuth is now implemented as a free alternative that does not require SMTP or a purchased domain. See `community-google-auth.md` for exact native redirect configuration, security behavior and current provider availability. Actual Google account/provider configuration remains required; implementation alone does not enable the provider.

Email delivery to ordinary users requires a custom SMTP sender. Supabase's default sender permits only project-team email addresses. No sender/domain credentials were provided and none were invented. Configure [Luto SMTP settings](https://supabase.com/dashboard/project/jhkexctlzxyrumfopdcx/auth/smtp) before public onboarding. The client accepts numeric OTPs or the original project verification link; numeric codes require the email template to include `{{ .Token }}`. Actual mailbox delivery/code verification was not exercised. See [official SMTP restrictions](https://supabase.com/docs/guides/auth/auth-smtp) and [passwordless email setup](https://supabase.com/docs/guides/auth/auth-email-passwordless).

General user media upload is not enabled: submitted remote media references carry integrity manifests, and the download path verifies bytes. The historical storage migration is archived and must not be deployed. An upload/quarantine/scanning/promotion pipeline requires separate implementation before accepting arbitrary binary uploads.

## Source and migration history

Active migration filenames use the exact versions returned by the deployed project. The secure bootstrap folds the never-deployed legacy schema and restrictive final policies into one transaction. Historical designs are in `supabase/legacy-migrations`; do not deploy them or the fictional-recipe `supabase/seed.sql`. The active dictionary migration seeds taxonomies only. Temporary native fixture policy migrations are retained to mirror remote history; their final state is deny-all and their test user is removed.

Initial unsafe standalone schema deployment was rejected by automatic review, then replaced by an atomic schema/hardening transaction with explicit parent privacy predicates. No unsafe intermediate schema was committed. Subagent cleanup DELETE/drop confirmations expired; parent performs the exact test-account deletion. Other authorized implementation, deployment, verification, and reversible policy disabling completed.
