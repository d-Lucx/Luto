import { appSchema, tableSchema } from '@nozbe/watermelondb';

export const schema = appSchema({
  version: 1,
  tables: [
    tableSchema({ name: 'local_recipes', columns: [
      { name: 'title', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'servings', type: 'number' },
      { name: 'hero_image_url', type: 'string' },
      { name: 'local_hero_uri', type: 'string', isOptional: true },
      { name: 'updated_at', type: 'number' },
    ] }),
    tableSchema({ name: 'local_steps', columns: [
      { name: 'recipe_id', type: 'string', isIndexed: true },
      { name: 'step_number', type: 'number' },
      { name: 'instruction', type: 'string' },
      { name: 'timer_duration_seconds', type: 'number' },
      { name: 'media_url', type: 'string', isOptional: true },
      { name: 'local_media_uri', type: 'string', isOptional: true },
    ] }),
    tableSchema({ name: 'local_ingredients', columns: [
      { name: 'recipe_id', type: 'string', isIndexed: true },
      { name: 'ingredient_id', type: 'string', isIndexed: true },
      { name: 'amount', type: 'number' },
      { name: 'unit', type: 'string' },
      { name: 'is_optional', type: 'boolean' },
      { name: 'tier', type: 'number' },
    ] }),
    tableSchema({ name: 'ingredients', columns: [
      { name: 'canonical_name', type: 'string', isIndexed: true },
      { name: 'display_name', type: 'string' },
      { name: 'category', type: 'string' },
      { name: 'default_unit', type: 'string' },
      { name: 'is_staple', type: 'boolean' },
    ] }),
    tableSchema({ name: 'local_pantry', columns: [
      { name: 'user_id', type: 'string', isIndexed: true },
      { name: 'ingredient_id', type: 'string', isIndexed: true },
      { name: 'quantity', type: 'number' },
      { name: 'unit', type: 'string' },
      { name: 'storage_location', type: 'string' },
      { name: 'updated_at', type: 'number' },
    ] }),
    tableSchema({ name: 'local_techniques', columns: [
      { name: 'canonical_slug', type: 'string', isIndexed: true },
      { name: 'title', type: 'string' },
      { name: 'summary', type: 'string' },
      { name: 'micro_video_url', type: 'string', isOptional: true },
      { name: 'local_video_uri', type: 'string', isOptional: true },
    ] }),
    tableSchema({ name: 'equipment', columns: [
      { name: 'canonical_name', type: 'string', isIndexed: true },
      { name: 'display_name', type: 'string' },
      { name: 'category', type: 'string' },
      { name: 'is_essential', type: 'boolean' },
      { name: 'icon_name', type: 'string' },
    ] }),
  ],
});
