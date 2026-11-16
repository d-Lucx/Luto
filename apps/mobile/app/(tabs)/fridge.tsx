import { colors, headingFont } from '../../src/theme';
import { useMemo, useState } from 'react';
import { ingredientMatches } from '../../src/engine/ingredientDisplay';
import { ActivityIndicator, Alert, FlatList, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useFridge } from '../../src/database/useFridge';
import { Ingredient, type StorageLocation } from '../../src/database/models';
import { setPantryQuantity } from '../../src/database/pantry';
import { loadDemoRecipes } from '../../src/database/demo';
import { evaluatePantryMatch, matchLabel, type IngredientRequirement } from '../../src/engine/evaluatePantryMatch';

const locations: StorageLocation[] = ['fridge', 'freezer', 'pantry', 'spice_rack'];
const locationLabel = (location: StorageLocation) => location === 'spice_rack' ? 'Spice rack' : location[0]!.toUpperCase() + location.slice(1);

export default function FridgeScreen() {
  const { ingredients, recipes, requirements, pantry, loading, error } = useFridge();
  const [search, setSearch] = useState('');
  const [quantity, setQuantity] = useState('1');
  const [selected, setSelected] = useState<Ingredient>();
  const [unit, setUnit] = useState('g');
  const [location, setLocation] = useState<StorageLocation>('fridge');
  const [showLow, setShowLow] = useState(false);
  const [saving, setSaving] = useState(false);
  const dictionary = useMemo(() => new Map(ingredients.map((item) => [item.id, item])), [ingredients]);
  const matches = useMemo(() => {
    const stock = new Map(pantry.map((item) => [item.ingredientId, { ingredientId: item.ingredientId, quantity: item.quantity, unit: item.unit }]));
    const byRecipe = new Map<string, IngredientRequirement[]>();
    const incomplete = new Set<string>();
    for (const line of requirements) {
      const ingredient = dictionary.get(line.ingredientId);
      if (!ingredient) { incomplete.add(line.recipeId); continue; }
      const group = byRecipe.get(line.recipeId) ?? [];
      group.push({ id: ingredient.id, name: ingredient.displayName, isStaple: ingredient.isStaple, isOptional: line.isOptional, tier: line.tier, amount: line.amount, unit: line.unit });
      byRecipe.set(line.recipeId, group);
    }
    return recipes.filter((recipe) => byRecipe.has(recipe.id) && !incomplete.has(recipe.id)).map((recipe) => ({
      recipe, result: evaluatePantryMatch(recipe.id, byRecipe.get(recipe.id)!, stock, new Map()),
    })).filter(({ result }) => showLow || result.matchScore >= 50)
      .sort((a, b) => b.result.matchScore - a.result.matchScore || a.recipe.title.localeCompare(b.recipe.title));
  }, [recipes, requirements, pantry, dictionary, showLow]);
  const suggestions = search.trim() && !selected
    ? ingredients.filter((item) => ingredientMatches(item.displayName, item.canonicalName, search)).slice(0, 6) : [];

  async function save(ingredient: Ingredient, amount: number) {
    setSaving(true);
    try {
      await setPantryQuantity(ingredient, amount, location, selected?.id === ingredient.id ? unit : ingredient.defaultUnit);
      setSelected(undefined); setSearch(''); setQuantity('1');
    } catch (cause) {
      Alert.alert('Could not save', cause instanceof Error ? cause.message : 'Please try again');
    } finally { setSaving(false); }
  }

  return <SafeAreaView style={styles.page} edges={['top', 'left', 'right']}>
    <FlatList data={matches} keyExtractor={({ recipe }) => recipe.id} keyboardShouldPersistTaps="handled"
      contentContainerStyle={styles.content}
      ListHeaderComponent={<View style={styles.section}>
        <Text style={styles.eyebrow}>LU2 · YOUR OFFLINE KITCHEN</Text>
        <Text style={styles.title}>What’s in your fridge?</Text>
        <Text style={styles.body}>Keep your pantry here. Find meals from recipes saved on this device.</Text>
        {loading && <ActivityIndicator accessibilityLabel="Loading pantry" />}
        {error && <Text accessibilityRole="alert" style={styles.error}>{error}</Text>}
        <TextInput accessibilityLabel="Find an ingredient" placeholder="Find an ingredient…" placeholderTextColor={colors.muted} value={search}
          onChangeText={(value) => { setSearch(value); setSelected(undefined); }} style={styles.input} />
        {suggestions.map((ingredient) => <Pressable key={ingredient.id} accessibilityRole="button" style={styles.suggestion}
          onPress={() => { const stock = pantry.find((item) => item.ingredientId === ingredient.id); setSelected(ingredient); setSearch(ingredient.displayName); setQuantity(String(stock?.quantity ?? 1)); setUnit(stock?.unit ?? ingredient.defaultUnit); setLocation(stock?.storageLocation ?? 'fridge'); }}>
          <Text style={styles.body}>{ingredient.displayName} · {ingredient.defaultUnit}</Text>
        </Pressable>)}
        {selected && <View style={styles.section}>
          <TextInput accessibilityLabel={`Quantity in ${unit}`} value={quantity} onChangeText={setQuantity}
            keyboardType="decimal-pad" style={styles.input} />
          <Text style={styles.body}>Total on hand in {unit}. Enter 0 to remove.</Text>
          <View style={styles.row}>{[...new Set([selected.defaultUnit, 'g', 'kg', 'ml', 'l', 'tsp', 'tbsp', 'piece'])].map((value) => <Pressable key={value} accessibilityRole="radio" accessibilityLabel={`Use ${value}`} accessibilityState={{ checked: value === unit }} style={[styles.chip, value === unit && styles.active]} onPress={() => setUnit(value)}><Text style={styles.body}>{value}</Text></Pressable>)}</View>
          <Text style={styles.muted}>Changing units changes the unit you are entering; it does not convert the number. Use g for a weighed onion, or piece for a count.</Text>
          <View style={styles.row}>{locations.map((value) => <Pressable key={value} accessibilityRole="button"
            accessibilityState={{ selected: value === location }} style={[styles.chip, value === location && styles.active]}
            onPress={() => setLocation(value)}><Text style={styles.body}>{locationLabel(value)}</Text></Pressable>)}</View>
          <Pressable accessibilityRole="button" disabled={saving || !quantity.trim() || !Number.isFinite(Number(quantity)) || Number(quantity) < 0}
            style={styles.button} onPress={() => { void save(selected, Number(quantity)); }}><Text style={styles.buttonText}>{saving ? 'Saving…' : 'Save quantity'}</Text></Pressable>
        </View>}
        {locations.map((value) => <View key={value} style={styles.section}>
          <Text style={styles.heading}>{locationLabel(value)}</Text>
          {pantry.filter((item) => item.storageLocation === value).map((item) => <View key={item.id} style={styles.inventory}>
            <Text style={styles.body}>{dictionary.get(item.ingredientId)?.displayName ?? 'Uncached ingredient'} · {item.quantity} {item.unit}</Text>
            <Pressable accessibilityRole="button" accessibilityLabel={`Remove ${dictionary.get(item.ingredientId)?.displayName ?? 'ingredient'}`} disabled={saving}
              onPress={() => { const ingredient = dictionary.get(item.ingredientId); if (ingredient) void save(ingredient, 0); }}><Text style={styles.link}>Remove</Text></Pressable>
          </View>)}
          {!pantry.some((item) => item.storageLocation === value) && <Text style={styles.muted}>Nothing added yet</Text>}
        </View>)}
        {!recipes.length && !loading && <Pressable accessibilityRole="button" style={styles.button}
          onPress={() => { void loadDemoRecipes().catch((cause: Error) => Alert.alert('Could not load sample', cause.message)); }}>
          <Text style={styles.buttonText}>Try an offline sample recipe</Text>
        </Pressable>}
        <Text style={styles.heading}>From your pantry</Text>
        <Pressable accessibilityRole="switch" accessibilityState={{ checked: showLow }} onPress={() => setShowLow(!showLow)}>
          <Text style={styles.link}>{showLow ? 'Hide' : 'Show'} recipes below 50% match</Text>
        </Pressable>
      </View>}
      ListEmptyComponent={<Text style={styles.body}>{recipes.length ? 'No recipes match this filter. Add ingredients or show lower matches.' : 'No saved recipes yet. Try the sample to explore offline matching.'}</Text>}
      renderItem={({ item: { recipe, result } }) => <View style={styles.card}>
        <Text style={styles.heading}>{recipe.title}</Text>
        <Text style={styles.badge}>{matchLabel(result)}</Text>
        <Text style={styles.body}>{recipe.description}</Text>
        {result.missingIngredients.length > 0 && <Text style={styles.muted}>Need: {result.missingIngredients.map((item) => item.name).join(', ')}</Text>}
      </View>}
    />
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: colors.paper },
  content: { padding: 20, paddingBottom: 36, gap: 16 },
  section: { gap: 12 }, row: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  eyebrow: { color: colors.accent, fontWeight: '700', fontSize: 12, letterSpacing: 1 },
  title: { fontSize: 34, fontFamily: headingFont, color: colors.ink },
  heading: { fontSize: 20, fontWeight: '600', color: colors.ink },
  body: { fontSize: 16, color: colors.ink, flexShrink: 1 },
  muted: { color: colors.muted, fontSize: 14 }, error: { color: colors.error },
  input: { backgroundColor: colors.surface, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 14, fontSize: 17, color: colors.ink },
  suggestion: { padding: 12, backgroundColor: colors.surface, borderRadius: 8 },
  chip: { padding: 12, minHeight: 48, backgroundColor: colors.surface, borderWidth: 2, borderColor: 'transparent', borderRadius: 20 },
  active: { backgroundColor: colors.inset, borderColor: colors.accent },
  button: { backgroundColor: colors.accent, padding: 15, borderRadius: 12, minHeight: 48 },
  buttonText: { color: colors.onAccent, fontWeight: '600', textAlign: 'center' },
  inventory: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: 12 },
  link: { color: colors.accent, fontSize: 16, paddingVertical: 14, minHeight: 48 },
  card: { backgroundColor: colors.surface, padding: 18, borderRadius: 16, gap: 10 },
  badge: { color: colors.accent, fontWeight: '700' },
});
