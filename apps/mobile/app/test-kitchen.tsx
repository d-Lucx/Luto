import { lazy, Suspense, useEffect, useState } from 'react';
import { ScrollView, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

const MediaTestPanel=lazy(()=>import('../src/testing/MediaTestPanel').then(module=>({default:module.MediaTestPanel})));

export default function TestKitchen() {
  const enabled=process.env.EXPO_PUBLIC_DEVICE_TESTS==='1';
  const [result,setResult]=useState('');const [error,setError]=useState('');
  useEffect(()=>{
    if(!enabled)return;
    let active=true;
    // Keep native SQLite benchmark initialization behind the build-time gate.
    void import('../src/testing/nativePerformanceBenchmark').then(module=>module.runPerformanceBenchmark())
      .then(value=>{if(active)setResult(JSON.stringify(value));})
      .catch(cause=>{if(active)setError(cause instanceof Error?cause.message:'Benchmark failed.');});
    return ()=>{active=false;};
  },[enabled]);
  if(!enabled)return <SafeAreaView><Text accessibilityRole="header">Device tests unavailable</Text><Text>This build does not enable the isolated performance harness.</Text></SafeAreaView>;
  return <SafeAreaView style={{flex:1,backgroundColor:'#fff'}}><ScrollView contentContainerStyle={{padding:20,gap:16}}>
    <Text accessibilityRole="header" style={{fontSize:24,color:'#111'}}>Isolated SQLite benchmark</Text>
    <Text style={{fontSize:16,color:'#111'}}>Synthetic fixtures in luto-benchmark. Component timings only.</Text>
    {!!error && <Text accessibilityRole="alert" accessibilityLabel="Benchmark error" style={{fontSize:16,color:'#9b1c1c'}}>{error}</Text>}
    {!result && !error && <Text accessibilityLabel="Benchmark running" style={{fontSize:16,color:'#111'}}>Preparing and measuring 500 fixtures…</Text>}
    {!!result && <View><Text accessibilityRole="header" style={{fontSize:18,color:'#111'}}>Benchmark complete</Text><Text selectable accessibilityLabel={`Benchmark result ${result}`} testID="benchmark-result" style={{fontSize:12,color:'#111'}}>{result}</Text></View>}
    {!!result && <Suspense fallback={<Text>Opening controlled media test…</Text>}><MediaTestPanel /></Suspense>}
  </ScrollView></SafeAreaView>;
}
