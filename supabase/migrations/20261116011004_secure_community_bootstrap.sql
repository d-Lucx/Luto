BEGIN;
-- ==============================================================================
-- LUTO (Logo: Lu2) — Initial Database Schema & RLS Policies Migration
-- Target: PostgreSQL 16 on Supabase
-- Version: 1.0.0 · Migration: 20261026000001_initial_schema.sql
-- ==============================================================================

-- 1. Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2. Utility Function: Timestamp Auto-Updater
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- auth.users is managed by Supabase Auth; never create a production mock.

-- 3. Profiles Table (Linked to Supabase Auth)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username VARCHAR(50) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    measurement_preference VARCHAR(10) DEFAULT 'metric' CHECK (measurement_preference IN ('metric', 'imperial')),
    dietary_preferences TEXT[] DEFAULT '{}',
    skill_level VARCHAR(20) DEFAULT 'intermediate' CHECK (skill_level IN ('beginner', 'intermediate', 'advanced', 'pro')),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TRIGGER trg_profiles_updated_at
BEFORE UPDATE ON profiles
FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- 4. Master Ingredients Dictionary
CREATE TABLE IF NOT EXISTS ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canonical_name VARCHAR(150) UNIQUE NOT NULL,
    display_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN (
        'protein', 'produce', 'dairy', 'pantry_dry', 'canned',
        'bakery', 'spice_seasoning', 'oil_fat', 'condiment', 'liquid'
    )),
    is_staple BOOLEAN DEFAULT FALSE NOT NULL,
    default_unit VARCHAR(30) NOT NULL,
    average_shelf_life_days INT,
    allergen_tags TEXT[] DEFAULT '{}',
    density_g_per_ml NUMERIC(6,3),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_ingredients_canonical ON ingredients USING btree (canonical_name);
CREATE INDEX IF NOT EXISTS idx_ingredients_trgm ON ingredients USING gin (display_name gin_trgm_ops);

-- 5. Master Kitchen Equipment Dictionary
CREATE TABLE IF NOT EXISTS equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canonical_name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN (
        'cookware', 'bakeware', 'knives_cutlery', 'prep_tools',
        'appliances', 'measuring', 'utensils'
    )),
    is_essential BOOLEAN DEFAULT TRUE NOT NULL,
    icon_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_equipment_canonical ON equipment (canonical_name);

-- 6. Master Cooking Techniques Catalog
CREATE TABLE IF NOT EXISTS techniques_and_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    canonical_slug VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN (
        'knife_skills', 'dry_heat', 'moist_heat', 'combination',
        'sauces_emulsions', 'baking_pastry', 'prep_finishing'
    )),
    difficulty_level VARCHAR(20) DEFAULT 'beginner' CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
    summary TEXT NOT NULL,
    micro_video_url TEXT,
    gif_preview_url TEXT,
    key_tips TEXT[] NOT NULL DEFAULT '{}',
    common_mistakes TEXT[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_techniques_slug ON techniques_and_skills (canonical_slug);

-- 7. Recipes Master Table
CREATE TABLE IF NOT EXISTS recipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(250) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    cuisine_tags TEXT[] DEFAULT '{}',
    category VARCHAR(50) NOT NULL,
    difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'expert')),
    prep_time_minutes INT NOT NULL CHECK (prep_time_minutes >= 0),
    cook_time_minutes INT NOT NULL CHECK (cook_time_minutes >= 0),
    total_time_minutes INT GENERATED ALWAYS AS (prep_time_minutes + cook_time_minutes) STORED,
    servings INT NOT NULL DEFAULT 4 CHECK (servings > 0),
    calories_per_serving INT,
    nutritional_facts JSONB DEFAULT '{}'::jsonb,
    hero_image_url TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'pending_review', 'published', 'archived')),
    average_rating NUMERIC(3,2) DEFAULT 0.00,
    ratings_count INT DEFAULT 0,
    version INT DEFAULT 1 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recipes_status ON recipes (status);
CREATE INDEX IF NOT EXISTS idx_recipes_author ON recipes (author_id);
CREATE INDEX IF NOT EXISTS idx_recipes_rating ON recipes (average_rating DESC);

