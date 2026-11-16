import * as Notifications from 'expo-notifications';
import { Platform } from 'react-native';
import { Q } from '@nozbe/watermelondb';
import { database } from '../../database';
import { CookingSessionRecord } from '../../database/models';
import type { SessionData } from '../../database/sessions';
import type { CookingTimer } from './TimerManager';
import { SerialQueue } from '../../engine/SerialQueue';
const alertQueue = new SerialQueue();

const channelId = 'cooking-timers';
Notifications.setNotificationHandler({ handleNotification: async () => ({ shouldPlaySound: true,
  shouldSetBadge: false, shouldShowBanner: true, shouldShowList: true }) });

export async function timerPermission(request: boolean): Promise<boolean> {
  if (Platform.OS === 'android') await Notifications.setNotificationChannelAsync(channelId, {
    name: 'Cooking timers', importance: Notifications.AndroidImportance.HIGH, sound: 'default', vibrationPattern: [0, 300, 150, 300],
  });
  let permission = await Notifications.getPermissionsAsync();
  if (!permission.granted && request && permission.canAskAgain) permission = await Notifications.requestPermissionsAsync();
  return permission.granted;
}

export async function syncTimerAlerts(sessionId: string, recipeId: string, title: string, timers: CookingTimer[], request = false): Promise<boolean> {
  return alertQueue.run(sessionId, () => syncLatestAlerts(sessionId, request));
}
async function syncLatestAlerts(sessionId: string, request: boolean, replaceExisting = false): Promise<boolean> {
  const allowed = await timerPermission(request);
  let scheduled = await Notifications.getAllScheduledNotificationsAsync();
  if (replaceExisting) {
    // Existing alarms may have been scheduled before precise alarms were allowed.
    await Promise.all(scheduled.filter((n) => n.content.data.sessionId === sessionId)
      .map((n) => Notifications.cancelScheduledNotificationAsync(n.identifier)));
    scheduled = scheduled.filter((n) => n.content.data.sessionId !== sessionId);
  }
  const row = await database.get<CookingSessionRecord>('cooking_sessions').find(sessionId);
  const data = JSON.parse(row.payload) as SessionData;
  const timers = row.status === 'active' ? data.timers : [];
  const wanted = new Set(timers.filter((t) => t.status === 'running' && t.targetEndTimeMs && t.targetEndTimeMs > Date.now()).map((t) => `lu2-${sessionId}-${t.id}`));
  await Promise.all(scheduled.filter((n) => n.content.data.sessionId === sessionId && !wanted.has(n.identifier)).map((n) => Notifications.cancelScheduledNotificationAsync(n.identifier)));
  for (const timer of timers) {
    const identifier = `lu2-${sessionId}-${timer.id}`;
    const previous = scheduled.find((n) => n.identifier === identifier);
    const deadline = timer.status === 'running' ? timer.targetEndTimeMs : null;
    if (previous && (!allowed || !deadline || previous.content.data.deadline !== deadline))
      await Notifications.cancelScheduledNotificationAsync(identifier);
    if (allowed && deadline && deadline > Date.now() && (!previous || previous.content.data.deadline !== deadline)) {
      await Notifications.scheduleNotificationAsync({ identifier,
        content: { title: `${data.title}: timer finished`, body: `${timer.label} is ready. Check your food.`, sound: 'default',
          data: { lu2: true, sessionId, recipeId: row.recipeId, deadline } },
        trigger: { type: Notifications.SchedulableTriggerInputTypes.DATE, date: deadline, channelId },
      });
    }
  }
  return allowed;
}

export async function cancelSessionAlerts(sessionId: string): Promise<void> {
  return alertQueue.run(sessionId, async () => {
  const alerts = await Notifications.getAllScheduledNotificationsAsync();
  await Promise.all(alerts.filter((a) => a.content.data.sessionId === sessionId).map((a) => Notifications.cancelScheduledNotificationAsync(a.identifier)));
  });
}

export async function reconcileAlerts(): Promise<void> {
  const rows = await database.get<CookingSessionRecord>('cooking_sessions').query(Q.where('status', 'active')).fetch();
  const ids = new Set(rows.map((r) => r.id));
  const scheduled = await Notifications.getAllScheduledNotificationsAsync();
  await Promise.all(scheduled.filter((n) => n.content.data.lu2 && !ids.has(String(n.content.data.sessionId)))
    .map((n) => Notifications.cancelScheduledNotificationAsync(n.identifier)));
  for (const row of rows) {
    await alertQueue.run(row.id, () => syncLatestAlerts(row.id, false, true));
  }
}
