// ==============================================================================
// LUTO (Logo: Lu2) — "Cooked It!" Completion & Pantry Deduction Modal
// Target: Post-Cooking Verified Review & Automatic Fridge Inventory Update
// ==============================================================================

import React, { useState } from 'react';
import {
  Modal,
  View,
  Text,
  StyleSheet,
  Pressable,
  ScrollView,
  TextInput,
  ActivityIndicator,
} from 'react-native';

export interface CookedIngredient {
  ingredientId: string;
  name: string;
  amount: number;
  unit: string;
}

interface CookedItModalProps {
  visible: boolean;
  recipeTitle: string;
  durationMinutes: number;
  ingredients: CookedIngredient[];
  onClose: () => void;
  onConfirm: (payload: {
    deductIngredientIds: string[];
    rating: number;
    reviewText: string;
  }) => Promise<void>;
}

export function CookedItModal({
  visible,
  recipeTitle,
  durationMinutes,
  ingredients,
  onClose,
  onConfirm,
}: CookedItModalProps) {
  // By default, select all ingredients for deduction
  const [selectedIds, setSelectedIds] = useState<Set<string>>(
    () => new Set(ingredients.map((i) => i.ingredientId))
  );
  const [rating, setRating] = useState<number>(5);
  const [reviewText, setReviewText] = useState<string>('');
  const [submitting, setSubmitting] = useState<boolean>(false);

  const toggleIngredient = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const handleComplete = async () => {
    setSubmitting(true);
    try {
      await onConfirm({
        deductIngredientIds: Array.from(selectedIds),
        rating,
        reviewText,
      });
      onClose();
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Modal visible={visible} animationType="slide" transparent>
      <View style={styles.overlay}>
        <View style={styles.card}>
          <Text style={styles.badge}>🎉 Cook Completed!</Text>
          <Text style={styles.title}>{recipeTitle}</Text>
          <Text style={styles.subtitle}>
            Finished in {durationMinutes} mins · Verified "Cooked It!"
          </Text>

          <ScrollView style={styles.scrollArea}>
            <Text style={styles.sectionHeading}>Rate this dish</Text>
            <View style={styles.starRow}>
              {[1, 2, 3, 4, 5].map((star) => (
                <Pressable
                  key={star}
                  onPress={() => setRating(star)}
                  style={styles.starButton}
                >
                  <Text style={[styles.starText, rating >= star && styles.starActive]}>
                    ★
                  </Text>
                </Pressable>
              ))}
            </View>

            <TextInput
              style={styles.reviewInput}
              placeholder="Add personal notes, pro tips, or tweaks..."
              placeholderTextColor="#8a9a86"
              value={reviewText}
              onChangeText={setReviewText}
              multiline
              numberOfLines={3}
            />

            <Text style={styles.sectionHeading}>
              Deduct ingredients from your fridge?
            </Text>
            <Text style={styles.caption}>
              Uncheck anything you didn't use or swapped out:
            </Text>

            {ingredients.map((item) => {
              const isChecked = selectedIds.has(item.ingredientId);
              return (
                <Pressable
                  key={item.ingredientId}
                  style={[styles.ingredientRow, isChecked && styles.ingredientRowSelected]}
                  onPress={() => toggleIngredient(item.ingredientId)}
                >
                  <View style={[styles.checkbox, isChecked && styles.checkboxActive]}>
                    {isChecked && <Text style={styles.checkmark}>✓</Text>}
                  </View>
                  <Text style={styles.ingredientName}>{item.name}</Text>
                  <Text style={styles.ingredientAmount}>
                    {item.amount} {item.unit}
                  </Text>
                </Pressable>
              );
            })}
          </ScrollView>

          <View style={styles.actionRow}>
            <Pressable
              style={styles.cancelButton}
              onPress={onClose}
              disabled={submitting}
            >
              <Text style={styles.cancelText}>Cancel</Text>
            </Pressable>
            <Pressable
              style={styles.confirmButton}
              onPress={handleComplete}
              disabled={submitting}
            >
              {submitting ? (
                <ActivityIndicator color="#fff" />
              ) : (
                <Text style={styles.confirmText}>Deduct & Save</Text>
              )}
            </Pressable>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.65)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  card: {
    width: '100%',
    maxHeight: '85%',
    backgroundColor: '#1b2a21',
    borderRadius: 20,
    padding: 20,
    borderWidth: 1,
    borderColor: '#2e4938',
  },
  badge: {
    color: '#84e1bc',
    fontSize: 14,
    fontWeight: '700',
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  title: {
    color: '#f3f4f6',
    fontSize: 22,
    fontWeight: '800',
    marginTop: 4,
  },
  subtitle: {
    color: '#9ca3af',
    fontSize: 13,
    marginBottom: 16,
  },
  scrollArea: {
    marginVertical: 8,
  },
  sectionHeading: {
    color: '#f9fafb',
    fontSize: 15,
    fontWeight: '700',
    marginTop: 12,
    marginBottom: 6,
  },
  caption: {
    color: '#9ca3af',
    fontSize: 12,
    marginBottom: 8,
  },
  starRow: {
    flexDirection: 'row',
    marginBottom: 12,
    gap: 8,
  },
  starButton: {
    padding: 4,
  },
  starText: {
    fontSize: 32,
    color: '#4b5563',
  },
  starActive: {
    color: '#fbbf24',
  },
  reviewInput: {
    backgroundColor: '#111d16',
    borderColor: '#2e4938',
    borderWidth: 1,
    borderRadius: 10,
    padding: 10,
    color: '#f3f4f6',
    fontSize: 14,
    minHeight: 60,
    textAlignVertical: 'top',
  },
  ingredientRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderRadius: 8,
    backgroundColor: '#111d16',
    marginBottom: 6,
    borderWidth: 1,
    borderColor: '#1e3325',
  },
  ingredientRowSelected: {
    borderColor: '#38a169',
    backgroundColor: '#15291d',
  },
  checkbox: {
    width: 22,
    height: 22,
    borderRadius: 6,
    borderWidth: 2,
    borderColor: '#4b5563',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
  checkboxActive: {
    backgroundColor: '#38a169',
    borderColor: '#38a169',
  },
  checkmark: {
    color: '#ffffff',
    fontSize: 13,
    fontWeight: '800',
  },
  ingredientName: {
    flex: 1,
    color: '#e5e7eb',
    fontSize: 14,
    fontWeight: '600',
  },
  ingredientAmount: {
    color: '#9ca3af',
    fontSize: 13,
  },
  actionRow: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: 12,
    marginTop: 16,
  },
  cancelButton: {
    paddingVertical: 12,
    paddingHorizontal: 18,
    borderRadius: 10,
    backgroundColor: '#263b2f',
  },
  cancelText: {
    color: '#d1d5db',
    fontSize: 14,
    fontWeight: '600',
  },
  confirmButton: {
    paddingVertical: 12,
    paddingHorizontal: 22,
    borderRadius: 10,
    backgroundColor: '#25855a',
  },
  confirmText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
});
