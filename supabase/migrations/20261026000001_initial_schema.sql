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
