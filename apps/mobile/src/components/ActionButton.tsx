import { Pressable, Text } from 'react-native';
import { colors } from '../theme';
export function ActionButton({ label, onPress, disabled = false, secondary = false }: { label: string; onPress: () => void; disabled?: boolean; secondary?: boolean }) {
  return <Pressable accessibilityRole="button" accessibilityState={{ disabled }} disabled={disabled} onPress={onPress}
    style={({ pressed }) => ({ minHeight: 52, borderRadius: 12, padding: 14, justifyContent: 'center', alignItems: 'center', borderWidth: 1,
      borderColor: colors.accent, backgroundColor: secondary ? colors.surface : colors.accent, opacity: disabled ? 0.5 : pressed ? 0.8 : 1 })}>
    <Text style={{ color: secondary ? colors.accent : colors.onAccent, fontSize: 16, fontWeight: '700' }}>{label}</Text>
  </Pressable>;
}
