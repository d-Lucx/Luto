import * as SecureStore from 'expo-secure-store';
import * as Crypto from 'expo-crypto';
import * as WebBrowser from 'expo-web-browser';
import {createGoogleAuth} from './googleCore';
import type {PendingGoogleFlow} from './googleCore';
import {fetchWithTimeout} from './http';
import { COMMUNITY_URL, COMMUNITY_PUBLISHABLE_KEY } from './config';
import type {CommunityRecipe,CommunityUser,CommunityDictionary,CommunityReview,RecipeSnapshot} from './types';
export type {CommunityRecipe,CommunityUser,CommunityDictionary,CommunityReview,RecipeSnapshot} from './types';
type Session = {access_token:string;refresh_token:string;expires_at:number;user:CommunityUser};
const SESSION_KEY='luto.community.session.v1';
let session:Session|null|undefined;
let refreshing:Promise<Session|null>|null=null;
async function loadSession(){if(session===undefined){const saved=await SecureStore.getItemAsync(SESSION_KEY);try{session=saved?JSON.parse(saved):null;}catch{session=null;await SecureStore.deleteItemAsync(SESSION_KEY);}}return session??null;}
async function saveSession(value:Session|null){session=value;if(value)await SecureStore.setItemAsync(SESSION_KEY,JSON.stringify(value));else await SecureStore.deleteItemAsync(SESSION_KEY);}
async function auth(path:string,body?:unknown,token?:string){const r=await fetchWithTimeout(`${COMMUNITY_URL}/auth/v1/${path}`,{method:body===undefined?'GET':'POST',headers:{apikey:COMMUNITY_PUBLISHABLE_KEY,'Content-Type':'application/json',...(token?{Authorization:`Bearer ${token}`}:{})},...(body===undefined?{}:{body:JSON.stringify(body)})});const data=await r.json().catch(()=>({}));if(!r.ok)throw new Error(data.msg??data.error_description??data.message??'Sign in failed. Try again.');return data;}
function normalizeSession(data:any):Session {if(!data.access_token||!data.refresh_token||!data.user?.id)throw new Error('Invalid authentication response');return {...data,expires_at:data.expires_at??Math.floor(Date.now()/1000)+(data.expires_in??3600)};}
async function activeSession(){const current=await loadSession();if(!current||current.expires_at>Date.now()/1000+60)return current;if(!refreshing)refreshing=(async()=>{try{const next=normalizeSession(await auth('token?grant_type=refresh_token',{refresh_token:current.refresh_token}));await saveSession(next);return next;}catch(error){/* A transient outage must not erase the refresh token. */throw error;}finally{refreshing=null;}})();return refreshing;}
export async function sendEmailCode(email:string){await auth('otp',{email:email.trim(),create_user:true});}
export async function verifyEmailCode(email:string,code:string){
 let value:any;const input=code.trim();
 if(/^https:\/\//i.test(input)){
  const link=new URL(input);if(link.origin!==COMMUNITY_URL||link.pathname!=='/auth/v1/verify')throw new Error('Use the sign-in link sent by Luto.');
  const fragment=new URLSearchParams(link.hash.slice(1));
  // Already redeemed links may contain a session. Validate the user with Auth before storing.
  if(fragment.get('access_token')&&fragment.get('refresh_token')){const access=fragment.get('access_token')!;value={access_token:access,refresh_token:fragment.get('refresh_token'),expires_in:Number(fragment.get('expires_in')??3600),user:await auth('user',undefined,access)};}
  else {const hash=link.searchParams.get('token_hash')??link.searchParams.get('token');const type=link.searchParams.get('type');if(!hash||!['email','magiclink','signup'].includes(type??''))throw new Error('This email link has no usable sign-in token. Request another email.');value=await auth('verify',{token_hash:hash,type});}
 }else value=await auth('verify',{email:email.trim(),token:input,type:'email'});
 const verified=normalizeSession(value);await saveSession(verified);return verified.user;
}
export async function signOut(){await googleFlow.cancel();const current=await loadSession();try{if(current)await auth('logout',{},current.access_token);}finally{await saveSession(null);}}
export async function getCurrentUser():Promise<CommunityUser|null>{const current=await activeSession();if(!current)return null;try{return await auth('user',undefined,current.access_token);}catch(error){throw error;}}
async function request<T>(action:string,payload:Record<string,unknown>={},required=false):Promise<T>{const current=await activeSession().catch(error=>{if(required)throw error;return null;});if(required&&!current)throw new Error('Sign in to share with the community.');const r=await fetchWithTimeout(`${COMMUNITY_URL}/functions/v1/community`,{method:'POST',headers:{apikey:COMMUNITY_PUBLISHABLE_KEY,'Content-Type':'application/json',...(current?{Authorization:`Bearer ${current.access_token}`}:{})},body:JSON.stringify({action,...payload})});const data=await r.json().catch(()=>({}));if(!r.ok)throw new Error(data.error??'Community service unavailable. Please retry.');return data;}
export const listPublished=(offset=0)=>request<CommunityRecipe[]>('list',{offset});
export const getRecipe=(id:string)=>request<CommunityRecipe>('get',{id});
export const getDictionary=()=>request<CommunityDictionary>('dictionary');
export const listMySubmissions=()=>request<CommunityRecipe[]>('mine',{},true);
export const submitRecipe=(localId:string,snapshot:RecipeSnapshot)=>request<CommunityRecipe>('submit',{localId,snapshot},true);
export const archiveRecipe=(id:string)=>request<CommunityRecipe>('archive',{id},true);
export const reportRecipe=(id:string,reason:string)=>request<{ok:boolean}>('report',{id,reason},true);
export const submitReview=(id:string,rating:number,reviewText='')=>request<CommunityReview>('review',{id,rating,reviewText},true);
export const listReviews=(id:string)=>request<CommunityReview[]>('reviews',{id});
export const getModerationQueue=()=>request<CommunityRecipe[]>('moderationQueue',{},true);
export const moderateRecipe=(id:string,decision:'published'|'archived',reason:string)=>request<CommunityRecipe>('moderate',{id,decision,reason},true);

