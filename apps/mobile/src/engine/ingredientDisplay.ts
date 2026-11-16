const aliases: Record<string, string[]> = {
  egg: ['itlog'], eggs: ['itlog'], tomato: ['kamatis'], tomatoes: ['kamatis'], onion: ['sibuyas'],
  garlic: ['bawang'], salt: ['asin'], ginger: ['luya'], rice: ['bigas', 'kanin'],
  'soy sauce': ['toyo'], vinegar: ['suka'], 'fish sauce': ['patis'],
};
const normalize = (value: string) => value.normalize('NFKD').replace(/\p{M}/gu, '').trim().toLowerCase();
export function ingredientMatches(displayName: string, canonicalName: string, query: string): boolean {
  const search = normalize(query);
  const canonical = normalize(canonicalName).replaceAll('_', ' ');
  const relatedAliases = Object.entries(aliases).filter(([key]) => canonical.split(' ').includes(key)).flatMap(([, terms]) => terms);
  return [displayName, canonicalName, ...(aliases[normalize(canonicalName).replaceAll('_', ' ')] ?? []),
    ...(aliases[normalize(displayName)] ?? []), ...relatedAliases].some((name) => normalize(name).includes(search));
}
const number = (n: number) => Number(n.toFixed(3)).toString();
export function displayQuantity(amount: number, unit: string): string {
  const primary = `${number(amount)} ${unit}`;
  const normalized = unit.trim().toLowerCase();
  if (normalized === 'tsp') return `${primary} · ${number(amount * 5)} ml`;
  if (normalized === 'tbsp') return `${primary} · ${number(amount * 15)} ml`;
  if (normalized === 'ml' && amount >= 15 && amount % 15 === 0) return `${primary} · ${number(amount / 15)} tbsp (15 ml)`;
  if (normalized === 'ml' && amount >= 5 && amount % 5 === 0) return `${primary} · ${number(amount / 5)} tsp (5 ml)`;
  return primary;
}
