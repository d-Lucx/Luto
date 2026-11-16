-- ==============================================================================
-- LUTO (Logo: Lu2) — Supabase Storage Buckets & Storage RLS Migration
-- Target: PostgreSQL 16 on Supabase
-- Version: 1.0.0 · Migration: 20261026000003_storage_buckets.sql
-- ==============================================================================

-- 1. Storage Schema Mock Stub (for isolated PostgreSQL environments and tests)
CREATE SCHEMA IF NOT EXISTS storage;

CREATE TABLE IF NOT EXISTS storage.buckets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    public BOOLEAN DEFAULT FALSE,
    avif_autodetection BOOLEAN DEFAULT FALSE,
    file_size_limit BIGINT,
    allowed_mime_types TEXT[]
);

CREATE TABLE IF NOT EXISTS storage.objects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bucket_id TEXT REFERENCES storage.buckets(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb,
    path_tokens TEXT[] GENERATED ALWAYS AS (string_to_array(name, '/')) STORED
);

-- Helper functions for storage folder extraction if not provided by storage extension
CREATE OR REPLACE FUNCTION storage.foldername(name TEXT)
RETURNS TEXT[] AS $$
BEGIN
    RETURN string_to_array(name, '/');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION storage.filename(name TEXT)
RETURNS TEXT AS $$
DECLARE
    tokens TEXT[];
BEGIN
    tokens := string_to_array(name, '/');
    RETURN tokens[array_length(tokens, 1)];
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION storage.extension(name TEXT)
RETURNS TEXT AS $$
DECLARE
    fname TEXT;
    parts TEXT[];
BEGIN
    fname := storage.filename(name);
    parts := string_to_array(fname, '.');
    IF array_length(parts, 1) > 1 THEN
        RETURN parts[array_length(parts, 1)];
    END IF;
    RETURN '';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 2. Register Storage Buckets
-- 2.1 recipe-media (Public, 5MB image limit, allowed: WebP, JPEG, PNG)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'recipe-media',
    'recipe-media',
    TRUE,
    5242880, -- 5 MB
    ARRAY['image/webp', 'image/jpeg', 'image/png']
)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types,
    updated_at = NOW();

-- 2.2 technique-videos (Public, 8MB video limit, allowed: MP4, WebM)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'technique-videos',
    'technique-videos',
    TRUE,
    8388608, -- 8 MB
    ARRAY['video/mp4', 'video/webm']
)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types,
    updated_at = NOW();

-- 2.3 user-uploads-quarantine (Private, 10MB limit, for async moderation & virus scanning)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'user-uploads-quarantine',
    'user-uploads-quarantine',
    FALSE,
    10485760, -- 10 MB
    ARRAY['image/webp', 'image/jpeg', 'image/png', 'video/mp4', 'video/webm']
)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types,
    updated_at = NOW();

-- 3. Row Level Security on storage.objects
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- 3.1 Public Read for Published Recipe Media and Technique Videos
CREATE POLICY "Public Read for recipe-media"
ON storage.objects FOR SELECT
USING (bucket_id = 'recipe-media');

CREATE POLICY "Public Read for technique-videos"
ON storage.objects FOR SELECT
USING (bucket_id = 'technique-videos');

-- 3.2 Authenticated Recipe Authors Can Upload to recipe-media
-- Enforces standard naming path: recipes/{recipe_id}/* or recipes/{author_id}/*
CREATE POLICY "Authenticated users can upload recipe media"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'recipe-media'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = 'recipes'
    AND (
        -- User can upload to their author workspace folder
        (storage.foldername(name))[2] = auth.uid()::text
        -- Or to a recipe they authored
        OR EXISTS (
            SELECT 1 FROM recipes
            WHERE recipes.id::text = (storage.foldername(name))[2]
              AND recipes.author_id = auth.uid()
        )
    )
);

-- 3.3 Authors Can Update or Delete Their Own Recipe Media
CREATE POLICY "Authors can update own recipe media"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'recipe-media'
    AND auth.role() = 'authenticated'
    AND (
        owner = auth.uid()
        OR (storage.foldername(name))[2] = auth.uid()::text
        OR EXISTS (
            SELECT 1 FROM recipes
            WHERE recipes.id::text = (storage.foldername(name))[2]
              AND recipes.author_id = auth.uid()
        )
    )
);

CREATE POLICY "Authors can delete own recipe media"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'recipe-media'
    AND auth.role() = 'authenticated'
    AND (
        owner = auth.uid()
        OR (storage.foldername(name))[2] = auth.uid()::text
        OR EXISTS (
            SELECT 1 FROM recipes
            WHERE recipes.id::text = (storage.foldername(name))[2]
              AND recipes.author_id = auth.uid()
        )
    )
);

-- 3.4 Quarantine Bucket Access (Isolated to uploader and service role)
CREATE POLICY "Users can upload to quarantine isolated folder"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'user-uploads-quarantine'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = 'quarantine'
    AND (storage.foldername(name))[2] = auth.uid()::text
);

CREATE POLICY "Users can view own quarantined uploads"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'user-uploads-quarantine'
    AND auth.role() = 'authenticated'
    AND (
        owner = auth.uid()
        OR (storage.foldername(name))[2] = auth.uid()::text
    )
);

CREATE POLICY "Users can delete own quarantined uploads"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'user-uploads-quarantine'
    AND auth.role() = 'authenticated'
    AND (
        owner = auth.uid()
        OR (storage.foldername(name))[2] = auth.uid()::text
    )
);
