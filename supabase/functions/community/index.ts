import { validateSnapshot, moderateSnapshot, readBoundedJSON } from './core.ts';
const cors={'Access-Control-Allow-Origin':'*','Access-Control-Allow-Headers':'authorization,apikey,content-type,x-client-info','Access-Control-Allow-Methods':'POST,OPTIONS'};
const json=(value:unknown,status=200)=>new Response(JSON.stringify(value),{status,headers:{...cors,'Content-Type':'application/json','Cache-Control':'no-store'}});
const url=Deno.env.get('SUPABASE_URL')!;
const secret=Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
async function db(path:string,method='GET',body?:unknown,prefer?:string){const r=await fetch(`${url}/rest/v1/${path}`,{method,headers:{apikey:secret,Authorization:`Bearer ${secret}`,'Content-Type':'application/json',...(prefer?{Prefer:prefer}:{})},...(body===undefined?{}:{body:JSON.stringify(body)})});const data=await r.json().catch(()=>null);if(!r.ok){console.error('Community database request failed',r.status,data?.code);throw new Error('Database operation failed');}return data;}
const eq=(v:string)=>encodeURIComponent(v);
function id(value:unknown){if(typeof value!=='string'||!/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/i.test(value))throw new Error('Invalid recipe ID');return value;}
async function visible(recipeId:string,userId?:string){const rows=await db(`community_recipes?id=eq.${eq(recipeId)}&limit=1`);const r=rows[0];if(!r||(r.status!=='published'&&r.author_id!==userId))return null;return r;}
async function user(req:Request){const bearer=req.headers.get('Authorization');if(!bearer)return null;const r=await fetch(`${url}/auth/v1/user`,{headers:{apikey:Deno.env.get('SUPABASE_ANON_KEY')!,Authorization:bearer}});if(!r.ok)return null;const u=await r.json();return u.id&&!u.is_anonymous?u:null;}
Deno.serve(async(req:Request)=>{
 if(req.method==='OPTIONS')return new Response('ok',{headers:cors});
 if(req.method!=='POST')return json({error:'Use POST'},405);
 try {
  const body=await readBoundedJSON(req);const action=body.action;const u=await user(req);
  if(action==='dictionary'){
   const [ingredients,equipment,techniques]=await Promise.all([db('ingredients?select=id,canonical_name,display_name,category,default_unit,is_staple,allergen_tags&order=canonical_name'),db('equipment?select=id,canonical_name,display_name,category,is_essential,icon_name&order=canonical_name'),db('techniques_and_skills?select=id,canonical_slug,title,summary,key_tips,common_mistakes&order=canonical_slug')]);return json({ingredients,equipment,techniques});
  }
  if(action==='list'){const offset=Number.isInteger(body.offset)&&body.offset>=0?Math.min(body.offset,10000):0;return json(await db(`community_recipes?status=eq.published&order=created_at.desc,id.desc&limit=40&offset=${offset}`));}
  if(action==='get'){const r=await visible(id(body.id),u?.id);return r?json(r):json({error:'Recipe not found'},404);}
  if(action==='reviews'){const recipeId=id(body.id);if(!(await visible(recipeId,u?.id)))return json({error:'Recipe not found'},404);return json(await db(`community_reviews?recipe_id=eq.${recipeId}&status=eq.published&order=created_at.desc&limit=100`));}
  if(!u)return json({error:'Sign in is required'},401);
  if(action==='mine')return json(await db(`community_recipes?author_id=eq.${u.id}&order=updated_at.desc&limit=100`));
  if(action==='submit'){
   if(typeof body.localId!=='string'||!body.localId.trim()||body.localId.length>150)return json({error:'Invalid local recipe ID'},400);
   const snapshot=validateSnapshot(body.snapshot);const flags=moderateSnapshot(snapshot);
   const [ingredients,equipment,techniques]=await Promise.all([db('ingredients?select=id,canonical_name'),db('equipment?select=id,canonical_name'),db('techniques_and_skills?select=canonical_slug')]);
   for(const i of snapshot.ingredients){const found=ingredients.find((v:any)=>v.canonical_name===i.canonicalName);if(found)i.ingredientId=found.id;else flags.push('UNKNOWN_INGREDIENT');}
   for(const e of snapshot.equipment){const found=equipment.find((v:any)=>v.canonical_name===e.canonicalName);if(found)e.equipmentId=found.id;else flags.push('UNKNOWN_EQUIPMENT');}
   for(const step of snapshot.steps)for(const slug of step.techniqueSlugs)if(!techniques.some((v:any)=>v.canonical_slug===slug))flags.push('UNKNOWN_TECHNIQUE');
   const digest=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(JSON.stringify(snapshot)));const hash=Array.from(new Uint8Array(digest),b=>b.toString(16).padStart(2,'0')).join('');
   return json(await db('rpc/community_commit','POST',{p_author:u.id,p_local:body.localId,p_snapshot:snapshot,p_flags:[...new Set(flags)],p_hash:hash}));
  }
  if(action==='archive'){const rows=await db(`community_recipes?id=eq.${id(body.id)}&author_id=eq.${u.id}`,'PATCH',{status:'archived',updated_at:new Date().toISOString()},'return=representation');return rows[0]?json(rows[0]):json({error:'Recipe not found'},404);}
  if(action==='report'||action==='review'){
   const recipeId=id(body.id), recipe=await visible(recipeId);if(!recipe)return json({error:'Published recipe not found'},404);
   if(action==='report'){if(typeof body.reason!=='string'||body.reason.trim().length<3||body.reason.length>2000)return json({error:'Describe the concern in 3–2000 characters'},400);await db('community_reports?on_conflict=recipe_id,user_id','POST',{recipe_id:recipeId,user_id:u.id,reason:body.reason.trim()},'resolution=merge-duplicates');return json({ok:true});}
   if(recipe.author_id===u.id)return json({error:'Authors cannot rate their own recipe'},403);
   if(!Number.isInteger(body.rating)||body.rating<1||body.rating>5||typeof body.reviewText!=='string'||body.reviewText.length>2000)return json({error:'Invalid rating or review'},400);
   const status=moderateSnapshot(body.reviewText).length?'pending_review':'published';const rows=await db('community_reviews?on_conflict=recipe_id,user_id','POST',{recipe_id:recipeId,user_id:u.id,rating:body.rating,review_text:body.reviewText,status,updated_at:new Date().toISOString()},'resolution=merge-duplicates,return=representation');return json(rows[0]);
  }
  if(action==='moderationQueue'||action==='moderate'){
   const roles=await db(`community_moderators?user_id=eq.${u.id}&limit=1`);if(!roles.length)return json({error:'Reviewer access required'},403);
   if(action==='moderationQueue')return json(await db('community_recipes?status=eq.pending_review&order=updated_at.asc&limit=100'));
   const recipeId=id(body.id);if(!['published','archived'].includes(body.decision)||typeof body.reason!=='string'||body.reason.trim().length<3||body.reason.length>2000)return json({error:'Decision and review reason required'},400);
   // Never let authors approve their own held submission.
   const current=await visible(recipeId,u.id);
   if(current?.author_id===u.id)return json({error:'Self-review forbidden'},403);
   return json(await db('rpc/community_moderate','POST',{p_reviewer:u.id,p_recipe:recipeId,p_decision:body.decision,p_reason:body.reason.trim()}));
  }
  return json({error:'Unknown action'},400);
 }catch(error){const message=error instanceof Error?error.message:'';if(message==='Recipe is too large')return json({error:message},413);if(message==='Database operation failed')return json({error:'Community is temporarily unavailable. Please retry.'},503);return json({error:message||'Invalid request'},400);}
});
