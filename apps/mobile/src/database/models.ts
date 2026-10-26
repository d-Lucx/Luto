import { Model, type Query, type Relation } from '@nozbe/watermelondb';
import { children, field, relation, text } from '@nozbe/watermelondb/decorators';

export class Recipe extends Model {
  static table = 'local_recipes';
  static associations = {
    local_steps: { type: 'has_many' as const, foreignKey: 'recipe_id' },
    local_ingredients: { type: 'has_many' as const, foreignKey: 'recipe_id' },
  };
  @text('title') title!: string;
  @text('description') description!: string;
  @field('servings') servings!: number;
  @text('hero_image_url') heroImageUrl!: string;
  @field('local_hero_uri') localHeroUri!: string | null;
  @field('updated_at') updatedAt!: number;
  @children('local_steps') steps!: Query<RecipeStep>;
  @children('local_ingredients') ingredients!: Query<RecipeIngredient>;
}

export class RecipeStep extends Model {
  static table = 'local_steps';
  static associations = { local_recipes: { type: 'belongs_to' as const, key: 'recipe_id' } };
  @field('recipe_id') recipeId!: string;
  @relation('local_recipes', 'recipe_id') recipe!: Relation<Recipe>;
  @field('step_number') stepNumber!: number;
  @text('instruction') instruction!: string;
  @field('timer_duration_seconds') timerDurationSeconds!: number;
  @field('media_url') mediaUrl!: string | null;
  @field('local_media_uri') localMediaUri!: string | null;
}

export class Ingredient extends Model {
  static table = 'ingredients';
  @text('canonical_name') canonicalName!: string;
  @text('display_name') displayName!: string;
  @text('category') category!: string;
  @text('default_unit') defaultUnit!: string;
  @field('is_staple') isStaple!: boolean;
}

export class RecipeIngredient extends Model {
  static table = 'local_ingredients';
  static associations = {
    local_recipes: { type: 'belongs_to' as const, key: 'recipe_id' },
    ingredients: { type: 'belongs_to' as const, key: 'ingredient_id' },
  };
  @field('recipe_id') recipeId!: string;
  @relation('local_recipes', 'recipe_id') recipe!: Relation<Recipe>;
  @field('ingredient_id') ingredientId!: string;
  @relation('ingredients', 'ingredient_id') ingredient!: Relation<Ingredient>;
  @field('amount') amount!: number;
  @text('unit') unit!: string;
  @field('is_optional') isOptional!: boolean;
  @field('tier') tier!: 0 | 1 | 2 | 3;
}

export type StorageLocation = 'fridge' | 'freezer' | 'pantry' | 'spice_rack';

export class UserPantry extends Model {
  static table = 'local_pantry';
  static associations = { ingredients: { type: 'belongs_to' as const, key: 'ingredient_id' } };
  @field('user_id') userId!: string;
  @field('ingredient_id') ingredientId!: string;
  @relation('ingredients', 'ingredient_id') ingredient!: Relation<Ingredient>;
  @field('quantity') quantity!: number;
  @text('unit') unit!: string;
  @text('storage_location') storageLocation!: StorageLocation;
  @field('updated_at') updatedAt!: number;
}

export class Technique extends Model {
  static table = 'local_techniques';
  @text('canonical_slug') canonicalSlug!: string;
  @text('title') title!: string;
  @text('summary') summary!: string;
  @field('micro_video_url') microVideoUrl!: string | null;
  @field('local_video_uri') localVideoUri!: string | null;
}

export class Equipment extends Model {
  static table = 'equipment';
  @text('canonical_name') canonicalName!: string;
  @text('display_name') displayName!: string;
  @text('category') category!: string;
  @field('is_essential') isEssential!: boolean;
  @text('icon_name') iconName!: string;
}

export const modelClasses = [Recipe, RecipeStep, RecipeIngredient, Ingredient, UserPantry, Technique, Equipment];