const GOOGLE_PENDING_KEY='luto.community.google-pkce.v1';
const googleFlow=createGoogleAuth({
 now:()=>Date.now(),randomBytes:()=>Crypto.getRandomBytesAsync(32),
 sha256:async(verifier)=>(await Crypto.digestStringAsync(Crypto.CryptoDigestAlgorithm.SHA256,verifier,{encoding:Crypto.CryptoEncoding.BASE64})).replace(/\+/g,'-').replace(/\//g,'_').replace(/=+$/,''),
 read:async()=>{const raw=await SecureStore.getItemAsync(GOOGLE_PENDING_KEY);if(!raw)return null;try{return JSON.parse(raw) as PendingGoogleFlow;}catch{await SecureStore.deleteItemAsync(GOOGLE_PENDING_KEY);return null;}},
 write:async(value)=>{if(value)await SecureStore.setItemAsync(GOOGLE_PENDING_KEY,JSON.stringify(value));else await SecureStore.deleteItemAsync(GOOGLE_PENDING_KEY);},
 browser:(url,callback)=>WebBrowser.openAuthSessionAsync(url,callback),
 exchange:async(code,verifier)=>{const value=normalizeSession(await auth('token?grant_type=pkce',{auth_code:code,code_verifier:verifier}));const verified=await auth('user',undefined,value.access_token);if(verified.id!==value.user.id||verified.is_anonymous)throw new Error('Sign-in could not be verified.');return {...value,user:verified};},
 save:async(value)=>saveSession(normalizeSession(value)),
},COMMUNITY_URL);
export interface AuthCapabilities {google:boolean;email:boolean;emailDeliveryVerified:false}
/** Public Auth settings confirm provider enablement, not SMTP delivery or OAuth end-to-end success. */
export async function getAuthCapabilities():Promise<AuthCapabilities>{const settings=await auth('settings');return {google:settings.external?.google===true,email:settings.external?.email===true,emailDeliveryVerified:false};}
export async function isGoogleAvailable():Promise<boolean>{return (await getAuthCapabilities()).google;}
export async function signInWithGoogle():Promise<CommunityUser|null>{if(!(await isGoogleAvailable()))throw new Error('Google sign-in is not configured for Luto yet.');return googleFlow.signIn();}
/** Call with the complete original deep link, including its query, from Expo Router's callback route. */
export async function completeGoogleSignIn(url:string):Promise<CommunityUser|null>{return googleFlow.complete(url);}
