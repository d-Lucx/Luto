import { useEffect, useState } from 'react';
import { ActivityIndicator, Linking, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { ActionButton } from '../src/components/ActionButton';
import { colors, headingFont } from '../src/theme';
import { archiveRecipe, getAuthCapabilities, getCurrentUser, getRecipe, listMySubmissions, listPublished, sendEmailCode, signInWithGoogle, signOut, verifyEmailCode, type CommunityRecipe, type CommunityUser } from '../src/services/community';
import { cacheCommunityRecipe } from '../src/database/communityRecipes';
import { updateCookbook } from '../src/database/cookbook';

export default function CommunityScreen() {
  const router = useRouter();
  const [user, setUser] = useState<CommunityUser | null>(null);
  const [email, setEmail] = useState(''); const [code, setCode] = useState('');
  const [sent, setSent] = useState(false); const [busy, setBusy] = useState(false);
  const [error, setError] = useState(''); const [message, setMessage] = useState('');
  const [recipes, setRecipes] = useState<CommunityRecipe[]>([]); const [mine, setMine] = useState<CommunityRecipe[]>([]);
  const [loaded, setLoaded] = useState(false); const [more, setMore] = useState(true);
  const [googleEnabled, setGoogleEnabled] = useState(false); const [showEmail, setShowEmail] = useState(false);
  async function run(work: () => Promise<void>) {
    if (busy) return;
    setBusy(true); setError('');
    try { await work(); } catch (e) { setError(e instanceof Error ? e.message : 'Could not connect. Your local cookbook is still available.'); }
    finally { setBusy(false); }
  }
  async function refresh() {
    const results = await listPublished(); setRecipes(results); setMore(results.length >= 40); setLoaded(true);
    setGoogleEnabled((await getAuthCapabilities()).google);
    const current = await getCurrentUser(); setUser(current);
    if (current) setMine(await listMySubmissions());
  }
  useEffect(() => { void run(refresh); }, []);
  async function add(remote: CommunityRecipe) {
    const latest = await getRecipe(remote.id);
    const id = await cacheCommunityRecipe(latest); await updateCookbook(id, { saved: true });
    router.push({ pathname: '/recipes/[id]', params: { id } });
  }
  return <SafeAreaView style={styles.page}><ScrollView contentContainerStyle={styles.content} keyboardShouldPersistTaps="handled">
    <ActionButton secondary label="Back to my cookbook" onPress={() => router.replace('/(tabs)/recipes')} />
    <Text accessibilityRole="header" style={styles.title}>The community table</Text>
    <Text style={styles.body}>Find recipes shared by home cooks. Automated checks do not mean a recipe has been kitchen tested. Add a recipe to keep its text available offline.</Text>
    <ActionButton secondary label="Help and privacy" onPress={() => void Linking.openURL('https://lu2-cooking.vercel.app/privacy').catch(() => setError('Could not open the support site.'))} />
    {!!error && <Text accessibilityRole="alert" style={styles.error}>{error}</Text>}
    {!!message && <Text accessibilityLiveRegion="polite" style={styles.body}>{message}</Text>}
    {busy && <ActivityIndicator color={colors.accent} />}
    <ActionButton secondary disabled={busy} label="Refresh community" onPress={() => void run(refresh)} />
    <View style={styles.card}>
      <Text accessibilityRole="header" style={styles.heading}>{user ? 'Your account' : 'Share your cooking'}</Text>
      {user ? <><Text style={styles.body}>{user.email ?? 'Signed in'}</Text><ActionButton secondary disabled={busy} label="Sign out" onPress={() => void run(async () => { try { await signOut(); } finally { setUser(null); setMine([]); setSent(false); setCode(''); } })} /></>
      : <>
        <Text style={styles.body}>Browsing, saving, pantry, and cooking work as a guest. Sign in to publish, review, or report community recipes.</Text>
        <ActionButton disabled={busy || !googleEnabled} label="Continue with Google" onPress={() => void run(async () => { const signedIn = await signInWithGoogle(); if (signedIn) { setUser(signedIn); setMine(await listMySubmissions()); setMessage('Signed in. Open a local recipe to publish it.'); } })} />
        {!googleEnabled && <Text style={styles.muted}>Google sign-in is being configured. Your offline cookbook is available now.</Text>}
        <ActionButton secondary label={showEmail ? 'Hide email sign-in' : 'Email sign-in options'} onPress={() => setShowEmail(!showEmail)} />
        {showEmail && <>
        <Text style={styles.muted}>Email delivery is currently limited to project-team testing until an email sender is configured.</Text>
        <Text style={styles.body}>Email</Text><TextInput accessibilityLabel="Account email" autoCapitalize="none" keyboardType="email-address" autoComplete="email" value={email} onChangeText={setEmail} style={styles.input} placeholder="you@example.com" placeholderTextColor={colors.muted} />
        <ActionButton disabled={busy || !email.trim()} label={sent ? 'Send another sign-in email' : 'Email me a sign-in code'} onPress={() => void run(async () => { await sendEmailCode(email); setSent(true); setMessage('Check your email for a sign-in code or link.'); })} />
        {sent && <><Text style={styles.body}>Code or sign-in link from your email</Text><TextInput accessibilityLabel="Email sign-in code or link" autoCapitalize="none" autoCorrect={false} value={code} onChangeText={setCode} style={styles.input} placeholderTextColor={colors.muted} placeholder="Paste your code or link" />
          <ActionButton disabled={busy || !code.trim()} label="Sign in" onPress={() => void run(async () => { setUser(await verifyEmailCode(email, code)); setCode(''); setMine(await listMySubmissions()); setMessage('Signed in. Open a local recipe to publish it.'); })} /></>}
        </>}
      </>}
    </View>
    {user && <View style={styles.card}><Text accessibilityRole="header" style={styles.heading}>Your submissions</Text>
      {!mine.length && <Text style={styles.body}>No submissions yet. Create and save a recipe, then publish it from its recipe page.</Text>}
      {mine.map((r) => <View key={r.id} style={styles.card}><Text style={styles.heading}>{r.snapshot.title}</Text><Text style={styles.body}>{r.status === 'pending_review' ? 'Held for review · visible only to you and reviewers' : r.status} · Version {r.version}</Text>
        {!!r.moderation_flags.length && <Text style={styles.body}>{r.moderation_flags.join(', ')}</Text>}
        {r.status !== 'archived' && <ActionButton secondary disabled={busy} label="Archive submission" onPress={() => void run(async () => { await archiveRecipe(r.id); setMine(await listMySubmissions()); setMessage('Submission archived.'); })} />}
      </View>)}
    </View>}
    <Text accessibilityRole="header" style={styles.heading}>Published recipes</Text>
    {loaded && !recipes.length && <Text style={styles.body}>The first page is waiting. New recipes appear here after passing automated checks.</Text>}
    {recipes.map((r) => <View key={r.id} style={styles.card}><Text accessibilityRole="header" style={styles.heading}>{r.snapshot.title}</Text><Text style={styles.body}>{r.snapshot.description}</Text><Text style={styles.muted}>{r.snapshot.servings} servings · {r.snapshot.difficulty} · Community recipe</Text>
      <ActionButton disabled={busy} label={`Add ${r.snapshot.title} to my cookbook`} onPress={() => void run(() => add(r))} />
    </View>)}
    {loaded && more && <ActionButton secondary disabled={busy} label="More recipes" onPress={() => void run(async () => { const next = await listPublished(recipes.length); setRecipes((previous) => [...previous, ...next.filter((r) => !previous.some((p) => p.id === r.id))]); setMore(next.length >= 40); })} />}
  </ScrollView></SafeAreaView>;
}
const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: colors.paper }, content: { width: '100%', maxWidth: 720, alignSelf: 'center', padding: 24, gap: 16, paddingBottom: 40 },
  title: { fontFamily: headingFont, fontSize: 32, color: colors.ink }, heading: { fontFamily: headingFont, fontSize: 24, color: colors.ink },
  body: { color: colors.ink, fontSize: 16, lineHeight: 25 }, muted: { color: colors.muted, fontSize: 14, lineHeight: 22 }, error: { color: colors.error, fontSize: 16, lineHeight: 25 },
  card: { backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 16, gap: 12 },
  input: { minHeight: 52, padding: 14, borderWidth: 1, borderColor: colors.border, borderRadius: 12, color: colors.ink, backgroundColor: colors.paper, fontSize: 16 },
});
