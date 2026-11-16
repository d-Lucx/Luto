import { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useURL } from 'expo-linking';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { completeGoogleSignIn, getCurrentUser } from '../../src/services/community';
import { ActionButton } from '../../src/components/ActionButton';
import { colors } from '../../src/theme';
import { callbackFromRoute } from '../../src/services/community/callbackRoute';
export default function AuthCallback() {
  const url = useURL(); const router = useRouter();
  const params = useLocalSearchParams<Record<string, string | string[]>>();
  const callback = useMemo(() => {
    try { return { url: callbackFromRoute(url, params), invalid: false }; }
    catch { return { url: null, invalid: true }; }
  }, [url, params.code, params.error, params.error_code, params.error_description, params.access_token, params.refresh_token, params.id_token, params['#']]);
  const [ready, setReady] = useState(false); const [error, setError] = useState('');
  useEffect(() => {
    if (callback.invalid) { setError('This sign-in callback is invalid. Start again from the community page.'); return; }
    let active = true;
    setError('');
    void (async () => {
      try {
        const user = (callback.url ? await completeGoogleSignIn(callback.url) : null) ?? await getCurrentUser();
        if (!callback.url && !user) return; // Router is still hydrating; no false failure.
        if (!user) throw new Error('Sign-in was not completed.');
        if (active) { setReady(true); setError(''); }
      } catch { if (active) setError('Sign-in could not be completed. Return to the community page and try again.'); }
    })();
    return () => { active = false; };
  }, [callback]);
  return <SafeAreaView style={{ flex: 1, backgroundColor: colors.paper, padding: 24, justifyContent: 'center' }}><View style={{ width: '100%', maxWidth: 600, alignSelf: 'center', gap: 20 }}>
    <Text accessibilityRole="header" style={{ color: colors.ink, fontSize: 28 }}>{ready ? 'Welcome to Lu2' : 'Completing sign-in'}</Text>
    {!ready && !error && <ActivityIndicator color={colors.accent} />}
    {!!error && <Text accessibilityRole="alert" style={{ color: colors.error, fontSize: 17 }}>{error}</Text>}
    <ActionButton label="Continue to community" onPress={() => router.replace('/community')} />
  </View></SafeAreaView>;
}
