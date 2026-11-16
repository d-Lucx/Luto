import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { ActivityIndicator, AppState, Platform, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter, useFocusEffect } from 'expo-router';
import { SafeAreaView } from 'react-native-safe-area-context';
import { activateKeepAwakeAsync, deactivateKeepAwake } from 'expo-keep-awake';
import { TimerManager, type CookingTimer } from '../../src/services/timer/TimerManager';
import { cancelSessionAlerts, syncTimerAlerts } from '../../src/services/timer/notifications';
import { openAlarmSettings } from '../../src/services/timer/alarmSettings';
import { finishSession, getSession, saveSession, startOrResumeSession, undoSession, type Session } from '../../src/database/sessions';
import { CookedItModal } from '../../src/components/CookedItModal';
import { colors } from '../../src/theme';
import { basics } from '../../src/content/basics';
import { ActionButton } from '../../src/components/ActionButton';
import { StepMedia } from '../../src/components/StepMedia';

export default function CookingModeScreen() {
  const { id, sessionId } = useLocalSearchParams<{ id: string; sessionId?: string }>();
  const router = useRouter();
  const [session, setSession] = useState<Session | null>(null);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');
  const [busy, setBusy] = useState(false);
  const guard = useRef(false);
  const alarmSettingsPending = useRef(false);
  const loadedSession = useRef<{ recipeId: string; id: string } | null>(null);
  const [step, setStep] = useState(0);
  const [completion, setCompletion] = useState(false);
  const [expandedTerms, setExpandedTerms] = useState<Set<string>>(new Set());
  const [timers, setTimers] = useState<CookingTimer[]>([]);
  const manager = useMemo(() => new TimerManager(), []);
  useFocusEffect(useCallback(() => {
    void activateKeepAwakeAsync('lu2-cooking').catch(() => {});
    return () => deactivateKeepAwake('lu2-cooking');
  }, []));
  useEffect(() => {
    manager.startClock();
    const unsub = manager.subscribe((all) => setTimers([...all]));
    return () => { unsub(); manager.stopClock(); };
  }, [manager]);
  useFocusEffect(useCallback(() => {
    let active = true;
    async function refresh() {
      if (guard.current) return;
      try {
        const persistedId = sessionId ?? (loadedSession.current?.recipeId === id ? loadedSession.current.id : undefined);
        const loaded = persistedId ? await getSession(persistedId) : await startOrResumeSession(id);
        if (loaded.recipeId !== id) throw new Error('This session belongs to a different recipe.');
        if (active) { loadedSession.current = { recipeId: id, id: loaded.id }; setSession(loaded); setStep(loaded.data.stepIndex); manager.restore(loaded.data.timers); }
        if (active && loaded.status === 'active') {
          try {
            // Replace a previously inexact alarm after visiting the system page.
            if (alarmSettingsPending.current) {
              alarmSettingsPending.current = false;
              await cancelSessionAlerts(loaded.id);
            }
            await syncTimerAlerts(loaded.id, id, loaded.data.title, loaded.data.timers, false);
          } catch { if (active) setNotice('Timers are saved, but alerts could not be scheduled. Keep this screen open or pause and resume your timer to try again.'); }
        }
      } catch (e) { if (active) setError(e instanceof Error ? e.message : 'Could not restore cooking.'); }
    }
    void refresh();
    const listener = AppState.addEventListener('change', (state) => { if (state === 'active') void refresh(); });
    return () => { active = false; listener.remove(); };
  }, [id, sessionId, manager]));
  async function configureAlarms() {
    alarmSettingsPending.current = true;
    try {
      await openAlarmSettings();
    } catch {
      alarmSettingsPending.current = false;
      setNotice('Could not open alarm settings. Open Android Settings, find Luto under Alarms & reminders, and allow it. Then return here or pause and resume your timer.');
    }
  }
  async function timerAction(action: 'start' | 'pause' | 'reset', timerId: string) {
    if (!session || guard.current) return;
    guard.current = true; setBusy(true); setError('');
    const before = manager.getAllTimers().map((t) => ({ ...t }));
    try {
      if (action === 'start') manager.startTimer(timerId);
      else if (action === 'pause') manager.pauseTimer(timerId);
      else manager.resetTimer(timerId);
      const snapshot = manager.getAllTimers().map((t) => ({ ...t }));
      await saveSession(session.id, { timers: snapshot });
      try {
        const allowed = await syncTimerAlerts(session.id, id, session.data.title, snapshot, action === 'start');
        setNotice(allowed ? 'Notification permission is enabled. Device battery settings can still affect delivery.' : 'Notifications are off. Keep this screen open to watch your timer.');
      } catch { setNotice('Timer saved; alert could not be scheduled. Keep this screen open.'); }
    } catch (e) { manager.restore(before); setError(e instanceof Error ? e.message : 'Could not save timer.'); }
    finally { guard.current = false; setBusy(false); }
  }
  async function changeStep(next: number) {
    if (!session || guard.current) return;
    guard.current = true; setBusy(true);
    try { await saveSession(session.id, { stepIndex: next }); setStep(next); setError(''); }
    catch { setError('Your step could not be saved. Try again.'); }
    finally { guard.current = false; setBusy(false); }
  }
  async function complete({ deductIngredientIds }: { deductIngredientIds: string[] }) {
    if (!session) throw new Error('No session loaded.');
    await finishSession(session.id, deductIngredientIds);
    setSession(await getSession(session.id)); manager.restore([]);
    await cancelSessionAlerts(session.id).catch(() => setNotice('Cooking saved; an old alert may remain until restart.'));
  }
  async function undo() {
    if (!session || guard.current) return;
    guard.current = true; setBusy(true);
    try { await undoSession(session.id); setSession(await getSession(session.id)); setError(''); }
    catch (e) { setError(e instanceof Error ? e.message : 'Could not undo.'); }
    finally { guard.current = false; setBusy(false); }
  }
  const leave = () => router.canGoBack() ? router.back() : router.replace('/(tabs)/recipes');
  const button = (label: string, action: () => void, disabled = false) => <Pressable accessibilityRole="button" accessibilityState={{ disabled }} disabled={disabled} style={styles.nextBtn} onPress={action}><Text style={styles.nextBtnText}>{label}</Text></Pressable>;
  if (!session) return <SafeAreaView style={styles.loadingContainer}>{error ? <Text accessibilityRole="alert" style={styles.errorText}>{error}</Text> : <ActivityIndicator color={colors.accent} />}{button('Back to recipes', leave)}</SafeAreaView>;
  const current = session.data.steps[step];
  const timer = timers.find((t) => t.stepNumber === current?.stepNumber);
  return <SafeAreaView style={styles.screen}>
    <View style={styles.header}><Pressable accessibilityRole="button" style={styles.exitBtn} onPress={leave}><Text style={styles.exitBtnText}>Save & exit</Text></Pressable><Text numberOfLines={1} style={styles.headerTitle}>{session.data.title}</Text><Text style={styles.stepProgress}>{step + 1} / {session.data.steps.length}</Text></View>
    <ScrollView contentContainerStyle={styles.content}>
      <Text style={styles.loadingText}>{session.data.servings} servings · Progress saved on this device</Text>
      {!!error && <Text accessibilityRole="alert" style={styles.errorText}>{error}</Text>}
      {!!notice && <Text accessibilityLiveRegion="polite" style={styles.loadingText}>{notice}</Text>}
      {session.status !== 'active' ? <View style={styles.stepCard}>
        <Text accessibilityRole="header" style={styles.instructionText}>{session.status === 'undone' ? 'Pantry update undone' : 'Cooking completed'}</Text>
        <Text style={styles.loadingText}>{session.status === 'undone' ? 'Consumed ingredients were added back to your current pantry.' : 'This session is saved. Reopening it will never deduct ingredients again.'}</Text>
        {session.status === 'completed' && session.data.consumed.length > 0 && button('Undo pantry deduction', () => void undo(), busy)}
        {button('Back to recipes', leave)}
      </View> : <View style={styles.stepCard}>
        <Text style={styles.stepLabel}>STEP {current?.stepNumber}</Text><Text style={styles.instructionText}>{current?.instruction}</Text>
        <StepMedia recipeId={id} url={current?.mediaUrl} mimeType={current?.mimeType} />
        {basics.filter((term) => (current?.instruction ?? '').normalize('NFKD').replace(/\p{M}/gu, '').toLowerCase().includes(term.slug)).map((term) => <View key={term.slug} style={{ gap: 8, marginTop: 16 }}><Pressable accessibilityRole="button" accessibilityState={{ expanded: expandedTerms.has(term.slug) }} style={{ minHeight: 48, justifyContent: 'center' }} onPress={() => setExpandedTerms((previous) => { const next = new Set(previous); if (next.has(term.slug)) next.delete(term.slug); else next.add(term.slug); return next; })}><Text style={styles.timerLabel}>What does {term.title.toLowerCase()} mean?</Text></Pressable>{expandedTerms.has(term.slug) && <Text style={styles.loadingText}>{term.summary}</Text>}</View>)}
        <ActionButton secondary label="Technique explainers" onPress={() => router.push('/techniques')} />
        {timer && <View style={styles.timerBox}><Text style={styles.timerLabel}>{timer.label}</Text><Text style={styles.timerDigits} accessibilityLabel={timer.remainingSeconds + ' seconds remaining'}>{TimerManager.formatTime(timer.remainingSeconds)}</Text>
          {timer.status === 'completed' && <Text accessibilityRole="alert" style={styles.loadingText}>Timer finished. Check your food.</Text>}
          <View style={styles.timerControls}>{timer.status !== 'completed' && button(timer.status === 'running' ? 'Pause timer' : timer.status === 'paused' ? 'Resume timer' : 'Start timer', () => void timerAction(timer.status === 'running' ? 'pause' : 'start', timer.id), busy)}{button('Reset timer', () => void timerAction('reset', timer.id), busy)}</View>
          {Platform.OS === 'android' && Number(Platform.Version) >= 31 && <View style={{ alignSelf: 'stretch', marginTop: 16, gap: 12 }}>
            <Text style={styles.loadingText}>For precise alerts, allow Alarms &amp; reminders in Android settings. Device battery settings can still affect delivery.</Text>
            <ActionButton secondary disabled={busy} label="Android alarm settings" onPress={() => void configureAlarms()} />
          </View>}
        </View>}
      </View>}
    </ScrollView>
    {session.status === 'active' && <View style={styles.footer}>{button('Previous', () => void changeStep(step - 1), busy || step === 0)}{step < session.data.steps.length - 1 ? button('Next step', () => void changeStep(step + 1), busy) : button('Finish cooking', () => setCompletion(true), busy)}</View>}
    {completion && <CookedItModal visible recipeTitle={session.data.title} durationMinutes={Math.max(1, Math.round((Date.now() - session.data.startedAt) / 60000))} ingredients={session.data.ingredients} onClose={() => setCompletion(false)} onConfirm={complete} />}
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.paper,
  },
  loadingContainer: {
    flex: 1,
    backgroundColor: colors.paper,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    color: colors.muted,
    marginTop: 12,
    fontSize: 16,
  },
  errorText: {
    color: colors.error,
    fontSize: 18,
    marginBottom: 16,
  },
  backButton: {
    minHeight: 48,
    padding: 12,
    backgroundColor: colors.surface,
    borderRadius: 8,
  },
  backButtonText: {
    color: colors.ink,
    fontWeight: '600',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderColor: colors.border,
  },
  exitBtn: {
    minHeight: 48,
    justifyContent: 'center',
    paddingVertical: 6,
    paddingHorizontal: 10,
    borderRadius: 8,
    backgroundColor: colors.surface,
  },
  exitBtnText: {
    color: colors.muted,
    fontWeight: '700',
    fontSize: 14,
  },
  headerTitle: {
    flex: 1,
    marginHorizontal: 12,
    textAlign: 'center',
    color: colors.ink,
    fontSize: 16,
    fontWeight: '700',
  },
  stepProgress: {
    color: colors.accent,
    fontSize: 14,
    fontWeight: '800',
  },
  content: {
    flexGrow: 1,
    padding: 24,
    justifyContent: 'center',
  },
  stepCard: {
    backgroundColor: colors.surface,
    borderRadius: 24,
    padding: 28,
    borderWidth: 1,
    borderColor: colors.border,
  },
  stepLabel: {
    color: colors.accent,
    fontSize: 15,
    fontWeight: '800',
    letterSpacing: 2,
    marginBottom: 14,
  },
  instructionText: {
    color: colors.ink,
    fontSize: 25,
    lineHeight: 38,
    fontWeight: '600',
  },
  timerBox: {
    marginTop: 28,
    backgroundColor: colors.paper,
    borderRadius: 16,
    padding: 20,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.border,
  },
  timerLabel: {
    color: colors.muted,
    fontSize: 13,
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  timerDigits: {
    color: colors.accent,
    fontSize: 52,
    fontWeight: '900',
    fontVariant: ['tabular-nums'],
    marginVertical: 8,
  },
  timerControls: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  timerStartBtn: {
    minHeight: 48,
    backgroundColor: colors.accent,
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  timerPauseBtn: {
    minHeight: 48,
    backgroundColor: colors.accent,
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  timerResetBtn: {
    minHeight: 48,
    backgroundColor: colors.inset,
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
  },
  timerBtnText: {
    color: colors.onAccent,
    fontWeight: '700',
    fontSize: 14,
  },
  timerBtnTextSecondary: {
    color: colors.muted,
    fontWeight: '600',
    fontSize: 14,
  },
  footer: {
    flexDirection: 'row',
    padding: 20,
    borderTopWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.paper,
    gap: 14,
  },
  navBtn: {
    flex: 1,
    paddingVertical: 16,
    backgroundColor: colors.surface,
    borderRadius: 14,
    alignItems: 'center',
  },
  navBtnDisabled: {
    opacity: 0.35,
  },
  navBtnText: {
    color: colors.ink,
    fontSize: 16,
    fontWeight: '700',
  },
  nextBtn: {
    flex: 1.5,
    paddingVertical: 16,
    backgroundColor: colors.accent,
    borderRadius: 14,
    alignItems: 'center',
  },
  nextBtnText: {
    color: colors.onAccent,
    fontSize: 17,
    fontWeight: '800',
  },
  finishBtn: {
    flex: 1.5,
    paddingVertical: 16,
    backgroundColor: colors.accent,
    borderRadius: 14,
    alignItems: 'center',
  },
  finishBtnText: {
    color: colors.onAccent,
    fontSize: 17,
    fontWeight: '800',
  },
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.7)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  techniqueModal: {
    width: '100%',
    backgroundColor: colors.surface,
    borderRadius: 20,
    padding: 24,
    borderWidth: 1,
    borderColor: colors.accent,
  },
  techniqueBadge: {
    color: colors.accent,
    fontSize: 12,
    fontWeight: '800',
    letterSpacing: 1.5,
  },
  techniqueTitle: {
    color: colors.ink,
    fontSize: 22,
    fontWeight: '800',
    marginVertical: 8,
  },
  techniqueSummary: {
    color: colors.ink,
    fontSize: 15,
    lineHeight: 22,
    marginBottom: 20,
  },
  modalCloseBtn: {
    minHeight: 48,
    backgroundColor: colors.accent,
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: 'center',
  },
  modalCloseText: {
    color: colors.onAccent,
    fontWeight: '700',
    fontSize: 15,
  },
});
