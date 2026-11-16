import { evaluatePantryMatch } from '../engine/evaluatePantryMatch.ts';
import type { IngredientRequirement, PantryItem, MatchResult } from '../engine/evaluatePantryMatch.ts';
export const BENCHMARK_DATABASE_NAME = 'luto-benchmark';
export const BENCHMARK_USER_ID = 'benchmark-device-only';
export const BENCHMARK_FIXTURE_VERSION = 1;
const id = (kind: string,index: number) => `benchmark-${kind}-${String(index).padStart(4,'0')}`;
export function createPerformanceFixture() {
  const ingredients=Array.from({length:4},(_,i)=>({id:id('ingredient',i),canonicalName:`benchmark fixture item ${i+1}`,displayName:`Benchmark item ${i+1}`,category:'benchmark',defaultUnit:'g',isStaple:false}));
  const pantry=ingredients.map((ingredient,i)=>({id:id('pantry',i),userId:BENCHMARK_USER_ID,ingredientId:ingredient.id,quantity:(i+1)*100,unit:'g',storageLocation:'pantry' as const,updatedAt:0}));
  const recipes=Array.from({length:500},(_,i)=>({id:id('recipe',i),title:`Benchmark fixture ${String(i).padStart(4,'0')}`,description:'Synthetic performance fixture. Not a recipe or cooking guidance.',servings:1,heroImageUrl:'',localHeroUri:null,updatedAt:0}));
  const requirements=recipes.flatMap((recipe,i)=>ingredients.map((ingredient,j)=>({id:id('requirement',i*4+j),recipeId:recipe.id,ingredientId:ingredient.id,amount:(j+1)*100*((i%5+1)/2),unit:'g',tier:([1,2,2,3] as const)[j]!,isOptional:false})));
  const steps=recipes.flatMap(recipe=>[1,2].map(stepNumber=>({id:`${recipe.id}-step-${stepNumber}`,recipeId:recipe.id,stepNumber,instruction:`Benchmark fixture step ${stepNumber}. Not cooking guidance.`,timerDurationSeconds:0,mediaUrl:null,localMediaUri:null})));
  return {recipes,ingredients,requirements,steps,pantry};
}
export interface ScoringDataset {
  recipes: readonly {id:string}[];
  ingredients: readonly {id:string;displayName:string;isStaple:boolean}[];
  requirements: readonly {recipeId:string;ingredientId:string;amount:number;unit:string;tier:0|1|2|3;isOptional:boolean}[];
  pantry: readonly {ingredientId:string;quantity:number;unit:string}[];
}
/** Same evaluator as the app, fed by actual fetched model properties in native runs. */
export function scorePerformanceFixture(data: ScoringDataset): MatchResult[] {
  const dictionary=new Map(data.ingredients.map(item=>[item.id,item]));
  const requirements=new Map<string,IngredientRequirement[]>();
  for(const line of data.requirements){
    const ingredient=dictionary.get(line.ingredientId);
    if(!ingredient)throw Error('Benchmark canonical reference missing.');
    const group=requirements.get(line.recipeId)??[];
    group.push({id:ingredient.id,name:ingredient.displayName,isStaple:ingredient.isStaple,isOptional:line.isOptional,tier:line.tier,amount:line.amount,unit:line.unit});requirements.set(line.recipeId,group);
  }
  const pantry=new Map<string,PantryItem>(data.pantry.map(item=>[item.ingredientId,{ingredientId:item.ingredientId,quantity:item.quantity,unit:item.unit}]));
  return data.recipes.map(recipe=>evaluatePantryMatch(recipe.id,requirements.get(recipe.id)??[],pantry,new Map()))
    .sort((a,b)=>b.matchScore-a.matchScore || a.recipeId.localeCompare(b.recipeId));
}
