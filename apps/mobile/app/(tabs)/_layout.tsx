import { Tabs } from 'expo-router';
import { colors } from '../../src/theme';

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarIcon: () => null,
        tabBarIconStyle: { display: 'none' },
        tabBarLabelStyle: { fontSize: 14, fontWeight: '600' },
        tabBarActiveTintColor: colors.accent,
        tabBarInactiveTintColor: colors.muted,
        tabBarStyle: {
          backgroundColor: colors.surface,
          borderTopColor: colors.border,
        },
      }}
    >
      <Tabs.Screen
        name="fridge"
        options={{
          title: 'My Fridge',
        }}
      />
      <Tabs.Screen
        name="recipes"
        options={{
          title: 'Recipes',
        }}
      />
    </Tabs>
  );
}
