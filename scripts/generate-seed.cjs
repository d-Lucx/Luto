const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const taxonomiesDir = path.join(rootDir, 'docs', 'taxonomies');

const equipmentData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'equipment.json'), 'utf8'));
const techniquesData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'techniques.json'), 'utf8'));
const substitutionsData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'substitutions.json'), 'utf8'));

let sql = `-- ==============================================================================
-- LUTO (Logo: Lu2) — Master Seed Data
-- Seeded: 32 Equipment, 20 Techniques, 35 Substitutions, Master Ingredients, 10 Starter Recipes
-- Generated: ${new Date().toISOString()}
-- ==============================================================================

-- 1. Demo Author Profile
INSERT INTO auth.users (id, email) 
VALUES ('00000000-0000-0000-0000-000000000001', 'chef@luto.app')
ON CONFLICT (id) DO NOTHING;

INSERT INTO profiles (id, username, display_name, avatar_url, bio, measurement_preference, skill_level)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'chef_lu2',
    'Chef Lu2',
    'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?auto=format&fit=crop&w=400&q=80',
    'Founding resident chef at Luto. Dedicated to universal cooking and zero food waste.',
    'metric',
    'pro'
) ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

-- 2. Master Equipment Seed (${equipmentData.equipment.length} items)
`;

equipmentData.equipment.forEach(eq => {
    const desc = eq.description ? `'${eq.description.replace(/'/g, "''")}'` : 'NULL';
    sql += `INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('${eq.canonical_name}', '${eq.display_name.replace(/'/g, "''")}', '${eq.category}', ${eq.is_essential}, '${eq.icon_name}', ${desc})
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;\n`;
});

sql += `\n-- 3. Master Techniques Seed (${techniquesData.techniques.length} items)\n`;

