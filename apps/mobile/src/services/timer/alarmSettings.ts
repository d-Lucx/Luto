import { Linking, Platform } from 'react-native';
import * as IntentLauncher from 'expo-intent-launcher';

/** Open the system page; Android owns the permission decision. */
export async function openAlarmSettings(): Promise<void> {
  if (Platform.OS === 'android') {
    if (Number(Platform.Version) < 31) return;
    await IntentLauncher.startActivityAsync('android.settings.REQUEST_SCHEDULE_EXACT_ALARM', {
      data: 'package:com.luto.app',
    });
    return;
  }
  await Linking.openSettings();
}
