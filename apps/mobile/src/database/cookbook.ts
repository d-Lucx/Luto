import { useEffect, useState } from 'react';
import { Q } from '@nozbe/watermelondb';
import { database } from './index';
import { CookbookEntry } from './models';

export function useCookbook() {
  const [entries, setEntries] = useState<CookbookEntry[]>([]);
  const [error, setError] = useState('');
  useEffect(() => {
    const sub = database.get<CookbookEntry>('cookbook_entries').query().observeWithColumns(['saved', 'manifest']).subscribe({
      next: (rows) => { setEntries([...rows]); setError(''); }, error: () => setError('Could not open saved recipes.'),
    });
    return () => sub.unsubscribe();
  }, []);
  return { entries, error };
}
export async function updateCookbook(recipeId: string, patch: { saved?: boolean; manifest?: string }) {
  await database.write(async () => {
    const collection = database.get<CookbookEntry>('cookbook_entries');
    const rows = await collection.query(Q.where('recipe_id', recipeId)).fetch();
    const assign = (row: CookbookEntry) => {
      row.recipeId = recipeId;
      if (patch.saved !== undefined) row.saved = patch.saved;
      if (patch.manifest !== undefined) row.manifest = patch.manifest;
      row.updatedAt = Date.now();
    };
    if (rows[0]) await rows[0].update(assign);
    else await collection.create((row) => { row.saved = false; row.manifest = ''; assign(row); });
  });
}
