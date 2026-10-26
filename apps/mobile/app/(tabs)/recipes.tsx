// ==============================================================================
// LUTO (Logo: Lu2) — Recipe Catalog Screen
// Screen: app/(tabs)/recipes.tsx
// ==============================================================================

import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';
import { database } from '../../src/database/index';
import { Recipe } from '../../src/database/models';

export default function RecipesScreen() {
  const router = useRouter();
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;

    async function fetchRecipes() {
      try {
        const list = await database.get<Recipe>('local_recipes').query().fetch();
        if (active) setRecipes(list);
      } catch (e) {
        console.warn('Error reading recipes', e);
      } finally {
        if (active) setLoading(false);
      }
    }

    void fetchRecipes();
    const subscription = database
      .withChangesForTables(['local_recipes'])
      .subscribe({ next: () => void fetchRecipes() });

    return () => {
      active = false;
      subscription.unsubscribe();
    };
  }, []);

  const filtered = recipes.filter((r) =>
    r.title.toLowerCase().includes(search.trim().toLowerCase())
  );

  return (
    <SafeAreaView style={styles.screen}>
      <View style={styles.header}>
        <View>
          <Text style={styles.title}>Luto Recipes</Text>
          <Text style={styles.subtitle}>Discover & Cook with what you have</Text>
        </View>
        <Pressable
          style={styles.createButton}
          onPress={() => router.push('/recipes/new')}
        >
          <Text style={styles.createButtonText}>+ Create</Text>
        </Pressable>
      </View>

      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Search recipes, tags, cuisines..."
          placeholderTextColor="#8a9a86"
          value={search}
          onChangeText={setSearch}
        />
      </View>

      {loading ? (
        <View style={styles.centerContainer}>
          <ActivityIndicator size="large" color="#10b981" />
          <Text style={styles.loadingText}>Loading recipes...</Text>
        </View>
      ) : filtered.length === 0 ? (
        <View style={styles.centerContainer}>
          <Text style={styles.emptyTitle}>No Recipes Found</Text>
          <Text style={styles.emptySubtitle}>
            {search ? 'Try adjusting your search terms.' : 'Create a recipe or sync from the community!'}
          </Text>
        </View>
      ) : (
        <FlatList
          data={filtered}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
          renderItem={({ item }) => (
            <View style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.cardTitle}>{item.title}</Text>
                <Text style={styles.servingsBadge}>{item.servings} servings</Text>
              </View>
              <Text style={styles.cardDescription} numberOfLines={2}>
                {item.description || 'No description provided.'}
              </Text>
              <View style={styles.cardFooter}>
                <Pressable
                  style={styles.cookButton}
                  onPress={() => router.push(`/cook/${item.id}`)}
                >
                  <Text style={styles.cookButtonText}>🍳 Start Cooking</Text>
                </Pressable>
              </View>
            </View>
          )}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: '#0c1610',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingTop: 12,
    paddingBottom: 8,
  },
  title: {
    color: '#f9fafb',
    fontSize: 26,
    fontWeight: '900',
  },
  subtitle: {
    color: '#84e1bc',
    fontSize: 13,
  },
  createButton: {
    backgroundColor: '#059669',
    paddingVertical: 8,
    paddingHorizontal: 14,
    borderRadius: 10,
  },
  createButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
  searchContainer: {
    paddingHorizontal: 20,
    marginVertical: 10,
  },
  searchInput: {
    backgroundColor: '#15241b',
    borderColor: '#244030',
    borderWidth: 1,
    borderRadius: 12,
    paddingHorizontal: 14,
    paddingVertical: 10,
    color: '#ffffff',
    fontSize: 15,
  },
  listContent: {
    padding: 20,
    paddingTop: 6,
    gap: 14,
  },
  card: {
    backgroundColor: '#15241b',
    borderRadius: 16,
    padding: 16,
    borderWidth: 1,
    borderColor: '#244030',
    gap: 8,
  },
  cardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  cardTitle: {
    flex: 1,
    color: '#f3f4f6',
    fontSize: 18,
    fontWeight: '800',
    marginRight: 8,
  },
  servingsBadge: {
    color: '#9ca3af',
    fontSize: 12,
    fontWeight: '600',
    backgroundColor: '#0c1610',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  cardDescription: {
    color: '#d1d5db',
    fontSize: 14,
    lineHeight: 20,
  },
  cardFooter: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    marginTop: 6,
  },
  cookButton: {
    backgroundColor: '#10b981',
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  cookButtonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '700',
  },
  centerContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  loadingText: {
    color: '#9ca3af',
    marginTop: 10,
  },
  emptyTitle: {
    color: '#f3f4f6',
    fontSize: 18,
    fontWeight: '700',
  },
  emptySubtitle: {
    color: '#9ca3af',
    fontSize: 14,
    textAlign: 'center',
    marginTop: 4,
  },
});
