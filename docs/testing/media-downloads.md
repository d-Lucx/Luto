# Verified recipe media: implementation and native checks

The production entry point is `apps/mobile/src/services/media/recipeMedia.ts`. Its async API is:

- `downloadRecipeMedia(recipeId, assets, onProgress?)` returns `{ state, totalBytes, assetCount, error? }`.
- `getRecipeMediaStatus(recipeId)` verifies persisted files and returns that status.
- `getDownloadedUri(recipeId, remoteUrl)` returns a verified app-private file URI or `null`.
- `removeRecipeMedia(recipeId)` deletes the recipe bundle and its failure metadata.

Each asset must provide `{ url, sha256, sizeBytes, mimeType }` from a trusted recipe/media manifest. SHA256 must be the server's expected 64-character hexadecimal digest of the actual file bytes. Do not compute an expected digest from a fresh download, invent a digest, or use a URL hash as an integrity value. Current bundled recipe URLs have no trustworthy digest metadata, so their media downloads remain explicitly unavailable. Saving recipe text remains a separate action and must not set the media download state.

The caller must supply the complete hero and step asset bundle. The service cannot infer omitted assets from a recipe ID. Use every available hero/step URL with its matching trusted metadata; if required metadata is missing, explain the unavailable bundle rather than silently omitting that asset. A downloaded result establishes media availability for the supplied bundle; complete recipe readiness additionally requires durable recipe text and ingredients.

Supported MIME types are JPEG, PNG, WebP, and MP4. The service validates URL, expected size, response Content-Type, file signature, and SHA256 before committing a bundle. Downloads use HTTPS without credentials and reject redirects, userinfo, literal IP hosts, local host names, and nonstandard ports. DNS resolution remains the platform's responsibility; trusted manifests should use approved public media hosts.

Files live in `Paths.document/recipe-media-v1`. Recipe IDs are SHA256-derived directory keys; no remote filenames or manifest-provided filesystem paths are used. Transfers write to a staging directory and publish it only after every file verifies. A failed transfer deletes staging files; initialization removes abandoned staging after process death. Existing committed bundles remain readable after a failed replacement. The final directory move publishes a complete bundle, although interruption between removing an old bundle and moving its replacement can leave no bundle; readiness is always rechecked from disk. Retries restart the transfer rather than resuming untrusted partial bytes.

The maximum is 50 MiB per file and 250 MiB of media across committed and staged bundles. Downloads serialize storage reservations. A replacement needs room for its staging bytes alongside the previous bundle. No automatic eviction occurs: the user explicitly removes downloads to free space, so another download cannot silently evict pinned or saved media. Native transfers check free device space with a 1 MiB margin and bound disk writes while streaming even without Content-Length. HTTP errors, wrong sizes, interruption, and integrity failures produce failed status with retry guidance. If a full device also prevents writing failure metadata, the caller still receives the failed result; after restart the absent bundle remains not downloaded. Each transfer aborts after 60 seconds. Verification reads one bounded file at a time into memory for Expo Crypto; native memory/performance measurements remain required.

`OfflineMediaManager.ts` remains a deprecated in-memory compatibility helper for legacy tests. It does not download, persist, delete physical files, or establish offline readiness. Runtime screens should use `recipeMedia.ts`.

## Automated evidence

Run from repository root:

```powershell
node --experimental-strip-types --test apps/mobile/tests/media*.test.mjs
npm --prefix apps/mobile run typecheck
npm --prefix apps/mobile test
```

The media tests exercise real temporary filesystem files and Node SHA256 through the same service port used by the native adapter. Controlled byte fixtures are original synthetic test data; no remote media is fetched. Coverage includes persisted restart/removal, hash/size/MIME/signature failures, corrupt on-disk files, partial bundle cleanup, interrupted transfer/restart cleanup, retry, cap preservation, concurrent reservations, bounded stream writes, HTTP errors, and stream cancellation. They do not execute Expo native modules.

## Android device acceptance gate (not yet executed)

1. Supply a controlled HTTPS endpoint and trusted manifest for an original or licensed hero image and step clip. Check displayed progress, then verify both returned file URIs render locally.
2. Restart in airplane mode; confirm downloaded status and both assets. Confirm text remains usable if either local file is removed or corrupted.
3. Interrupt a transfer by losing connectivity, backgrounding, and killing the process. Restart; confirm no partial asset is served, staging is reclaimed, and retry downloads a complete bundle.
4. Exercise wrong digest, wrong size, wrong Content-Type, HTML instead of image bytes, HTTP error, redirect, stalled response, and stream overflow. Confirm useful failure states and no committed partial bundle.
5. Fill app media close to 250 MiB and exhaust device free storage separately. Confirm refusal, readable existing bundles, explicit removal reclaiming physical storage, then successful retry. Verify replacement headroom behavior.
6. Remove a downloaded recipe's media, restart, and confirm text stays saved while media shows not downloaded. Confirm no account or network is required to read/remove downloaded content.
7. Measure peak memory and verification latency with a 50 MiB clip and a realistic full cookbook on a named Android reference device. Rebuild the development client after adding native Expo modules.

Native offline playback, filesystem atomic move behavior, cancellation under process death, storage-full behavior, and Android performance require these device checks before release.
