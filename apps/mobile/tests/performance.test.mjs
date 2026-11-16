import test from 'node:test';
import assert from 'node:assert/strict';
const mod = await import('../src/testing/performanceFixture.ts').catch(()=>({}));
test('benchmark fixture generator is available',()=>assert.equal(typeof mod.createPerformanceFixture,'function'));
if(mod.createPerformanceFixture) {
  test('500 deterministic fixtures preserve canonical references without production content',()=>{
    const a=mod.createPerformanceFixture();const b=mod.createPerformanceFixture();assert.deepEqual(a,b);
    assert.equal(a.recipes.length,500);assert.equal(a.requirements.length,2000);assert.equal(a.steps.length,1000);assert.equal(a.ingredients.length,4);assert.equal(a.pantry.length,4);
    const all=[...a.recipes,...a.requirements,...a.steps,...a.ingredients,...a.pantry];assert.equal(new Set(all.map(row=>row.id)).size,3508);
    assert.ok(all.every(row=>row.id.startsWith('benchmark-')));
    const recipes=new Set(a.recipes.map(row=>row.id));const dictionary=new Set(a.ingredients.map(row=>row.id));
    for(const recipe of a.recipes){assert.match(recipe.title,/^Benchmark fixture /);assert.equal(recipe.heroImageUrl,'');assert.equal(a.requirements.filter(row=>row.recipeId===recipe.id).length,4);assert.equal(a.steps.filter(row=>row.recipeId===recipe.id).length,2);}
    for(const row of a.requirements){assert.ok(recipes.has(row.recipeId));assert.ok(dictionary.has(row.ingredientId));assert.ok(row.amount>0);assert.equal(row.unit,'g');}
    assert.ok(a.steps.every(row=>row.timerDurationSeconds===0 && !row.mediaUrl));
  });
  test('benchmark scoring uses all 500 recipes with quantity-aware ratios and deterministic sort',()=>{
    const data=mod.createPerformanceFixture();const scored=mod.scorePerformanceFixture(data);
    assert.equal(scored.length,500);assert.equal(scored.filter(row=>row.matchScore===100).length,200);assert.equal(scored.filter(row=>row.canCookNow).length,200);
    assert.equal(scored[0].recipeId,'benchmark-recipe-0000');assert.equal(scored[200].matchScore,0);
    assert.equal(data.requirements[0].amount,50);assert.equal(data.requirements[8].amount,150);
    assert.deepEqual(data.pantry.map(row=>row.quantity),[100,200,300,400]);
  });
}