CREATE TRIGGER trg_recipes_updated_at
BEFORE UPDATE ON recipes
FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- 8. Recipe Steps
CREATE TABLE IF NOT EXISTS recipe_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    step_number INT NOT NULL,
    title VARCHAR(150),
    instruction TEXT NOT NULL,
    media_url TEXT,
    media_type VARCHAR(20) CHECK (media_type IN ('image', 'video', 'gif')),
    timer_duration_seconds INT DEFAULT 0,
    timer_label VARCHAR(100),
    is_critical BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT unique_step_per_recipe UNIQUE (recipe_id, step_number)
);

CREATE INDEX IF NOT EXISTS idx_steps_recipe_id ON recipe_steps (recipe_id, step_number);

-- 9. Recipe Step Techniques Link Table
CREATE TABLE IF NOT EXISTS recipe_step_techniques (
    recipe_step_id UUID NOT NULL REFERENCES recipe_steps(id) ON DELETE CASCADE,
    technique_id UUID NOT NULL REFERENCES techniques_and_skills(id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_step_id, technique_id)
);

-- 10. Recipe Ingredients Junction
CREATE TABLE IF NOT EXISTS recipe_ingredients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id UUID NOT NULL REFERENCES ingredients(id) ON DELETE RESTRICT,
    amount NUMERIC(8,3) NOT NULL CHECK (amount > 0),
    unit VARCHAR(30) NOT NULL,
    display_text VARCHAR(200) NOT NULL,
    is_optional BOOLEAN DEFAULT FALSE NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe ON recipe_ingredients (recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_ingredient ON recipe_ingredients (ingredient_id);

-- 11. Recipe Equipment Requirements Junction
CREATE TABLE IF NOT EXISTS equipment_requirements (
    recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    equipment_id UUID NOT NULL REFERENCES equipment(id) ON DELETE RESTRICT,
    is_required BOOLEAN DEFAULT TRUE NOT NULL,
    notes VARCHAR(200),
    PRIMARY KEY (recipe_id, equipment_id)
);

-- 12. User Pantry Table
CREATE TABLE IF NOT EXISTS user_pantry (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    ingredient_id UUID NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
    quantity NUMERIC(8,3),
    unit VARCHAR(30),
    storage_location VARCHAR(30) DEFAULT 'fridge' CHECK (storage_location IN ('fridge', 'freezer', 'pantry', 'spice_rack')),
    expiration_date DATE,
    is_staple BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT unique_user_ingredient UNIQUE (user_id, ingredient_id)
);

CREATE INDEX IF NOT EXISTS idx_user_pantry_user ON user_pantry (user_id);

CREATE TRIGGER trg_user_pantry_updated_at
BEFORE UPDATE ON user_pantry
FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- 13. Saved Recipes & Offline Sync State
CREATE TABLE IF NOT EXISTS saved_recipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    is_favorite BOOLEAN DEFAULT TRUE NOT NULL,
    is_downloaded_offline BOOLEAN DEFAULT FALSE NOT NULL,
    downloaded_at TIMESTAMPTZ,
    local_sync_version INT DEFAULT 1,
    personal_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT unique_user_saved_recipe UNIQUE (user_id, recipe_id)
);

CREATE INDEX IF NOT EXISTS idx_saved_recipes_user ON saved_recipes (user_id);

