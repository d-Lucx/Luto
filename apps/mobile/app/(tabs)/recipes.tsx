import { useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Image, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { database } from '../../src/database/index';
import { Recipe } from '../../src/database/models';
import { loadDemoRecipes } from '../../src/database/demo';
import { colors, headingFont } from '../../src/theme';
import { useCookbook } from '../../src/database/cookbook';

export default function RecipesScreen() {
  const router = useRouter();
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [search, setSearch] = useState('');
  const [savedOnly, setSavedOnly] = useState(false);
  const { entries, error: savedError } = useCookbook();
  const saved = new Set(entries.filter((entry) => entry.saved).map((entry) => entry.recipeId));
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [attempt, setAttempt] = useState(0);
  const [seeding, setSeeding] = useState(false);

  useEffect(() => {
    setLoading(true);
    setError('');
    const subscription = database.get<Recipe>('local_recipes').query().observe().subscribe({
      next: (list) => { setRecipes(list); setLoading(false); },
      error: () => { setError('Your recipe library could not be opened. Please try again.'); setLoading(false); },
    });
    return () => subscription.unsubscribe();
  }, [attempt]);

  async function addSample() {
    if (seeding) return;
    setSeeding(true);
    try { await loadDemoRecipes(); }
    catch { setError('The sample could not be added. Please try again.'); }
    finally { setSeeding(false); }
  }

  const filtered = recipes.filter((recipe) => (!savedOnly || saved.has(recipe.id)) && recipe.title.toLowerCase().includes(search.trim().toLowerCase()));

  return <SafeAreaView style={styles.page} edges={['top', 'left', 'right']}>
    <FlatList data={error ? [] : filtered} keyExtractor={(item) => item.id}
      contentContainerStyle={styles.content} keyboardShouldPersistTaps="handled"
      ListHeaderComponent={<View style={styles.header}>
        <Image source={require('../../assets/brand/lu2-logo.png')} accessibilityLabel="Lu2" style={{ width: 160, height: 60, resizeMode: 'contain', alignSelf: 'flex-start' }} />
        <Text accessibilityRole="header" style={styles.title}>A little inspiration.{'\n'}Something good to cook.</Text>
        <Text style={styles.body}>Read a recipe, gather your ingredients, and take it one step at a time.</Text>
        <Pressable accessibilityRole="button" style={styles.secondary} onPress={() => router.push('/community')}><Text style={styles.secondaryText}>Explore community recipes</Text></Pressable>
        <Pressable accessibilityRole="button" onPress={() => router.push('/recipes/new')}
          style={({ pressed }) => [styles.secondary, pressed && styles.pressed]}>
          <Text style={styles.secondaryText}>Create a recipe</Text>
        </Pressable>
        <Text accessibilityRole="header" style={styles.heading}>Your recipe library</Text>
        <Text style={styles.muted}>Recipes stored on this device</Text>
        {!!savedError && <Text accessibilityRole="alert" style={styles.body}>{savedError}</Text>}
        <Pressable accessibilityRole="switch" accessibilityState={{ checked: savedOnly }} style={styles.secondary} onPress={() => setSavedOnly(!savedOnly)}><Text style={styles.secondaryText}>{savedOnly ? 'Saved recipes only' : 'All recipes · Show saved only'}</Text></Pressable>
        <Text style={styles.inputLabel}>Find a recipe</Text>
        <TextInput accessibilityLabel="Search recipes by title" style={styles.input}
          placeholder="Search recipe titles" placeholderTextColor={colors.muted} value={search} onChangeText={setSearch} />
      </View>}
      ListEmptyComponent={<View style={styles.empty}>
        {loading ? <><ActivityIndicator size="large" color={colors.accent} /><Text style={styles.body}>Opening your cookbook…</Text></>
          : error ? <><Text accessibilityRole="alert" style={styles.body}>{error}</Text>
            <Pressable accessibilityRole="button" style={styles.secondary} onPress={() => setAttempt((value) => value + 1)}>
              <Text style={styles.secondaryText}>Try again</Text>
            </Pressable></>
          : search.trim() || savedOnly ? <><Text style={styles.heading}>No matching recipes</Text><Text style={styles.body}>Save a recipe from its page, or show your full library.</Text>
            <Pressable accessibilityRole="button" style={styles.secondary} onPress={() => { setSearch(''); setSavedOnly(false); }}><Text style={styles.secondaryText}>Show all recipes</Text></Pressable></>
          : <><Text style={styles.heading}>Your first page is waiting</Text><Text style={styles.body}>Try a local sample to explore the cooking flow. It works without an account or internet.</Text>
            <Pressable accessibilityRole="button" disabled={seeding} accessibilityState={{ disabled: seeding }}
              style={({ pressed }) => [styles.button, pressed && styles.pressed]} onPress={() => void addSample()}>
              <Text style={styles.buttonText}>{seeding ? 'Adding sample…' : 'Try an offline sample recipe'}</Text>
            </Pressable></>}
      </View>}
      renderItem={({ item }) => <Pressable accessibilityRole="button" accessibilityLabel={`Open ${item.title}`}
        onPress={() => router.push({ pathname: '/recipes/[id]', params: { id: item.id } })}
        style={({ pressed }) => [styles.card, pressed && styles.pressed]}>
        <Text style={styles.eyebrow}>RECIPE</Text>
        <Text accessibilityRole="header" style={styles.recipeTitle}>{item.title}</Text>
        {!!item.description && <Text style={styles.body}>{item.description}</Text>}
        <Text style={styles.muted}>{item.servings} servings · View ingredients and method</Text>
        <Text style={styles.secondaryText}>Open recipe</Text>
      </Pressable>} />
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: colors.paper },
  content: { width: '100%', maxWidth: 720, alignSelf: 'center', padding: 24, paddingBottom: 40, gap: 16 },
  header: { gap: 14, paddingBottom: 8 },
  eyebrow: { color: colors.muted, fontSize: 12, fontWeight: '700', letterSpacing: 1.2 },
  title: { fontFamily: headingFont, fontSize: 34, lineHeight: 43, color: colors.ink, marginVertical: 8 },
  heading: { fontFamily: headingFont, fontSize: 25, color: colors.ink, marginTop: 12 },
  body: { color: colors.ink, fontSize: 17, lineHeight: 27 },
  muted: { color: colors.muted, fontSize: 15, lineHeight: 24 },
  inputLabel: { color: colors.ink, fontSize: 16, fontWeight: '600', marginTop: 8 },
  input: { minHeight: 52, padding: 14, borderWidth: 1, borderColor: colors.border, borderRadius: 12, backgroundColor: colors.surface, color: colors.ink, fontSize: 17 },
  secondary: { minHeight: 48, borderWidth: 1, borderColor: colors.accent, borderRadius: 12, padding: 14, justifyContent: 'center', alignItems: 'center' },
  secondaryText: { color: colors.accent, fontSize: 16, fontWeight: '700' },
  button: { minHeight: 52, padding: 16, backgroundColor: colors.accent, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  buttonText: { color: colors.onAccent, fontSize: 16, fontWeight: '700' },
  empty: { gap: 16, paddingVertical: 20 },
  card: { backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, padding: 20, borderRadius: 16, gap: 12 },
  recipeTitle: { fontFamily: headingFont, color: colors.ink, fontSize: 27, lineHeight: 34 },
  pressed: { opacity: 0.75 },
});
