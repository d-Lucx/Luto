import test from 'node:test';
import assert from 'node:assert/strict';
import { validateSnapshot, moderateSnapshot, readBoundedJSON } from '../../../supabase/functions/community/core.ts';
import {fetchWithTimeout} from '../src/services/community/http.ts';
const valid = () => ({ title:'Simple rice', description:'Steamed rice', category:'side', difficulty:'easy', prepTimeMinutes:2, cookTimeMinutes:20, servings:2, ingredients:[{canonicalName:'white_rice',name:'White rice',amount:1,unit:'cup'}],equipment:[],steps:[{instruction:'Rinse rice and simmer in water until tender.'}] });
test('complete snapshot accepted without client dictionary UUIDs',()=>assert.equal(validateSnapshot(valid()).title,'Simple rice'));
test('malformed and oversized graph rejected',()=>{ for(const patch of [{ingredients:[]},{steps:[]},{servings:0},{prepTimeMinutes:NaN},{title:'a'},{ingredients:[{name:'rice',canonicalName:'rice',amount:-1,unit:'cup'}]}]) assert.throws(()=>validateSnapshot({...valid(),...patch})); });
test('server strips client authority and local media',()=>{const clean=validateSnapshot({...valid(),status:'published',author_id:'spoof',kitchenTested:true,heroImageUrl:'file:///private.jpg'});assert.equal(clean.status,undefined);assert.equal(clean.kitchenTested,undefined);assert.equal(clean.heroImageUrl,undefined);});
test('hazards and promotional content held; clean receives automated pass only',()=>{assert.deepEqual(moderateSnapshot(valid()),[]);assert.ok(moderateSnapshot({...valid(),description:'add bleach'}).length);assert.ok(moderateSnapshot({...valid(),description:'https://casino.example'}).length);});
test('server servings stay within mobile cookable range',()=>{assert.equal(validateSnapshot({...valid(),servings:100}).servings,100);assert.throws(()=>validateSnapshot({...valid(),servings:101}));});
test('media assets require HTTPS and explicit SHA256, byte count and supported MIME',()=>{const asset={url:'https://example.com/rice.png',sha256:'a'.repeat(64),sizeBytes:100,mimeType:'image/png'};assert.equal(validateSnapshot({...valid(),mediaAssets:[asset]}).mediaAssets.length,1);for(const patch of [{url:'file:///a.png'},{sha256:'bad'},{sizeBytes:0},{mimeType:'text/html'}])assert.throws(()=>validateSnapshot({...valid(),mediaAssets:[{...asset,...patch}]}));});
test('stream limit counts UTF8 bytes and cancels oversized body without length header',async()=>{
 let cancelled=false;const stream=new ReadableStream({start(controller){controller.enqueue(new TextEncoder().encode('"éééééé"'));},cancel(){cancelled=true;}});
 const request=new Request('https://example.com',{method:'POST',body:stream,duplex:'half'});
 await assert.rejects(readBoundedJSON(request,10),/too large/);assert.equal(cancelled,true);
 assert.deepEqual(await readBoundedJSON(new Request('https://example.com',{method:'POST',body:'{"ok":true}'})),{ok:true});
});
test('network timeout aborts pending fetch',async()=>{
 const original=globalThis.fetch;let aborted=false;globalThis.fetch=(_url,init)=>new Promise((_resolve,reject)=>init.signal.addEventListener('abort',()=>{aborted=true;reject(new Error('aborted'));}));
 try{await assert.rejects(fetchWithTimeout('https://example.com',{},5),/timed out/);assert.equal(aborted,true);}finally{globalThis.fetch=original;}
});
