import { useEffect, useState } from 'react';
import { Image, Text, View } from 'react-native';
import { downloadRecipeMedia, getRecipeMediaStatus, getDownloadedUri, removeRecipeMedia, type RecipeMediaStatus } from '../services/media/recipeMedia';
import { ActionButton } from '../components/ActionButton';
import { colors } from '../theme';
import fixture from './mediaFixture.json';
import * as Notifications from 'expo-notifications';
import { timerPermission } from '../services/timer/notifications';
const testId = 'lu2-native-media-test';
export function MediaTestPanel() {
  const [status, setStatus] = useState<RecipeMediaStatus | null>(null); const [uri, setUri] = useState<string | null>(null);
  const [busy, setBusy] = useState(false); const [error, setError] = useState('');
  const [alerts, setAlerts] = useState('');
  async function alertTest(delay: boolean) {
    try {
      if (!await timerPermission(true)) throw new Error('Notification permission is disabled.');
      await Notifications.scheduleNotificationAsync({ identifier: delay ? 'lu2-native-delayed-test' : 'lu2-native-immediate-test',
        content: { title: 'Lu2 native alert test', body: delay ? 'Ten-second native alert' : 'Immediate native alert', sound: 'default', data: { lu2Test: true } },
        trigger: delay ? { type: Notifications.SchedulableTriggerInputTypes.DATE, date: Date.now() + 10000, channelId: 'cooking-timers' } : { channelId: 'cooking-timers' },
      });
      setAlerts(delay ? 'Ten-second alert scheduled.' : 'Immediate alert sent.');
    } catch (e) { setError(String(e)); }
  }
  async function readAlerts() {
    const [scheduled, presented] = await Promise.all([Notifications.getAllScheduledNotificationsAsync(), Notifications.getPresentedNotificationsAsync()]);
    setAlerts(JSON.stringify({ scheduled: scheduled.map((n) => ({ id: n.identifier, data: n.content.data })), presented: presented.map((n) => ({ id: n.request.identifier, title: n.request.content.title })) }));
  }
  async function refresh() {
    setStatus(await getRecipeMediaStatus(testId));
    const asset = fixture.assets[0] as { url: string } | undefined;
    setUri(asset ? await getDownloadedUri(testId, asset.url) : null);
  }
  useEffect(() => { void refresh().catch((e) => setError(String(e))); }, []);
  async function run(remove: boolean) {
    if (busy) return; setBusy(true); setError('');
    try {
      if (remove) await removeRecipeMedia(testId); else await downloadRecipeMedia(testId, fixture.assets);
      await refresh();
    } catch (e) { setError(e instanceof Error ? e.message : String(e)); }
    finally { setBusy(false); }
  }
  return <View style={{ gap: 12, padding: 16 }}><Text style={{ color: colors.ink, fontSize: 22 }}>Native media fixture</Text>
    <Text accessibilityLabel={`Media test result ${JSON.stringify(status)}`} style={{ color: colors.ink }}>{JSON.stringify(status)}</Text>
    {!!error && <Text accessibilityRole="alert" style={{ color: colors.error }}>{error}</Text>}
    {uri && <Image source={{ uri }} style={{ width: 240, height: 90, resizeMode: 'contain' }} accessibilityLabel="Verified cached Lu2 logo" />}
    <ActionButton disabled={busy} label="Download media fixture" onPress={() => void run(false)} />
    <ActionButton secondary disabled={busy} label="Remove media fixture" onPress={() => void run(true)} />
    <Text accessibilityLabel={`Native alert result ${alerts}`} style={{ color: colors.ink }}>{alerts}</Text>
    <ActionButton label="Send immediate alert test" onPress={() => void alertTest(false)} />
    <ActionButton label="Schedule ten-second alert test" onPress={() => void alertTest(true)} />
    <ActionButton secondary label="Read native alert status" onPress={() => void readAlerts().catch((e) => setError(String(e)))} />
  </View>;
}
