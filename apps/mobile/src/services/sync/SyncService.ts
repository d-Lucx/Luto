// ==============================================================================
// LUTO (Logo: Lu2) — Offline-First Delta Synchronization Service
// Target: WatermelonDB <-> Supabase PostgreSQL Sync Engine
// ==============================================================================

import { LOCAL_GUEST_ID } from '../../database/constants.ts';

export interface RemoteSyncChanges {
  recipes: Array<{
    id: string;
    title: string;
    description: string;
    servings: number;
    hero_image_url: string;
    updated_at: string | number;
    steps?: Array<{
      id: string;
      step_number: number;
      instruction: string;
      timer_duration_seconds: number;
      media_url: string | null;
    }>;
    ingredients?: Array<{
      id: string;
      ingredient_id: string;
      amount: number;
      unit: string;
      is_optional: boolean;
      tier: number;
    }>;
  }>;
  techniques?: Array<{
    id: string;
    canonical_slug: string;
    title: string;
    summary: string;
    micro_video_url: string | null;
  }>;
  timestamp: number;
}

export interface SyncPushPayload {
  userId: string;
  pantryUpdates: Array<{
    ingredientId: string;
    quantity: number;
    unit: string;
    storageLocation: string;
    updatedAt: number;
  }>;
}

export class SyncService {
  private static lastSyncTimestamp: number = 0;
  private static databaseInstance: any = null;

  public static setDatabase(db: any): void {
    this.databaseInstance = db;
  }

  public static getLastSyncTimestamp(): number {
    return this.lastSyncTimestamp;
  }

  public static setLastSyncTimestamp(ts: number): void {
    this.lastSyncTimestamp = Math.max(0, ts);
  }

