import { database } from './index';
import { Equipment, Ingredient, Technique } from './models';
import library from '../content/learningLibrary.json';
import ingredients from '../content/ingredientLibrary.json';
let loading: Promise<void> | null = null;
export function ensureLearningLibrary(): Promise<void> {
  if (!loading) loading = database.write(async () => {
    const techniques = database.get<Technique>('local_techniques');
    const equipment = database.get<Equipment>('equipment');
    const ingredientTable = database.get<Ingredient>('ingredients');
    const knownIngredients = new Set((await ingredientTable.query().fetch()).map((r) => r.canonicalName));
    const knownTechniques = new Set((await techniques.query().fetch()).map((r) => r.canonicalSlug));
    const knownEquipment = new Set((await equipment.query().fetch()).map((r) => r.canonicalName));
    const ops = [
      ...ingredients.filter((item) => !knownIngredients.has(item.canonical_name)).map((item) => ingredientTable.prepareCreate((r) => {
        r._raw.id = `local-ingredient-${item.id}`; r.canonicalName = item.canonical_name; r.displayName = item.display_name;
        r.category = item.category; r.defaultUnit = item.default_unit; r.isStaple = item.is_staple;
      })),
      ...library.techniques.filter((item) => !knownTechniques.has(item.slug)).map((item) => techniques.prepareCreate((r) => {
        r._raw.id = `local-tech-${item.slug}`; r.canonicalSlug = item.slug; r.title = item.title; r.summary = item.summary;
      })),
      ...library.equipment.filter((item) => !knownEquipment.has(item.canonicalName)).map((item) => equipment.prepareCreate((r) => {
        r._raw.id = `local-eq-${item.canonicalName}`; r.canonicalName = item.canonicalName; r.displayName = item.name;
        r.category = item.category; r.isEssential = item.essential; r.iconName = item.icon;
      })),
    ];
    if (ops.length) await database.batch(ops);
  }).catch((e) => { loading = null; throw e; });
  return loading;
}
