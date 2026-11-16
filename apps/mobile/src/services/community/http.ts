export async function fetchWithTimeout(input:string,init:RequestInit={},timeoutMs=15000):Promise<Response>{
 const controller=new AbortController();const timeout=setTimeout(()=>controller.abort(),timeoutMs);
 try{return await fetch(input,{...init,signal:controller.signal});}
 catch(error){if(controller.signal.aborted)throw new Error('The connection timed out. Please retry.');throw error;}
 finally{clearTimeout(timeout);}
}