CREATE TRIGGER trg_saved_recipes_updated_at
BEFORE UPDATE ON saved_recipes
FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- 14. Ratings & Community Reviews
CREATE TABLE IF NOT EXISTS ratings_and_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    difficulty_score INT CHECK (difficulty_score BETWEEN 1 AND 5),
    review_text TEXT,
    photos TEXT[] DEFAULT '{}',
    pro_tips TEXT,
    helpful_votes INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT unique_user_recipe_review UNIQUE (recipe_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_recipe ON ratings_and_reviews (recipe_id);

CREATE TRIGGER trg_reviews_updated_at
BEFORE UPDATE ON ratings_and_reviews
FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- 15. Dynamic Ingredient Substitutions Matrix
CREATE TABLE IF NOT EXISTS ingredient_substitutions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    original_ingredient_id UUID NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
    substitute_ingredient_id UUID NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
    conversion_ratio NUMERIC(5,3) NOT NULL,
    category VARCHAR(50) NOT NULL,
    applicable_contexts TEXT[] NOT NULL DEFAULT '{"all"}',
    forbidden_contexts TEXT[] NOT NULL DEFAULT '{}',
    flavor_impact TEXT NOT NULL,
    texture_impact TEXT NOT NULL,
    preparation_note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_substitutions_original ON ingredient_substitutions (original_ingredient_id);

-- 16. Automated Recipe Rating Rollup Trigger
CREATE OR REPLACE FUNCTION update_recipe_rating_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE recipes
    SET
        average_rating = COALESCE((
            SELECT ROUND(AVG(rating)::numeric, 2)
            FROM ratings_and_reviews
            WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
        ), 0.00),
        ratings_count = (
            SELECT COUNT(*)
            FROM ratings_and_reviews
            WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
        ),
        updated_at = NOW()
    WHERE id = COALESCE(NEW.recipe_id, OLD.recipe_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ratings_rollup
AFTER INSERT OR UPDATE OR DELETE ON ratings_and_reviews
FOR EACH ROW EXECUTE FUNCTION update_recipe_rating_stats();

-- ==============================================================================
-- 17. Row Level Security (RLS) Policy Specifications
-- ==============================================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE techniques_and_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_step_techniques ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment_requirements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_pantry ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings_and_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE ingredient_substitutions ENABLE ROW LEVEL SECURITY;

-- Master Taxonomies (Public read-only)
CREATE POLICY "Public read for ingredients" ON ingredients FOR SELECT USING (true);
CREATE POLICY "Public read for equipment" ON equipment FOR SELECT USING (true);
CREATE POLICY "Public read for techniques" ON techniques_and_skills FOR SELECT USING (true);
CREATE POLICY "Public read for substitutions" ON ingredient_substitutions FOR SELECT USING (true);

-- Profiles Policies
CREATE POLICY "Profiles are publicly viewable" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can create their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Recipes Policies
CREATE POLICY "Published recipes are viewable by all" ON recipes
    FOR SELECT USING (status = 'published' OR auth.uid() = author_id);
CREATE POLICY "Authors can insert recipes" ON recipes
    FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = author_id);
CREATE POLICY "Authors can update their own recipes" ON recipes
    FOR UPDATE USING (auth.uid() = author_id);
CREATE POLICY "Authors can delete draft recipes" ON recipes
    FOR DELETE USING (auth.uid() = author_id AND status = 'draft');

-- Recipe Steps, Ingredients, Equipment Requirements
CREATE POLICY "Public read recipe steps" ON recipe_steps FOR SELECT USING (true);
CREATE POLICY "Authors manage recipe steps" ON recipe_steps FOR ALL USING (
    EXISTS (SELECT 1 FROM recipes WHERE recipes.id = recipe_steps.recipe_id AND recipes.author_id = auth.uid())
);

CREATE POLICY "Public read recipe step techniques" ON recipe_step_techniques FOR SELECT USING (true);
CREATE POLICY "Authors manage recipe step techniques" ON recipe_step_techniques FOR ALL USING (
    EXISTS (
        SELECT 1 FROM recipe_steps
        JOIN recipes ON recipes.id = recipe_steps.recipe_id
        WHERE recipe_steps.id = recipe_step_techniques.recipe_step_id AND recipes.author_id = auth.uid()
    )
);

CREATE POLICY "Public read recipe ingredients" ON recipe_ingredients FOR SELECT USING (true);
CREATE POLICY "Authors manage recipe ingredients" ON recipe_ingredients FOR ALL USING (
    EXISTS (SELECT 1 FROM recipes WHERE recipes.id = recipe_ingredients.recipe_id AND recipes.author_id = auth.uid())
);

CREATE POLICY "Public read equipment requirements" ON equipment_requirements FOR SELECT USING (true);
CREATE POLICY "Authors manage equipment requirements" ON equipment_requirements FOR ALL USING (
    EXISTS (SELECT 1 FROM recipes WHERE recipes.id = equipment_requirements.recipe_id AND recipes.author_id = auth.uid())
);

-- User Pantry Isolation
CREATE POLICY "Pantry isolated to owner select" ON user_pantry FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Pantry isolated to owner insert" ON user_pantry FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Pantry isolated to owner update" ON user_pantry FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Pantry isolated to owner delete" ON user_pantry FOR DELETE USING (auth.uid() = user_id);

-- Saved Recipes Isolation
CREATE POLICY "Saved recipes isolated to owner select" ON saved_recipes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Saved recipes isolated to owner all" ON saved_recipes FOR ALL USING (auth.uid() = user_id);

-- Reviews
CREATE POLICY "Public read reviews" ON ratings_and_reviews FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create reviews" ON ratings_and_reviews FOR INSERT
    WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);
CREATE POLICY "Users can update their own reviews" ON ratings_and_reviews FOR UPDATE
    USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own reviews" ON ratings_and_reviews FOR DELETE
    USING (auth.uid() = user_id);



