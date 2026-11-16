export interface RecipeSnapshot {
  title:string; description:string; category:string; difficulty:'easy'|'medium'|'hard'|'expert'; prepTimeMinutes:number; cookTimeMinutes:number; servings:number;
  heroImageUrl?:string; cuisineTags?:string[];
  mediaAssets?:{url:string;sha256:string;sizeBytes:number;mimeType:string}[];
  ingredients:{canonicalName:string;name:string;amount:number;unit:string;displayText?:string;isOptional?:boolean;tier?:'critical'|'important'|'optional';ingredientId?:string}[];
  equipment:{canonicalName:string;name:string;isRequired?:boolean;notes?:string;equipmentId?:string}[];
  steps:{title?:string;instruction:string;timerDurationSeconds?:number;timerLabel?:string;isCritical?:boolean;techniqueSlugs?:string[];mediaUrl?:string;mediaType?:'image'|'video'|'gif'}[];
}
export interface CommunityRecipe {id:string;author_id:string;local_recipe_id:string;snapshot:RecipeSnapshot;status:'published'|'pending_review'|'archived';moderation_flags:string[];version:number;created_at:string;updated_at:string;content_hash?:string}
export interface CommunityUser {id:string;email?:string}
export interface CommunityReview {id:string;recipe_id:string;user_id:string;rating:number;review_text:string;status:'published'|'pending_review';created_at:string}
export interface CommunityDictionary {ingredients:{id:string;canonical_name:string;display_name:string;category:string;default_unit:string;is_staple:boolean;allergen_tags:string[]}[];equipment:{id:string;canonical_name:string;display_name:string;category:string;is_essential:boolean;icon_name:string}[];techniques:{id:string;canonical_slug:string;title:string;summary:string;key_tips:string[];common_mistakes:string[]}[]}
