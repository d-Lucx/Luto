export function canEditRecipe(id: string, source?: string): boolean {
  return !id.startsWith('demo-') && source !== 'community';
}
