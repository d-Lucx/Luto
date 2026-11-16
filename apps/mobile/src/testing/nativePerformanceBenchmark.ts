import { Database, type Model, Q } from '@nozbe/watermelondb';
import SQLiteAdapter from '@nozbe/watermelondb/adapters/sqlite';
import { Platform } from 'react-native';
import { schema } from '../database/schema';
import { modelClasses, Ingredient, Recipe, RecipeIngredient, RecipeStep, UserPantry } from '../database/models';
import { migrations } from '../database/migrations';
import { BENCHMARK_DATABASE_NAME, BENCHMARK_FIXTURE_VERSION, BENCHMARK_USER_ID, createPerformanceFixture, scorePerformanceFixture } from './performanceFixture';

// Deliberately never import ../database/index or production pantry/cookbook/session helpers.
let benchmarkDatabase: Database | undefined;
let run: Promise<BenchmarkResult> | undefined;
export interface BenchmarkResult {
  fixtureVersion:number; schemaVersion:number; databaseName:string; seededThisRun:boolean;
  dataset:{recipes:number;requirements:number;steps:number;dictionary:number;pantry:number};
  timingsMs:Record<string,number>;
  scoring:{evaluated:number;readyCount:number;bestScore:number;worstScore:number};
  detail:{recipeId:string;requirements:number;steps:number};
  runtime:{platform:string;platformVersion:string;jsEngine:string};
  nativeMemoryBytes:null; measurementScope:string;
}
function fixtureRecord(item:Model, row:{id:string}) {const {id,...fields}=row;item._raw.id=id;Object.assign(item,fields);}
const elapsed = (start:number) => Math.round((performance.now()-start)*1000)/1000;
async function execute():Promise<BenchmarkResult> {
  if(process.env.EXPO_PUBLIC_DEVICE_TESTS!=='1')throw Error('Device benchmarks are unavailable in this build.');
  const setupStart=performance.now();
  benchmarkDatabase??=new Database({adapter:new SQLiteAdapter({schema,migrations,dbName:BENCHMARK_DATABASE_NAME,jsi:true}),modelClasses});
  const db=benchmarkDatabase;
  const recipes=db.get<Recipe>('local_recipes');const requirements=db.get<RecipeIngredient>('local_ingredients');
  const steps=db.get<RecipeStep>('local_steps');const ingredients=db.get<Ingredient>('ingredients');const pantry=db.get<UserPantry>('local_pantry');
  const existing=await recipes.query().fetchCount();
  const databaseOpenAndCount=elapsed(setupStart);
  const seedStart=performance.now();
  if(existing===0) {
    const fixture=createPerformanceFixture();
    // One native batch/transaction: process death cannot expose half of this fixture.
    await db.write(async()=>db.batch(
      ...fixture.ingredients.map(row=>ingredients.prepareCreate(item=>fixtureRecord(item,row))),
      ...fixture.recipes.map(row=>recipes.prepareCreate(item=>fixtureRecord(item,row))),
      ...fixture.requirements.map(row=>requirements.prepareCreate(item=>fixtureRecord(item,row))),
      ...fixture.steps.map(row=>steps.prepareCreate(item=>fixtureRecord(item,row))),
      ...fixture.pantry.map(row=>pantry.prepareCreate(item=>fixtureRecord(item,row))),
    ));
  } else if(existing!==500)throw Error(`Benchmark dataset is incomplete: ${existing} recipes. No data was changed.`);
  const seed=elapsed(seedStart);
  // Sequential timings describe each query, including SQLite bridge + model hydration.
  let start=performance.now();const fetchedRecipes=await recipes.query().fetch();const recipeFetch=elapsed(start);
  start=performance.now();const fetchedIngredients=await ingredients.query().fetch();const dictionaryFetch=elapsed(start);
  start=performance.now();const fetchedRequirements=await requirements.query().fetch();const requirementsFetch=elapsed(start);
  start=performance.now();const fetchedPantry=await pantry.query(Q.where('user_id',BENCHMARK_USER_ID)).fetch();const pantryFetch=elapsed(start);
  start=performance.now();const ranked=scorePerformanceFixture({recipes:fetchedRecipes,ingredients:fetchedIngredients,requirements:fetchedRequirements,pantry:fetchedPantry});const scoringAndSort=elapsed(start);
  const target='benchmark-recipe-0250';
  start=performance.now();
  // These query fetches always execute SQL; find() could return only a cached Model.
  const [detailRecipes,detailRequirements,detailSteps]=await Promise.all([
    recipes.query(Q.where('id',target)).fetch(),
    requirements.query(Q.where('recipe_id',target)).fetch(),
    steps.query(Q.where('recipe_id',target),Q.sortBy('step_number',Q.asc)).fetch(),
  ]);
  const indexedRecipeDetail=elapsed(start);
  const stepCount=await steps.query().fetchCount();
  if(fetchedRecipes.length!==500 || fetchedIngredients.length!==4 || fetchedRequirements.length!==2000 || fetchedPantry.length!==4 || stepCount!==1000 || detailRecipes.length!==1 || detailRequirements.length!==4 || detailSteps.length!==2 || ranked.length!==500 || ranked.filter(item=>item.canCookNow).length!==200)throw Error('Benchmark fixture validation failed. Results are not valid.');
  return {
    fixtureVersion:BENCHMARK_FIXTURE_VERSION,schemaVersion:schema.version,databaseName:BENCHMARK_DATABASE_NAME,seededThisRun:existing===0,
    dataset:{recipes:fetchedRecipes.length,requirements:fetchedRequirements.length,steps:stepCount,dictionary:fetchedIngredients.length,pantry:fetchedPantry.length},
    timingsMs:{databaseOpenAndCount,seed:existing===0?seed:0,recipeFetch,dictionaryFetch,requirementsFetch,pantryFetch,scoringAndSort,indexedRecipeDetail},
    scoring:{evaluated:ranked.length,readyCount:ranked.filter(item=>item.canCookNow).length,bestScore:ranked[0]!.matchScore,worstScore:ranked[ranked.length-1]!.matchScore},
    detail:{recipeId:target,requirements:detailRequirements.length,steps:detailSteps.length},
    runtime:{platform:Platform.OS,platformVersion:String(Platform.Version),jsEngine:typeof (globalThis as {HermesInternal?:unknown}).HermesInternal==='undefined'?'unknown or non-Hermes':'Hermes'},
    nativeMemoryBytes:null,
    measurementScope:'Component timings only. Not Activity startup, UI responsiveness, scrolling, production dataset realism, or a release pass. Native memory requires adb dumpsys meminfo.',
  };
}
/** One run per JS process; cold-launch repetitions must force-stop and relaunch the app. */
export function runPerformanceBenchmark():Promise<BenchmarkResult> {
  if(process.env.EXPO_PUBLIC_DEVICE_TESTS!=='1')return Promise.reject(Error('Device benchmarks are unavailable in this build.'));
  run??=execute();return run;
}
