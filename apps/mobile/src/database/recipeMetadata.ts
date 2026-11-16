import type { RecipeMediaAsset } from '../services/media/VerifiedRecipeMedia';
export interface RecipeMetadata {
  category?: string; difficulty?: 'easy' | 'medium' | 'hard' | 'expert'; cuisineTags?: string[];
  prepTimeMinutes?: number; cookTimeMinutes?: number;
  equipment?: { canonicalName: string; name: string; isRequired?: boolean; notes?: string }[];
  mediaAssets?: RecipeMediaAsset[];
  source?: 'community' | 'local'; remoteId?: string; remoteVersion?: number;
  publicationStatus?: string;
}
