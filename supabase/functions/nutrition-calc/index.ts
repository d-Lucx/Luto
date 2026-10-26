// ==============================================================================
// LUTO (Logo: Lu2) — Nutritional Calculator Supabase Edge Function
// Target: Deno runtime on Supabase Edge Functions
// ==============================================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { calculateRecipeNutrition } from "./calculator.ts";

export * from "./calculator.ts";

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
    const { ingredients, servings } = await req.json();
    if (!Array.isArray(ingredients)) {
      return new Response(JSON.stringify({ error: "Missing or invalid 'ingredients' array" }), {
        status: 400,
        headers: corsHeaders,
      });
    }

    const result = calculateRecipeNutrition(ingredients, servings);
    return new Response(JSON.stringify({ success: true, data: result }), {
      status: 200,
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
