import { useState } from 'react';
import { Text, TextInput, View } from 'react-native';
import { useRouter } from 'expo-router';
import { ActionButton } from './ActionButton';
import { colors } from '../theme';
import { snapshotLocalRecipe } from '../database/communityRecipes';
import { writeDocument } from '../database/documents';
import type { RecipeMetadata } from '../database/recipeMetadata';
import { listReviews, reportRecipe, submitRecipe, submitReview, type CommunityReview } from '../services/community';

export function RecipeCommunityActions({ recipeId, metadata, onMetadata }: { recipeId: string; metadata: RecipeMetadata | null; onMetadata: (metadata: RecipeMetadata) => void }) {
  const router = useRouter();
  const [busy, setBusy] = useState(false); const [message, setMessage] = useState(''); const [error, setError] = useState('');
  const [rating, setRating] = useState('5'); const [review, setReview] = useState(''); const [reason, setReason] = useState('');
  const [reviews, setReviews] = useState<CommunityReview[] | null>(null);
  async function run(work: () => Promise<void>) {
    if (busy) return; setBusy(true); setError(''); setMessage('');
    try { await work(); } catch (e) { setError(e instanceof Error ? e.message : 'Could not connect. Your local recipe is safe.'); }
    finally { setBusy(false); }
  }
  const remoteId = metadata?.remoteId;
  const body = { color: colors.ink, fontSize: 16, lineHeight: 25 };
  const input = { minHeight: 52, padding: 12, color: colors.ink, borderWidth: 1, borderColor: colors.border, borderRadius: 12, fontSize: 16 };
  return <View style={{ gap: 12, paddingTop: 16, borderTopWidth: 1, borderTopColor: colors.border }}>
    <Text accessibilityRole="header" style={{ ...body, fontWeight: '700', fontSize: 22 }}>Community</Text>
    {metadata?.source !== 'community' && !recipeId.startsWith('demo-') && <>
      <Text style={body}>Publish your own recipe when signed in. Submissions that pass automated checks go live; flagged recipes are held privately for review.</Text>
      <ActionButton disabled={busy} label={metadata?.publicationStatus ? 'Submit recipe update' : 'Publish recipe'} onPress={() => void run(async () => {
        const result = await submitRecipe(recipeId, await snapshotLocalRecipe(recipeId));
        const next = { ...metadata, remoteId: result.id, remoteVersion: result.version, publicationStatus: result.status };
        await writeDocument(`recipe-meta-${recipeId}`, next); onMetadata(next);
        setMessage(result.status === 'published' ? 'Published to the community.' : `Held privately for review. ${result.moderation_flags.join(', ')}`);
      })} />
    </>}
    {metadata?.publicationStatus && <Text style={body}>Submission: {metadata.publicationStatus} · Version {metadata.remoteVersion}</Text>}
    <ActionButton secondary label="Community and account" onPress={() => router.push('/community')} />
    {remoteId && <>
      <ActionButton secondary disabled={busy} label="Load community reviews" onPress={() => void run(async () => { setReviews(await listReviews(remoteId)); })} />
      {reviews && !reviews.length && <Text style={body}>No public reviews yet.</Text>}
      {reviews?.map((item) => <View key={item.id} style={{ gap: 4 }}><Text style={body}>{item.rating} / 5</Text>{!!item.review_text && <Text style={body}>{item.review_text}</Text>}</View>)}
      <Text style={body}>Your rating (1–5)</Text><TextInput accessibilityLabel="Recipe rating from 1 to 5" value={rating} onChangeText={setRating} keyboardType="number-pad" style={input} />
      <TextInput accessibilityLabel="Recipe review" value={review} onChangeText={setReview} multiline style={input} placeholder="What helped you cook this?" placeholderTextColor={colors.muted} />
      <ActionButton disabled={busy} label="Submit review" onPress={() => void run(async () => {
        const value = Number(rating); if (!Number.isInteger(value) || value < 1 || value > 5) throw new Error('Choose a whole rating from 1 to 5.');
        const result = await submitReview(remoteId, value, review); setMessage(result.status === 'published' ? 'Review published.' : 'Review held privately for review.');
        setReviews(await listReviews(remoteId));
      })} />
      <TextInput accessibilityLabel="Reason for reporting recipe" value={reason} onChangeText={setReason} multiline style={input} placeholder="Describe the problem with this recipe" placeholderTextColor={colors.muted} />
      <ActionButton secondary disabled={busy || !reason.trim()} label="Report recipe" onPress={() => void run(async () => { await reportRecipe(remoteId, reason); setReason(''); setMessage('Report submitted for review.'); })} />
    </>}
    {!!message && <Text accessibilityLiveRegion="polite" style={body}>{message}</Text>}
    {!!error && <Text accessibilityRole="alert" style={{ ...body, color: colors.error }}>{error}</Text>}
  </View>;
}
