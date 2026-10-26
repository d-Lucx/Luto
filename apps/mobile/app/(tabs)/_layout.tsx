import { Tabs } from 'expo-router';

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: '#10b981',
        tabBarInactiveTintColor: '#6b7280',
        tabBarStyle: {
          backgroundColor: '#0c1610',
          borderTopColor: '#1e3325',
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
