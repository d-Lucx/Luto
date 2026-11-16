// Shared declarations keep fresh installs and v1 upgrades identical.
export const localStateTables = [
  { name: 'local_documents', columns: [
    { name: 'key', type: 'string' as const, isIndexed: true },
    { name: 'payload', type: 'string' as const },
  ] },
  { name: 'cooking_sessions', columns: [
    { name: 'recipe_id', type: 'string' as const, isIndexed: true },
    { name: 'status', type: 'string' as const, isIndexed: true },
    { name: 'payload', type: 'string' as const },
    { name: 'updated_at', type: 'number' as const },
  ] },
  { name: 'cookbook_entries', columns: [
    { name: 'recipe_id', type: 'string' as const, isIndexed: true },
    { name: 'saved', type: 'boolean' as const },
    { name: 'manifest', type: 'string' as const },
    { name: 'updated_at', type: 'number' as const },
  ] },
];
