import { colors, headingFont } from '../../src/theme';
import { ingredientMatches } from '../../src/engine/ingredientDisplay';
import { canEditRecipe } from '../../src/engine/recipePermissions';
// ==============================================================================
// LUTO (Logo: Lu2) — Community Recipe Creator Flow
// Screen: app/recipes/new.tsx
// ==============================================================================

import React, { useEffect, useRef, useState } from 'react';
import { readDocument } from '../../src/database/documents';
import { LocalDocument } from '../../src/database/models';
import { validateCreator } from '../../src/engine/creatorValidation';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Q, type Model } from '@nozbe/watermelondb';
import type { RecipeMetadata } from '../../src/database/recipeMetadata';
import { ensureLearningLibrary } from '../../src/database/learningLibrary';
import { database } from '../../src/database/index';
import { Ingredient, Equipment, Recipe, RecipeStep, RecipeIngredient } from '../../src/database/models';

interface IngredientRow {
  ingredientId: string;
  name: string;
  amount: string;
  unit: string;
  isOptional: boolean;
  tier: 0 | 1 | 2 | 3;
}

interface StepRow {
  stepNumber: number;
  instruction: string;
  timerMinutes: string;
  mediaUrl?: string | null;
  localMediaUri?: string | null;
  originalTimerSeconds?: number;
}
interface CreatorDraft {
  category?: string; difficulty?: 'easy' | 'medium' | 'hard' | 'expert'; cuisine?: string;
  title: string; description: string; servings: string; prepMinutes: string; cookMinutes: string;
  selectedIngredients: IngredientRow[]; selectedEquipmentIds: string[]; recipeSteps: StepRow[]; wizardStage: 1 | 2 | 3;
}

export function createEditDraft(recipe: Pick<Recipe, 'title' | 'description' | 'servings'>,
  requirements: RecipeIngredient[], steps: RecipeStep[], dictionary: Ingredient[], equipment: Equipment[], metadata: RecipeMetadata): CreatorDraft {
  const names = new Map(dictionary.map((item) => [item.id, item.displayName]));
  return { title: recipe.title, description: recipe.description, servings: String(recipe.servings),
    prepMinutes: String(metadata.prepTimeMinutes ?? 0), cookMinutes: String(metadata.cookTimeMinutes ?? 0),
    category: metadata.category ?? 'Main course', difficulty: metadata.difficulty ?? 'easy', cuisine: (metadata.cuisineTags ?? []).join(', '),
    selectedIngredients: requirements.map((item) => ({ ingredientId: item.ingredientId, name: names.get(item.ingredientId) ?? 'Unknown ingredient',
      amount: String(item.amount), unit: item.unit, isOptional: item.isOptional, tier: item.tier })),
    selectedEquipmentIds: equipment.filter((item) => metadata.equipment?.some((e) => e.canonicalName === item.canonicalName)).map((item) => item.id),
    recipeSteps: [...steps].sort((a, b) => a.stepNumber - b.stepNumber).map((item, index) => ({ stepNumber: index + 1,
      instruction: item.instruction, timerMinutes: String(Math.ceil(item.timerDurationSeconds / 60)), originalTimerSeconds: item.timerDurationSeconds,
      mediaUrl: item.mediaUrl, localMediaUri: item.localMediaUri })), wizardStage: 1 };
}

