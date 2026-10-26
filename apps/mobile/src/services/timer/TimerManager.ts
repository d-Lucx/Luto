// ==============================================================================
// LUTO (Logo: Lu2) — Multi-Timer Concurrent Kitchen Engine
// Target: Accurate Wall-Clock Kitchen Timers Resilient to App Sleep
// ==============================================================================

export type TimerStatus = 'idle' | 'running' | 'paused' | 'completed';

export interface CookingTimer {
  id: string;
  stepNumber: number;
  label: string;
  totalDurationSeconds: number;
  remainingSeconds: number;
  status: TimerStatus;
  targetEndTimeMs: number | null;
  pausedRemainingSeconds: number | null;
}

export type TimerChangeListener = (timers: CookingTimer[]) => void;

export class TimerManager {
  private timers: Map<string, CookingTimer> = new Map();
  private intervalHandle: any = null;
  private listeners: Set<TimerChangeListener> = new Set();

  constructor() {
    this.startClock();
  }

  public subscribe(listener: TimerChangeListener): () => void {
    this.listeners.add(listener);
    listener(this.getAllTimers());
    return () => {
      this.listeners.delete(listener);
    };
  }

  private notify(): void {
    const all = this.getAllTimers();
    for (const listener of this.listeners) {
      listener(all);
    }
  }

  private startClock(): void {
    if (this.intervalHandle) return;
    this.intervalHandle = setInterval(() => {
      this.tick();
    }, 500);
  }

  public stopClock(): void {
    if (this.intervalHandle) {
      clearInterval(this.intervalHandle);
      this.intervalHandle = null;
    }
  }

  private tick(): void {
    const now = Date.now();
    let hasChanged = false;

    for (const timer of this.timers.values()) {
      if (timer.status === 'running' && timer.targetEndTimeMs !== null) {
        const remaining = Math.max(0, Math.ceil((timer.targetEndTimeMs - now) / 1000));
        if (remaining !== timer.remainingSeconds) {
          timer.remainingSeconds = remaining;
          hasChanged = true;
        }

        if (remaining === 0) {
          timer.status = 'completed';
          timer.targetEndTimeMs = null;
          hasChanged = true;
        }
      }
    }

    if (hasChanged) {
      this.notify();
    }
  }

  public createTimer(id: string, stepNumber: number, label: string, durationSeconds: number): CookingTimer {
    const timer: CookingTimer = {
      id,
      stepNumber,
      label,
      totalDurationSeconds: durationSeconds,
      remainingSeconds: durationSeconds,
      status: 'idle',
      targetEndTimeMs: null,
      pausedRemainingSeconds: null,
    };
    this.timers.set(id, timer);
    this.notify();
    return timer;
  }

  public startTimer(id: string): CookingTimer | null {
    const timer = this.timers.get(id);
    if (!timer) return null;

    const duration = timer.pausedRemainingSeconds !== null ? timer.pausedRemainingSeconds : timer.remainingSeconds;
    if (duration <= 0) return timer;

    timer.status = 'running';
    timer.targetEndTimeMs = Date.now() + duration * 1000;
    timer.pausedRemainingSeconds = null;
    this.notify();
    return timer;
  }

  public pauseTimer(id: string): CookingTimer | null {
    const timer = this.timers.get(id);
    if (!timer || timer.status !== 'running') return null;

    const now = Date.now();
    const remaining = Math.max(0, Math.ceil(((timer.targetEndTimeMs || now) - now) / 1000));
    timer.status = 'paused';
    timer.remainingSeconds = remaining;
    timer.pausedRemainingSeconds = remaining;
    timer.targetEndTimeMs = null;
    this.notify();
    return timer;
  }

  public resetTimer(id: string): CookingTimer | null {
    const timer = this.timers.get(id);
    if (!timer) return null;

    timer.status = 'idle';
    timer.remainingSeconds = timer.totalDurationSeconds;
    timer.pausedRemainingSeconds = null;
    timer.targetEndTimeMs = null;
    this.notify();
    return timer;
  }

  public deleteTimer(id: string): boolean {
    const deleted = this.timers.delete(id);
    if (deleted) this.notify();
    return deleted;
  }

  public getTimer(id: string): CookingTimer | undefined {
    return this.timers.get(id);
  }

  public getAllTimers(): CookingTimer[] {
    return Array.from(this.timers.values()).sort((a, b) => a.stepNumber - b.stepNumber);
  }

  public static formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    const pad = (n: number) => (n < 10 ? `0${n}` : `${n}`);
    return `${pad(mins)}:${pad(secs)}`;
  }
}
