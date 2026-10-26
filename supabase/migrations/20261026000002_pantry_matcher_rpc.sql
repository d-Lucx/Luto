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
