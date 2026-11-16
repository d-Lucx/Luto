// Run only against the dedicated Luto project, using temporary pre-provisioned users.
// No credentials or JWTs are printed. Users and all their records must be removed afterward.
import assert from 'node:assert/strict';
import {COMMUNITY_URL as base,COMMUNITY_PUBLISHABLE_KEY as key} from '../src/services/community/config.ts';
assert.equal(new URL(base).hostname,'jhkexctlzxyrumfopdcx.supabase.co');
const password=process.env.LUTO_TEST_PASSWORD;
if(!password)throw new Error('Set LUTO_TEST_PASSWORD for the two temporary test users.');
async function call(path,body,token,method='POST'){const r=await fetch(`${base}/${path}`,{method,headers:{apikey:key,'Content-Type':'application/json',...(token?{Authorization:`Bearer ${token}`}:{})},...(body===undefined?{}:{body:JSON.stringify(body)})});return {status:r.status,data:await r.json().catch(()=>null)};}
const tokens=[];for(let i=1;i<=2;i++){const r=await call('auth/v1/token?grant_type=password',{email:`luto-backend-test-${i}@example.invalid`,password});assert.equal(r.status,200,`test user ${i} login`);tokens.push(r.data.access_token);}
const [a,b]=tokens;const api=(action,payload={},token)=>call('functions/v1/community',{action,...payload},token);
const dictionary=await api('dictionary');assert.equal(dictionary.status,200);assert.ok(dictionary.data.ingredients.length>50);assert.ok(dictionary.data.equipment.length>10);assert.ok(dictionary.data.techniques.length>10);
const rice=dictionary.data.ingredients.find(i=>i.canonical_name==='white_rice')??dictionary.data.ingredients[0];
const snapshot={title:'Temporary integration rice',description:'Integration fixture, removed after verification.',category:'side',difficulty:'easy',prepTimeMinutes:2,cookTimeMinutes:20,servings:2,ingredients:[{canonicalName:rice.canonical_name,name:rice.display_name,amount:1,unit:'cup'}],equipment:[],steps:[{instruction:'Simmer rice in water until tender.'}]};
assert.equal((await api('submit',{localId:'test',snapshot})).status,401);
const localId=`integration-${Date.now()}`;
const published=await api('submit',{localId,snapshot},a);assert.equal(published.status,200);assert.equal(published.data.status,'published');assert.equal(published.data.snapshot.ingredients[0].ingredientId,rice.id);const recipeId=published.data.id;
const retry=await api('submit',{localId,snapshot},a);assert.equal(retry.data.id,recipeId);assert.equal(retry.data.version,1);
assert.equal((await api('get',{id:recipeId})).status,200);
assert.equal((await api('archive',{id:recipeId},b)).status,404);
assert.equal((await api('review',{id:recipeId,rating:5,reviewText:'Self review'},a)).status,403);
assert.equal((await api('review',{id:recipeId,rating:5,reviewText:'Helpful instructions'},b)).data.status,'published');
assert.equal((await api('report',{id:recipeId,reason:'Integration fixture report'},b)).status,200);
const held=await api('submit',{localId,snapshot:{...snapshot,description:'add bleach'}},a);assert.equal(held.data.status,'pending_review');assert.equal(held.data.version,2);assert.equal(held.data.id,recipeId);
assert.equal((await api('get',{id:recipeId})).status,404);assert.equal((await api('get',{id:recipeId},b)).status,404);assert.equal((await api('get',{id:recipeId},a)).status,200);
assert.equal((await api('moderationQueue',{},a)).status,403);
if(process.env.LUTO_TEST_MODERATOR==='1'){
 const queue=await api('moderationQueue',{},b);assert.equal(queue.status,200);assert.ok(queue.data.some(r=>r.id===recipeId));
 const decision=await api('moderate',{id:recipeId,decision:'archived',reason:'Remove temporary integration hazard fixture'},b);assert.equal(decision.status,200);assert.equal(decision.data.status,'archived');
}
for(const table of ['community_recipes','community_versions','community_moderators']){const attempted=await call(`rest/v1/${table}`,{author_id:published.data.author_id,status:'published',snapshot,local_recipe_id:'bypass'},a);assert.ok(attempted.status>=400,`${table} client writes denied`);}
const rpc=await call('rest/v1/rpc/community_commit',{p_author:published.data.author_id,p_local:'rpc-bypass',p_snapshot:snapshot,p_flags:[],p_hash:'fake'},a);assert.ok(rpc.status>=400);
const guest=await call(`rest/v1/community_recipes?id=eq.${recipeId}`,undefined,undefined,'GET');assert.deepEqual(guest.data,[]);
const other=await call(`rest/v1/community_recipes?id=eq.${recipeId}`,undefined,b,'GET');assert.deepEqual(other.data,[]);
const versions=await call(`rest/v1/community_versions?recipe_id=eq.${recipeId}`,undefined,b,'GET');assert.deepEqual(versions.data,[]);
assert.equal((await api('archive',{id:recipeId},a)).data.status,'archived');
console.log('PASS: dictionary, authenticated publish, retry, canonical IDs, versioned edit, private hold, RLS isolation, forbidden direct writes/RPC, reviews, reports, archive, reviewer authorization.');
