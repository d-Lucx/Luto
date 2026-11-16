import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useEffect } from 'react';
import { useRouter } from 'expo-router';
import * as Notifications from 'expo-notifications';
import { reconcileAlerts } from '../src/services/timer/notifications';
import { ensureLearningLibrary } from '../src/database/learningLibrary';

export default function RootLayout() {
  const router = useRouter();
  useEffect(() => {
    void ensureLearningLibrary().catch((error) => console.warn('Learning library could not be loaded', error));
    void reconcileAlerts().catch((error) => console.warn('Timer notification reconciliation failed', error));
    const open = (response: Notifications.NotificationResponse | null) => {
      const data = response?.notification.request.content.data;
      if (data?.lu2 && typeof data.recipeId === 'string' && typeof data.sessionId === 'string') {
        router.push({ pathname: '/cook/[id]', params: { id: data.recipeId, sessionId: data.sessionId } });
        void Notifications.clearLastNotificationResponseAsync();
      }
    };
    void Notifications.getLastNotificationResponseAsync().then(open);
    const subscription = Notifications.addNotificationResponseReceivedListener(open);
    return () => subscription.remove();
  }, [router]);
  return <SafeAreaProvider>
    <StatusBar style="dark" />
    <Stack screenOptions={{ headerShown: false }} />
  </SafeAreaProvider>;
}
