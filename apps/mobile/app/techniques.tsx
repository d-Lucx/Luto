import { useState } from 'react';
import { FlatList, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { ActionButton } from '../src/components/ActionButton';
import { colors, headingFont } from '../src/theme';
import library from '../src/content/learningLibrary.json';
import { basics } from '../src/content/basics';
const techniques = [...basics.map((b) => ({ ...b, tips: [] as string[], mistakes: [] as string[] })), ...library.techniques];
export default function TechniquesScreen() {
  const [query, setQuery] = useState(''); const router = useRouter();
  return <SafeAreaView style={styles.page}><FlatList data={techniques.filter((t) => `${t.title} ${t.summary}`.toLowerCase().includes(query.trim().toLowerCase()))} keyExtractor={(item) => item.slug} contentContainerStyle={styles.content}
    ListHeaderComponent={<View style={styles.card}><ActionButton secondary label="Back to cooking" onPress={() => router.canGoBack() ? router.back() : router.replace('/(tabs)/recipes')} /><Text accessibilityRole="header" style={styles.title}>A little kitchen know-how</Text><Text style={styles.body}>Plain-language explainers, available offline. Follow your recipe’s quantities, cooking cues, and food-specific instructions.</Text><TextInput accessibilityLabel="Search technique explainers" style={styles.input} value={query} onChangeText={setQuery} placeholder="Search a cooking term" placeholderTextColor={colors.muted} /></View>}
    ListEmptyComponent={<Text style={styles.body}>No matching terms. Try a different word.</Text>}
    renderItem={({ item }) => <View style={styles.card}><Text accessibilityRole="header" style={styles.heading}>{item.title}</Text><Text style={styles.body}>{item.summary}</Text>{item.tips.map((tip) => <Text key={tip} style={styles.body}>• {tip}</Text>)}{!!item.mistakes.length && <Text style={styles.heading}>Watch out for</Text>}{item.mistakes.map((tip) => <Text key={tip} style={styles.body}>• {tip}</Text>)}</View>} /></SafeAreaView>;
}
const styles = StyleSheet.create({ page: { flex: 1, backgroundColor: colors.paper }, content: { width: '100%', maxWidth: 720, alignSelf: 'center', padding: 24, gap: 16 }, card: { gap: 12, padding: 16, backgroundColor: colors.surface, borderRadius: 12 }, title: { fontSize: 30, fontFamily: headingFont, color: colors.ink }, heading: { fontSize: 22, fontFamily: headingFont, color: colors.ink }, body: { fontSize: 16, lineHeight: 25, color: colors.ink }, input: { minHeight: 52, padding: 12, borderWidth: 1, borderColor: colors.border, borderRadius: 12, fontSize: 16, color: colors.ink } });