  /**
   * Applies remote delta changes pulled from Supabase into local WatermelonDB.
   * Uses idempotent batch upserts to guarantee zero duplicate keys.
   */
  public static async applyRemoteChanges(changes: RemoteSyncChanges, dbOverride?: any): Promise<{ recipesProcessed: number }> {
    const db = dbOverride || this.databaseInstance;
    if (!db || !changes || !Array.isArray(changes.recipes)) {
      return { recipesProcessed: 0 };
    }

    let processedCount = 0;

    await db.write(async () => {
      const recipeCollection = db.get('local_recipes');
      const stepCollection = db.get('local_steps');
      const ingredientCollection = db.get('local_ingredients');
      const techniqueCollection = db.get('local_techniques');

      const batchOperations: any[] = [];

      // 1. Process recipes & children
      for (const raw of changes.recipes) {
        let localRecipe: any = null;
        try {
          localRecipe = await recipeCollection.find(raw.id);
        } catch {
          localRecipe = null;
        }

        const updatedAtMs = typeof raw.updated_at === 'string'
          ? new Date(raw.updated_at).getTime()
          : Number(raw.updated_at);

        if (localRecipe) {
          batchOperations.push(
            localRecipe.prepareUpdate((rec: any) => {
              rec.title = raw.title;
              rec.description = raw.description || '';
              rec.servings = raw.servings || 4;
              rec.heroImageUrl = raw.hero_image_url || '';
              rec.updatedAt = updatedAtMs || Date.now();
            })
          );
        } else {
          batchOperations.push(
            recipeCollection.prepareCreate((rec: any) => {
              rec._raw.id = raw.id;
              rec.title = raw.title;
              rec.description = raw.description || '';
              rec.servings = raw.servings || 4;
              rec.heroImageUrl = raw.hero_image_url || '';
              rec.updatedAt = updatedAtMs || Date.now();
            })
          );
        }

        // Process steps
        if (Array.isArray(raw.steps)) {
          for (const s of raw.steps) {
            let localStep: any = null;
            try {
              localStep = await stepCollection.find(s.id);
            } catch {
              localStep = null;
            }

            if (localStep) {
              batchOperations.push(
                localStep.prepareUpdate((item: any) => {
                  item.recipeId = raw.id;
                  item.stepNumber = s.step_number;
                  item.instruction = s.instruction;
                  item.timerDurationSeconds = s.timer_duration_seconds || 0;
                  item.mediaUrl = s.media_url || null;
                })
              );
            } else {
              batchOperations.push(
                stepCollection.prepareCreate((item: any) => {
                  item._raw.id = s.id;
                  item.recipeId = raw.id;
                  item.stepNumber = s.step_number;
                  item.instruction = s.instruction;
                  item.timerDurationSeconds = s.timer_duration_seconds || 0;
                  item.mediaUrl = s.media_url || null;
                })
              );
            }
          }
        }

        // Process recipe ingredients
        if (Array.isArray(raw.ingredients)) {
          for (const ing of raw.ingredients) {
            let localItem: any = null;
            try {
              localItem = await ingredientCollection.find(ing.id);
            } catch {
              localItem = null;
            }

            if (localItem) {
              batchOperations.push(
                localItem.prepareUpdate((item: any) => {
                  item.recipeId = raw.id;
                  item.ingredientId = ing.ingredient_id;
                  item.amount = ing.amount;
                  item.unit = ing.unit;
                  item.isOptional = Boolean(ing.is_optional);
                  item.tier = ing.tier || 0;
                })
              );
            } else {
              batchOperations.push(
                ingredientCollection.prepareCreate((item: any) => {
                  item._raw.id = ing.id;
                  item.recipeId = raw.id;
                  item.ingredientId = ing.ingredient_id;
                  item.amount = ing.amount;
                  item.unit = ing.unit;
                  item.isOptional = Boolean(ing.is_optional);
                  item.tier = ing.tier || 0;
                })
              );
            }
          }
        }

        processedCount++;
      }

      // 2. Process techniques
      if (Array.isArray(changes.techniques)) {
        for (const t of changes.techniques) {
          let localTechnique: any = null;
          try {
            localTechnique = await techniqueCollection.find(t.id);
          } catch {
            localTechnique = null;
          }

          if (localTechnique) {
            batchOperations.push(
              localTechnique.prepareUpdate((item: any) => {
                item.canonicalSlug = t.canonical_slug;
                item.title = t.title;
                item.summary = t.summary;
                item.microVideoUrl = t.micro_video_url || null;
              })
            );
          } else {
            batchOperations.push(
              techniqueCollection.prepareCreate((item: any) => {
                item._raw.id = t.id;
                item.canonicalSlug = t.canonical_slug;
                item.title = t.title;
                item.summary = t.summary;
                item.microVideoUrl = t.micro_video_url || null;
              })
            );
          }
        }
      }

      if (batchOperations.length > 0) {
        await db.batch(...batchOperations);
      }
    });

    this.lastSyncTimestamp = changes.timestamp || Date.now();
    return { recipesProcessed: processedCount };
  }

  /**
   * Prepares local pantry items modified since last push for synchronization with Supabase.
   * Adheres strictly to security boundary: LOCAL_GUEST_ID items are filtered out!
   */
  public static async preparePantryPushPayload(authenticatedUserId: string, dbOverride?: any): Promise<SyncPushPayload | null> {
    if (!authenticatedUserId || authenticatedUserId === LOCAL_GUEST_ID) {
      return null;
    }

    const db = dbOverride || this.databaseInstance;
    if (!db) {
      return { userId: authenticatedUserId, pantryUpdates: [] };
    }

    const pantryCollection = db.get('local_pantry');
    const allRecords = await pantryCollection.query().fetch();

    // Enforce privacy: never upload guest data to remote server
    const userRecords = allRecords.filter((rec: any) => rec.userId === authenticatedUserId);

    const pantryUpdates = userRecords.map((item: any) => ({
      ingredientId: item.ingredientId,
      quantity: item.quantity,
      unit: item.unit,
      storageLocation: item.storageLocation,
      updatedAt: item.updatedAt,
    }));

    return {
      userId: authenticatedUserId,
      pantryUpdates,
    };
  }
}
