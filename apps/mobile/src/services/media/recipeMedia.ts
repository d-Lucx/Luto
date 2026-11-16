import { Directory, File, Paths } from 'expo-file-system';
import * as Crypto from 'expo-crypto';
import { fetch as expoFetch } from 'expo/fetch';
import { createRecipeMediaService } from './VerifiedRecipeMedia';
import type { MediaPort } from './VerifiedRecipeMedia';
import { createBoundedMediaTransfer } from './BoundedMediaTransfer';
export type { RecipeMediaAsset, RecipeMediaStatus, MediaProgress } from './VerifiedRecipeMedia';

// Documents persist across launches and are private to the installed app.
const root = new Directory(Paths.document,'recipe-media-v1');
function safePath(path: string): string {
  if (path && !/^[a-z0-9.-]+(?:\/[a-z0-9.-]+)*$/.test(path)) throw Error('Invalid media storage path.');
  if (path.split('/').some(part=>part==='.' || part==='..')) throw Error('Invalid media storage path.');
  return path;
}
const file = (path: string) => new File(root,safePath(path));
const directory = (path: string) => path ? new Directory(root,safePath(path)) : root;
function entry(path: string): File | Directory | null {
  const info = Paths.info(root.uri,safePath(path));
  return !info.exists ? null : info.isDirectory ? directory(path) : file(path);
}
const transfer = createBoundedMediaTransfer(expoFetch,async path=>{
  const output=file(path);output.create();
  const handle=output.open();
  return {write:bytes=>handle.writeBytes(bytes),close:()=>handle.close()};
});
const port: MediaPort = {
  async list(path){const dir=directory(path);return dir.exists?dir.list().map(item=>item.name):[];},
  async exists(path){return entry(path)!==null;},
  async mkdir(path){directory(path).create({intermediates:true,idempotent:true});},
  async size(path){return file(path).size;},
  async read(path){return file(path).bytes();},
  async write(path,bytes){file(path).write(bytes);},
  async remove(path){entry(path)?.delete();},
  async move(from,to){const source=entry(from);if(!source)throw Error('Media staging file is missing.');source.move(source instanceof Directory?directory(to):file(to));},
  uri:path=>file(path).uri,
  async sha256(bytes){
    const digest=await Crypto.digest(Crypto.CryptoDigestAlgorithm.SHA256,new Uint8Array(bytes));
    return Array.from(new Uint8Array(digest),byte=>byte.toString(16).padStart(2,'0')).join('');
  },
  async transfer(url,path,maxBytes,progress){
    // Keep a small margin for the manifest and native filesystem metadata.
    if(Paths.availableDiskSpace < maxBytes+1024*1024) throw Error('Device storage is full. Free space and retry.');
    return transfer(url,path,maxBytes,progress);
  },
};
const service=createRecipeMediaService(port);
export const downloadRecipeMedia=service.downloadRecipeMedia;
export const getRecipeMediaStatus=service.getRecipeMediaStatus;
export const removeRecipeMedia=service.removeRecipeMedia;
export const getDownloadedUri=service.getDownloadedUri;
