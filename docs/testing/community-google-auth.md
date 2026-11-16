# Google sign-in without paid email or a purchased domain

Implemented native Google OAuth using Expo WebBrowser and Supabase PKCE. This path does not send email or depend on SMTP. A free `*.vercel.app` support/privacy site can provide public app information; the native OAuth callback remains the custom app URL below. No domain purchase or paid email service is required by this implementation.

## Exports ready for the app

From `apps/mobile/src/services/community/index.ts`:

- `signInWithGoogle(): Promise<CommunityUser | null>` opens the system auth browser after checking provider enablement. User cancellation returns `null`.
- `completeGoogleSignIn(fullOriginalUrl): Promise<CommunityUser | null>` handles a callback route, including cold app launches. Pass the original URL with its query; never log it. A replay with no pending flow returns `null`.
- `isGoogleAvailable(): Promise<boolean>` and `getAuthCapabilities(): Promise<{ google: boolean; email: boolean; emailDeliveryVerified: false }>` read only the public Auth settings. They do not start sign-in or send mail. `email:true` means the provider is enabled, not that a public sender works.
- Existing email-code/link APIs remain for team addresses or optional future SMTP. Guest browsing remains available.

## Exact provider configuration

1. In the user's Google Cloud account, create/select the Luto project and configure the Google Auth Platform audience/consent screen with basic `openid`, email and profile scopes. Add intended test users while the application is in Testing mode.
2. Create an OAuth **Web application** client for this browser-through-Supabase flow. Set its authorized redirect URI to exactly:

   `https://jhkexctlzxyrumfopdcx.supabase.co/auth/v1/callback`

3. Enter that Google Client ID and Client Secret privately in [Luto's Supabase Google provider settings](https://supabase.com/dashboard/project/jhkexctlzxyrumfopdcx/auth/providers?provider=Google), then enable Google. Do not paste the secret into chat, app source, build variables exposed to clients, or documentation.
4. In [Luto Auth URL configuration](https://supabase.com/dashboard/project/jhkexctlzxyrumfopdcx/auth/url-configuration), add this exact additional redirect URL:

   `luto://auth/callback`

   The Android/iOS app must register the `luto` scheme and its callback route. Do not use a wildcard callback. The support site's Site URL can be the eventual free Vercel URL; the native request explicitly overrides redirect destination with the exact custom callback.

This implementation uses the browser OAuth client and Supabase callback; it does not use Google's native ID-token SDK, so native Google Android/iOS SDK client setup is a separate integration.

## Security behavior

Each attempt generates a fresh 256-bit random verifier and separate internal flow identifier with `expo-crypto`. The S256 challenge is sent to Supabase; the verifier stays in SecureStore. Supabase manages the Google provider's OAuth state; the one-use authorization code must match this local verifier when exchanged at `/auth/v1/token?grant_type=pkce`. Thus the cryptographic request/response binding does not require adding a dynamic state parameter to the exact app callback.

Pending state survives a cold app launch, expires after ten minutes, and is consumed persistently before exchange. Callback handling validates exact scheme/host/path, rejects userinfo/ports, ambiguous codes and implicit access-token fragments. Duplicate concurrent callbacks share one exchange; later replays cannot exchange again. OAuth error messages are replaced with a generic error. A failed exchange does not replace an existing session. Sign-out invalidates an in-progress OAuth exchange, preventing a delayed response from restoring it. Provider errors, browser cancellation, and stale/corrupt pending flows do not store sessions.

Session storage uses native SecureStore; the app verifies the exchanged access token through Auth's `/user` endpoint before storing it. No OAuth secret is included in the application. Auth HTTP calls retain the existing fifteen-second timeout.

## Verification and remaining setup

Executed `node --experimental-strip-types --test tests/community.test.mjs tests/community-oauth.test.mjs`: **17 passed**, including nine OAuth cases: PKCE encoding/challenge, exact callback rejection, cancellation, persisted cold callback, expiration, replay/concurrency, exchange failure, provider denial, and sign-out during exchange. Typecheck also passed.

Public Luto `/auth/v1/settings` now returns **`google:true`, `email:true`**. The approved web client is configured privately in Supabase, with the exact native redirect allowlisted and the free support site https://lu2-cooking.vercel.app as Site URL. No purchased domain or SMTP service is used.

On November 16, 2026, after the owner explicitly approved public Google sign-in, Google Auth Platform was switched from Testing to **In production** for project `still-bank-514902-a8`. The Audience page confirmed External / In production. The test-user allowlist no longer restricts basic profile/email sign-in. This changes OAuth availability; it is not Google Play publication or a claim of Google brand verification. A second, non-test Google account has not yet been exercised on-device. Evidence: ignored device artifact `google-audience-production.jpg`.

The initial native attempt authenticated but showed a false callback failure because a stale initial Linking URL was interpreted as the current callback. The route now uses current router parameters, waits for hydration, and ignores stale codes/error fragments. Four route regression tests pass alongside the nine PKCE tests. After the corrected APK was installed, the owner confirmed a fresh Google sign-in, “Welcome to Lu2,” and return to the signed-in community page on November 15, 2026. The complete mobile suite passed 91 tests and strict TypeScript before this device retry.

References: [Supabase Google sign-in](https://supabase.com/docs/guides/auth/social-sign-in/auth-google), [Supabase native deep linking](https://supabase.com/docs/guides/auth/native-mobile-deep-linking), [official auth-js PKCE implementation](https://github.com/supabase/auth-js/blob/master/src/GoTrueClient.ts), [Expo SDK 54 WebBrowser source](https://github.com/expo/expo/blob/sdk-54/packages/expo-web-browser/src/WebBrowser.ts).
