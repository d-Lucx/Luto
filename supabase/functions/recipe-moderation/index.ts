// ==============================================================================
// LUTO (Logo: Lu2) — Automated Recipe Moderation Supabase Edge Function
// Target: Deno runtime on Supabase Edge Functions
// ==============================================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { moderateRecipeDraft, RecipeDraft } from "./moderator.ts";

export * from "./moderator.ts";

serve(async (req: Request) => {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    "Content-Type": "application/json",
  };

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const draft: RecipeDraft = await req.json();
    const result = moderateRecipeDraft(draft);

    return new Response(JSON.stringify({ success: true, data: result }), {
      status: result.approved ? 200 : 422,
      headers: corsHeaders,
    });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Internal Server Error";
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: corsHeaders,
    });
  }
});
