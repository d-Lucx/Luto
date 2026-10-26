// ==============================================================================
// LUTO (Logo: Lu2) — Hands-Free Distraction-Free Kitchen Cooking Mode
// Screen: app/cook/[id].tsx
// ==============================================================================

import React, { useEffect, useMemo, useState } from 'react';
import {
  ActivityIndicator,
  Modal,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Q } from '@nozbe/watermelondb';
import { database } from '../../src/database/index';
import { Recipe, RecipeIngredient, RecipeStep, Technique, UserPantry, Ingredient } from '../../src/database/models';
import { LOCAL_GUEST_ID } from '../../src/database/pantry';
import { TimerManager, CookingTimer } from '../../src/services/timer/TimerManager';
import { CookedItModal, CookedIngredient } from '../../src/components/CookedItModal';
import { calculatePantryDecrement } from '../../src/engine/decrementPantry';

export default function CookingModeScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  const [loading, setLoading] = useState(true);
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [steps, setSteps] = useState<RecipeStep[]>([]);
  const [ingredients, setIngredients] = useState<CookedIngredient[]>([]);
  const [activeStepIndex, setActiveStepIndex] = useState(0);

  // Technique Modal State
  const [activeTechnique, setActiveTechnique] = useState<Technique | null>(null);

  // Timer State
  const timerManager = useMemo(() => new TimerManager(), []);
  const [activeTimers, setActiveTimers] = useState<CookingTimer[]>([]);

  // Completion / Deduction Modal
  const [showCompletionModal, setShowCompletionModal] = useState(false);
  const [startTimeMs] = useState(Date.now());

  useEffect(() => {
    let active = true;

    async function loadRecipeData() {
      if (!id) return;
      try {
        const recipeRecord = await database.get<Recipe>('local_recipes').find(id);
        const stepRecords = await database
          .get<RecipeStep>('local_steps')
          .query(Q.where('recipe_id', id), Q.sortBy('step_number', Q.asc))
          .fetch();

        const reqRecords = await database
          .get<RecipeIngredient>('local_ingredients')
          .query(Q.where('recipe_id', id))
          .fetch();

        const ingredientDictionary = await database.get<Ingredient>('ingredients').query().fetch();
        const dictMap = new Map(ingredientDictionary.map((i) => [i.id, i.displayName]));

        const cookedList: CookedIngredient[] = reqRecords.map((r) => ({
          ingredientId: r.ingredientId,
          name: dictMap.get(r.ingredientId) || 'Ingredient',
          amount: r.amount,
          unit: r.unit,
        }));

        if (active) {
          setRecipe(recipeRecord);
          setSteps(stepRecords);
          setIngredients(cookedList);

          // Initialize timers for steps that have durations
          for (const s of stepRecords) {
            if (s.timerDurationSeconds > 0) {
              timerManager.createTimer(
                `timer-step-${s.stepNumber}`,
                s.stepNumber,
                `Step ${s.stepNumber} Timer`,
                s.timerDurationSeconds
              );
            }
          }
        }
      } catch (err) {
        console.warn('Failed to load recipe for cook mode', err);
      } finally {
        if (active) setLoading(false);
      }
    }

    void loadRecipeData();
    const unsub = timerManager.subscribe((t) => setActiveTimers([...t]));

    return () => {
      active = false;
      unsub();
      timerManager.stopClock();
    };
  }, [id, timerManager]);

  const currentStep = steps[activeStepIndex];
  const stepTimer = currentStep
    ? activeTimers.find((t) => t.stepNumber === currentStep.stepNumber)
    : undefined;

  const handleFinishCooking = () => {
    setShowCompletionModal(true);
  };

  const handleConfirmDeduction = async ({
    deductIngredientIds,
  }: {
    deductIngredientIds: string[];
    rating: number;
    reviewText: string;
  }) => {
    try {
      const pantryRecords = await database
        .get<UserPantry>('local_pantry')
        .query(Q.where('user_id', LOCAL_GUEST_ID))
        .fetch();

      const usedItems = ingredients.map((item) => ({
        ingredientId: item.ingredientId,
        amount: item.amount,
        unit: item.unit,
        selected: deductIngredientIds.includes(item.ingredientId),
      }));

      const stockItems = pantryRecords.map((p) => ({
        id: p.id,
        ingredientId: p.ingredientId,
        quantity: p.quantity,
        unit: p.unit,
      }));

      const { updatedStock, deletedStockIds } = calculatePantryDecrement(stockItems, usedItems);

      await database.write(async () => {
        const batchOps: any[] = [];
        for (const record of pantryRecords) {
          if (deletedStockIds.includes(record.id)) {
            batchOps.push(record.prepareMarkAsDeleted());
          } else if (updatedStock.has(record.ingredientId)) {
            const newQty = updatedStock.get(record.ingredientId)!;
            batchOps.push(
              record.prepareUpdate((p) => {
                p.quantity = newQty;
                p.updatedAt = Date.now();
              })
            );
          }
        }
        if (batchOps.length > 0) {
          await database.batch(...batchOps);
        }
      });
    } catch (e) {
      console.warn('Error deducting pantry', e);
    } finally {
      router.back();
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#38a169" />
        <Text style={styles.loadingText}>Setting up kitchen mode...</Text>
      </SafeAreaView>
    );
  }

  if (!recipe || steps.length === 0) {
    return (
      <SafeAreaView style={styles.loadingContainer}>
        <Text style={styles.errorText}>Recipe steps not found.</Text>
        <Pressable style={styles.backButton} onPress={() => router.back()}>
          <Text style={styles.backButtonText}>Return</Text>
        </Pressable>
      </SafeAreaView>
    );
  }

  const elapsedMinutes = Math.max(1, Math.round((Date.now() - startTimeMs) / 60000));

  return (
    <SafeAreaView style={styles.screen}>
      {/* Top Header */}
      <View style={styles.header}>
        <Pressable style={styles.exitBtn} onPress={() => router.back()}>
          <Text style={styles.exitBtnText}>✕ Exit</Text>
        </Pressable>
        <Text style={styles.headerTitle} numberOfLines={1}>
          {recipe.title}
        </Text>
        <Text style={styles.stepProgress}>
          {activeStepIndex + 1} / {steps.length}
        </Text>
      </View>

      {/* Main Step Display */}
      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.stepCard}>
          <Text style={styles.stepLabel}>STEP {currentStep.stepNumber}</Text>
          <Text style={styles.instructionText}>{currentStep.instruction}</Text>

          {/* Active Step Timer Widget */}
          {stepTimer && (
            <View style={styles.timerBox}>
              <Text style={styles.timerLabel}>{stepTimer.label}</Text>
              <Text style={styles.timerDigits}>
                {TimerManager.formatTime(stepTimer.remainingSeconds)}
              </Text>
              <View style={styles.timerControls}>
                {stepTimer.status !== 'running' ? (
                  <Pressable
                    style={styles.timerStartBtn}
                    onPress={() => timerManager.startTimer(stepTimer.id)}
                  >
                    <Text style={styles.timerBtnText}>▶ Start Timer</Text>
                  </Pressable>
                ) : (
                  <Pressable
                    style={styles.timerPauseBtn}
                    onPress={() => timerManager.pauseTimer(stepTimer.id)}
                  >
                    <Text style={styles.timerBtnText}>⏸ Pause</Text>
                  </Pressable>
                )}
                <Pressable
                  style={styles.timerResetBtn}
                  onPress={() => timerManager.resetTimer(stepTimer.id)}
                >
                  <Text style={styles.timerBtnTextSecondary}>↺ Reset</Text>
                </Pressable>
              </View>
            </View>
          )}
        </View>
      </ScrollView>

      {/* Bottom Navigation Bar */}
      <View style={styles.footer}>
        <Pressable
          style={[styles.navBtn, activeStepIndex === 0 && styles.navBtnDisabled]}
          disabled={activeStepIndex === 0}
          onPress={() => setActiveStepIndex((prev) => Math.max(0, prev - 1))}
        >
          <Text style={styles.navBtnText}>← Previous</Text>
        </Pressable>

        {activeStepIndex < steps.length - 1 ? (
          <Pressable
            style={styles.nextBtn}
            onPress={() => setActiveStepIndex((prev) => Math.min(steps.length - 1, prev + 1))}
          >
            <Text style={styles.nextBtnText}>Next Step →</Text>
          </Pressable>
        ) : (
          <Pressable style={styles.finishBtn} onPress={handleFinishCooking}>
            <Text style={styles.finishBtnText}>✓ Finish Cooking</Text>
          </Pressable>
        )}
      </View>

      {/* Technique Modal */}
      <Modal visible={Boolean(activeTechnique)} transparent animationType="fade">
        <View style={styles.modalBackdrop}>
          <View style={styles.techniqueModal}>
            <Text style={styles.techniqueBadge}>TECHNIQUE GUIDE</Text>
            <Text style={styles.techniqueTitle}>{activeTechnique?.title}</Text>
            <Text style={styles.techniqueSummary}>{activeTechnique?.summary}</Text>
            <Pressable
              style={styles.modalCloseBtn}
              onPress={() => setActiveTechnique(null)}
            >
              <Text style={styles.modalCloseText}>Got it</Text>
            </Pressable>
          </View>
        </View>
      </Modal>

      {/* Post-Cook Deduction & Review Modal */}
      <CookedItModal
        visible={showCompletionModal}
        recipeTitle={recipe.title}
        durationMinutes={elapsedMinutes}
        ingredients={ingredients}
        onClose={() => setShowCompletionModal(false)}
        onConfirm={handleConfirmDeduction}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: '#0c1610',
  },
  loadingContainer: {
    flex: 1,
    backgroundColor: '#0c1610',
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    color: '#a7f3d0',
    marginTop: 12,
    fontSize: 16,
  },
  errorText: {
    color: '#f87171',
    fontSize: 18,
    marginBottom: 16,
  },
  backButton: {
    padding: 12,
    backgroundColor: '#1b2a21',
    borderRadius: 8,
  },
  backButtonText: {
    color: '#fff',
    fontWeight: '600',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderColor: '#1e3325',
  },
  exitBtn: {
    paddingVertical: 6,
    paddingHorizontal: 10,
    borderRadius: 8,
    backgroundColor: '#1b2a21',
  },
  exitBtnText: {
    color: '#9ca3af',
    fontWeight: '700',
    fontSize: 14,
  },
  headerTitle: {
    flex: 1,
    marginHorizontal: 12,
    textAlign: 'center',
    color: '#d1fae5',
    fontSize: 16,
    fontWeight: '700',
  },
  stepProgress: {
    color: '#84e1bc',
    fontSize: 14,
    fontWeight: '800',
  },
  content: {
    flexGrow: 1,
    padding: 24,
    justifyContent: 'center',
  },
  stepCard: {
    backgroundColor: '#14231a',
    borderRadius: 24,
    padding: 28,
    borderWidth: 1,
    borderColor: '#244030',
  },
  stepLabel: {
    color: '#34d399',
    fontSize: 15,
    fontWeight: '800',
    letterSpacing: 2,
    marginBottom: 14,
  },
  instructionText: {
    color: '#f9fafb',
    fontSize: 25,
    lineHeight: 38,
    fontWeight: '600',
  },
  timerBox: {
    marginTop: 28,
    backgroundColor: '#0c1610',
    borderRadius: 16,
    padding: 20,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#1e3325',
  },
  timerLabel: {
    color: '#9ca3af',
    fontSize: 13,
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  timerDigits: {
    color: '#fbbf24',
    fontSize: 52,
    fontWeight: '900',
    fontVariant: ['tabular-nums'],
    marginVertical: 8,
  },
  timerControls: {
    flexDirection: 'row',
    gap: 12,
  },
  timerStartBtn: {
    backgroundColor: '#059669',
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  timerPauseBtn: {
    backgroundColor: '#d97706',
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  timerResetBtn: {
    backgroundColor: '#1f2937',
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
  },
  timerBtnText: {
    color: '#ffffff',
    fontWeight: '700',
    fontSize: 14,
  },
  timerBtnTextSecondary: {
    color: '#9ca3af',
    fontWeight: '600',
    fontSize: 14,
  },
  footer: {
    flexDirection: 'row',
    padding: 20,
    borderTopWidth: 1,
    borderColor: '#1e3325',
    backgroundColor: '#0c1610',
    gap: 14,
  },
  navBtn: {
    flex: 1,
    paddingVertical: 16,
    backgroundColor: '#1b2a21',
    borderRadius: 14,
    alignItems: 'center',
  },
  navBtnDisabled: {
    opacity: 0.35,
  },
  navBtnText: {
    color: '#d1d5db',
    fontSize: 16,
    fontWeight: '700',
  },
  nextBtn: {
    flex: 1.5,
    paddingVertical: 16,
    backgroundColor: '#059669',
    borderRadius: 14,
    alignItems: 'center',
  },
  nextBtnText: {
    color: '#ffffff',
    fontSize: 17,
    fontWeight: '800',
  },
  finishBtn: {
    flex: 1.5,
    paddingVertical: 16,
    backgroundColor: '#10b981',
    borderRadius: 14,
    alignItems: 'center',
  },
  finishBtnText: {
    color: '#ffffff',
    fontSize: 17,
    fontWeight: '800',
  },
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.7)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  techniqueModal: {
    width: '100%',
    backgroundColor: '#1b2a21',
    borderRadius: 20,
    padding: 24,
    borderWidth: 1,
    borderColor: '#38a169',
  },
  techniqueBadge: {
    color: '#34d399',
    fontSize: 12,
    fontWeight: '800',
    letterSpacing: 1.5,
  },
  techniqueTitle: {
    color: '#ffffff',
    fontSize: 22,
    fontWeight: '800',
    marginVertical: 8,
  },
  techniqueSummary: {
    color: '#d1d5db',
    fontSize: 15,
    lineHeight: 22,
    marginBottom: 20,
  },
  modalCloseBtn: {
    backgroundColor: '#059669',
    paddingVertical: 12,
    borderRadius: 10,
    alignItems: 'center',
  },
  modalCloseText: {
    color: '#ffffff',
    fontWeight: '700',
    fontSize: 15,
  },
});
