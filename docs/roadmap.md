# Luto (Logo: Lu2) — Phased Engineering Delivery Roadmap
**Multi-Agent Dispatch Backlog, Milestone Gates, and Verification Criteria**
_Document Version: 1.0.0 · Status: Final Execution Roadmap · Date: October 2026_

---

## 1. Roadmap Architecture & Dispatch Strategy

The engineering lifecycle of Luto is partitioned into **four cohesive milestones**, each structured for parallel and sequential dispatch across specialized autonomous agents (Backend/Database Engineer, Mobile/Frontend Engineer, QA/Test Engineer, and Security Engineer).

```
+---------------------------------------------------------------------------------+
|                     MILESTONE 1: Schemas, Migrations & Taxonomies               |
|                     (PostgreSQL DDL, Seed Scripts, Typegen)                     |
+----------------------------------------+----------------------------------------+
                                         |
                                         v
+---------------------------------------------------------------------------------+
|                     MILESTONE 2: Backend API, Auth & Storage RLS                |
|                     (Supabase Client, Edge Functions, Matching RPC)             |
+----------------------------------------+----------------------------------------+
                                         |
                                         v
+---------------------------------------------------------------------------------+
|                     MILESTONE 3: Mobile Core, Offline Sync & Pantry             |
|                     (Expo v51+, WatermelonDB, "Fridge" Filter UI)               |
+----------------------------------------+----------------------------------------+
                                         |
                                         v
+---------------------------------------------------------------------------------+
|                     MILESTONE 4: Community CRUD & Interactive Cooking Mode      |
|                     (Recipe Creator, Multitimer Cooking UX, Verified Reviews)   |
+---------------------------------------------------------------------------------+
```

---

## 2. Milestone 1: Data Schemas, DB Migrations & Seed Taxonomies

**Lead Persona**: `Backend and full stack engineer`  
**Target Duration**: Sprint 1 (Foundation)  
**Primary Deliverable**: Reproducible Supabase migration suite and seeded master dictionaries.

### Task Breakdown & Dispatch Contracts

#### Task 1.1: Core Relational Database Migration Suite
- **OBJECTIVE**: Transcribe the DDL from `system-architecture.md` into clean, idempotent PostgreSQL migration files managed under `supabase/migrations/`.
- **OUTPUT**:
  - `supabase/migrations/20261026000001_initial_schema.sql` (profiles, ingredients, equipment, techniques_and_skills, recipes, recipe_steps, recipe_ingredients, equipment_requirements, user_pantry, saved_recipes, ratings_and_reviews, ingredient_substitutions).
  - Triggers for `updated_at` timestamps and automated `average_rating` recalculation.
- **TOOLS**: PostgreSQL 16, Supabase CLI (`supabase db diff`, `supabase migration up`).
- **BOUNDARIES**: Adhere strictly to normalized relational types; enforce positive numeric constraints and foreign key cascade rules.

#### Task 1.2: Seed Data Loader & Universal Taxonomy Ingestion
- **OBJECTIVE**: Ingest `taxonomies/substitutions.json`, `taxonomies/equipment.json`, and `taxonomies/techniques.json` into the database.
- **OUTPUT**:
  - `supabase/seed.sql` containing batch `INSERT` statements for 35+ substitutions, 32 equipment items, and 20 techniques.
  - 10 reference starter recipes (diverse global cuisines: Pasta Carbonara, Chicken Adobo, Thai Green Curry, Beef Stir Fry, French Omelet, Shakshuka, Lentil Dahl, Ratatouille, Guacamole, Sourdough Bread) linking canonical ingredients and steps.
- **TOOLS**: Node.js seed script (`scripts/seed-taxonomies.ts`) using `@supabase/supabase-js`.
- **BOUNDARIES**: Guarantee that all foreign keys in `seed.sql` match valid canonical UUIDs.

#### Task 1.3: Automated Database Type Generation
- **OBJECTIVE**: Export static TypeScript database definitions from the running schema.
- **OUTPUT**: `src/types/database.types.ts` containing strongly typed definitions for all tables, views, and RPC returns.
- **TOOLS**: `npx supabase gen types typescript --local > src/types/database.types.ts`.
- **BOUNDARIES**: Clean zero-warning export.

