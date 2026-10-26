// ==============================================================================
// LUTO (Logo: Lu2) — Community Recipe Creator Flow
// Screen: app/recipes/new.tsx
// ==============================================================================

import React, { useEffect, useState } from 'react';
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
import { useRouter } from 'expo-router';
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
}

export default function NewRecipeScreen() {
  const router = useRouter();

  // Step wizard stage: 1 = Metadata, 2 = Ingredients, 3 = Equipment & Steps
  const [wizardStage, setWizardStage] = useState<1 | 2 | 3>(1);

  // Metadata
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [servings, setServings] = useState('4');
  const [prepMinutes, setPrepMinutes] = useState('15');
  const [cookMinutes, setCookMinutes] = useState('25');

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

  useEffect(() => {
    async function loadMasters() {
      try {
        const [ings, equips] = await Promise.all([
          database.get<Ingredient>('ingredients').query().fetch(),
          database.get<Equipment>('equipment').query().fetch(),
        ]);
        setAvailableIngredients(ings);
        setAvailableEquipment(equips);
      } catch (err) {
        console.warn('Could not load master taxonomy for creator', err);
      }
    }
    void loadMasters();
  }, []);

  const filteredIngredients = ingSearch.trim()
    ? availableIngredients
        .filter((i) => i.displayName.toLowerCase().includes(ingSearch.toLowerCase()))
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
      prev.map((s, idx) => (idx === index ? { ...s, timerMinutes } : s))
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
    if (!title.trim()) {
      Alert.alert('Required', 'Please enter a recipe title.');
      setWizardStage(1);
      return;
    }
    if (selectedIngredients.length === 0) {
      Alert.alert('Required', 'Please add at least one ingredient.');
      setWizardStage(2);
      return;
    }
    const hasEmptyStep = recipeSteps.some((s) => !s.instruction.trim());
    if (hasEmptyStep) {
      Alert.alert('Required', 'All recipe steps must have instructions.');
      return;
    }

    setSaving(true);
    try {
      await database.write(async () => {
        const recipeCollection = database.get<Recipe>('local_recipes');
        const stepCollection = database.get<RecipeStep>('local_steps');
        const ingCollection = database.get<RecipeIngredient>('local_ingredients');

        const newRecipe = recipeCollection.prepareCreate((r) => {
          r.title = title.trim();
          r.description = description.trim();
          r.servings = parseInt(servings, 10) || 4;
          r.heroImageUrl = '';
          r.updatedAt = Date.now();
        });

        const stepRecords = recipeSteps.map((s) =>
          stepCollection.prepareCreate((rec) => {
            rec.recipeId = newRecipe.id;
            rec.stepNumber = s.stepNumber;
            rec.instruction = s.instruction.trim();
            rec.timerDurationSeconds = (parseInt(s.timerMinutes, 10) || 0) * 60;
          })
        );

        const ingRecords = selectedIngredients.map((i) =>
          ingCollection.prepareCreate((rec) => {
            rec.recipeId = newRecipe.id;
            rec.ingredientId = i.ingredientId;
            rec.amount = parseFloat(i.amount) || 1;
            rec.unit = i.unit;
            rec.isOptional = i.isOptional;
            rec.tier = i.tier;
          })
        );

        await database.batch(newRecipe, ...stepRecords, ...ingRecords);
      });

      Alert.alert('Recipe Published', 'Your recipe has been saved successfully!');
      router.back();
    } catch (err) {
      Alert.alert('Save Failed', err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setSaving(false);
    }
  };

  return (
    <SafeAreaView style={styles.screen}>
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

      <ScrollView contentContainerStyle={styles.scrollArea}>
        {/* STAGE 1: METADATA */}
        {wizardStage === 1 && (
          <View style={styles.formSection}>
            <Text style={styles.sectionTitle}>Recipe Details</Text>

            <Text style={styles.label}>Recipe Title</Text>
            <TextInput
              style={styles.input}
              placeholder="e.g. Crispy Garlic Butter Noodles"
              placeholderTextColor="#8a9a86"
              value={title}
              onChangeText={setTitle}
            />

            <Text style={styles.label}>Description & Flavor Story</Text>
            <TextInput
              style={[styles.input, styles.textArea]}
              placeholder="A quick 15-minute comfort food favorite..."
              placeholderTextColor="#8a9a86"
              value={description}
              onChangeText={setDescription}
              multiline
              numberOfLines={3}
            />

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
              placeholderTextColor="#8a9a86"
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
                  placeholderTextColor="#8a9a86"
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
                  <ActivityIndicator color="#fff" />
                ) : (
                  <Text style={styles.publishBtnText}>Publish Recipe ✓</Text>
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
    backgroundColor: '#0c1610',
  },
  wizardBar: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderColor: '#1e3325',
    backgroundColor: '#122017',
  },
  wizardTab: {
    flex: 1,
    paddingVertical: 14,
    alignItems: 'center',
  },
  wizardTabActive: {
    borderBottomWidth: 3,
    borderBottomColor: '#10b981',
  },
  wizardTabText: {
    color: '#6b7280',
    fontSize: 13,
    fontWeight: '700',
  },
  wizardTabTextActive: {
    color: '#a7f3d0',
  },
  scrollArea: {
    padding: 20,
    paddingBottom: 40,
  },
  formSection: {
    gap: 12,
  },
  sectionTitle: {
    color: '#f9fafb',
    fontSize: 22,
    fontWeight: '800',
    marginBottom: 8,
  },
  label: {
    color: '#d1fae5',
    fontSize: 14,
    fontWeight: '600',
    marginTop: 4,
  },
  subHeading: {
    color: '#f9fafb',
    fontSize: 16,
    fontWeight: '700',
    marginTop: 16,
  },
  input: {
    backgroundColor: '#15241b',
    borderWidth: 1,
    borderColor: '#244030',
    borderRadius: 10,
    padding: 12,
    color: '#ffffff',
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
    backgroundColor: '#059669',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
    marginTop: 18,
  },
  nextStageBtnFlex: {
    flex: 2,
    backgroundColor: '#059669',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  nextStageBtnText: {
    color: '#ffffff',
    fontSize: 15,
    fontWeight: '700',
  },
  prevStageBtn: {
    flex: 1,
    backgroundColor: '#1f2937',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  prevStageBtnText: {
    color: '#d1d5db',
    fontSize: 15,
    fontWeight: '600',
  },
  suggestionsBox: {
    backgroundColor: '#1b2c21',
    borderRadius: 10,
    borderWidth: 1,
    borderColor: '#2b4b35',
    overflow: 'hidden',
  },
  suggestionItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#244030',
  },
  suggestionText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
  },
  suggestionUnit: {
    color: '#34d399',
    fontSize: 13,
  },
  selectedIngRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#15241b',
    borderRadius: 10,
    padding: 10,
    gap: 10,
    borderWidth: 1,
    borderColor: '#244030',
  },
  ingName: {
    flex: 1,
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
  },
  amountInput: {
    width: 60,
    backgroundColor: '#0c1610',
    color: '#ffffff',
    padding: 8,
    borderRadius: 6,
    textAlign: 'center',
    borderWidth: 1,
    borderColor: '#244030',
  },
  unitLabel: {
    color: '#9ca3af',
    fontSize: 13,
    minWidth: 40,
  },
  removeIngBtn: {
    padding: 6,
  },
  removeIngText: {
    color: '#f87171',
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
    backgroundColor: '#15241b',
    borderWidth: 1,
    borderColor: '#244030',
  },
  equipChipActive: {
    backgroundColor: '#059669',
    borderColor: '#34d399',
  },
  equipChipText: {
    color: '#9ca3af',
    fontSize: 13,
  },
  equipChipTextActive: {
    color: '#ffffff',
    fontWeight: '700',
  },
  stepCard: {
    backgroundColor: '#15241b',
    borderRadius: 14,
    padding: 14,
    borderWidth: 1,
    borderColor: '#244030',
    gap: 8,
  },
  stepHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  stepNumberBadge: {
    color: '#34d399',
    fontSize: 14,
    fontWeight: '800',
  },
  stepDeleteText: {
    color: '#f87171',
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
    color: '#9ca3af',
    fontSize: 13,
  },
  timerMinutesInput: {
    width: 50,
    backgroundColor: '#0c1610',
    color: '#fbbf24',
    padding: 6,
    borderRadius: 6,
    textAlign: 'center',
    fontWeight: '700',
    borderWidth: 1,
    borderColor: '#244030',
  },
  addStepBtn: {
    paddingVertical: 12,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: '#34d399',
    borderStyle: 'dashed',
    alignItems: 'center',
    marginTop: 6,
  },
  addStepBtnText: {
    color: '#34d399',
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
    backgroundColor: '#10b981',
    borderRadius: 12,
    paddingVertical: 14,
    alignItems: 'center',
  },
  publishBtnText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '800',
  },
});
