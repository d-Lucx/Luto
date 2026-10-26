import { Tabs } from 'expo-router';
export default function TabLayout() {
  return <Tabs screenOptions={{ headerShown: false, tabBarActiveTintColor: '#23664a' }}>
    <Tabs.Screen name="fridge" options={{ title: 'My Fridge' }} />
  </Tabs>;
}
