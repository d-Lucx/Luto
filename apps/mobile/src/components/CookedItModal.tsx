import { useRef, useState } from 'react';
import { ActivityIndicator, Modal, Pressable, ScrollView, StyleSheet, Text, useWindowDimensions, View } from 'react-native';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors, headingFont } from '../theme';

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
  onConfirm: (payload: { deductIngredientIds: string[] }) => Promise<void>;
}

export function CookedItModal({ visible, recipeTitle, durationMinutes, ingredients, onClose, onConfirm }: CookedItModalProps) {
  const { height: windowHeight } = useWindowDimensions();
  const insets = useSafeAreaInsets();
  const modalHeight = Math.max(1, Math.min(windowHeight * 0.85, windowHeight - insets.top - insets.bottom - 40));
  const [selectedIds, setSelectedIds] = useState(() => new Set(ingredients.map((item) => item.ingredientId)));
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const saving = useRef(false);

  function toggle(id: string) {
    setSelectedIds((previous) => {
      const next = new Set(previous);
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
  }

  async function finish(ids: string[]) {
    if (saving.current) return;
    saving.current = true;
    setSubmitting(true);
    setError('');
    try {
      await onConfirm({ deductIngredientIds: ids });
      onClose();
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : 'Your pantry could not be updated. Please try again.');
    } finally {
      saving.current = false;
      setSubmitting(false);
    }
  }

  return <Modal visible={visible} animationType="slide" transparent onRequestClose={() => { if (!saving.current) onClose(); }}>
    <SafeAreaView style={styles.overlay} edges={['top', 'bottom']}>
      <View style={[styles.card, { height: modalHeight }]} accessibilityViewIsModal>
        <ScrollView style={styles.scroll} contentContainerStyle={styles.content}>
          <Text style={styles.eyebrow}>COOKED IT!</Text>
          <Text accessibilityRole="header" style={styles.title}>{recipeTitle}</Text>
          <Text style={styles.body}>About {durationMinutes} {durationMinutes === 1 ? 'minute' : 'minutes'} in your kitchen.</Text>
          <Text accessibilityRole="header" style={styles.heading}>Update your pantry</Text>
          <Text style={styles.body}>Keep checked only the ingredients you used from your pantry. Uncheck anything you replaced or did not track.</Text>
          {ingredients.map((item, index) => <Pressable key={`${item.ingredientId}-${index}`}
            accessibilityRole="checkbox" accessibilityState={{ checked: selectedIds.has(item.ingredientId), disabled: submitting }}
            accessibilityLabel={`${item.name}, ${item.amount} ${item.unit}`} disabled={submitting}
            onPress={() => toggle(item.ingredientId)}
            style={({ pressed }) => [styles.ingredient, selectedIds.has(item.ingredientId) && styles.selected, pressed && styles.pressed]}>
            <Text style={styles.check} accessible={false}>{selectedIds.has(item.ingredientId) ? '✓' : '○'}</Text>
            <View style={styles.ingredientText}>
              <Text style={styles.body}>{item.name}</Text>
              <Text style={styles.muted}>{item.amount} {item.unit}</Text>
            </View>
          </Pressable>)}
          {!!error && <Text accessibilityRole="alert" accessibilityLiveRegion="polite" style={styles.error}>{error}</Text>}
          <Text style={styles.muted}>Your pantry update stays on this device. Community reviews are available from a published recipe’s page.</Text>
          <Pressable accessibilityRole="button" disabled={submitting} accessibilityState={{ disabled: submitting }}
            onPress={() => void finish([...selectedIds])} style={({ pressed }) => [styles.button, pressed && styles.pressed]}>
            {submitting ? <ActivityIndicator color={colors.onAccent} /> : <Text style={styles.buttonText}>Confirm and finish</Text>}
          </Pressable>
          <Pressable accessibilityRole="button" disabled={submitting} accessibilityState={{ disabled: submitting }}
            onPress={() => void finish([])} style={({ pressed }) => [styles.secondary, pressed && styles.pressed]}>
            <Text style={styles.secondaryText}>Finish without deduction</Text>
          </Pressable>
          <Pressable accessibilityRole="button" disabled={submitting} accessibilityState={{ disabled: submitting }}
            onPress={onClose} style={({ pressed }) => [styles.secondary, pressed && styles.pressed]}>
            <Text style={styles.secondaryText}>Back to cooking</Text>
          </Pressable>
        </ScrollView>
      </View>
    </SafeAreaView>
  </Modal>;
}

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(30,24,18,0.6)', justifyContent: 'center', padding: 20 },
  card: { width: '100%', maxWidth: 600, alignSelf: 'center', backgroundColor: colors.surface, borderRadius: 20, overflow: 'hidden' },
  scroll: { flex: 1 },
  content: { padding: 24, gap: 16 },
  eyebrow: { color: colors.accent, fontSize: 13, fontWeight: '700', letterSpacing: 1 },
  title: { color: colors.ink, fontFamily: headingFont, fontSize: 28 },
  heading: { color: colors.ink, fontFamily: headingFont, fontSize: 24, marginTop: 8 },
  body: { color: colors.ink, fontSize: 16, lineHeight: 25 },
  muted: { color: colors.muted, fontSize: 14, lineHeight: 22 },
  ingredient: { flexDirection: 'row', minHeight: 56, gap: 12, alignItems: 'center', padding: 12, borderWidth: 1, borderColor: colors.border, borderRadius: 10 },
  selected: { borderColor: colors.accent, backgroundColor: colors.paper },
  ingredientText: { flex: 1, gap: 4 },
  check: { fontSize: 23, color: colors.accent },
  error: { color: colors.error, fontSize: 16, lineHeight: 25 },
  button: { minHeight: 52, backgroundColor: colors.accent, padding: 16, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
  buttonText: { color: colors.onAccent, fontSize: 16, fontWeight: '700' },
  secondary: { minHeight: 48, alignItems: 'center', justifyContent: 'center', padding: 12 },
  secondaryText: { color: colors.accent, fontSize: 16, fontWeight: '700' },
  pressed: { opacity: 0.75 },
});
