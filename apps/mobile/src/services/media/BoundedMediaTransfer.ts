interface Sink { write(bytes: Uint8Array): void; close(): void }
type MediaFetch = (url: string, init: {signal: AbortSignal; redirect: 'error'; credentials: 'omit'}) => Promise<Pick<Response,'ok'|'status'|'headers'|'body'>>;
/** Bounds writes even when Content-Length is missing or false. Redirects never leave the approved URL. */
export function createBoundedMediaTransfer(fetchMedia: MediaFetch, open: (path: string) => Promise<Sink>) {
  return async (url: string, path: string, maxBytes: number, progress?: (bytes: number)=>void) => {
    const controller = new AbortController();
    const timeout = setTimeout(()=>controller.abort(),60_000);
    let reader: ReadableStreamDefaultReader<Uint8Array> | undefined;
    let sink: Sink | undefined;
    try {
      const response = await fetchMedia(url,{signal:controller.signal,redirect:'error',credentials:'omit'});
      if (!response.ok) throw Error(`Media download failed: HTTP ${response.status}.`);
      const length = response.headers.get('Content-Length');
      if (length !== null && (!/^\d+$/.test(length) || Number(length) !== maxBytes)) throw Error('Media response size does not match expected size.');
      if (!response.body) throw Error('Media download stream is unavailable.');
      reader=response.body.getReader(); sink=await open(path);
      let received=0;
      while (true) {
        const {done,value}=await reader.read(); if(done) break;
        if (received+value.byteLength>maxBytes) throw Error('Media exceeded the expected size.');
        sink.write(value);received+=value.byteLength;progress?.(received);
      }
      if(received!==maxBytes) throw Error('Media download ended before expected size.');
      return {mimeType:response.headers.get('Content-Type')??''};
    } finally {
      clearTimeout(timeout);controller.abort();
      try {await reader?.cancel();} catch { /* The failed stream may already be closed. */ }
      reader?.releaseLock();sink?.close();
    }
  };
}
