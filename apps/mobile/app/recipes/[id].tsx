import { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useFocusEffect, useLocalSearchParams, useRouter } from 'expo-router';
import { database } from '../../src/database/index';
import { Ingredient, Recipe, RecipeIngredient, RecipeStep } from '../../src/database/models';
import { getRecipeReadiness, type OverviewIngredient } from '../../src/engine/recipeReadiness';
import { colors, headingFont } from '../../src/theme';
import { Q } from '@nozbe/watermelondb';
import { CookingSessionRecord } from '../../src/database/models';
import { useCookbook, updateCookbook } from '../../src/database/cookbook';
import { startOrResumeSession, type SessionData } from '../../src/database/sessions';
import { scaleIngredients } from '../../src/engine/cookingSession';
import { displayQuantity } from '../../src/engine/ingredientDisplay';
import { canEditRecipe } from '../../src/engine/recipePermissions';
import { readDocument } from '../../src/database/documents';
import type { RecipeMetadata } from '../../src/database/recipeMetadata';
import { downloadRecipeMedia, getRecipeMediaStatus, getDownloadedUri, removeRecipeMedia, type RecipeMediaStatus } from '../../src/services/media/recipeMedia';
import { RecipeCommunityActions } from '../../src/components/RecipeCommunityActions';

interface Detail {
  title: string;
  description: string;
  servings: number;
  ingredients: (OverviewIngredient & { id: string; optional: boolean })[];
  steps: { id: string; instruction: string; stepNumber: number }[];
}