---

## 3. Milestone 2: Backend API, Auth & Supabase Storage RLS

**Lead Persona**: `Backend and full stack engineer` & `Security engineer`  
**Target Duration**: Sprint 2 (Core Services)  
**Primary Deliverable**: Hardened API layer with Row Level Security, Storage Buckets, and Matching RPC.

### Task Breakdown & Dispatch Contracts

#### Task 2.1: Supabase Auth & RLS Policy Enforcement
- **OBJECTIVE**: Implement and verify RLS policies ensuring secure multi-tenant isolation.
- **OUTPUT**:
  - `supabase/migrations/20261026000002_rls_policies.sql`.
  - Automated SQL integration tests (`tests/rls_test.sql` using `pgTAP`) proving that unauthorized users cannot read unreleased drafts or modify another user's pantry.
- **TOOLS**: Supabase RLS, `pgTAP`.
- **BOUNDARIES**: Zero public write access without authentication. Guest anonymous users may read published recipes and store local pantry items in unauthenticated client memory only.

#### Task 2.2: Supabase Media Storage Configuration
- **OBJECTIVE**: Configure media storage buckets with auto-scaling CDN and file upload policies.
- **OUTPUT**:
  - Buckets: `recipe-media` (public, 5MB image limit), `technique-videos` (public, 8MB video limit), `user-uploads-quarantine` (authenticated, private).
  - Storage RLS rules allowing authenticated recipe authors to write to designated subfolders `recipes/{recipe_id}/*`.
- **TOOLS**: Supabase Storage API, Cloudflare CDN.
- **BOUNDARIES**: Reject non-WebP/JPEG/PNG image mimetypes and non-MP4/WebM video mimetypes at the bucket policy level.

#### Task 2.3: "What's in My Fridge?" Server-Side Database RPC (PostgreSQL Function)
- **OBJECTIVE**: Implement high-performance server-side pantry matching function for non-offline client search.
- **OUTPUT**:
  - `supabase/migrations/20261026000003_pantry_matcher_rpc.sql` defining `rpc_match_pantry(user_ingredient_ids UUID[], min_score INT)`.
  - Benchmarked query executing in < 50ms across 10,000 recipes utilizing GIN and trigram indexes on `recipe_ingredients`.
- **TOOLS**: PL/pgSQL, array set operations, EXPLAIN ANALYZE.
- **BOUNDARIES**: Match mathematical scoring logic defined in `feature-spec.md`.

---

## 4. Milestone 3: Mobile Core UI, Offline Sync & Pantry Engine

**Lead Persona**: `Mobile developer`  
**Target Duration**: Sprint 3 (Client Application)  
**Primary Deliverable**: Functional cross-platform React Native / Expo application with local WatermelonDB offline storage.

### Task Breakdown & Dispatch Contracts

#### Task 3.1: React Native / Expo Architecture & WatermelonDB Bridge
- **OBJECTIVE**: Initialize the mobile client workspace with Expo Router, Hermes engine, and WatermelonDB SQLite adapter.
- **OUTPUT**:
  - Expo SDK 51+ configuration (`app.json`, `babel.config.js`).
  - WatermelonDB local schema and models: `Recipe`, `RecipeStep`, `RecipeIngredient`, `UserPantry`, `Technique`, `Equipment`.
  - SQLite JSI database connection verified on iOS Simulator and Android Emulator.
- **TOOLS**: Expo, WatermelonDB, `@nozbe/watermelondb`, `expo-sqlite`.
- **BOUNDARIES**: TypeScript strict mode enabled; zero native Swift/Kotlin compilation errors.

#### Task 3.2: Local Delta Sync & Media Download Engine
- **OBJECTIVE**: Build the offline download pipeline and bidirectional sync manager.
- **OUTPUT**:
  - `src/services/sync/SyncService.ts`: Delta synchronization pulling updated published recipes and pushing local pantry changes using Last-Write-Wins timestamps.
  - `src/services/media/OfflineMediaManager.ts`: Background file downloader downloading images and looping video clips to `expo-file-system` and updating local URI pointers.
- **TOOLS**: `expo-file-system`, `expo-network`, NetInfo.
- **BOUNDARIES**: Seamless handling of connection interruptions; auto-retry on exponential backoff.

