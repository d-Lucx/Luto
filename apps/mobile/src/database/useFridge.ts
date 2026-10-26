import { useEffect, useState } from 'react';
import { Q } from '@nozbe/watermelondb';
import { database } from './index';
import { Ingredient, Recipe, RecipeIngredient, UserPantry } from './models';
import { LOCAL_GUEST_ID } from './pantry';

interface FridgeData {
  ingredients: Ingredient[];
  recipes: Recipe[];
  requirements: RecipeIngredient[];
  pantry: UserPantry[];
}

export function useFridge() {
  const [data, setData] = useState<FridgeData>({ ingredients: [], recipes: [], requirements: [], pantry: [] });
  const [error, setError] = useState<string>();
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    let active = true;
    let revision = 0;
    async function refresh() {
      const current = ++revision;
      try {
        const [ingredients, recipes, requirements, pantry] = await Promise.all([
          database.get<Ingredient>('ingredients').query().fetch(),
          database.get<Recipe>('local_recipes').query().fetch(),
          database.get<RecipeIngredient>('local_ingredients').query().fetch(),
          database.get<UserPantry>('local_pantry').query(Q.where('user_id', LOCAL_GUEST_ID)).fetch(),
        ]);
        if (active && current === revision) { setData({ ingredients, recipes, requirements, pantry }); setError(undefined); }
      } catch (cause) {
        if (active) setError(cause instanceof Error ? cause.message : 'Could not read local inventory');
      } finally {
        if (active) setLoading(false);
      }
    }
    const subscription = database.withChangesForTables(['ingredients', 'local_recipes', 'local_ingredients', 'local_pantry'])
      .subscribe({ next: () => { void refresh(); }, error: (cause: Error) => { if (active) setError(cause.message); } });
    void refresh();
    return () => { active = false; subscription.unsubscribe(); };
  }, []);
  return { ...data, error, loading };
}