techniquesData.techniques.forEach(tech => {
    const summary = tech.summary.replace(/'/g, "''");
    const keyTips = "ARRAY[" + tech.key_tips.map(t => `'${t.replace(/'/g, "''")}'`).join(', ') + "]";
    const commonMistakes = "ARRAY[" + tech.common_mistakes.map(m => `'${m.replace(/'/g, "''")}'`).join(', ') + "]";
    sql += `INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('${tech.canonical_slug}', '${tech.name.replace(/'/g, "''")}', '${tech.category}', '${tech.difficulty}', '${summary}', ${keyTips}, ${commonMistakes})
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;\n`;
});

// 4. Collect and insert canonical ingredients
sql += `\n-- 4. Master Ingredients Seed\n`;

const ingredientMap = new Map();

function registerIngredient(canonical, display, category, isStaple, defaultUnit) {
    if (!ingredientMap.has(canonical)) {
        ingredientMap.set(canonical, { canonical, display, category, isStaple, defaultUnit });
    }
}

// Register universal staples
registerIngredient('salt_fine', 'Fine Sea Salt', 'spice_seasoning', true, 'g');
registerIngredient('black_pepper_ground', 'Ground Black Pepper', 'spice_seasoning', true, 'g');
registerIngredient('water_tap', 'Water', 'liquid', true, 'ml');
registerIngredient('cooking_oil_neutral', 'Neutral Cooking Oil', 'oil_fat', true, 'ml');
registerIngredient('olive_oil_extra_virgin', 'Extra Virgin Olive Oil', 'oil_fat', false, 'ml');
registerIngredient('butter_unsalted', 'Unsalted Butter', 'dairy', false, 'g');
registerIngredient('garlic_fresh', 'Fresh Garlic Cloves', 'produce', false, 'clove');
registerIngredient('onion_yellow', 'Yellow Onion', 'produce', false, 'piece');

// Register ingredients from substitutions
substitutionsData.substitutions.forEach(sub => {
    const origSlug = sub.original_ingredient.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
    const subSlug = sub.substitute_ingredient.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
    
    let cat = 'pantry_dry';
    if (sub.category === 'dairy') cat = 'dairy';
    else if (sub.category === 'proteins') cat = 'protein';
    else if (sub.category === 'aromatics') cat = 'produce';
    else if (sub.category === 'acids') cat = 'condiment';
    else if (sub.category === 'thickeners') cat = 'pantry_dry';
    else if (sub.category === 'leaveners') cat = 'pantry_dry';

    registerIngredient(origSlug, sub.original_ingredient, cat, false, 'g');
    registerIngredient(subSlug, sub.substitute_ingredient, cat, false, 'g');
});

// Output all ingredients
for (const ing of ingredientMap.values()) {
    sql += `INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('${ing.canonical}', '${ing.display.replace(/'/g, "''")}', '${ing.category}', ${ing.isStaple}, '${ing.defaultUnit}')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;\n`;
}

// 5. Insert Ingredient Substitutions
sql += `\n-- 5. Ingredient Substitutions Matrix Seed (${substitutionsData.substitutions.length} items)\n`;

substitutionsData.substitutions.forEach(sub => {
    const origSlug = sub.original_ingredient.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
    const subSlug = sub.substitute_ingredient.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
    const appCtx = "ARRAY[" + sub.applicable_contexts.map(c => `'${c.replace(/'/g, "''")}'`).join(', ') + "]";
    const forbCtx = "ARRAY[" + sub.forbidden_contexts.map(c => `'${c.replace(/'/g, "''")}'`).join(', ') + "]";
    const flavor = sub.flavor_impact.replace(/'/g, "''");
    const texture = sub.texture_impact.replace(/'/g, "''");
    const prep = sub.instructions_and_tips.replace(/'/g, "''");

    sql += `INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = '${origSlug}' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = '${subSlug}' LIMIT 1),
    ${sub.conversion_ratio},
    '${sub.category}',
    ${appCtx},
    ${forbCtx},
    '${flavor}',
    '${texture}',
    '${prep}'
);\n`;
});

// 6. Ten Global Reference Starter Recipes
sql += `\n-- 6. Ten Global Starter Recipes\n`;

const starterRecipes = [
    {
        title: "Classic Spaghetti Carbonara",
        slug: "classic-spaghetti-carbonara",
        cuisine: "Italian",
        category: "pasta",
        difficulty: "medium",
        prep: 10,
        cook: 15,
        servings: 4,
        calories: 650,
        image: "https://images.unsplash.com/photo-1612874742237-6526221588e3?auto=format&fit=crop&w=800&q=80",
        description: "Silky, authentic Roman carbonara prepared with egg yolks, Pecorino Romano, guanciale, and cracked black pepper.",
        steps: [
            { num: 1, title: "Boil Pasta Water", text: "Bring a large stockpot of well-salted water to a vigorous rolling boil.", timer: 600 },
            { num: 2, title: "Crisp Guanciale", text: "In a cold 12-inch stainless steel skillet, add sliced guanciale. Render over medium-low heat for 8 minutes until golden and crisp.", timer: 480 },
            { num: 3, title: "Whisk Egg Mixture", text: "In a mixing bowl, vigorously whisk egg yolks, finely grated Pecorino Romano, and generous freshly ground black pepper into a thick paste.", timer: 120 },
            { num: 4, title: "Combine and Emulsify", text: "Transfer al dente spaghetti directly into the guanciale skillet off the heat. Pour egg mixture and 1/4 cup hot pasta water, tossing rapidly until a glossy emulsion coats every strand.", timer: 180 }
        ]
    },
    {
        title: "Authentic Chicken Adobo",
        slug: "authentic-chicken-adobo",
        cuisine: "Filipino",
        category: "braise",
        difficulty: "easy",
        prep: 15,
        cook: 35,
        servings: 4,
        calories: 520,
        image: "https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=800&q=80",
        description: "Tender chicken braised in a savory, tangy reduction of soy sauce, cane vinegar, whole black peppercorns, bay leaves, and smashed garlic.",
        steps: [
            { num: 1, title: "Brown Chicken", text: "Heat 1 tbsp oil in a heavy Dutch oven over medium-high heat. Sear chicken thighs skin-side down for 6 minutes until deeply browned.", timer: 360 },
            { num: 2, title: "Simmer Aromatics", text: "Add smashed garlic, soy sauce, cane vinegar, water, bay leaves, and black peppercorns. Bring to a simmer, cover, and cook for 25 minutes.", timer: 1500 },
            { num: 3, title: "Reduce Sauce to Glaze", text: "Remove lid, raise heat to high, and reduce sauce for 7 minutes until thick, glossy, and clinging to chicken.", timer: 420 }
        ]
    },
    {
        title: "Thai Green Chicken Curry",
        slug: "thai-green-chicken-curry",
        cuisine: "Thai",
        category: "curry",
        difficulty: "medium",
        prep: 15,
        cook: 20,
        servings: 4,
        calories: 580,
        image: "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?auto=format&fit=crop&w=800&q=80",
        description: "Fragrant coconut milk curry with tender chicken strips, Thai basil, bamboo shoots, and green curry paste.",
        steps: [
            { num: 1, title: "Crack Coconut Cream", text: "Skim 1/2 cup of solid coconut cream from the top of the can and heat in a saucepan over medium heat until oil separates.", timer: 240 },
            { num: 2, title: "Fry Curry Paste", text: "Add green curry paste to the cracked coconut oil and stir-fry for 2 minutes until intensely aromatic.", timer: 120 },
            { num: 3, title: "Simmer Chicken & Basil", text: "Add chicken strips, remaining coconut milk, fish sauce, and palm sugar. Simmer for 12 minutes, then fold in fresh Thai basil leaves.", timer: 720 }
        ]
    },
    {
        title: "Classic French Rolled Omelet",
        slug: "classic-french-rolled-omelet",
        cuisine: "French",
        category: "breakfast",
        difficulty: "medium",
        prep: 5,
        cook: 3,
        servings: 1,
        calories: 310,
        image: "https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=800&q=80",
        description: "Pale golden, tender exterior with a soft, creamy custard center, finished with butter gloss and minced fresh chives.",
        steps: [
            { num: 1, title: "Beat Eggs Smooth", text: "Whisk 3 large room-temperature eggs with a pinch of fine salt until completely homogenous without visible albumen streaks.", timer: 90 },
            { num: 2, title: "Vigorous Scramble", text: "Melt 1.5 tbsp butter in a 10-inch nonstick pan over medium-low heat. Pour in eggs and shake pan rapidly while stirring vigorously in circles with a fork.", timer: 90 },
            { num: 3, title: "Roll and Plate", text: "Smooth surface, tilt pan forward, tap handle with palm to roll omelet onto itself, and invert seam-side down onto a warm plate. Rub surface with cold butter.", timer: 45 }
        ]
    },
    {
        title: "North African Shakshuka",
        slug: "north-african-shakshuka",
        cuisine: "Middle Eastern",
        category: "breakfast_skillet",
        difficulty: "easy",
        prep: 10,
        cook: 25,
        servings: 4,
        calories: 340,
        image: "https://images.unsplash.com/photo-1590412200988-a436970781fa?auto=format&fit=crop&w=800&q=80",
        description: "Gently poached eggs in a spiced, chunky tomato, bell pepper, and onion sauce with cumin, paprika, and crumbled feta cheese.",
        steps: [
            { num: 1, title: "Sauté Aromatics", text: "Heat olive oil in a 12-inch skillet. Sauté onions and bell peppers for 8 minutes until tender and sweet.", timer: 480 },
            { num: 2, title: "Simmer Tomato Sauce", text: "Add minced garlic, cumin, paprika, and crushed canned tomatoes. Simmer on medium-low for 12 minutes until thickened.", timer: 720 },
            { num: 3, title: "Poach Eggs in Wells", text: "Create 4 small wells with a spoon, crack eggs into the wells, cover skillet, and simmer for 6 minutes until egg whites are set and yolks remain runny.", timer: 360 }
        ]
    },
    {
        title: "Szechuan Beef & Broccoli Stir-Fry",
        slug: "szechuan-beef-and-broccoli-stir-fry",
        cuisine: "Chinese",
        category: "stir_fry",
        difficulty: "medium",
        prep: 20,
        cook: 8,
        servings: 4,
        calories: 480,
        image: "https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80",
        description: "Thinly sliced flank steak seared at screaming heat, tossed with crisp broccoli florets and a savory ginger-garlic soy glaze.",
        steps: [
            { num: 1, title: "Blanch Broccoli", text: "Drop broccoli florets in boiling water for 60 seconds, drain and shock in ice water to lock in deep green color and crunch.", timer: 60 },
            { num: 2, title: "High-Heat Sear", text: "Heat 1 tbsp oil in a smoking wok or stainless skillet. Spread marinated beef in a single layer and sear without moving for 90 seconds per side.", timer: 180 },
            { num: 3, title: "Toss with Sauce", text: "Add ginger, garlic, blanched broccoli, and sauce slurry. Toss furiously for 60 seconds until sauce thickens to a lacquer.", timer: 60 }
        ]
    },
    {
        title: "Creamy Red Lentil Dahl",
        slug: "creamy-red-lentil-dahl",
        cuisine: "Indian",
        category: "soup_stew",
        difficulty: "easy",
        prep: 10,
        cook: 25,
        servings: 4,
        calories: 390,
        image: "https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80",
        description: "Hearty, comforting red lentils simmered in coconut milk, turmeric, and ginger, finished with a sizzling tempered cumin-mustard seed tadka.",
        steps: [
            { num: 1, title: "Simmer Lentils", text: "Combine rinsed red lentils, water, coconut milk, turmeric, and grated ginger in a saucepan. Simmer for 20 minutes until lentils melt tender.", timer: 1200 },
            { num: 2, title: "Prepare Tadka", text: "In a small skillet, heat ghee or coconut oil. Fry whole cumin seeds and mustard seeds until they pop and release fragrant oils (30 seconds).", timer: 30 },
            { num: 3, title: "Sizzle and Swirl", text: "Pour the hot sizzling spiced tadka oil directly over the cooked dahl and stir in fresh cilantro and lime juice.", timer: 60 }
        ]
    },
    {
        title: "Provencal Vegetable Ratatouille",
        slug: "provencal-vegetable-ratatouille",
        cuisine: "French",
        category: "vegetable_stew",
        difficulty: "medium",
        prep: 25,
        cook: 40,
        servings: 6,
        calories: 220,
        image: "https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?auto=format&fit=crop&w=800&q=80",
        description: "Layers of tender summer vegetables (eggplant, zucchini, yellow squash, bell pepper) slow-simmered in a rich tomato, garlic, and thyme reduction.",
        steps: [
            { num: 1, title: "Brown Eggplant & Squash", text: "Sauté salted eggplant cubes and zucchini in hot olive oil until golden; set aside.", timer: 600 },
            { num: 2, title: "Build Pipérade Sauce", text: "Cook onions, peppers, garlic, and fresh thyme in olive oil until soft, then simmer with crushed tomatoes for 15 minutes.", timer: 900 },
            { num: 3, title: "Braid and Bake", text: "Combine browned vegetables into the sauce, cover, and simmer on low for 25 minutes until all vegetables are meltingly tender.", timer: 1500 }
        ]
    },
    {
        title: "Fresh Molcajete Guacamole",
        slug: "fresh-molcajete-guacamole",
        cuisine: "Mexican",
        category: "dips",
        difficulty: "easy",
        prep: 10,
        cook: 0,
        servings: 4,
        calories: 240,
        image: "https://images.unsplash.com/photo-1584278860047-22db9ff82bed?auto=format&fit=crop&w=800&q=80",
        description: "Silky yet chunky ripe Hass avocados crushed in a mortar with raw lime juice, diced jalapeño, sweet white onion, and cilantro.",
        steps: [
            { num: 1, title: "Grind Aromatic Paste", text: "In a granite mortar or bowl, crush diced white onion, jalapeño, cilantro stems, and coarse salt with a pestle until a fragrant paste forms.", timer: 120 },
            { num: 2, title: "Coarsely Mash Avocado", text: "Halve avocados, scoop flesh into mortar, and mash with pestle or fork, leaving substantial tender chunks for texture.", timer: 90 },
            { num: 3, title: "Season and Fold", text: "Gently fold in fresh lime juice and chopped cilantro leaves. Taste and adjust salt before serving with warm tortilla chips.", timer: 60 }
        ]
    },
    {
        title: "No-Knead Overnight Sourdough Boule",
        slug: "no-knead-overnight-sourdough-boule",
        cuisine: "Universal",
        category: "bread",
        difficulty: "hard",
        prep: 30,
        cook: 45,
        servings: 8,
        calories: 210,
        image: "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=800&q=80",
        description: "Crisp, blistered artisanal crust with an open, airy, chewy crumb baked in an enameled cast iron Dutch oven.",
        steps: [
            { num: 1, title: "Autolyse & Mix", text: "Combine bread flour, water, active sourdough starter, and salt into a shaggy dough. Rest covered for 30 minutes.", timer: 1800 },
            { num: 2, title: "Stretch and Fold", text: "Perform 4 sets of stretch-and-folds spaced 30 minutes apart, then bulk ferment for 6 hours until puffy and aerated.", timer: 7200 },
            { num: 3, title: "Cold Retard & Dutch Oven Bake", text: "Shape into a taut boule, proof overnight in banneton in fridge. Score top and bake covered at 450°F (230°C) for 25 min, then uncovered for 20 min until deep chestnut brown.", timer: 2700 }
        ]
    }
];

starterRecipes.forEach(r => {
    sql += `INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    '${r.title.replace(/'/g, "''")}',
    '${r.slug}',
    '${r.description.replace(/'/g, "''")}',
    ARRAY['${r.cuisine}'],
    '${r.category}',
    '${r.difficulty}',
    ${r.prep},
    ${r.cook},
    ${r.servings},
    ${r.calories},
    '${r.image}',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;\n`;

    r.steps.forEach(s => {
        sql += `INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = '${r.slug}' LIMIT 1),
    ${s.num},
    '${s.title.replace(/'/g, "''")}',
    '${s.text.replace(/'/g, "''")}',
    ${s.timer}
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;\n`;
    });
});

const outputPath = path.join(rootDir, 'supabase', 'seed.sql');
fs.writeFileSync(outputPath, sql, 'utf8');
console.log('Successfully generated master seed file at:', outputPath);
console.log('File size:', (fs.statSync(outputPath).size / 1024).toFixed(2), 'KB');