#### Task 3.3: "What's in My Fridge?" Interactive Screen & Local Filter Engine
- **OBJECTIVE**: Build the intuitive pantry inventory manager and instant recipe recommender.
- **OUTPUT**:
  - Screen `app/(tabs)/fridge.tsx`: Quick-add tag input with auto-complete against canonical ingredients, categorized by fridge, freezer, and dry pantry.
  - Real-time client-side evaluation of `evaluatePantryMatch()` yielding 60 FPS filtering as pantry items are toggled.
  - Visual score badges: "100% Ready to Cook", "Missing 1 minor item", etc.
- **TOOLS**: React Native, Zustand, Lucide Icons, FlashList (high-performance list rendering).
- **BOUNDARIES**: Must operate 100% offline with zero network requests once recipes are cached.

---

## 5. Milestone 4: Community Upload, Ratings & Interactive Cooking Mode

**Lead Persona**: `Mobile developer` & `Frontend developer`  
**Target Duration**: Sprint 4 (Full Experience)  
**Primary Deliverable**: Interactive cooking execution mode and community contribution flow.

### Task Breakdown & Dispatch Contracts

#### Task 4.1: Hands-Free Distraction-Free Cooking Mode
- **OBJECTIVE**: Deliver the fullscreen kitchen cooking mode.
- **OUTPUT**:
  - Screen `app/cook/[id].tsx`: High-contrast large format step cards (24sp+ text), wake-lock activation via `expo-keep-awake`.
  - Concurrent multi-timer widget with haptic and audio alarms (`expo-av`).
  - Technique callout badge opening lightweight modal with seamless 6-second video loop from `taxonomies/techniques.json`.
- **TOOLS**: `expo-keep-awake`, `expo-av`, `react-native-reanimated`.
- **BOUNDARIES**: Must retain timer state across app minimization and screen orientation rotations.

#### Task 4.2: Post-Cook Workflow & Pantry Auto-Decrement
- **OBJECTIVE**: Provide immediate closure and pantry maintenance upon completing a meal.
- **OUTPUT**:
  - Completion modal prompting: "Cook completed in 34 mins! Deduct ingredients from your fridge?".
  - Verified "Cooked It!" badge trigger upon submitting rating/review.
- **TOOLS**: Zustand, WatermelonDB batch writer.
- **BOUNDARIES**: Allow users to uncheck individual items if they substituted on the fly.

#### Task 4.3: Community Recipe Creator Flow
- **OBJECTIVE**: Implement the multi-step recipe authoring wizard.
- **OUTPUT**:
  - Step 1: Metadata (Title, Cuisine, Servings, Hero Image with crop/compress).
  - Step 2: Canonical ingredient selector with unit picker and substitution toggles.
  - Step 3: Equipment checklist and step builder with timer duration attachments.
  - Client-side validation ensuring compliance with moderation rules before draft submission.
- **TOOLS**: React Hook Form, Zod schema validation, `expo-image-manipulator`.
- **BOUNDARIES**: All ingredients must map to canonical IDs or submit a new proposal.

---

## 6. Multi-Agent Dispatch Matrix & Verification Gates

| Milestone | Deliverable Artifacts | Primary Agent | Quality Gate / Acceptance Criteria |
| :--- | :--- | :--- | :--- |
| **M1: Schemas & Taxonomies** | `system-architecture.md`, `taxonomies/*.json`, `supabase/seed.sql` | `Backend Engineer` | Clean SQL execution, zero foreign key violations, 100% JSON schema validation. |
| **M2: Backend & Auth** | Supabase migrations, RLS tests, RPC functions | `Security Engineer` | `pgTAP` tests pass; unauthorized queries rejected; RPC executes in < 50ms. |
| **M3: Mobile Core & Offline** | Expo workspace, WatermelonDB models, Pantry filter | `Mobile Engineer` | Offline mode confirmed in Airplane mode; 60 FPS scrolling on 500+ cached recipes. |
| **M4: Cooking Mode & CRUD** | Cooking Mode UI, multi-timer engine, Recipe creator | `Mobile Engineer` | Wake-lock prevents screen sleep; timers trigger audio/vibration; photo upload pipeline succeeds. |
