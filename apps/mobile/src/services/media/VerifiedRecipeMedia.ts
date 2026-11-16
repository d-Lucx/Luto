/** Byte-verified recipe bundles. All paths are generated locally; manifests never contain paths. */
export interface RecipeMediaAsset { url: string; sha256: string; sizeBytes: number; mimeType: string }
export interface RecipeMediaStatus { state: 'not_downloaded' | 'downloaded' | 'failed' | 'unavailable'; totalBytes: number; assetCount: number; error?: string }
export interface MediaProgress { receivedBytes: number; totalBytes: number }
export interface MediaPort {
  list(path: string): Promise<string[]>; exists(path: string): Promise<boolean>;
  mkdir(path: string): Promise<void>; size(path: string): Promise<number>; read(path: string): Promise<Uint8Array>;
  write(path: string, bytes: Uint8Array): Promise<void>; remove(path: string): Promise<void>;
  move(from: string, to: string): Promise<void>; uri(path: string): string;
  sha256(bytes: Uint8Array): Promise<string>;
  /** Must bound bytes while streaming, enforce HTTPS on redirects, and cancel on failure. */
  transfer(url: string, path: string, maxBytes: number, onProgress?: (bytes: number) => void): Promise<{mimeType: string}>;
}
const FILE_LIMIT = 50 * 1024 * 1024;
const TOTAL_LIMIT = 250 * 1024 * 1024;
const encoder = new TextEncoder();
const decoder = new TextDecoder();
const kinds = ['image/jpeg', 'image/png', 'image/webp', 'video/mp4'];
export function validateMediaAsset(asset: RecipeMediaAsset): void {
  if (!asset || !/^[a-fA-F0-9]{64}$/.test(asset.sha256 ?? '')) throw Error('Media unavailable: trusted SHA256 metadata is missing.');
  let url: URL;
  try { url = new URL(asset.url); } catch { throw Error('Media URL is invalid.'); }
  const host = url.hostname.toLowerCase();
  if (url.protocol !== 'https:' || url.username || url.password || url.hash || (url.port && url.port !== '443') || !host.includes('.') || host.includes(':') || /^[\d.]+$/.test(host) || /(^|\.)(localhost|local|internal|test)$/.test(host)) throw Error('Media requires a public HTTPS URL.');
  if (!Number.isSafeInteger(asset.sizeBytes) || asset.sizeBytes <= 0 || asset.sizeBytes > FILE_LIMIT) throw Error('Media size is unavailable or exceeds the 50 MB file limit.');
  if (!kinds.includes(asset.mimeType)) throw Error('Media format is unavailable.');
}
function signature(bytes: Uint8Array, mime: string): boolean {
  const ascii = (start: number, end: number) => String.fromCharCode(...bytes.slice(start,end));
  if (mime === 'image/jpeg') return bytes[0]===255 && bytes[1]===216 && bytes[2]===255;
  if (mime === 'image/png') return bytes.slice(0,8).join(',')==='137,80,78,71,13,10,26,10';
  if (mime === 'image/webp') return ascii(0,4)==='RIFF' && ascii(8,12)==='WEBP';
  return mime === 'video/mp4' && ascii(4,8)==='ftyp' && bytes.length>=12;
}
function status(state: RecipeMediaStatus['state'], error?: string): RecipeMediaStatus { return {state,totalBytes:0,assetCount:0,...(error?{error}:{})}; }
export function createRecipeMediaService(port: MediaPort, options: {maxTotalBytes?: number} = {}) {
  const cap = Math.min(TOTAL_LIMIT, options.maxTotalBytes ?? TOTAL_LIMIT);
  let queue: Promise<unknown> = Promise.resolve();
  let initialized = false;
  const serialized = <T>(work: () => Promise<T>): Promise<T> => {
    const result = queue.then(async () => {
      if (!initialized) {
        await port.mkdir('');
        for (const name of await port.list('')) if (/^pending-[a-z0-9-]+$/.test(name)) await port.remove(name);
        initialized = true;
      }
      return work();
    });
    queue = result.catch(() => {}); return result;
  };
  const keyFor = async (recipeId: string) => {
    if (!recipeId || recipeId.length > 512) throw Error('Recipe ID is invalid.');
    return port.sha256(encoder.encode(recipeId));
  };
  async function readManifest(key: string): Promise<RecipeMediaAsset[] | null> {
    if (!await port.exists(`${key}/manifest.json`)) return null;
    if (await port.size(`${key}/manifest.json`) > 100_000) throw Error('Invalid media manifest.');
    const parsed: unknown = JSON.parse(decoder.decode(await port.read(`${key}/manifest.json`)));
    if (!Array.isArray(parsed) || !parsed.length || parsed.length>100) throw Error('Invalid media manifest.');
    for (const item of parsed) validateMediaAsset(item);
    return parsed;
  }
  async function check(key: string): Promise<RecipeMediaStatus> {
    try {
      const assets = await readManifest(key);
      if (!assets) {
        const failure = `${key}.json`;
        if (await port.exists(failure)) {
          const saved = JSON.parse(decoder.decode(await port.read(failure))) as RecipeMediaStatus;
          if (saved.state==='failed' || saved.state==='unavailable') return saved;
        }
        return status('not_downloaded');
      }
      for (const [index, asset] of assets.entries()) {
        if (await port.size(`${key}/${index}.media`) !== asset.sizeBytes) throw Error('Downloaded media size verification failed.');
        const bytes = await port.read(`${key}/${index}.media`);
        if (bytes.length !== asset.sizeBytes || !signature(bytes,asset.mimeType) || await port.sha256(bytes) !== asset.sha256.toLowerCase()) throw Error('Downloaded media is missing or failed integrity verification. Download it again.');
      }
      return {state:'downloaded', totalBytes:assets.reduce((sum,a)=>sum+a.sizeBytes,0),assetCount:assets.length};
    } catch (e) { return status('failed', e instanceof Error ? e.message : 'Media verification failed.'); }
  }
  async function saveFailure(key: string, value: RecipeMediaStatus) {
    const temp = `pending-${key}-state`;
    try {
      await port.write(temp,encoder.encode(JSON.stringify(value)));
      await port.remove(`${key}.json`);
      await port.move(temp,`${key}.json`);
    } catch {
      // A full device may also prevent failure metadata writes. Return the
      // actionable failure to the caller; no downloaded manifest was published.
      // Any partial metadata staging is reclaimed on the next launch.
    }
  }
  return {
    downloadRecipeMedia(recipeId: string, assets: RecipeMediaAsset[], onProgress?: (progress: MediaProgress)=>void) {
      return serialized(async () => {
        const key = await keyFor(recipeId); const stage = `pending-${key}`;
        try {
          if (!Array.isArray(assets) || !assets.length || assets.length>100) throw Error('Media unavailable: no verified asset bundle was supplied.');
          assets.forEach(validateMediaAsset);
          if (new Set(assets.map(a=>a.url)).size!==assets.length) throw Error('Media bundle contains duplicate URLs.');
        } catch(e) {
          const value=status('unavailable',e instanceof Error?e.message:'Media unavailable.');
          if (!await port.exists(key)) await saveFailure(key,value);
          return value;
        }
        assets = assets.map(asset => ({...asset}));
        const total = assets.reduce((sum,a)=>sum+a.sizeBytes,0);
        try {
          let occupied = 0;
          for (const name of await port.list('')) {
            if (/^[a-f0-9]{64}$/.test(name)) {
              // Count physical bytes, including corrupt bundles, rather than trusting manifests.
              for (const file of await port.list(name)) if (/^\d+\.media$/.test(file)) occupied += await port.size(`${name}/${file}`);
            }
          }
          if (occupied + total > cap) throw Error('Offline media storage is full. Remove a downloaded recipe and retry.');
          await port.remove(stage); await port.mkdir(stage);
          let received = 0;
          for (const [index,asset] of assets.entries()) {
            const path=`${stage}/${index}.media`;
            const result=await port.transfer(asset.url,path,asset.sizeBytes,bytes=>onProgress?.({receivedBytes:received+bytes,totalBytes:total}));
            const bytes=await port.read(path);
            if (result.mimeType.toLowerCase().split(';')[0]?.trim()!==asset.mimeType || bytes.length!==asset.sizeBytes || !signature(bytes,asset.mimeType)) throw Error('Media size or format verification failed.');
            if (await port.sha256(bytes)!==asset.sha256.toLowerCase()) throw Error('Media SHA256 integrity verification failed.');
            received+=bytes.length; onProgress?.({receivedBytes:received,totalBytes:total});
          }
          await port.write(`${stage}/manifest.json`,encoder.encode(JSON.stringify(assets)));
          await port.remove(key); await port.move(stage,key); await port.remove(`${key}.json`);
          return {state:'downloaded' as const,totalBytes:total,assetCount:assets.length};
        } catch(e) {
          await port.remove(stage);
          const value=status('failed',e instanceof Error?e.message:'Media download failed.');
          if (!await port.exists(key)) await saveFailure(key,value);
          return value;
        }
      });
    },
    getRecipeMediaStatus(recipeId: string) {return serialized(async()=>check(await keyFor(recipeId)));},
    removeRecipeMedia(recipeId: string) {return serialized(async()=>{const key=await keyFor(recipeId);await port.remove(key);await port.remove(`${key}.json`);});},
    getDownloadedUri(recipeId: string, url: string) {return serialized(async()=>{
      const key=await keyFor(recipeId); if ((await check(key)).state!=='downloaded') return null;
      const assets=await readManifest(key); const index=assets?.findIndex(a=>a.url===url)??-1;
      return index<0?null:port.uri(`${key}/${index}.media`);
    });},
  };
}