-- ==============================================================================
-- LUTO (Logo: Lu2) — "What's in My Fridge?" Server-Side Pantry Matcher RPC
-- Migration: 20261026000002_pantry_matcher_rpc.sql
-- ==============================================================================

CREATE OR REPLACE FUNCTION rpc_match_pantry(
    p_user_ingredient_ids UUID[],
    p_min_score INT DEFAULT 50
)
RETURNS TABLE (
    recipe_id UUID,
    title VARCHAR,
    slug VARCHAR,
    hero_image_url TEXT,
    difficulty VARCHAR,
    total_time_minutes INT,
    average_rating NUMERIC(3,2),
    match_score INT,
    missing_count INT,
    missing_critical_count INT,
    can_cook_now BOOLEAN
) AS $$
BEGIN
    p_user_ingredient_ids := COALESCE(p_user_ingredient_ids, ARRAY[]::UUID[]);

    RETURN QUERY
    WITH recipe_eval AS (
        SELECT
            r.id AS r_id,
            r.title AS r_title,
            r.slug AS r_slug,
            r.hero_image_url AS r_hero_image_url,
            r.difficulty AS r_difficulty,
            r.total_time_minutes AS r_total_time_minutes,
            r.average_rating AS r_average_rating,

            -- Total theoretical weight (excluding staples)
            COALESCE(SUM(
                CASE
                    WHEN ing.is_staple THEN 0.0
                    WHEN ing.category IN ('protein', 'pantry_dry') THEN 3.5
                    WHEN ing.category IN ('produce', 'canned', 'dairy') THEN 2.0
                    ELSE 0.8
                END
            ), 0.0) AS total_weight,

            -- Earned score based on matches, substitutions, and optional status
            COALESCE(SUM(
                CASE
                    -- Staple items are universally assumed present
                    WHEN ing.is_staple THEN 0.0

                    -- Exact match in user pantry
                    WHEN ing.id = ANY(p_user_ingredient_ids) THEN
                        (CASE
                            WHEN ing.category IN ('protein', 'pantry_dry') THEN 3.5
                            WHEN ing.category IN ('produce', 'canned', 'dairy') THEN 2.0
                            ELSE 0.8
                        END) * 1.0

                    -- 1:1 or Emergency Substitute in user pantry
                    WHEN EXISTS (
                        SELECT 1 FROM ingredient_substitutions sub
                        WHERE sub.original_ingredient_id = ing.id
                          AND sub.substitute_ingredient_id = ANY(p_user_ingredient_ids)
                    ) THEN
                        (CASE
                            WHEN ing.category IN ('protein', 'pantry_dry') THEN 3.5
                            WHEN ing.category IN ('produce', 'canned', 'dairy') THEN 2.0
                            ELSE 0.8
                        END) * 0.90

                    -- Optional ingredients earn half weight without penalty
                    WHEN ri.is_optional THEN
                        (CASE
                            WHEN ing.category IN ('protein', 'pantry_dry') THEN 3.5
                            WHEN ing.category IN ('produce', 'canned', 'dairy') THEN 2.0
                            ELSE 0.8
                        END) * 0.50

                    ELSE 0.0
                END
            ), 0.0) AS earned_score,

            -- Count of missing non-optional ingredients
            COUNT(*) FILTER (
                WHERE NOT ing.is_staple
                  AND NOT ri.is_optional
                  AND NOT (ing.id = ANY(p_user_ingredient_ids))
                  AND NOT EXISTS (
                      SELECT 1 FROM ingredient_substitutions sub
                      WHERE sub.original_ingredient_id = ing.id
                        AND sub.substitute_ingredient_id = ANY(p_user_ingredient_ids)
                  )
            )::INT AS missing_items,

            -- Count of missing critical (Tier 1) components
            COUNT(*) FILTER (
                WHERE NOT ing.is_staple
                  AND NOT ri.is_optional
                  AND ing.category IN ('protein', 'pantry_dry')
                  AND NOT (ing.id = ANY(p_user_ingredient_ids))
                  AND NOT EXISTS (
                      SELECT 1 FROM ingredient_substitutions sub
                      WHERE sub.original_ingredient_id = ing.id
                        AND sub.substitute_ingredient_id = ANY(p_user_ingredient_ids)
                  )
            )::INT AS missing_critical_items

        FROM recipes r
        JOIN recipe_ingredients ri ON ri.recipe_id = r.id
        JOIN ingredients ing ON ing.id = ri.ingredient_id
        WHERE r.status = 'published'
        GROUP BY r.id
    ),
    scored_recipes AS (
        SELECT
            re.r_id,
            re.r_title,
            re.r_slug,
            re.r_hero_image_url,
            re.r_difficulty,
            re.r_total_time_minutes,
            re.r_average_rating,
            re.missing_items,
            re.missing_critical_items,

            -- Calculate final weighted match score with critical missing penalty
            CASE
                WHEN re.total_weight = 0 THEN 100
                ELSE GREATEST(0, ROUND(
                    ((re.earned_score / re.total_weight) - ((re.missing_critical_items * 1.5) / re.total_weight)) * 100
                ))::INT
            END AS calculated_score
        FROM recipe_eval re
    )
    SELECT
        sr.r_id AS recipe_id,
        sr.r_title AS title,
        sr.r_slug AS slug,
        sr.r_hero_image_url AS hero_image_url,
        sr.r_difficulty AS difficulty,
        sr.r_total_time_minutes AS total_time_minutes,
        sr.r_average_rating AS average_rating,
        sr.calculated_score AS match_score,
        sr.missing_items AS missing_count,
        sr.missing_critical_items AS missing_critical_count,
        (sr.calculated_score >= 80 AND sr.missing_critical_items = 0) AS can_cook_now
    FROM scored_recipes sr
    WHERE sr.calculated_score >= p_min_score
    ORDER BY sr.calculated_score DESC, sr.r_average_rating DESC, sr.missing_items ASC;
