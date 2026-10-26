export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string
          display_name: string
          avatar_url: string | null
          bio: string | null
          measurement_preference: 'metric' | 'imperial'
          dietary_preferences: string[]
          skill_level: 'beginner' | 'intermediate' | 'advanced' | 'pro'
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username: string
          display_name: string
          avatar_url?: string | null
          bio?: string | null
          measurement_preference?: 'metric' | 'imperial'
          dietary_preferences?: string[]
          skill_level?: 'beginner' | 'intermediate' | 'advanced' | 'pro'
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          username?: string
          display_name?: string
          avatar_url?: string | null
          bio?: string | null
          measurement_preference?: 'metric' | 'imperial'
          dietary_preferences?: string[]
          skill_level?: 'beginner' | 'intermediate' | 'advanced' | 'pro'
          created_at?: string
          updated_at?: string
        }
      }
      ingredients: {
        Row: {
          id: string
          canonical_name: string
          display_name: string
          category:
            | 'protein'
            | 'produce'
            | 'dairy'
            | 'pantry_dry'
            | 'canned'
            | 'bakery'
            | 'spice_seasoning'
            | 'oil_fat'
            | 'condiment'
            | 'liquid'
          is_staple: boolean
          default_unit: string
          average_shelf_life_days: number | null
          allergen_tags: string[]
          density_g_per_ml: number | null
          created_at: string
        }
        Insert: {
          id?: string
          canonical_name: string
          display_name: string
          category:
            | 'protein'
            | 'produce'
            | 'dairy'
            | 'pantry_dry'
            | 'canned'
            | 'bakery'
            | 'spice_seasoning'
            | 'oil_fat'
            | 'condiment'
            | 'liquid'
          is_staple?: boolean
          default_unit: string
          average_shelf_life_days?: number | null
          allergen_tags?: string[]
          density_g_per_ml?: number | null
          created_at?: string
        }
        Update: {
          id?: string
          canonical_name?: string
          display_name?: string
          category?:
            | 'protein'
            | 'produce'
            | 'dairy'
            | 'pantry_dry'
            | 'canned'
            | 'bakery'
            | 'spice_seasoning'
            | 'oil_fat'
            | 'condiment'
            | 'liquid'
          is_staple?: boolean
          default_unit?: string
          average_shelf_life_days?: number | null
          allergen_tags?: string[]
          density_g_per_ml?: number | null
          created_at?: string
        }
      }
      equipment: {
        Row: {
          id: string
          canonical_name: string
          display_name: string
          category:
            | 'cookware'
            | 'bakeware'
            | 'knives_cutlery'
            | 'prep_tools'
            | 'appliances'
            | 'measuring'
            | 'utensils'
          is_essential: boolean
          icon_name: string
          description: string | null
          created_at: string
        }
        Insert: {
          id?: string
          canonical_name: string
          display_name: string
          category:
            | 'cookware'
            | 'bakeware'
            | 'knives_cutlery'
            | 'prep_tools'
            | 'appliances'
            | 'measuring'
            | 'utensils'
          is_essential?: boolean
          icon_name: string
          description?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          canonical_name?: string
          display_name?: string
          category?:
            | 'cookware'
            | 'bakeware'
            | 'knives_cutlery'
            | 'prep_tools'
            | 'appliances'
            | 'measuring'
            | 'utensils'
          is_essential?: boolean
          icon_name?: string
          description?: string | null
          created_at?: string
        }
      }
      techniques_and_skills: {
        Row: {
          id: string
          canonical_slug: string
          title: string
          category:
            | 'knife_skills'
            | 'dry_heat'
            | 'moist_heat'
            | 'combination'
            | 'sauces_emulsions'
            | 'baking_pastry'
            | 'prep_finishing'
          difficulty_level: 'beginner' | 'intermediate' | 'advanced'
          summary: string
          micro_video_url: string | null
          gif_preview_url: string | null
          key_tips: string[]
          common_mistakes: string[]
          created_at: string
        }
        Insert: {
          id?: string
          canonical_slug: string
          title: string
          category:
            | 'knife_skills'
            | 'dry_heat'
            | 'moist_heat'
            | 'combination'
            | 'sauces_emulsions'
            | 'baking_pastry'
            | 'prep_finishing'
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced'
          summary: string
          micro_video_url?: string | null
          gif_preview_url?: string | null
          key_tips?: string[]
          common_mistakes?: string[]
          created_at?: string
        }
        Update: {
          id?: string
          canonical_slug?: string
          title?: string
          category?:
            | 'knife_skills'
            | 'dry_heat'
            | 'moist_heat'
            | 'combination'
            | 'sauces_emulsions'
            | 'baking_pastry'
            | 'prep_finishing'
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced'
          summary?: string
          micro_video_url?: string | null
          gif_preview_url?: string | null
          key_tips?: string[]
          common_mistakes?: string[]
          created_at?: string
        }
      }
      recipes: {
        Row: {
          id: string
          author_id: string
          title: string
          slug: string
          description: string
          cuisine_tags: string[]
          category: string
          difficulty: 'easy' | 'medium' | 'hard' | 'expert'
          prep_time_minutes: number
          cook_time_minutes: number
          total_time_minutes: number
          servings: number
          calories_per_serving: number | null
          nutritional_facts: Json
          hero_image_url: string
          status: 'draft' | 'pending_review' | 'published' | 'archived'
          average_rating: number
          ratings_count: number
          version: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          author_id: string
          title: string
          slug: string
          description: string
          cuisine_tags?: string[]
          category: string
          difficulty: 'easy' | 'medium' | 'hard' | 'expert'
          prep_time_minutes: number
          cook_time_minutes: number
          servings?: number
          calories_per_serving?: number | null
          nutritional_facts?: Json
          hero_image_url: string
          status?: 'draft' | 'pending_review' | 'published' | 'archived'
          average_rating?: number
          ratings_count?: number
          version?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          author_id?: string
          title?: string
          slug?: string
          description?: string
          cuisine_tags?: string[]
          category?: string
          difficulty?: 'easy' | 'medium' | 'hard' | 'expert'
          prep_time_minutes?: number
          cook_time_minutes?: number
          servings?: number
          calories_per_serving?: number | null
          nutritional_facts?: Json
          hero_image_url?: string
          status?: 'draft' | 'pending_review' | 'published' | 'archived'
          average_rating?: number
          ratings_count?: number
          version?: number
          created_at?: string
          updated_at?: string
        }
      }
      recipe_steps: {
        Row: {
          id: string
          recipe_id: string
          step_number: number
          title: string | null
          instruction: string
          media_url: string | null
          media_type: 'image' | 'video' | 'gif' | null
          timer_duration_seconds: number
          timer_label: string | null
          is_critical: boolean
          created_at: string
        }
        Insert: {
          id?: string
          recipe_id: string
          step_number: number
          title?: string | null
          instruction: string
          media_url?: string | null
          media_type?: 'image' | 'video' | 'gif' | null
          timer_duration_seconds?: number
          timer_label?: string | null
          is_critical?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          recipe_id?: string
          step_number?: number
          title?: string | null
          instruction?: string
          media_url?: string | null
          media_type?: 'image' | 'video' | 'gif' | null
          timer_duration_seconds?: number
          timer_label?: string | null
          is_critical?: boolean
          created_at?: string
        }
      }
      recipe_ingredients: {
        Row: {
          id: string
          recipe_id: string
          ingredient_id: string
          amount: number
          unit: string
          display_text: string
          is_optional: boolean
          sort_order: number
          created_at: string
        }
        Insert: {
          id?: string
          recipe_id: string
          ingredient_id: string
          amount: number
          unit: string
          display_text: string
          is_optional?: boolean
          sort_order?: number
          created_at?: string
        }
        Update: {
          id?: string
          recipe_id?: string
          ingredient_id?: string
          amount?: number
          unit?: string
          display_text?: string
          is_optional?: boolean
          sort_order?: number
          created_at?: string
        }
      }
      equipment_requirements: {
        Row: {
          recipe_id: string
          equipment_id: string
          is_required: boolean
          notes: string | null
        }
        Insert: {
          recipe_id: string
          equipment_id: string
          is_required?: boolean
          notes?: string | null
        }
        Update: {
          recipe_id?: string
          equipment_id?: string
          is_required?: boolean
          notes?: string | null
        }
      }
      user_pantry: {
        Row: {
          id: string
          user_id: string
          ingredient_id: string
          quantity: number | null
          unit: string | null
          storage_location: 'fridge' | 'freezer' | 'pantry' | 'spice_rack'
          expiration_date: string | null
          is_staple: boolean
          added_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          ingredient_id: string
          quantity?: number | null
          unit?: string | null
          storage_location?: 'fridge' | 'freezer' | 'pantry' | 'spice_rack'
          expiration_date?: string | null
          is_staple?: boolean
          added_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          ingredient_id?: string
          quantity?: number | null
          unit?: string | null
          storage_location?: 'fridge' | 'freezer' | 'pantry' | 'spice_rack'
          expiration_date?: string | null
          is_staple?: boolean
          added_at?: string
          updated_at?: string
        }
      }
      saved_recipes: {
        Row: {
          id: string
          user_id: string
          recipe_id: string
          is_favorite: boolean
          is_downloaded_offline: boolean
          downloaded_at: string | null
          local_sync_version: number
          personal_notes: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          recipe_id: string
          is_favorite?: boolean
          is_downloaded_offline?: boolean
          downloaded_at?: string | null
          local_sync_version?: number
          personal_notes?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          recipe_id?: string
          is_favorite?: boolean
          is_downloaded_offline?: boolean
          downloaded_at?: string | null
          local_sync_version?: number
          personal_notes?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      ratings_and_reviews: {
        Row: {
          id: string
          recipe_id: string
          user_id: string
          rating: number
          difficulty_score: number | null
          review_text: string | null
          photos: string[]
          pro_tips: string | null
          helpful_votes: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          recipe_id: string
          user_id: string
          rating: number
          difficulty_score?: number | null
          review_text?: string | null
          photos?: string[]
          pro_tips?: string | null
          helpful_votes?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          recipe_id?: string
          user_id?: string
          rating?: number
          difficulty_score?: number | null
          review_text?: string | null
          photos?: string[]
          pro_tips?: string | null
          helpful_votes?: number
          created_at?: string
          updated_at?: string
        }
      }
      ingredient_substitutions: {
        Row: {
          id: string
          original_ingredient_id: string
          substitute_ingredient_id: string
          conversion_ratio: number
          category: string
          applicable_contexts: string[]
          forbidden_contexts: string[]
          flavor_impact: string
          texture_impact: string
          preparation_note: string | null
          created_at: string
        }
        Insert: {
          id?: string
          original_ingredient_id: string
          substitute_ingredient_id: string
          conversion_ratio: number
          category: string
          applicable_contexts?: string[]
          forbidden_contexts?: string[]
          flavor_impact: string
          texture_impact: string
          preparation_note?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          original_ingredient_id?: string
          substitute_ingredient_id?: string
          conversion_ratio?: number
          category?: string
          applicable_contexts?: string[]
          forbidden_contexts?: string[]
          flavor_impact?: string
          texture_impact?: string
          preparation_note?: string | null
          created_at?: string
        }
      }
    }
    Functions: {
      rpc_match_pantry: {
        Args: {
          p_user_ingredient_ids: string[]
          p_min_score?: number
        }
        Returns: {
          recipe_id: string
          title: string
          slug: string
          hero_image_url: string
          difficulty: string
          total_time_minutes: number
          average_rating: number
          match_score: number
          missing_count: number
          missing_critical_count: number
          can_cook_now: boolean
        }[]
      }
    }
  }
}
