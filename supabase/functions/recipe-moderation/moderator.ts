// ==============================================================================
// LUTO (Logo: Lu2) — Automated Recipe Moderation Engine
// Target: Automated Content Safety & Cooking Instructions Sanity Checks
// ==============================================================================

export interface RecipeDraft {
  title: string;
  description?: string;
  prepTimeMinutes?: number;
  cookTimeMinutes?: number;
  ingredients: Array<{ name: string; amount: number; unit: string }>;
  steps: Array<{ stepNumber: number; instruction: string }>;
  proTips?: string;
}

export interface ModerationResult {
  approved: boolean;
  severity: "clean" | "warning" | "rejected";
  flags: string[];
  reasons: string[];
}

// Prohibited / Hazardous Food Safety Patterns
export const HAZARDOUS_PATTERNS: Array<{ pattern: RegExp; reason: string }> = [
  { pattern: /\b(bleach|ammonia|detergent|chlorine|drain cleaner|borax|lead|cyanide|mercury)\b/i, reason: "Contains toxic/hazardous non-food chemical substances." },
  { pattern: /\b(microwave(d)?\s+metal|tin foil\s+in\s+microwave|aluminum foil\s+in\s+microwave)\b/i, reason: "Severe fire hazard: metal in microwave." },
  { pattern: /\b(deep fry(ing)?\s+frozen turkey|frozen turkey\s+in\s+hot oil)\b/i, reason: "Severe explosion hazard: deep frying frozen moisture-heavy food." },
  { pattern: /\b(heat(ing)?\s+sealed can|boil(ing)?\s+unopened can)\b/i, reason: "Pressure explosion hazard: heating unopened pressurized sealed containers." },
  { pattern: /\b(raw\s+wild\s+mushroom|unidentified\s+mushroom)\b/i, reason: "Toxic hazard: foraging unidentified wild mushrooms without certification." },
];

// Spam / External Promotional Patterns
export const SPAM_PATTERNS: Array<{ pattern: RegExp; reason: string }> = [
  { pattern: /https?:\/\/(?!luto\.app)[^\s]+/i, reason: "Contains unauthorized external links or promotional URLs." },
  { pattern: /\b(crypto|casino|viagra|poker|whatsapp\s+\+\d|telegram\s+@)\b/i, reason: "Contains commercial spam or solicitation keywords." },
];

// Vulgarity & Harassment Filter
export const PROFANITY_PATTERNS: Array<{ pattern: RegExp; reason: string }> = [
  { pattern: /\b(fuck|shit|bitch|cunt|asshole|nigger|faggot)\b/i, reason: "Contains offensive profanity or derogatory language." },
];

export function moderateRecipeDraft(draft: RecipeDraft): ModerationResult {
  const flags: string[] = [];
  const reasons: string[] = [];

  // 1. Structural / Quality checks
  if (!draft.title || draft.title.trim().length < 3) {
    flags.push("INVALID_TITLE");
    reasons.push("Title must be at least 3 characters long.");
  }

  if (!draft.ingredients || draft.ingredients.length === 0) {
    flags.push("MISSING_INGREDIENTS");
    reasons.push("Recipe must include at least one ingredient.");
  }

  if (!draft.steps || draft.steps.length === 0) {
    flags.push("MISSING_STEPS");
    reasons.push("Recipe must include at least one preparation step.");
  }

  // Concatenate all text fields for scanning
  const textCorpus = [
    draft.title,
    draft.description || "",
    draft.proTips || "",
    ...draft.ingredients.map(i => `${i.name} ${i.unit}`),
    ...draft.steps.map(s => s.instruction),
  ].join(" ");

  // 2. Hazardous Food Safety Scan
  for (const item of HAZARDOUS_PATTERNS) {
    if (item.pattern.test(textCorpus)) {
      flags.push("SAFETY_VIOLATION");
      reasons.push(item.reason);
    }
  }

  // 3. Spam and URL Scan
  for (const item of SPAM_PATTERNS) {
    if (item.pattern.test(textCorpus)) {
      flags.push("SPAM_DETECTED");
      reasons.push(item.reason);
    }
  }

  // 4. Vulgarity / Harassment Scan
  for (const item of PROFANITY_PATTERNS) {
    if (item.pattern.test(textCorpus)) {
      flags.push("COMMUNITY_GUIDELINES");
      reasons.push(item.reason);
    }
  }

  const hasSafety = flags.includes("SAFETY_VIOLATION");
  const hasProfanity = flags.includes("COMMUNITY_GUIDELINES");
  const hasSpam = flags.includes("SPAM_DETECTED");
  const hasStructural = flags.includes("INVALID_TITLE") || flags.includes("MISSING_INGREDIENTS") || flags.includes("MISSING_STEPS");

  let severity: ModerationResult["severity"] = "clean";
  let approved = true;

  if (hasSafety || hasProfanity) {
    severity = "rejected";
    approved = false;
  } else if (hasSpam || hasStructural) {
    severity = "warning";
    approved = false;
  }

  return {
    approved,
    severity,
    flags,
    reasons,
  };
}
