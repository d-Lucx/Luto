import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, mkdir, readFile, writeFile, readdir, rm, rename, stat } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createHash } from 'node:crypto';
const mod = await import('../src/services/media/VerifiedRecipeMedia.ts').catch(() => ({}));
const jpeg = new Uint8Array([255,216,255,224,1,2,3,4]);
const sha = b => createHash('sha256').update(b).digest('hex');
const asset = {url:'https://media.example.com/hero.jpg', sha256:sha(jpeg), sizeBytes:8, mimeType:'image/jpeg'};
async function setup(options={}) {
  const root = await mkdtemp(join(tmpdir(),'luto-media-'));
  const port = {
    async list(path) {try{return await readdir(join(root,path));}catch(e){if(e.code==='ENOENT')return [];throw e;}},
    async exists(path){try{await stat(join(root,path));return true;}catch{return false;}},
    async mkdir(path){await mkdir(join(root,path),{recursive:true});},
    async size(path){return (await stat(join(root,path))).size;},
    async read(path){return new Uint8Array(await readFile(join(root,path)));},
    async write(path,bytes){await writeFile(join(root,path),bytes);},
    async remove(path){await rm(join(root,path),{recursive:true,force:true});},
    async move(a,b){await rename(join(root,a),join(root,b));},
    uri:path=>join(root,path), sha256:async bytes=>sha(bytes),
    async transfer(url,path,max,progress){await writeFile(join(root,path),options.bytes??jpeg);progress?.((options.bytes??jpeg).length);if(options.interrupt)throw Error('connection lost');return {mimeType:options.mimeType??'image/jpeg'};},
  };
  return {root,port,service:mod.createRecipeMediaService(port)};
}
test('verified media service exists',()=>assert.equal(typeof mod.createRecipeMediaService,'function'));
if(mod.createRecipeMediaService) {
 test('verified files survive service restart and explicit removal deletes bytes',async t=>{
   const {root,port,service}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
   assert.equal((await service.downloadRecipeMedia('../recipe',[asset])).state,'downloaded');
   const restarted=mod.createRecipeMediaService(port);
   const uri=await restarted.getDownloadedUri('../recipe',asset.url);assert.ok(uri.startsWith(root));assert.deepEqual(new Uint8Array(await readFile(uri)),jpeg);
   await restarted.removeRecipeMedia('../recipe');assert.equal((await restarted.getRecipeMediaStatus('../recipe')).state,'not_downloaded');assert.equal(await port.exists(uri.slice(root.length+1)),false);
 });
 test('missing digest and unsafe URLs are unavailable before transfer',async t=>{
   const {root,service}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
   for(const bad of [{...asset,sha256:''},{...asset,url:'file:///secret'},{...asset,url:'https://127.0.0.1/a'},{...asset,sizeBytes:51*1024*1024}])assert.equal((await service.downloadRecipeMedia('a',[bad])).state,'unavailable');
   assert.equal((await service.downloadRecipeMedia('a',[])).state,'unavailable');
 });
 for(const [name,options,change] of [
   ['hash mismatch',{}, {sha256:'0'.repeat(64)}],['size mismatch',{}, {sizeBytes:9}],
   ['wrong response MIME',{mimeType:'text/html'},{}],['wrong file signature',{bytes:new Uint8Array(8)},{}],['interrupted transfer',{interrupt:true},{}],
 ])test(`${name} never produces local media and cleans partial files`,async t=>{
   const {root,port,service}=await setup(options);t.after(()=>rm(root,{recursive:true,force:true}));
   assert.equal((await service.downloadRecipeMedia('bad',[{...asset,...change}])).state,'failed');
   assert.equal(await service.getDownloadedUri('bad',asset.url),null);
   assert.ok(!(await port.list('')).some(n=>n.startsWith('pending-')));
 });
 test('corrupt downloaded bytes stop being served',async t=>{
   const {root,service}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
   await service.downloadRecipeMedia('a',[asset]);const uri=await service.getDownloadedUri('a',asset.url);await writeFile(uri,new Uint8Array(8));
   assert.equal((await service.getRecipeMediaStatus('a')).state,'failed');assert.equal(await service.getDownloadedUri('a',asset.url),null);
 });
 test('storage cap rejects complete bundle without evicting saved downloads',async t=>{
   const {root,port}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));const service=mod.createRecipeMediaService(port,{maxTotalBytes:12});
   assert.equal((await service.downloadRecipeMedia('a',[asset])).state,'downloaded');
   assert.equal((await service.downloadRecipeMedia('b',[asset])).state,'failed');assert.equal((await service.getRecipeMediaStatus('a')).state,'downloaded');
 });
 test('restart removes interrupted staging files',async t=>{
   const {root,port}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));await port.mkdir('pending-abcd');await port.write('pending-abcd/file',jpeg);
   await mod.createRecipeMediaService(port).getRecipeMediaStatus('a');assert.equal(await port.exists('pending-abcd'),false);
 });
}


test('complete bundle failure removes earlier staged assets and retry persists readiness', async t=>{
  const {root,port}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
  const service=mod.createRecipeMediaService(port);
  const second={...asset,url:'https://media.example.com/step.jpg',sha256:'0'.repeat(64)};
  assert.equal((await service.downloadRecipeMedia('bundle',[asset,second])).state,'failed');
  assert.equal((await mod.createRecipeMediaService(port).getRecipeMediaStatus('bundle')).state,'failed');
  assert.equal((await port.list('')).filter(name=>/^[a-f0-9]{64}$/.test(name)).length,0);
  assert.equal((await service.downloadRecipeMedia('bundle',[asset])).state,'downloaded');
  assert.equal((await mod.createRecipeMediaService(port).getRecipeMediaStatus('bundle')).state,'downloaded');
});

test('concurrent downloads serialize their storage reservations',async t=>{
  const {root,port}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
  const service=mod.createRecipeMediaService(port,{maxTotalBytes:12});
  const results=await Promise.all([service.downloadRecipeMedia('first',[asset]),service.downloadRecipeMedia('second',[asset])]);
  assert.deepEqual(results.map(result=>result.state),['downloaded','failed']);
});

test('disk-full failure remains actionable when failure metadata cannot be written',async t=>{
  const {root,port}=await setup();t.after(()=>rm(root,{recursive:true,force:true}));
  port.transfer=async()=>{throw Error('Device storage is full.');};
  port.write=async()=>{throw Error('ENOSPC');};
  const service=mod.createRecipeMediaService(port);
  const result=await service.downloadRecipeMedia('full',[asset]);
  assert.equal(result.state,'failed');assert.match(result.error,/storage is full/i);
  assert.equal(await service.getDownloadedUri('full',asset.url),null);
});
