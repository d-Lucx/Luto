import { GOOGLE_CALLBACK, parseGoogleCallback } from './googleCore.ts';

/** Router query data is current; Linking's initial URL can belong to an earlier screen. */
export function callbackFromRoute(_observed: string | null, params: Record<string, string | string[] | undefined>): string | null {
  for (const key of ['code', 'error', 'error_code', 'error_description', '#']) {
    if (Array.isArray(params[key])) throw new Error('Ambiguous sign-in callback.');
  }
  if (params.access_token !== undefined || params.refresh_token !== undefined || params.id_token !== undefined)
    throw new Error('Implicit sign-in tokens are not accepted.');
  const fragment = params['#'];
  if (typeof fragment === 'string' && fragment) {
    if (params.code || params.error) throw new Error('Ambiguous sign-in callback.');
    const callback = `${GOOGLE_CALLBACK}#${fragment}`;
    parseGoogleCallback(callback);
    return callback;
  }
  if (!params.code && !params.error) return null;
  const query = new URLSearchParams();
  for (const key of ['code', 'error', 'error_code', 'error_description']) {
    const value = params[key];
    if (typeof value === 'string') query.set(key, value);
  }
  const callback = `${GOOGLE_CALLBACK}?${query}`;
  parseGoogleCallback(callback);
  return callback;
}