export default function RecipeDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [detail, setDetail] = useState<Detail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [attempt, setAttempt] = useState(0);
  const [servings, setServings] = useState(1);
  const [busy, setBusy] = useState(false);
  const [metadata, setMetadata] = useState<RecipeMetadata | null>(null);
  const [media, setMedia] = useState<RecipeMediaStatus | null>(null);
  const [mediaBusy, setMediaBusy] = useState(false);
  const [heroUri, setHeroUri] = useState<string | null>(null);
  const [actionError, setActionError] = useState('');
  const [lastSession, setLastSession] = useState<{ id: string; status: string; servings: number } | null>(null);
  const { entries } = useCookbook();
  const saved = entries.some((entry) => entry.recipeId === id && entry.saved);
  useEffect(() => {
    const sub = database.get<CookingSessionRecord>('cooking_sessions').query(Q.where('recipe_id', id), Q.sortBy('updated_at', Q.desc))
      .observeWithColumns(['status', 'payload']).subscribe({ next: (rows) => {
        const row = rows.find((r) => r.status === 'active') ?? rows[0];
        setLastSession(row ? { id: row.id, status: row.status, servings: (JSON.parse(row.payload) as SessionData).servings } : null);
      }, error: () => setActionError('Could not read cooking progress.') });
    return () => sub.unsubscribe();
  }, [id]);
  async function startCooking() {
    if (busy) return;
    setBusy(true); setActionError('');
    try {
      const session = await startOrResumeSession(id, servings);
      router.push({ pathname: '/cook/[id]', params: { id, sessionId: session.id } });
    } catch (cause) { setActionError(cause instanceof Error ? cause.message : 'Could not start cooking.'); }
    finally { setBusy(false); }
  }
  async function changeMedia(remove = false) {
    if (mediaBusy) return;
    setMediaBusy(true);
    try {
      if (remove) { await removeRecipeMedia(id); setHeroUri(null); }
      else await downloadRecipeMedia(id, metadata?.mediaAssets ?? []);
      setMedia(await getRecipeMediaStatus(id));
      const recipe = await database.get<Recipe>('local_recipes').find(id);
      setHeroUri(await getDownloadedUri(id, recipe.heroImageUrl));
    } catch (cause) { setActionError(cause instanceof Error ? cause.message : 'Could not update media.'); }
    finally { setMediaBusy(false); }
  }

  useFocusEffect(useCallback(() => {
    let active = true;
    setLoading(true);
    setDetail(null);
    setError('');
    async function load() {
      try {
        if (!id) throw new Error('No recipe selected.');
        const recipe = await database.get<Recipe>('local_recipes').find(id);
        const [meta, downloaded] = await Promise.all([readDocument<RecipeMetadata>(`recipe-meta-${id}`), getRecipeMediaStatus(id)]);
        const photo = recipe.heroImageUrl ? await getDownloadedUri(id, recipe.heroImageUrl) : null;
        if (active) { setMetadata(meta); setMedia(downloaded); setHeroUri(photo); }
        const [requirements, steps, dictionary] = await Promise.all([
          recipe.ingredients.fetch(), recipe.steps.fetch(),
          database.get<Ingredient>('ingredients').query().fetch(),
        ]);
        const names = new Map(dictionary.map((item) => [item.id, item.displayName]));
        const result: Detail = {
          title: recipe.title, description: recipe.description, servings: recipe.servings,
          ingredients: requirements.map((item: RecipeIngredient) => ({
            id: item.id, name: names.get(item.ingredientId) ?? null,
            amount: item.amount, unit: item.unit, optional: item.isOptional,
          })),
          steps: steps.map((step: RecipeStep) => ({
            id: step.id, instruction: step.instruction, stepNumber: step.stepNumber,
          })).sort((a, b) => a.stepNumber - b.stepNumber),
        };
        if (active) { setDetail(result); setServings(Number.isFinite(result.servings) && result.servings > 0 ? Math.min(100, Math.max(1, Math.round(result.servings))) : 1); }
      } catch {
        if (active) setError('This recipe could not be opened from your device. Try again or return to the library.');
      } finally {
        if (active) setLoading(false);
      }
    }
    void load();
    return () => { active = false; };
  }, [id, attempt]));

  const readiness = detail ? getRecipeReadiness(detail.ingredients, detail.steps) : null;
  const servingsValid = detail && Number.isFinite(detail.servings) && detail.servings > 0;
  const ready = readiness?.ready && servingsValid;
  const scaled = detail && ready ? scaleIngredients(detail.ingredients, detail.servings, servings) : detail?.ingredients ?? [];

  return <SafeAreaView style={styles.page}>
    <ScrollView contentContainerStyle={styles.content}>
      <Pressable accessibilityRole="button" onPress={() => router.canGoBack() ? router.back() : router.replace('/(tabs)/recipes')}
        style={({ pressed }) => [styles.back, pressed && styles.pressed]}>
        <Text style={styles.backText}>Back to recipes</Text>
      </Pressable>
      {loading ? <View style={styles.state}>
        <ActivityIndicator color={colors.accent} size="large" />
        <Text style={styles.body}>Opening your recipe…</Text>
      </View> : error || !detail ? <View style={styles.state}>
        <Text accessibilityRole="header" style={styles.title}>Recipe unavailable</Text>
        <Text accessibilityRole="alert" style={styles.body}>{error}</Text>
        <Pressable accessibilityRole="button" onPress={() => setAttempt((value) => value + 1)}
          style={({ pressed }) => [styles.button, pressed && styles.pressed]}>
          <Text style={styles.buttonText}>Try again</Text>
        </Pressable>
      </View> : <>
        <Text style={styles.eyebrow}>LU2 · FROM YOUR DEVICE</Text>
        <Text accessibilityRole="header" style={styles.title}>{detail.title}</Text>
        {heroUri && <Image source={{ uri: heroUri }} accessibilityLabel={detail.title} style={{ width: '100%', aspectRatio: 1.5, borderRadius: 12 }} />}
        {!!detail.description && <Text style={styles.body}>{detail.description}</Text>}
        <Text style={styles.meta}>{servingsValid ? `${servings} servings · Recipe base: ${detail.servings}` : 'Serving count unavailable'}</Text>
        <View style={styles.line}>
          <Pressable accessibilityRole="button" accessibilityLabel="Decrease servings" disabled={servings <= 1} style={styles.back} onPress={() => setServings((n) => Math.max(1, n - 1))}><Text style={styles.backText}>− Serving</Text></Pressable>
          <Pressable accessibilityRole="button" accessibilityLabel="Increase servings" disabled={servings >= 100} style={styles.back} onPress={() => setServings((n) => Math.min(100, n + 1))}><Text style={styles.backText}>+ Serving</Text></Pressable>
        </View>
        <Pressable accessibilityRole="button" accessibilityState={{ selected: saved }} style={styles.back} onPress={() => void updateCookbook(id, { saved: !saved }).catch(() => setActionError('Could not save this recipe.'))}><Text style={styles.backText}>{saved ? 'Saved · Remove from saved' : 'Save recipe'}</Text></Pressable>
        {canEditRecipe(id, metadata?.source) && <Pressable accessibilityRole="button" style={styles.back} onPress={() => router.push({ pathname: '/recipes/new', params: { editId: id } })}><Text style={styles.backText}>Edit recipe</Text></Pressable>}
        <Text style={styles.meta}>Recipe text: available offline. Media: {media?.state === 'downloaded' ? `${media.assetCount} files · ${(media.totalBytes / 1048576).toFixed(1)} MB` : media?.error ?? 'not downloaded'}.</Text>
        <Pressable accessibilityRole="button" disabled={mediaBusy} style={styles.back} onPress={() => void changeMedia(media?.state === 'downloaded')}><Text style={styles.backText}>{mediaBusy ? 'Updating media…' : media?.state === 'downloaded' ? 'Remove downloaded media' : 'Download recipe media'}</Text></Pressable>
        {!!actionError && <Text accessibilityRole="alert" style={styles.body}>{actionError}</Text>}
        <View style={styles.section}>
          <Text accessibilityRole="header" style={styles.sectionTitle}>Ingredients</Text>
          {scaled.map((item) => <View key={item.id} style={styles.line}>
            <Text style={styles.ingredient}>{item.name || 'Ingredient name unavailable'}{item.optional ? ' (optional)' : ''}</Text>
            <Text style={styles.quantity}>{Number.isFinite(item.amount) && item.amount > 0 ? displayQuantity(item.amount, item.unit) : 'Quantity unavailable'}</Text>
          </View>)}
        </View>
        <View style={styles.section}>
          <Text accessibilityRole="header" style={styles.sectionTitle}>Before you begin</Text>
          <Text style={styles.body}>Read through the steps and set out your ingredients.</Text>
          {metadata?.equipment?.length ? metadata.equipment.map((item) => <Text key={item.canonicalName} style={styles.body}>{item.name}{item.isRequired ? ' · required' : ' · optional'}{item.notes ? ` — ${item.notes}` : ''}</Text>) : <Text style={styles.meta}>Equipment details are unavailable.</Text>}
          <Text style={styles.meta}>Nutrition per serving is unavailable.</Text>
        </View>
        <View style={styles.section}>
          <Text accessibilityRole="header" style={styles.sectionTitle}>The method</Text>
          {detail.steps.map((step, index) => <View key={step.id} style={styles.method}>
            <Text style={styles.eyebrow}>STEP {index + 1}</Text>
            <Text style={styles.body}>{step.instruction || 'Instruction unavailable'}</Text>
          </View>)}
        </View>
        {!ready && <View style={styles.notice} accessibilityRole="alert">
          <Text style={styles.body}>This recipe needs more information before cooking.</Text>
          {readiness?.issues.map((issue) => <Text key={issue} style={styles.meta}>{issue}</Text>)}
          {!servingsValid && <Text style={styles.meta}>A valid serving count is required.</Text>}
        </View>}
        <Pressable accessibilityRole="button" accessibilityState={{ disabled: busy || (!ready && lastSession?.status !== 'active') }} disabled={busy || (!ready && lastSession?.status !== 'active')}
          onPress={() => void startCooking()}
          style={({ pressed }) => [styles.button, !ready && styles.disabled, pressed && styles.pressed]}>
          <Text style={styles.buttonText}>{busy ? 'Opening…' : lastSession?.status === 'active' ? `Resume cooking · ${lastSession.servings} servings` : 'Start cooking'}</Text>
        </Pressable>
        {lastSession && lastSession.status !== 'active' && <Pressable accessibilityRole="button" style={styles.back} onPress={() => router.push({ pathname: '/cook/[id]', params: { id, sessionId: lastSession.id } })}><Text style={styles.backText}>View last cooking session</Text></Pressable>}
        <Text style={styles.meta}>Recipe text and cooking progress stay on this device. Timers can request local alerts. Spoon measures use 5 ml teaspoons and 15 ml tablespoons; weight-to-volume conversions require ingredient data.</Text>
        <RecipeCommunityActions recipeId={id} metadata={metadata} onMetadata={setMetadata} />
      </>}
    </ScrollView>
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: colors.paper },
  content: { width: '100%', maxWidth: 720, alignSelf: 'center', padding: 24, gap: 16, paddingBottom: 40 },
  back: { minHeight: 48, justifyContent: 'center', alignSelf: 'flex-start', paddingRight: 16 },
  backText: { color: colors.accent, fontSize: 16, fontWeight: '700' },
  eyebrow: { color: colors.muted, fontSize: 13, fontWeight: '700', letterSpacing: 1 },
  title: { color: colors.ink, fontFamily: headingFont, fontSize: 34, lineHeight: 42 },
  body: { color: colors.ink, fontSize: 17, lineHeight: 27 },
  meta: { color: colors.muted, fontSize: 15, lineHeight: 24 },
  section: { gap: 12, borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 24, marginTop: 8 },
  sectionTitle: { color: colors.ink, fontFamily: headingFont, fontSize: 26 },
  line: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: colors.inset },
  ingredient: { flexGrow: 1, flexShrink: 1, color: colors.ink, fontSize: 17, lineHeight: 26 },
  quantity: { color: colors.muted, fontSize: 17, lineHeight: 26 },
  method: { gap: 8, paddingVertical: 8 },
  button: { minHeight: 52, backgroundColor: colors.accent, borderRadius: 12, padding: 16, alignItems: 'center', justifyContent: 'center' },
  buttonText: { color: colors.onAccent, fontSize: 17, fontWeight: '700' },
  pressed: { opacity: 0.75 },
  disabled: { backgroundColor: colors.muted },
  notice: { backgroundColor: colors.inset, borderRadius: 12, padding: 16, gap: 8 },
  state: { paddingVertical: 40, gap: 20 },
});
