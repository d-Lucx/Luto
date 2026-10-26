// ==============================================================================
// LUTO (Logo: Lu2) — Offline Media Manager
// Target: Local Cache Management for Recipe Photos & Technique Video Loops
// ==============================================================================

export interface CachedMediaItem {
  remoteUrl: string;
  localUri: string;
  sizeBytes: number;
  mimeType: string;
  accessSeq: number;
  downloadedAt: number;
}

export class OfflineMediaManager {
  private static cacheIndex: Map<string, CachedMediaItem> = new Map();
  private static maxCacheSizeBytes: number = 250 * 1024 * 1024; // 250 MB default cap
  private static accessSequenceCounter: number = 0;

  public static setMaxCacheSize(bytes: number): void {
    this.maxCacheSizeBytes = Math.max(1, bytes);
  }

  public static getMaxCacheSize(): number {
    return this.maxCacheSizeBytes;
  }

  public static getTotalCachedBytes(): number {
    let sum = 0;
    for (const item of this.cacheIndex.values()) {
      sum += item.sizeBytes;
    }
    return sum;
  }

  public static getCachedCount(): number {
    return this.cacheIndex.size;
  }

  public static isCached(remoteUrl: string): boolean {
    if (!remoteUrl) return false;
    return this.cacheIndex.has(remoteUrl);
  }

  public static getLocalUri(remoteUrl: string): string | null {
    const item = this.cacheIndex.get(remoteUrl);
    if (!item) return null;
    item.accessSeq = ++this.accessSequenceCounter;
    return item.localUri;
  }

  /**
   * Deterministically generates a sanitized filename for offline storage
   */
  public static generateLocalFilename(remoteUrl: string): string {
    const clean = remoteUrl.split('?')[0] || '';
    const ext = clean.includes('.') ? clean.substring(clean.lastIndexOf('.')) : '.media';
    let hash = 0;
    for (let i = 0; i < remoteUrl.length; i++) {
      hash = ((hash << 5) - hash) + remoteUrl.charCodeAt(i);
      hash |= 0;
    }
    const safeHash = Math.abs(hash).toString(36);
    return `media_${safeHash}${ext}`;
  }

  /**
   * Registers a successfully downloaded media asset in the offline index
   */
  public static registerMedia(
    remoteUrl: string,
    localUri: string,
    sizeBytes: number,
    mimeType: string = 'image/webp'
  ): CachedMediaItem {
    const currentTotal = this.getTotalCachedBytes();
    const needed = (currentTotal + sizeBytes) - this.maxCacheSizeBytes;

    if (needed > 0) {
      this.evictLRU(needed);
    }

    const item: CachedMediaItem = {
      remoteUrl,
      localUri,
      sizeBytes,
      mimeType,
      accessSeq: ++this.accessSequenceCounter,
      downloadedAt: Date.now(),
    };

    this.cacheIndex.set(remoteUrl, item);
    return item;
  }

  /**
   * Evicts least recently used media files until required bytes are freed
   */
  public static evictLRU(bytesToFree: number): number {
    let freedBytes = 0;
    const sorted = Array.from(this.cacheIndex.values()).sort(
      (a, b) => a.accessSeq - b.accessSeq
    );

    for (const item of sorted) {
      if (freedBytes >= bytesToFree) break;
      this.cacheIndex.delete(item.remoteUrl);
      freedBytes += item.sizeBytes;
    }

    return freedBytes;
  }

  public static clearCache(): void {
    this.cacheIndex.clear();
    this.accessSequenceCounter = 0;
  }
}
