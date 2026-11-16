export const GOOGLE_CALLBACK='luto://auth/callback';
const MAX_FLOW_AGE_MS=10*60*1000;
export interface PendingGoogleFlow {flowId:string;verifier:string;createdAt:number}
interface Dependencies {
 now:()=>number;randomBytes:()=>Promise<Uint8Array>;sha256:(text:string)=>Promise<string>;
 read:()=>Promise<PendingGoogleFlow|null>;write:(value:PendingGoogleFlow|null)=>Promise<void>;
 browser:(url:string,callback:string)=>Promise<{type:string;url?:string}>;
 exchange:(code:string,verifier:string)=>Promise<any>;save:(session:any)=>Promise<void>;
}
export function base64Url(bytes:Uint8Array):string {
 const alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';let result='',bits=0,value=0;
 for(const byte of bytes){value=(value<<8)|byte;bits+=8;while(bits>=6){bits-=6;result+=alphabet[(value>>>bits)&63];}}
 if(bits)result+=alphabet[(value<<(6-bits))&63];return result;
}
export function parseGoogleCallback(input:string):{code?:string;error?:string}{
 if(input.length>4096)throw new Error('Invalid sign-in callback');
 let url:URL;try{url=new URL(input);}catch{throw new Error('Invalid sign-in callback');}
 if(url.protocol!=='luto:'||url.hostname!=='auth'||url.pathname!=='/callback'||url.username||url.password||url.port)throw new Error('Invalid sign-in callback');
 if(url.hash){const fragment=new URLSearchParams(url.hash.slice(1));if(url.search||!fragment.get('error')||[...fragment.keys()].some(key=>!['error','error_code','error_description'].includes(key)))throw new Error('Invalid sign-in callback');return {error:fragment.get('error')!};}
 const codes=url.searchParams.getAll('code'),errors=url.searchParams.getAll('error');
 if(codes.length>1||errors.length>1||(codes.length&&errors.length))throw new Error('Invalid sign-in callback');
 if(errors.length)return {error:errors[0]};
 const code=codes[0];if(!code||code.length>2048||!/^[-A-Za-z0-9._~]+$/.test(code))throw new Error('Invalid sign-in callback');
 return {code};
}
export function createGoogleAuth(deps:Dependencies,projectUrl:string){
 let browserActive=false,epoch=0;let queue:Promise<unknown>=Promise.resolve();const inFlight=new Map<string,Promise<any>>();
 async function clearIfCurrent(flowId:string){const current=await deps.read();if(current?.flowId===flowId)await deps.write(null);}
 function complete(input:string):Promise<any|null>{
  let parsed:ReturnType<typeof parseGoogleCallback>;try{parsed=parseGoogleCallback(input);}catch(error){return Promise.reject(error);}
  const key=parsed.code??'provider-error';const existing=inFlight.get(key);if(existing)return existing;
  const generation=epoch;
  const task=queue.then(async()=>{
   const pending=await deps.read();if(!pending)return null;
   if(!/^[A-Za-z0-9_-]{43,128}$/.test(pending.verifier)||!/^[-A-Za-z0-9_]{43}$/.test(pending.flowId)||!Number.isFinite(pending.createdAt)||deps.now()-pending.createdAt>MAX_FLOW_AGE_MS||deps.now()<pending.createdAt){await deps.write(null);throw new Error('Sign-in expired. Start again.');}
   // Consume before exchange: a cold restart or duplicate deep link cannot redeem it twice.
   await deps.write(null);
   if(parsed.error)throw new Error('Google sign-in was not completed. Please try again.');
   // Auth verifies that this code belongs to the random S256 verifier for THIS flow.
   const session=await deps.exchange(parsed.code!,pending.verifier);
   if(generation!==epoch)return null;
   if(!session?.user?.id||!session.access_token||!session.refresh_token)throw new Error('Invalid sign-in response');
   await deps.save(session);return session.user;
  });
  inFlight.set(key,task);queue=task.catch(()=>{});
  void task.finally(()=>inFlight.delete(key)).catch(()=>{});return task;
 }
 async function signIn():Promise<any|null>{
  if(browserActive||inFlight.size)throw new Error('A sign-in is already in progress.');
  browserActive=true;const generation=epoch;let flow:PendingGoogleFlow|undefined;
  try {
   flow={flowId:base64Url(await deps.randomBytes()),verifier:base64Url(await deps.randomBytes()),createdAt:deps.now()};
   if(!/^[A-Za-z0-9_-]{43,128}$/.test(flow.verifier))throw new Error('Secure sign-in randomness unavailable');
   const challenge=await deps.sha256(flow.verifier);if(!/^[A-Za-z0-9_-]{43}$/.test(challenge))throw new Error('Secure sign-in challenge unavailable');
   if(generation!==epoch)return null;
   await deps.write(flow);
   if(generation!==epoch)return null;
   const authorize=new URL(`${projectUrl}/auth/v1/authorize`);authorize.searchParams.set('provider','google');authorize.searchParams.set('redirect_to',GOOGLE_CALLBACK);authorize.searchParams.set('code_challenge',challenge);authorize.searchParams.set('code_challenge_method','s256');
   const result=await deps.browser(authorize.href,GOOGLE_CALLBACK);
   if(result.type!=='success'||!result.url)return null;
   return await complete(result.url);
  }finally{if(flow)await clearIfCurrent(flow.flowId);browserActive=false;}
 }
 async function cancel(){epoch++;await deps.write(null);}
 return {signIn,complete,cancel};
}
