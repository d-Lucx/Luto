export interface RecipeSnapshot {
  title: string; description: string; category: string; difficulty: 'easy'|'medium'|'hard'|'expert';
  prepTimeMinutes: number; cookTimeMinutes: number; servings: number; heroImageUrl?: string; cuisineTags: string[];
  mediaAssets: {url:string;sha256:string;sizeBytes:number;mimeType:string}[];
  ingredients: { canonicalName: string; name: string; amount: number; unit: string; displayText?: string; isOptional: boolean; tier: 'critical'|'important'|'optional'; ingredientId?: string }[];
  equipment: {canonicalName:string; name:string; isRequired:boolean; notes?:string; equipmentId?:string}[];
  steps: {title?:string; instruction:string; timerDurationSeconds:number; timerLabel?:string; isCritical:boolean; techniqueSlugs:string[]; mediaUrl?:string; mediaType?:'image'|'video'|'gif'}[];
}
function text(value: unknown, max: number, required = false): string {
  if (typeof value !== 'string' || value.length > max || (required && !value.trim())) throw new Error('Invalid recipe text');
  return value.trim();
}
function optional(value: unknown,max:number) {return value == null ? undefined : text(value,max);}
function number(value:unknown,min:number,max:number) {if(typeof value!=='number'||!Number.isFinite(value)||value<min||value>max)throw new Error('Invalid recipe quantity or time');return value;}
function list(value:unknown,max:number,min=0): any[] {if(!Array.isArray(value)||value.length<min||value.length>max)throw new Error('Invalid recipe list');return value;}
export function canonical(value: unknown): string {return text(value,150,true).toLowerCase().replace(/[\s-]+/g,'_');}
export async function readBoundedJSON(request:Request,maxBytes=200000):Promise<any>{
 if(Number(request.headers.get('Content-Length')??0)>maxBytes)throw new Error('Recipe is too large');
 const reader=request.body?.getReader();if(!reader)throw new Error('Request body is required');
 const decoder=new TextDecoder('utf-8',{fatal:true});let size=0,body='';
 try {while(true){const {done,value}=await reader.read();if(done)break;size+=value.byteLength;if(size>maxBytes){void reader.cancel().catch(()=>{});throw new Error('Recipe is too large');}body+=decoder.decode(value,{stream:true});}body+=decoder.decode();return JSON.parse(body);}
 finally{reader.releaseLock();}
}
function media(value:unknown) {if(typeof value!=='string'||value.length>2048)return undefined;try {const u=new URL(value);return u.protocol==='https:'&&!u.username&&!u.password?u.href:undefined;}catch{return undefined;}}
export function validateSnapshot(input:unknown): RecipeSnapshot {
  if(!input||typeof input!=='object'||Array.isArray(input))throw new Error('Recipe is required');
  const s=input as any;
  const title=text(s.title,200,true); if(title.length<3)throw new Error('Title must have at least 3 characters');
  if(!['easy','medium','hard','expert'].includes(s.difficulty))throw new Error('Invalid difficulty');
  const servings=number(s.servings,1,100);if(!Number.isInteger(servings))throw new Error('Servings must be whole');
  return {title,description:text(s.description??'',5000),category:text(s.category,50,true),difficulty:s.difficulty,prepTimeMinutes:number(s.prepTimeMinutes,0,10080),cookTimeMinutes:number(s.cookTimeMinutes,0,10080),servings,
    heroImageUrl:media(s.heroImageUrl),cuisineTags:list(s.cuisineTags??[],20).map(v=>text(v,50,true)),
    mediaAssets:list(s.mediaAssets??[],100).map(a=>{const url=media(a.url);if(!url||!/^([a-f0-9]{64})$/i.test(a.sha256)||!['image/jpeg','image/png','image/webp','image/gif','video/mp4'].includes(a.mimeType))throw new Error('Invalid media integrity metadata');return {url,sha256:a.sha256.toLowerCase(),sizeBytes:number(a.sizeBytes,1,52428800),mimeType:a.mimeType};}),
    ingredients:list(s.ingredients,100,1).map(i=>({canonicalName:canonical(i.canonicalName),name:text(i.name,150,true),amount:number(i.amount,0.001,99999),unit:text(i.unit,30,true),displayText:optional(i.displayText,200),isOptional:i.isOptional===true,tier:['critical','important','optional'].includes(i.tier)?i.tier:'important'})),
    equipment:list(s.equipment??[],50).map(i=>({canonicalName:canonical(i.canonicalName),name:text(i.name,100,true),isRequired:i.isRequired!==false,notes:optional(i.notes,200)})),
    steps:list(s.steps,100,1).map(i=>({title:optional(i.title,150),instruction:text(i.instruction,10000,true),timerDurationSeconds:number(i.timerDurationSeconds??0,0,604800),timerLabel:optional(i.timerLabel,100),isCritical:i.isCritical===true,techniqueSlugs:list(i.techniqueSlugs??[],20).map(canonical),mediaUrl:media(i.mediaUrl),mediaType:['image','video','gif'].includes(i.mediaType)?i.mediaType:undefined})),
  };
}
// Conservative automated screening is not a kitchen test or a guarantee of food safety.
export function moderateSnapshot(snapshot: unknown): string[] {
  const corpus=JSON.stringify(snapshot).normalize('NFKC'); const flags:string[]=[];
  if(/\b(bleach|ammonia|detergent|chlorine|drain cleaner|borax|cyanide|mercury)\b|microwave.{0,20}(metal|foil)|deep fry.{0,20}frozen turkey|boil.{0,20}unopened can|unidentified.{0,10}mushroom/i.test(corpus))flags.push('SAFETY_REVIEW');
  if(/https?:\/\/|\b(crypto|casino|viagra|telegram)\b/i.test(corpus.replace(/"(?:heroImageUrl|mediaUrl)":"[^\"]*"/g,'')))flags.push('SPAM_REVIEW');
  if(/\b(fuck|shit|bitch|cunt|asshole|nigger|faggot)\b/i.test(corpus))flags.push('COMMUNITY_REVIEW');
  return flags;
}
