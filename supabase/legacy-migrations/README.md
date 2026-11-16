# Historical designs — not deployment migrations

The original three migrations were never deployed to the dedicated Luto project. They are retained here as historical source only. They contained broad public child reads, client publication writes, and managed auth/storage mock stubs.

The active migration directory matches the dedicated project's actual migration history. Its bootstrap applies the relational schema and restrictive publication/child privacy policies in one transaction. Community publishes use immutable versioned JSON snapshots and service-only transactional commit/moderation RPCs.

Do not run the historical storage migration or `supabase/seed.sql` against production. The latter includes fictional creator/sample recipes and unsupported assumptions. The active dictionary migration seeds canonical taxonomies only. No sample recipe was published to Luto.
