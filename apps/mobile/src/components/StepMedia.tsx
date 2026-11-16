import { useEffect, useState } from 'react';
import { Image, Text, View } from 'react-native';
import { VideoView, useVideoPlayer } from 'expo-video';
import { getDownloadedUri } from '../services/media/recipeMedia';
import { colors } from '../theme';
function LocalVideo({ uri }: { uri: string }) {
  const player = useVideoPlayer(uri);
  const [error, setError] = useState('');
  useEffect(() => {
    const listener = player.addListener('statusChange', (status) => { if (status.status === 'error') setError('This tutorial could not be played. The written step is still available.'); });
    return () => listener.remove();
  }, [player]);
  return error ? <Text accessibilityRole="alert" style={{ color: colors.error }}>{error}</Text>
    : <VideoView player={player} nativeControls style={{ width: '100%', aspectRatio: 16 / 9 }} contentFit="contain" />;
}
export function StepMedia({ recipeId, url, mimeType }: { recipeId: string; url?: string; mimeType?: string }) {
  const [uri, setUri] = useState<string | null>(null);
  useEffect(() => {
    let active = true; setUri(null);
    if (url) void getDownloadedUri(recipeId, url).then((value) => { if (active) setUri(value); }).catch(() => {});
    return () => { active = false; };
  }, [recipeId, url]);
  if (!url) return null;
  return <View style={{ width: '100%', gap: 8, marginTop: 16 }}>
    {uri ? mimeType === 'video/mp4' ? <LocalVideo uri={uri} /> : <Image source={{ uri }} accessibilityLabel="Recipe step tutorial" style={{ width: '100%', aspectRatio: 1.5, resizeMode: 'contain' }} />
      : <Text style={{ color: colors.muted, fontSize: 15, lineHeight: 24 }}>Tutorial media is not downloaded. Follow the written step, or download verified media from the recipe page.</Text>}
  </View>;
}