END;
$$ LANGUAGE plpgsql STABLE;

-- Only community Edge Functions may mutate publication or moderation state.
-- JSON snapshots keep the complete recipe graph and its immutable revisions atomic.
create table public.community_recipes (
 id uuid primary key default gen_random_uuid(), author_id uuid not null references auth.users(id) on delete cascade,
 local_recipe_id text not null check(length(local_recipe_id) between 1 and 150), snapshot jsonb not null,
 status text not null check(status in ('published','pending_review','archived')),
 moderation_flags text[] not null default '{}', version integer not null default 1,
 content_hash text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(author_id,local_recipe_id), check(pg_column_size(snapshot)<200000)
);
create index community_recipes_status_date on public.community_recipes(status,created_at desc);
create table public.community_versions (
 recipe_id uuid references public.community_recipes(id) on delete cascade, version integer not null,
 snapshot jsonb not null, status text not null, moderation_flags text[] not null, created_at timestamptz not null default now(),
 primary key(recipe_id,version)
);
create table public.community_reports (
 id uuid primary key default gen_random_uuid(), recipe_id uuid not null references public.community_recipes(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade, reason text not null check(length(reason) between 3 and 2000),
 created_at timestamptz not null default now(), unique(recipe_id,user_id)
);
create table public.community_reviews (
 id uuid primary key default gen_random_uuid(), recipe_id uuid not null references public.community_recipes(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade, rating integer not null check(rating between 1 and 5),
 review_text text not null check(length(review_text)<=2000), status text not null check(status in ('published','pending_review')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(recipe_id,user_id)
);
create table public.community_moderators(user_id uuid primary key references auth.users(id) on delete cascade);
create table public.community_moderation_log (
 id uuid primary key default gen_random_uuid(), recipe_id uuid references public.community_recipes(id) on delete cascade,
 moderator_id uuid references auth.users(id) on delete set null, decision text not null, reason text not null, created_at timestamptz not null default now()
);
alter table public.community_recipes enable row level security;
alter table public.community_versions enable row level security;
alter table public.community_reviews enable row level security;
alter table public.community_reports enable row level security;
alter table public.community_moderators enable row level security;
alter table public.community_moderation_log enable row level security;
revoke all on public.community_recipes,public.community_versions,public.community_reviews,public.community_reports,public.community_moderators,public.community_moderation_log from anon,authenticated;
grant select on public.community_recipes,public.community_reviews to anon,authenticated;
grant select on public.community_versions,public.community_reports to authenticated;
grant all on public.community_recipes,public.community_versions,public.community_reviews,public.community_reports,public.community_moderators,public.community_moderation_log to service_role;
create policy community_read on public.community_recipes for select to anon,authenticated using(status='published' or author_id=(select auth.uid()));
create policy community_versions_owner on public.community_versions for select to authenticated using(exists(select 1 from public.community_recipes r where r.id=recipe_id and r.author_id=(select auth.uid())));
create policy community_reports_owner on public.community_reports for select to authenticated using(user_id=(select auth.uid()));
create policy community_reviews_read on public.community_reviews for select to anon,authenticated using((status='published' and exists(select 1 from public.community_recipes r where r.id=recipe_id and r.status='published')) or user_id=(select auth.uid()));

-- Service-only, invoker function: transactional idempotent publish, no elevated definer API.
create function public.community_commit(p_author uuid,p_local text,p_snapshot jsonb,p_flags text[],p_hash text) returns public.community_recipes
language plpgsql security invoker set search_path='' as $$
declare result public.community_recipes; next_status text;
begin
 perform pg_advisory_xact_lock(hashtextextended(p_author::text||':'||p_local,0));
 select * into result from public.community_recipes where author_id=p_author and local_recipe_id=p_local for update;
 if result.id is not null and result.content_hash=p_hash and result.status<>'archived' then return result; end if;
 if (select count(*) from public.community_versions v join public.community_recipes r on r.id=v.recipe_id where r.author_id=p_author and v.created_at>now()-interval '1 hour') >= 30 then raise exception 'Submission limit reached'; end if;
 next_status := case when cardinality(p_flags)=0 then 'published' else 'pending_review' end;
 insert into public.community_recipes(author_id,local_recipe_id,snapshot,status,moderation_flags,content_hash)
 values(p_author,p_local,p_snapshot,next_status,p_flags,p_hash)
 on conflict(author_id,local_recipe_id) do update set snapshot=excluded.snapshot,status=excluded.status,moderation_flags=excluded.moderation_flags,content_hash=excluded.content_hash,version=community_recipes.version+1,updated_at=now()
 returning * into result;
 insert into public.community_versions(recipe_id,version,snapshot,status,moderation_flags) values(result.id,result.version,result.snapshot,result.status,result.moderation_flags);
 return result;
end $$;
revoke all on function public.community_commit(uuid,text,jsonb,text[],text) from public,anon,authenticated;
grant execute on function public.community_commit(uuid,text,jsonb,text[],text) to service_role;

-- Harden the original relational API, including parent-derived privacy of every child.
do $$ declare p record; t text; begin
 for p in select schemaname,tablename,policyname from pg_policies where schemaname='public' and tablename in ('recipes','recipe_steps','recipe_step_techniques','recipe_ingredients','equipment_requirements','ratings_and_reviews') loop
 execute format('drop policy %I on %I.%I',p.policyname,p.schemaname,p.tablename); end loop;
 foreach t in array array['recipes','recipe_steps','recipe_step_techniques','recipe_ingredients','equipment_requirements','ratings_and_reviews'] loop
 execute format('revoke insert,update,delete on public.%I from anon,authenticated',t);
 execute format('grant select on public.%I to anon,authenticated',t); end loop;
end $$;
create policy legacy_recipe_read on public.recipes for select to anon,authenticated using(status='published' or author_id=(select auth.uid()));
create policy legacy_steps_read on public.recipe_steps for select to anon,authenticated using(exists(select 1 from public.recipes r where r.id=recipe_id and (r.status='published' or r.author_id=(select auth.uid()))));
create policy legacy_ingredients_read on public.recipe_ingredients for select to anon,authenticated using(exists(select 1 from public.recipes r where r.id=recipe_id and (r.status='published' or r.author_id=(select auth.uid()))));
create policy legacy_equipment_read on public.equipment_requirements for select to anon,authenticated using(exists(select 1 from public.recipes r where r.id=recipe_id and (r.status='published' or r.author_id=(select auth.uid()))));
create policy legacy_techniques_read on public.recipe_step_techniques for select to anon,authenticated using(exists(select 1 from public.recipe_steps s join public.recipes r on r.id=s.recipe_id where s.id=recipe_step_id and (r.status='published' or r.author_id=(select auth.uid()))));
create policy legacy_reviews_read on public.ratings_and_reviews for select to anon,authenticated using(exists(select 1 from public.recipes r where r.id=recipe_id and r.status='published'));
grant select on public.ingredients,public.equipment,public.techniques_and_skills,public.ingredient_substitutions to anon,authenticated;
alter function public.set_updated_at_column() set search_path='public';
alter function public.update_recipe_rating_stats() set search_path='public';
alter function public.rpc_match_pantry(uuid[],integer) set search_path='public';


COMMIT;