export default function NewRecipeScreen() {
  const router = useRouter();
  const { editId } = useLocalSearchParams<{ editId?: string }>();
  const draftKey = editId ? `creator-draft-edit-${editId}` : 'creator-draft';
  const submitting = useRef(false);

  // Step wizard stage: 1 = Metadata, 2 = Ingredients, 3 = Equipment & Steps
  const [wizardStage, setWizardStage] = useState<1 | 2 | 3>(1);

  // Metadata
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [servings, setServings] = useState('4');
  const [prepMinutes, setPrepMinutes] = useState('15');
  const [cookMinutes, setCookMinutes] = useState('25');
  const [category, setCategory] = useState('Main course');
  const [difficulty, setDifficulty] = useState<'easy' | 'medium' | 'hard' | 'expert'>('easy');
  const [cuisine, setCuisine] = useState('');

  // Master lists
  const [availableIngredients, setAvailableIngredients] = useState<Ingredient[]>([]);
  const [availableEquipment, setAvailableEquipment] = useState<Equipment[]>([]);

  // Selected recipe components
  const [selectedIngredients, setSelectedIngredients] = useState<IngredientRow[]>([]);
  const [selectedEquipmentIds, setSelectedEquipmentIds] = useState<Set<string>>(new Set());
  const [recipeSteps, setRecipeSteps] = useState<StepRow[]>([
    { stepNumber: 1, instruction: '', timerMinutes: '0' },
  ]);

  // Ingredient search in wizard
  const [ingSearch, setIngSearch] = useState('');
  const [saving, setSaving] = useState(false);
  const [draftReady, setDraftReady] = useState(false);
  const [draftMessage, setDraftMessage] = useState('Opening your draft…');
  const finalized = useRef(false);
  const draftLoaded = useRef(false);
  const draft: CreatorDraft = { title, description, servings, prepMinutes, cookMinutes, category, difficulty, cuisine, selectedIngredients,
    selectedEquipmentIds: [...selectedEquipmentIds], recipeSteps, wizardStage };
  const draftRef = useRef(draft); draftRef.current = draft;
  async function persistDraft() {
    const value = draftRef.current;
    await database.write(async () => {
      if (finalized.current || submitting.current) return;
      const documents = database.get<LocalDocument>('local_documents');
      const rows = await documents.query(Q.where('key', draftKey)).fetch();
      if (rows[0]) await rows[0].update((row) => { row.payload = JSON.stringify(value); });
      else await documents.create((row) => { row.key = draftKey; row.payload = JSON.stringify(value); });
    });
  }
  useEffect(() => {
    let active = true;
    draftLoaded.current = false; finalized.current = false; setDraftReady(false);
    void (async () => {
      await ensureLearningLibrary();
      const [dictionary, equipment] = await Promise.all([
        database.get<Ingredient>('ingredients').query().fetch(), database.get<Equipment>('equipment').query().fetch(),
      ]);
      let initial: CreatorDraft | null = null;
      if (editId) {
        const recipe = await database.get<Recipe>('local_recipes').find(editId);
        const metadata = await readDocument<RecipeMetadata>(`recipe-meta-${editId}`) ?? {};
        if (!canEditRecipe(editId, metadata.source))
          throw new Error('Community and sample recipes cannot be edited. Create your own recipe instead.');
        const [requirements, steps] = await Promise.all([recipe.ingredients.fetch(), recipe.steps.fetch()]);
        initial = createEditDraft(recipe, requirements, steps, dictionary, equipment, metadata);
      }
      const saved = await readDocument<CreatorDraft>(draftKey);
      if (!active) return;
      setAvailableIngredients(dictionary); setAvailableEquipment(equipment);
      const value = saved ?? initial;
      if (value) {
        setTitle(value.title); setDescription(value.description); setServings(value.servings); setPrepMinutes(value.prepMinutes); setCookMinutes(value.cookMinutes);
        setCategory(value.category ?? 'Main course'); setDifficulty(value.difficulty ?? 'easy'); setCuisine(value.cuisine ?? '');
        setSelectedIngredients(value.selectedIngredients); setSelectedEquipmentIds(new Set(value.selectedEquipmentIds)); setRecipeSteps(value.recipeSteps); setWizardStage(value.wizardStage);
      }
      draftLoaded.current = true;
      setDraftReady(true); setDraftMessage(saved ? 'Your saved draft is restored.' : 'Draft saves automatically on this device.');
    })().catch((error) => { if (active) setDraftMessage(error instanceof Error ? error.message : 'Draft could not be opened. Reopen the creator to try again.'); });
    return () => { active = false; if (draftLoaded.current && !finalized.current && !submitting.current) void persistDraft().catch(() => {}); };
  }, [editId, draftKey]);
  useEffect(() => {
    if (!draftReady || finalized.current || saving) return;
    const timeout = setTimeout(() => {
      void persistDraft().then(() => setDraftMessage('Draft saved on this device.')).catch(() => setDraftMessage('Draft save failed. Keep this screen open and try Save draft.'));
    }, 500);
    return () => clearTimeout(timeout);
  }, [draftReady, saving, draftKey, title, description, servings, prepMinutes, cookMinutes, category, difficulty, cuisine, selectedIngredients, selectedEquipmentIds, recipeSteps, wizardStage]);

  const filteredIngredients = ingSearch.trim()
    ? availableIngredients
        .filter((i) => ingredientMatches(i.displayName, i.canonicalName, ingSearch))
        .slice(0, 8)
    : [];

  const addIngredient = (ing: Ingredient) => {
    if (selectedIngredients.some((i) => i.ingredientId === ing.id)) return;
    setSelectedIngredients((prev) => [
      ...prev,
      {
        ingredientId: ing.id,
        name: ing.displayName,
        amount: '1',
        unit: ing.defaultUnit,
        isOptional: false,
        tier: ing.isStaple ? 0 : 2,
      },
    ]);
    setIngSearch('');
  };

  const removeIngredient = (id: string) => {
    setSelectedIngredients((prev) => prev.filter((i) => i.ingredientId !== id));
  };

  const updateIngredientAmount = (id: string, amount: string) => {
    setSelectedIngredients((prev) =>
      prev.map((i) => (i.ingredientId === id ? { ...i, amount } : i))
    );
  };

  const toggleEquipment = (id: string) => {
    setSelectedEquipmentIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const addStep = () => {
    setRecipeSteps((prev) => [
      ...prev,
      { stepNumber: prev.length + 1, instruction: '', timerMinutes: '0' },
    ]);
  };

  const updateStepInstruction = (index: number, text: string) => {
    setRecipeSteps((prev) =>
      prev.map((s, idx) => (idx === index ? { ...s, instruction: text } : s))
    );
  };

  const updateStepTimer = (index: number, timerMinutes: string) => {
    setRecipeSteps((prev) =>
      prev.map((s, idx) => (idx === index ? { ...s, timerMinutes, originalTimerSeconds: undefined } : s))
    );
  };

  const removeStep = (index: number) => {
    if (recipeSteps.length <= 1) return;
    setRecipeSteps((prev) =>
      prev
        .filter((_, idx) => idx !== index)
        .map((s, idx) => ({ ...s, stepNumber: idx + 1 }))
    );
  };

  const handleSaveRecipe = async () => {
    if (submitting.current || finalized.current || !draftReady) return;
    const value = draftRef.current;
    const issue = validateCreator(value);
    if (issue) { Alert.alert('Check your recipe', issue); return; }
    submitting.current = true; setSaving(true);
    try {
      await database.write(async () => {
        const recipes = database.get<Recipe>('local_recipes');
        const steps = database.get<RecipeStep>('local_steps');
        const requirements = database.get<RecipeIngredient>('local_ingredients');
        const documents = database.get<LocalDocument>('local_documents');
        const existing = editId ? await recipes.find(editId) : null;
        const metadataRows = editId ? await documents.query(Q.where('key', `recipe-meta-${editId}`)).fetch() : [];
        const previousMetadata: RecipeMetadata = metadataRows[0] ? JSON.parse(metadataRows[0].payload) as RecipeMetadata : {};
        if (existing && !canEditRecipe(existing.id, previousMetadata.source))
          throw new Error('Community and sample recipes cannot be edited.');
        const [oldSteps, oldIngredients, drafts] = await Promise.all([
          existing ? existing.steps.fetch() : Promise.resolve([]), existing ? existing.ingredients.fetch() : Promise.resolve([]), documents.query(Q.where('key', draftKey)).fetch(),
        ]);
        const assign = (row: Recipe) => { row.title = value.title.trim(); row.description = value.description.trim(); row.servings = Number(value.servings); row.updatedAt = Date.now(); };
        const recipe = existing ?? recipes.prepareCreate((row) => { assign(row); row.heroImageUrl = ''; });
        const ops: Model[] = [existing ? existing.prepareUpdate(assign) : recipe,
          ...oldSteps.map((row) => row.prepareMarkAsDeleted()), ...oldIngredients.map((row) => row.prepareMarkAsDeleted())];
        value.recipeSteps.forEach((step, index) => ops.push(steps.prepareCreate((row) => {
          row.recipeId = recipe.id; row.stepNumber = index + 1; row.instruction = step.instruction.trim(); row.timerDurationSeconds = step.originalTimerSeconds ?? Number(step.timerMinutes) * 60;
          row.mediaUrl = step.mediaUrl ?? null; row.localMediaUri = step.localMediaUri ?? null;
        })));
        value.selectedIngredients.forEach((item) => ops.push(requirements.prepareCreate((row) => {
          row.recipeId = recipe.id; row.ingredientId = item.ingredientId; row.amount = Number(item.amount); row.unit = item.unit; row.isOptional = item.isOptional; row.tier = item.tier;
        })));
        const selectedEquipment = new Set(value.selectedEquipmentIds);
        const knownEquipment = new Set(availableEquipment.map((item) => item.canonicalName));
        const equipment = [
          ...(previousMetadata.equipment ?? []).filter((item) => !knownEquipment.has(item.canonicalName)),
          ...availableEquipment.filter((item) => selectedEquipment.has(item.id)).map((item) =>
            previousMetadata.equipment?.find((old) => old.canonicalName === item.canonicalName) ?? { canonicalName: item.canonicalName, name: item.displayName, isRequired: item.isEssential }),
        ];
        const payload: RecipeMetadata = { ...previousMetadata, category: value.category, difficulty: value.difficulty,
          cuisineTags: (value.cuisine ?? '').split(',').map((tag) => tag.trim()).filter(Boolean), prepTimeMinutes: Number(value.prepMinutes), cookTimeMinutes: Number(value.cookMinutes), equipment };
        const setMetadata = (row: LocalDocument) => { row.key = `recipe-meta-${recipe.id}`; row.payload = JSON.stringify(payload); };
        ops.push(metadataRows[0] ? metadataRows[0].prepareUpdate(setMetadata) : documents.prepareCreate(setMetadata));
        ops.push(...drafts.map((row) => row.prepareMarkAsDeleted()));
        await database.batch(ops);
        finalized.current = true;
      });
      Alert.alert('Saved on this device', editId ? 'Your recipe changes are saved. Existing cooking sessions keep their original recipe.' : 'Your recipe is stored locally. Open its recipe page to publish it when signed in.');
      router.back();
    } catch (error) {
      Alert.alert('Save Failed', error instanceof Error ? error.message : 'Unknown error');
    } finally {
      submitting.current = false; setSaving(false);
    }
  };

  return (
    <SafeAreaView style={styles.screen}>
      <Text accessibilityLiveRegion="polite" style={{ color: colors.muted, padding: 12 }}>{draftMessage}</Text>
      {editId && <Pressable accessibilityRole="button" disabled={!draftReady || saving} accessibilityState={{ disabled: !draftReady || saving }}
        style={{ minHeight: 48, padding: 12 }} onPress={() => void handleSaveRecipe()}><Text style={{ color: colors.accent, fontWeight: '700' }}>{saving ? 'Saving…' : 'Save changes'}</Text></Pressable>}
      <Pressable accessibilityRole="button" disabled={!draftReady || saving} style={{ minHeight: 48, padding: 12 }} onPress={() => void persistDraft().then(() => setDraftMessage('Draft saved on this device.')).catch(() => setDraftMessage('Draft save failed. Try again.'))}><Text style={{ color: colors.accent, fontWeight: '700' }}>Save draft</Text></Pressable>
      {/* Wizard Progress Indicator */}
      <View style={styles.wizardBar}>
        <Pressable
          style={[styles.wizardTab, wizardStage === 1 && styles.wizardTabActive]}
          onPress={() => setWizardStage(1)}
        >
          <Text style={[styles.wizardTabText, wizardStage === 1 && styles.wizardTabTextActive]}>
            1. Overview
          </Text>
        </Pressable>
        <Pressable
          style={[styles.wizardTab, wizardStage === 2 && styles.wizardTabActive]}
          onPress={() => setWizardStage(2)}
        >
          <Text style={[styles.wizardTabText, wizardStage === 2 && styles.wizardTabTextActive]}>
            2. Ingredients
          </Text>
        </Pressable>
        <Pressable
          style={[styles.wizardTab, wizardStage === 3 && styles.wizardTabActive]}
          onPress={() => setWizardStage(3)}
        >
          <Text style={[styles.wizardTabText, wizardStage === 3 && styles.wizardTabTextActive]}>
            3. Steps & Tools
          </Text>
        </Pressable>
      </View>

      <ScrollView contentContainerStyle={styles.scrollArea} keyboardShouldPersistTaps="handled" pointerEvents={draftReady && !saving ? 'auto' : 'none'}>
        {/* STAGE 1: METADATA */}
        {wizardStage === 1 && (
          <View style={styles.formSection}>
            <Text style={styles.sectionTitle}>{editId ? 'Edit recipe' : 'Recipe Details'}</Text>

            <Text style={styles.label}>Recipe Title</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. Crispy Garlic Butter Noodles"
              placeholderTextColor={colors.muted}
              value={title}
              onChangeText={setTitle}
            />

            <Text style={styles.label}>Description & Flavor Story</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="A quick 15-minute comfort food favorite..."
              placeholderTextColor={colors.muted}
              value={description}
              onChangeText={setDescription}
              multiline
              numberOfLines={3}
            />

            <Text style={styles.label}>Meal category</Text>
            <TextInput accessibilityLabel="Meal category" value={category} onChangeText={setCategory} style={styles.input} placeholderTextColor={colors.muted} />
            <Text style={styles.label}>Cuisine tags (comma separated)</Text>
            <TextInput accessibilityLabel="Cuisine tags" value={cuisine} onChangeText={setCuisine} style={styles.input} placeholder="e.g. Filipino, Everyday" placeholderTextColor={colors.muted} />
            <Text style={styles.label}>Difficulty</Text>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 8 }}>
              {(['easy', 'medium', 'hard', 'expert'] as const).map((value) => <Pressable key={value} accessibilityRole="radio" accessibilityState={{ checked: difficulty === value }} style={{ minHeight: 48, padding: 14, borderWidth: 1, borderRadius: 10, borderColor: difficulty === value ? colors.accent : colors.border, backgroundColor: difficulty === value ? colors.inset : colors.surface }} onPress={() => setDifficulty(value)}><Text style={{ color: colors.ink }}>{value}</Text></Pressable>)}
            </View>

            <View style={styles.row}>
              <View style={styles.col}>
                <Text style={styles.label}>Servings</Text>
                <TextInput
                  style={styles.input}
                  keyboardType="numeric"
                  value={servings}
                  onChangeText={setServings}
                />
              </View>
              <View style={styles.col}>
                <Text style={styles.label}>Prep (Mins)</Text>
                <TextInput
                  style={styles.input}
                  keyboardType="numeric"
                  value={prepMinutes}
                  onChangeText={setPrepMinutes}
                />
              </View>
              <View style={styles.col}>
                <Text style={styles.label}>Cook (Mins)</Text>
                <TextInput
                  style={styles.input}
                  keyboardType="numeric"
                  value={cookMinutes}
                  onChangeText={setCookMinutes}
                />
              </View>
            </View>

            <Pressable style={styles.nextStageBtn} onPress={() => setWizardStage(2)}>
              <Text style={styles.nextStageBtnText}>Next: Select Ingredients →</Text>
            </Pressable>
          </View>
        )}

        {/* STAGE 2: INGREDIENTS */}
        {wizardStage === 2 && (
          <View style={styles.formSection}>
            <Text style={styles.sectionTitle}>Required Ingredients</Text>

            <Text style={styles.label}>Search Canonical Ingredients</Text>
            <TextInput
              style={styles.input}
              placeholder="Type to search (e.g. Eggs, Garlic, Soy sauce)..."
              placeholderTextColor={colors.muted}
              value={ingSearch}
              onChangeText={setIngSearch}
            />

            {filteredIngredients.length > 0 && (
              <View style={styles.suggestionsBox}>
                {filteredIngredients.map((ing) => (
                  <Pressable
                    key={ing.id}
                    style={styles.suggestionItem}
                    onPress={() => addIngredient(ing)}
                  >
                    <Text style={styles.suggestionText}>{ing.displayName}</Text>
                    <Text style={styles.suggestionUnit}>+ add ({ing.defaultUnit})</Text>
                  </Pressable>
                ))}
              </View>
            )}

            <Text style={styles.subHeading}>
              Selected Ingredients ({selectedIngredients.length})
            </Text>

            {selectedIngredients.map((item) => (
              <View key={item.ingredientId} style={styles.selectedIngRow}>
                <Text style={styles.ingName}>{item.name}</Text>
                <TextInput
                  style={styles.amountInput}
                  keyboardType="numeric"
                  value={item.amount}
                  onChangeText={(val) => updateIngredientAmount(item.ingredientId, val)}
                />
                <Text style={styles.unitLabel}>{item.unit}</Text>
                <Pressable
                  style={styles.removeIngBtn}
                  onPress={() => removeIngredient(item.ingredientId)}
                >
                  <Text style={styles.removeIngText}>✕</Text>
                </Pressable>
              </View>
            ))}

            <View style={styles.row}>
              <Pressable style={styles.prevStageBtn} onPress={() => setWizardStage(1)}>
                <Text style={styles.prevStageBtnText}>← Back</Text>
              </Pressable>
              <Pressable style={styles.nextStageBtnFlex} onPress={() => setWizardStage(3)}>
                <Text style={styles.nextStageBtnText}>Next: Steps & Tools →</Text>
              </Pressable>
            </View>
          </View>
        )}

        {/* STAGE 3: STEPS & EQUIPMENT */}
        {wizardStage === 3 && (
          <View style={styles.formSection}>
            <Text style={styles.sectionTitle}>Preparation Steps & Tools</Text>

            {/* Equipment Checklist */}
            <Text style={styles.subHeading}>Kitchen Equipment Needed</Text>
            <View style={styles.equipmentWrap}>
              {availableEquipment.map((eq) => {
                const isSelected = selectedEquipmentIds.has(eq.id);
                return (
                  <Pressable
                    key={eq.id}
                    style={[styles.equipChip, isSelected && styles.equipChipActive]}
                    onPress={() => toggleEquipment(eq.id)}
                  >
                    <Text style={[styles.equipChipText, isSelected && styles.equipChipTextActive]}>
                      {eq.displayName}
                    </Text>
                  </Pressable>
                );
              })}
            </View>

            {/* Steps List */}
            <Text style={styles.subHeading}>Cooking Instructions</Text>

            {recipeSteps.map((step, idx) => (
              <View key={step.stepNumber} style={styles.stepCard}>
                <View style={styles.stepHeader}>
                  <Text style={styles.stepNumberBadge}>Step {step.stepNumber}</Text>
                  {recipeSteps.length > 1 && (
                    <Pressable onPress={() => removeStep(idx)}>
                      <Text style={styles.stepDeleteText}>Delete</Text>
                    </Pressable>
                  )}
                </View>

                <TextInput
                  style={[styles.input, styles.stepInput]}
                  placeholder={`Describe step ${step.stepNumber}...`}
                  placeholderTextColor={colors.muted}
                  value={step.instruction}
                  onChangeText={(val) => updateStepInstruction(idx, val)}
                  multiline
                />

                <View style={styles.timerRow}>
                  <Text style={styles.timerPrompt}>Step Timer (minutes, 0 if none):</Text>
                  <TextInput
                    style={styles.timerMinutesInput}
                    keyboardType="numeric"
                    value={step.timerMinutes}
                    onChangeText={(val) => updateStepTimer(idx, val)}
                  />
                </View>
              </View>
            ))}

            <Pressable style={styles.addStepBtn} onPress={addStep}>
              <Text style={styles.addStepBtnText}>+ Add Another Step</Text>
            </Pressable>

            <View style={styles.actionRow}>
              <Pressable style={styles.prevStageBtn} onPress={() => setWizardStage(2)}>
                <Text style={styles.prevStageBtnText}>← Back</Text>
              </Pressable>
              <Pressable
                style={styles.publishBtn}
                onPress={handleSaveRecipe}
                disabled={saving}
              >
                {saving ? (
                  <ActivityIndicator color={colors.onAccent} />
                ) : (
                  <Text style={styles.publishBtnText}>{editId ? 'Save changes' : 'Save on this device'}</Text>
                )}
              </Pressable>
            </View>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.paper,
  },
  wizardBar: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.inset,
  },
  wizardTab: {
    flex: 1,
    paddingVertical: 14,
    alignItems: 'center',
  },
  wizardTabActive: {
    borderBottomWidth: 3,
    borderBottomColor: colors.accent,
  },
  wizardTabText: {
    color: colors.muted,
    fontSize: 13,
    fontWeight: '700',
  },
  wizardTabTextActive: {
    color: colors.muted,
  },
  scrollArea: {
    padding: 20,
    paddingBottom: 40,
  },
  formSection: {
    gap: 12,
  },
  sectionTitle: {
    fontFamily: headingFont,
    color: colors.ink,
    fontSize: 22,
    fontWeight: '800',
    marginBottom: 8,
  },
  label: {
    color: colors.ink,
    fontSize: 14,
    fontWeight: '600',
    marginTop: 4,
  },
  subHeading: {
    color: colors.ink,
    fontSize: 16,
    fontWeight: '700',
    marginTop: 16,
  },
  input: {
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 10,
    padding: 12,
    color: colors.ink,
    fontSize: 15,
  },
  textArea: {
    minHeight: 80,
    textAlignVertical: 'top',
  },
  row: {
    flexDirection: 'row',
    gap: 12,
  },
  col: {
    flex: 1,
  },
  nextStageBtn: {
    backgroundColor: colors.accent,
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
    marginTop: 18,
  },
  nextStageBtnFlex: {
    flex: 2,
    backgroundColor: colors.accent,
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  nextStageBtnText: {
    color: colors.onAccent,
    fontSize: 15,
    fontWeight: '700',
  },
  prevStageBtn: {
    flex: 1,
    backgroundColor: colors.inset,
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  prevStageBtnText: {
    color: colors.ink,
    fontSize: 15,
    fontWeight: '600',
  },
  suggestionsBox: {
    backgroundColor: colors.surface,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: colors.border,
    overflow: 'hidden',
  },
  suggestionItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  suggestionText: {
    color: colors.ink,
    fontSize: 14,
    fontWeight: '600',
  },
  suggestionUnit: {
    color: colors.accent,
    fontSize: 13,
  },
  selectedIngRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: 10,
    padding: 10,
    gap: 10,
    borderWidth: 1,
    borderColor: colors.border,
  },
  ingName: {
    flex: 1,
    color: colors.ink,
    fontSize: 14,
    fontWeight: '600',
  },
  amountInput: {
    width: 60,
    backgroundColor: colors.paper,
    color: colors.ink,
    padding: 8,
    borderRadius: 6,
    textAlign: 'center',
    borderWidth: 1,
    borderColor: colors.border,
  },
  unitLabel: {
    color: colors.muted,
    fontSize: 13,
    minWidth: 40,
  },
  removeIngBtn: {
    padding: 6,
  },
  removeIngText: {
    color: colors.error,
    fontWeight: '700',
  },
  equipmentWrap: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  equipChip: {
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 20,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
  },
  equipChipActive: {
    backgroundColor: colors.accent,
    borderColor: colors.accent,
  },
  equipChipText: {
    color: colors.muted,
    fontSize: 13,
  },
  equipChipTextActive: {
    color: colors.onAccent,
    fontWeight: '700',
  },
  stepCard: {
    backgroundColor: colors.surface,
    borderRadius: 14,
    padding: 14,
    borderWidth: 1,
    borderColor: colors.border,
    gap: 8,
  },
  stepHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  stepNumberBadge: {
    color: colors.accent,
    fontSize: 14,
    fontWeight: '800',
  },
  stepDeleteText: {
    color: colors.error,
    fontSize: 12,
  },
  stepInput: {
    minHeight: 65,
    textAlignVertical: 'top',
  },
  timerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  timerPrompt: {
    color: colors.muted,
    fontSize: 13,
  },
  timerMinutesInput: {
    width: 50,
    backgroundColor: colors.paper,
    color: colors.accent,
    padding: 6,
    borderRadius: 6,
    textAlign: 'center',
    fontWeight: '700',
    borderWidth: 1,
    borderColor: colors.border,
  },
  addStepBtn: {
    paddingVertical: 12,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: colors.accent,
    borderStyle: 'dashed',
    alignItems: 'center',
    marginTop: 6,
  },
  addStepBtnText: {
    color: colors.accent,
    fontWeight: '700',
    fontSize: 14,
  },
  actionRow: {
    flexDirection: 'row',
    gap: 12,
    marginTop: 20,
  },
  publishBtn: {
    flex: 2,
    backgroundColor: colors.accent,
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  publishBtnText: {
    color: colors.onAccent,
    fontSize: 16,
    fontWeight: '800',
  },
});
