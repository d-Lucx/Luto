/**
 * ==============================================================================
 * LUTO (Logo: Lu2) — Universal Mobile Cooking Platform
 * File: src/types/database.types.ts
 *
 * Strongly typed TypeScript definitions representing the PostgreSQL 16
 * Supabase database schema, RPC functions, and domain entity models.
 * ==============================================================================
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export type MeasurementPreference = 'metric' | 'imperial';
export type SkillLevel = 'beginner' | 'intermediate' | 'advanced' | 'pro';
export type IngredientCategory =
  | 'protein'
  | 'produce'
  | 'dairy'
  | 'pantry_dry'
  | 'canned'
  | 'bakery'
  | 'spice_seasoning'
  | 'oil_fat'
  | 'condiment'
  | 'liquid';

export type EquipmentCategory =
  | 'cookware'
  | 'bakeware'
  | 'knives_cutlery'
  | 'prep_tools'
  | 'appliances'
  | 'measuring'
  | 'utensils';

export type TechniqueCategory =
  | 'knife_skills'
  | 'dry_heat'
  | 'moist_heat'
  | 'combination'
  | 'sauces_emulsions'
  | 'baking_pastry'
  | 'prep_finishing';

export type RecipeDifficulty = 'easy' | 'medium' | 'hard' | 'expert';
export type RecipeStatus = 'draft' | 'pending_review' | 'published' | 'archived';
export type MediaType = 'image' | 'video' | 'gif';
export type StorageLocation = 'fridge' | 'freezer' | 'pantry' | 'spice_rack';

export interface NutritionalFacts {
  protein_g?: number;
  carbs_g?: number;
  fat_g?: number;
  fiber_g?: number;
  sodium_mg?: number;
  [key: string]: number | undefined;
}

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          username: string;
          display_name: string;
          avatar_url: string | null;
          bio: string | null;
          measurement_preference: MeasurementPreference;
          dietary_preferences: string[];
          skill_level: SkillLevel;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          username: string;
          display_name: string;
          avatar_url?: string | null;
          bio?: string | null;
          measurement_preference?: MeasurementPreference;
          dietary_preferences?: string[];
          skill_level?: SkillLevel;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          username?: string;
          display_name?: string;
          avatar_url?: string | null;
          bio?: string | null;
          measurement_preference?: MeasurementPreference;
          dietary_preferences?: string[];
          skill_level?: SkillLevel;
          created_at?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'profiles_id_fkey';
            columns: ['id'];
            referencedRelation: 'users';
            referencedColumns: ['id'];
          }
        ];
      };

      ingredients: {
        Row: {
          id: string;
          canonical_name: string;
          display_name: string;
          category: IngredientCategory;
          is_staple: boolean;
          default_unit: string;
          average_shelf_life_days: number | null;
          allergen_tags: string[];
          density_g_per_ml: number | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          canonical_name: string;
          display_name: string;
          category: IngredientCategory;
          is_staple?: boolean;
          default_unit: string;
          average_shelf_life_days?: number | null;
          allergen_tags?: string[];
          density_g_per_ml?: number | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          canonical_name?: string;
          display_name?: string;
          category?: IngredientCategory;
          is_staple?: boolean;
          default_unit?: string;
          average_shelf_life_days?: number | null;
          allergen_tags?: string[];
          density_g_per_ml?: number | null;
          created_at?: string;
        };
        Relationships: [];
      };

      equipment: {
        Row: {
          id: string;
          canonical_name: string;
          display_name: string;
          category: EquipmentCategory;
          is_essential: boolean;
          icon_name: string;
          description: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          canonical_name: string;
          display_name: string;
          category: EquipmentCategory;
          is_essential?: boolean;
          icon_name: string;
          description?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          canonical_name?: string;
          display_name?: string;
          category?: EquipmentCategory;
          is_essential?: boolean;
          icon_name?: string;
          description?: string | null;
          created_at?: string;
        };
        Relationships: [];
      };

      techniques_and_skills: {
        Row: {
          id: string;
          canonical_slug: string;
          title: string;
          category: TechniqueCategory;
          difficulty_level: 'beginner' | 'intermediate' | 'advanced';
          summary: string;
          micro_video_url: string | null;
          gif_preview_url: string | null;
          key_tips: string[];
          common_mistakes: string[];
          created_at: string;
        };
        Insert: {
          id?: string;
          canonical_slug: string;
          title: string;
          category: TechniqueCategory;
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced';
          summary: string;
          micro_video_url?: string | null;
          gif_preview_url?: string | null;
          key_tips?: string[];
          common_mistakes?: string[];
          created_at?: string;
        };
        Update: {
          id?: string;
          canonical_slug?: string;
          title?: string;
          category?: TechniqueCategory;
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced';
          summary?: string;
          micro_video_url?: string | null;
          gif_preview_url?: string | null;
          key_tips?: string[];
          common_mistakes?: string[];
          created_at?: string;
        };
        Relationships: [];
      };

      recipes: {
        Row: {
          id: string;
          author_id: string;
          title: string;
          slug: string;
          description: string;
          cuisine_tags: string[];
          category: string;
          difficulty: RecipeDifficulty;
          prep_time_minutes: number;
          cook_time_minutes: number;
          total_time_minutes: number;
          servings: number;
          calories_per_serving: number | null;
          nutritional_facts: Json;
          hero_image_url: string;
          status: RecipeStatus;
          average_rating: number;
          ratings_count: number;
          version: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          author_id: string;
          title: string;
          slug: string;
          description: string;
          cuisine_tags?: string[];
          category: string;
          difficulty: RecipeDifficulty;
          prep_time_minutes: number;
          cook_time_minutes: number;
          servings?: number;
          calories_per_serving?: number | null;
          nutritional_facts?: Json;
          hero_image_url: string;
          status?: RecipeStatus;
          average_rating?: number;
          ratings_count?: number;
          version?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          author_id?: string;
          title?: string;
          slug?: string;
          description?: string;
          cuisine_tags?: string[];
          category?: string;
          difficulty?: RecipeDifficulty;
          prep_time_minutes?: number;
          cook_time_minutes?: number;
          servings?: number;
          calories_per_serving?: number | null;
          nutritional_facts?: Json;
          hero_image_url?: string;
          status?: RecipeStatus;
          average_rating?: number;
          ratings_count?: number;
          version?: number;
          created_at?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'recipes_author_id_fkey';
            columns: ['author_id'];
            referencedRelation: 'profiles';
            referencedColumns: ['id'];
          }
        ];
      };

      recipe_steps: {
        Row: {
          id: string;
          recipe_id: string;
          step_number: number;
          title: string | null;
          instruction: string;
          media_url: string | null;
          media_type: MediaType | null;
          timer_duration_seconds: number;
          timer_label: string | null;
          is_critical: boolean;
          created_at: string;
        };
        Insert: {
          id?: string;
          recipe_id: string;
          step_number: number;
          title?: string | null;
          instruction: string;
          media_url?: string | null;
          media_type?: MediaType | null;
          timer_duration_seconds?: number;
          timer_label?: string | null;
          is_critical?: boolean;
          created_at?: string;
        };
        Update: {
          id?: string;
          recipe_id?: string;
          step_number?: number;
          title?: string | null;
          instruction?: string;
          media_url?: string | null;
          media_type?: MediaType | null;
          timer_duration_seconds?: number;
          timer_label?: string | null;
          is_critical?: boolean;
          created_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'recipe_steps_recipe_id_fkey';
            columns: ['recipe_id'];
            referencedRelation: 'recipes';
            referencedColumns: ['id'];
          }
        ];
      };

      recipe_step_techniques: {
        Row: {
          recipe_step_id: string;
          technique_id: string;
        };
        Insert: {
          recipe_step_id: string;
          technique_id: string;
        };
        Update: {
          recipe_step_id?: string;
          technique_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'recipe_step_techniques_recipe_step_id_fkey';
            columns: ['recipe_step_id'];
            referencedRelation: 'recipe_steps';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'recipe_step_techniques_technique_id_fkey';
            columns: ['technique_id'];
            referencedRelation: 'techniques_and_skills';
            referencedColumns: ['id'];
          }
        ];
      };

      recipe_ingredients: {
        Row: {
          id: string;
          recipe_id: string;
          ingredient_id: string;
          amount: number;
          unit: string;
          display_text: string;
          is_optional: boolean;
          tier: number | null;
          sort_order: number;
          created_at: string;
        };
        Insert: {
          id?: string;
          recipe_id: string;
          ingredient_id: string;
          amount: number;
          unit: string;
          display_text: string;
          is_optional?: boolean;
          tier?: number | null;
          sort_order?: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          recipe_id?: string;
          ingredient_id?: string;
          amount?: number;
          unit?: string;
          display_text?: string;
          is_optional?: boolean;
          tier?: number | null;
          sort_order?: number;
          created_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'recipe_ingredients_recipe_id_fkey';
            columns: ['recipe_id'];
            referencedRelation: 'recipes';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'recipe_ingredients_ingredient_id_fkey';
            columns: ['ingredient_id'];
            referencedRelation: 'ingredients';
            referencedColumns: ['id'];
          }
        ];
      };

      equipment_requirements: {
        Row: {
          recipe_id: string;
          equipment_id: string;
          is_required: boolean;
          notes: string | null;
        };
        Insert: {
          recipe_id: string;
          equipment_id: string;
          is_required?: boolean;
          notes?: string | null;
        };
        Update: {
          recipe_id?: string;
          equipment_id?: string;
          is_required?: boolean;
          notes?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'equipment_requirements_recipe_id_fkey';
            columns: ['recipe_id'];
            referencedRelation: 'recipes';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'equipment_requirements_equipment_id_fkey';
            columns: ['equipment_id'];
            referencedRelation: 'equipment';
            referencedColumns: ['id'];
          }
        ];
      };

      user_pantry: {
        Row: {
          id: string;
          user_id: string;
          ingredient_id: string;
          quantity: number | null;
          unit: string | null;
          storage_location: StorageLocation;
          expiration_date: string | null;
          is_staple: boolean;
          added_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          ingredient_id: string;
          quantity?: number | null;
          unit?: string | null;
          storage_location?: StorageLocation;
          expiration_date?: string | null;
          is_staple?: boolean;
          added_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          ingredient_id?: string;
          quantity?: number | null;
          unit?: string | null;
          storage_location?: StorageLocation;
          expiration_date?: string | null;
          is_staple?: boolean;
          added_at?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'user_pantry_user_id_fkey';
            columns: ['user_id'];
            referencedRelation: 'profiles';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'user_pantry_ingredient_id_fkey';
            columns: ['ingredient_id'];
            referencedRelation: 'ingredients';
            referencedColumns: ['id'];
          }
        ];
      };

      saved_recipes: {
        Row: {
          id: string;
          user_id: string;
          recipe_id: string;
          is_favorite: boolean;
          is_downloaded_offline: boolean;
          downloaded_at: string | null;
          local_sync_version: number;
          personal_notes: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          recipe_id: string;
          is_favorite?: boolean;
          is_downloaded_offline?: boolean;
          downloaded_at?: string | null;
          local_sync_version?: number;
          personal_notes?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          recipe_id?: string;
          is_favorite?: boolean;
          is_downloaded_offline?: boolean;
          downloaded_at?: string | null;
          local_sync_version?: number;
          personal_notes?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'saved_recipes_user_id_fkey';
            columns: ['user_id'];
            referencedRelation: 'profiles';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'saved_recipes_recipe_id_fkey';
            columns: ['recipe_id'];
            referencedRelation: 'recipes';
            referencedColumns: ['id'];
          }
        ];
      };

      ratings_and_reviews: {
        Row: {
          id: string;
          recipe_id: string;
          user_id: string;
          rating: number;
          difficulty_score: number | null;
          review_text: string | null;
          photos: string[];
          pro_tips: string | null;
          helpful_votes: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          recipe_id: string;
          user_id: string;
          rating: number;
          difficulty_score?: number | null;
          review_text?: string | null;
          photos?: string[];
          pro_tips?: string | null;
          helpful_votes?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          recipe_id?: string;
          user_id?: string;
          rating?: number;
          difficulty_score?: number | null;
          review_text?: string | null;
          photos?: string[];
          pro_tips?: string | null;
          helpful_votes?: number;
          created_at?: string;
          updated_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'ratings_and_reviews_recipe_id_fkey';
            columns: ['recipe_id'];
            referencedRelation: 'recipes';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'ratings_and_reviews_user_id_fkey';
            columns: ['user_id'];
            referencedRelation: 'profiles';
            referencedColumns: ['id'];
          }
        ];
      };

      ingredient_substitutions: {
        Row: {
          id: string;
          original_ingredient_id: string;
          substitute_ingredient_id: string;
          conversion_ratio: number;
          category: string;
          applicable_contexts: string[];
          forbidden_contexts: string[];
          flavor_impact: string;
          texture_impact: string;
          preparation_note: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          original_ingredient_id: string;
          substitute_ingredient_id: string;
          conversion_ratio: number;
          category: string;
          applicable_contexts?: string[];
          forbidden_contexts?: string[];
          flavor_impact: string;
          texture_impact: string;
          preparation_note?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          original_ingredient_id?: string;
          substitute_ingredient_id?: string;
          conversion_ratio?: number;
          category?: string;
          applicable_contexts?: string[];
          forbidden_contexts?: string[];
          flavor_impact?: string;
          texture_impact?: string;
          preparation_note?: string | null;
          created_at?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'ingredient_substitutions_original_ingredient_id_fkey';
            columns: ['original_ingredient_id'];
            referencedRelation: 'ingredients';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'ingredient_substitutions_substitute_ingredient_id_fkey';
            columns: ['substitute_ingredient_id'];
            referencedRelation: 'ingredients';
            referencedColumns: ['id'];
          }
        ];
      };
    };

    Views: {
      [_ in never]: never;
    };

    Functions: {
      rpc_match_pantry: {
        Args: {
          p_user_ingredient_ids: string[];
          p_min_score?: number;
        };
        Returns: {
          recipe_id: string;
          title: string;
          slug: string;
          hero_image_url: string;
          difficulty: RecipeDifficulty;
          total_time_minutes: number;
          average_rating: number;
          match_score: number;
          missing_count: number;
          missing_critical_count: number;
          can_cook_now: boolean;
        }[];
      };
    };

    Enums: {
      measurement_preference: MeasurementPreference;
      skill_level: SkillLevel;
      ingredient_category: IngredientCategory;
      equipment_category: EquipmentCategory;
      technique_category: TechniqueCategory;
      recipe_difficulty: RecipeDifficulty;
      recipe_status: RecipeStatus;
      storage_location: StorageLocation;
    };
  };
}

// Convenient Entity Type Aliases
export type Profile = Database['public']['Tables']['profiles']['Row'];
export type ProfileInsert = Database['public']['Tables']['profiles']['Insert'];
export type ProfileUpdate = Database['public']['Tables']['profiles']['Update'];

export type Ingredient = Database['public']['Tables']['ingredients']['Row'];
export type IngredientInsert = Database['public']['Tables']['ingredients']['Insert'];
export type IngredientUpdate = Database['public']['Tables']['ingredients']['Update'];

export type Equipment = Database['public']['Tables']['equipment']['Row'];
export type EquipmentInsert = Database['public']['Tables']['equipment']['Insert'];
export type EquipmentUpdate = Database['public']['Tables']['equipment']['Update'];

export type Technique = Database['public']['Tables']['techniques_and_skills']['Row'];
export type TechniqueInsert = Database['public']['Tables']['techniques_and_skills']['Insert'];
export type TechniqueUpdate = Database['public']['Tables']['techniques_and_skills']['Update'];

export type Recipe = Database['public']['Tables']['recipes']['Row'];
export type RecipeInsert = Database['public']['Tables']['recipes']['Insert'];
export type RecipeUpdate = Database['public']['Tables']['recipes']['Update'];

export type RecipeStep = Database['public']['Tables']['recipe_steps']['Row'];
export type RecipeStepInsert = Database['public']['Tables']['recipe_steps']['Insert'];
export type RecipeStepUpdate = Database['public']['Tables']['recipe_steps']['Update'];

export type RecipeStepTechnique = Database['public']['Tables']['recipe_step_techniques']['Row'];
export type RecipeIngredient = Database['public']['Tables']['recipe_ingredients']['Row'];
export type EquipmentRequirement = Database['public']['Tables']['equipment_requirements']['Row'];

export type UserPantryItem = Database['public']['Tables']['user_pantry']['Row'];
export type UserPantryInsert = Database['public']['Tables']['user_pantry']['Insert'];
export type UserPantryUpdate = Database['public']['Tables']['user_pantry']['Update'];

export type SavedRecipe = Database['public']['Tables']['saved_recipes']['Row'];
export type RatingAndReview = Database['public']['Tables']['ratings_and_reviews']['Row'];
export type IngredientSubstitution = Database['public']['Tables']['ingredient_substitutions']['Row'];

export type PantryMatchRecord = Database['public']['Functions']['rpc_match_pantry']['Returns'][number];
