const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Deterministic UUID generator using MD5 namespace hashing
function getUUID(namespace, name) {
  const hash = crypto.createHash('md5').update(`${namespace}:${name}`).digest('hex');
  return [
    hash.slice(0, 8),
    hash.slice(8, 12),
    '4' + hash.slice(13, 16),
    'a' + hash.slice(17, 20),
    hash.slice(20, 32)
  ].join('-');
}

function escapeSQL(str) {
  if (str === null || str === undefined) return 'NULL';
  return `'${String(str).replace(/'/g, "''")}'`;
}

function sqlArray(arr) {
  if (!arr || arr.length === 0) return "'{}'::text[]";
  const escaped = arr.map(item => `"${String(item).replace(/"/g, '\\"')}"`).join(',');
  return `'{${escaped}}'::text[]`;
}

// Load taxonomies
const taxonomiesDir = path.join(__dirname, '..', 'docs', 'taxonomies');
const equipmentData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'equipment.json'), 'utf8'));
const techniquesData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'techniques.json'), 'utf8'));
const substitutionsData = JSON.parse(fs.readFileSync(path.join(taxonomiesDir, 'substitutions.json'), 'utf8'));

// Build Master Ingredients List
// Categories allowed: 'protein', 'produce', 'dairy', 'pantry_dry', 'canned', 'bakery', 'spice_seasoning', 'oil_fat', 'condiment', 'liquid'
const masterIngredients = [
  // Staples
  { canonical: 'salt', display: 'Fine Sea Salt', category: 'spice_seasoning', is_staple: true, unit: 'g', shelf_life: 1825, allergens: [], density: 1.2 },
  { canonical: 'black_pepper', display: 'Black Peppercorns (Ground)', category: 'spice_seasoning', is_staple: true, unit: 'g', shelf_life: 730, allergens: [], density: 0.55 },
  { canonical: 'water', display: 'Filtered Water', category: 'liquid', is_staple: true, unit: 'ml', shelf_life: null, allergens: [], density: 1.0 },
  { canonical: 'neutral_oil', display: 'Neutral Cooking Oil (Canola/Vegetable)', category: 'oil_fat', is_staple: true, unit: 'ml', shelf_life: 365, allergens: [], density: 0.92 },
  { canonical: 'olive_oil', display: 'Extra Virgin Olive Oil', category: 'oil_fat', is_staple: true, unit: 'ml', shelf_life: 540, allergens: [], density: 0.915 },

  // Dairy & Dairy Substitutes
  { canonical: 'buttermilk', display: 'Cultured Buttermilk', category: 'dairy', is_staple: false, unit: 'ml', shelf_life: 21, allergens: ['dairy'], density: 1.03 },
  { canonical: 'whole_milk', display: 'Whole Cow Milk', category: 'dairy', is_staple: false, unit: 'ml', shelf_life: 14, allergens: ['dairy'], density: 1.03 },
  { canonical: 'sour_cream', display: 'Cultured Sour Cream', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 21, allergens: ['dairy'], density: 1.0 },
  { canonical: 'greek_yogurt', display: 'Full-Fat Plain Greek Yogurt', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 28, allergens: ['dairy'], density: 1.05 },
  { canonical: 'heavy_cream', display: 'Heavy Whipping Cream (36% Fat)', category: 'dairy', is_staple: false, unit: 'ml', shelf_life: 28, allergens: ['dairy'], density: 0.99 },
  { canonical: 'coconut_cream', display: 'Canned Coconut Cream', category: 'canned', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['tree_nut'], density: 0.95 },
  { canonical: 'unsalted_butter', display: 'Unsalted Butter', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 90, allergens: ['dairy'], density: 0.911 },
  { canonical: 'ricotta_cheese', display: 'Whole Milk Ricotta Cheese', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 14, allergens: ['dairy'], density: 1.0 },
  { canonical: 'cottage_cheese', display: 'Small-Curd Cottage Cheese', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 21, allergens: ['dairy'], density: 1.0 },
  { canonical: 'parmesan_cheese', display: 'Parmigiano-Reggiano', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 180, allergens: ['dairy'], density: 0.6 },
  { canonical: 'pecorino_romano', display: 'Pecorino Romano Cheese', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 180, allergens: ['dairy'], density: 0.6 },
  { canonical: 'feta_cheese', display: 'Greek Feta Cheese', category: 'dairy', is_staple: false, unit: 'g', shelf_life: 60, allergens: ['dairy'], density: 0.75 },

  // Flours, Grains, Starches & Thickeners
  { canonical: 'cornstarch', display: 'Cornstarch (Maize Starch)', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: ['corn'], density: 0.55 },
  { canonical: 'all_purpose_flour', display: 'All-Purpose Wheat Flour', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['wheat', 'gluten'], density: 0.53 },
  { canonical: 'bread_flour', display: 'Unbleached Hard Bread Flour', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['wheat', 'gluten'], density: 0.55 },
  { canonical: 'whole_wheat_flour', display: 'Stone Ground Whole Wheat Flour', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 180, allergens: ['wheat', 'gluten'], density: 0.52 },
  { canonical: 'self_rising_flour', display: 'Self-Rising Flour', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 180, allergens: ['wheat', 'gluten'], density: 0.53 },
  { canonical: 'arrowroot_powder', display: 'Arrowroot Starch Powder', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.55 },
  { canonical: 'tapioca_starch', display: 'Tapioca Starch (Flour)', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.55 },
  { canonical: 'flaxseed_meal', display: 'Ground Golden Flaxseed Meal', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 180, allergens: [], density: 0.5 },
  { canonical: 'agar_agar_powder', display: 'Agar-Agar Powder', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 1095, allergens: [], density: 0.6 },
  { canonical: 'animal_gelatin', display: 'Unflavored Gelatin Powder', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 1095, allergens: [], density: 0.68 },
  { canonical: 'spaghetti', display: 'Bronze-Cut Spaghetti Pasta', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: ['wheat', 'gluten'], density: 0.6 },
  { canonical: 'red_lentils', display: 'Split Red Lentils (Masoor Dal)', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.8 },

  // Aromatics & Produce
  { canonical: 'garlic_cloves', display: 'Fresh Garlic Cloves', category: 'produce', is_staple: false, unit: 'clove', shelf_life: 60, allergens: [], density: 0.65 },
  { canonical: 'garlic_powder', display: 'Granulated Garlic Powder', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.45 },
  { canonical: 'shallots', display: 'French Shallots', category: 'produce', is_staple: false, unit: 'g', shelf_life: 45, allergens: [], density: 0.6 },
  { canonical: 'yellow_onion', display: 'Medium Yellow Onion', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 45, allergens: [], density: 0.6 },
  { canonical: 'red_onion', display: 'Red Onion', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 45, allergens: [], density: 0.6 },
  { canonical: 'scallions', display: 'Fresh Scallions (Green Onions)', category: 'produce', is_staple: false, unit: 'g', shelf_life: 10, allergens: [], density: 0.4 },
  { canonical: 'fresh_ginger', display: 'Fresh Ginger Root', category: 'produce', is_staple: false, unit: 'g', shelf_life: 30, allergens: [], density: 0.6 },
  { canonical: 'ground_ginger', display: 'Ground Dried Ginger', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.45 },
  { canonical: 'fresh_cilantro', display: 'Fresh Cilantro (Coriander)', category: 'produce', is_staple: false, unit: 'g', shelf_life: 7, allergens: [], density: 0.3 },
  { canonical: 'italian_parsley', display: 'Flat-Leaf Italian Parsley', category: 'produce', is_staple: false, unit: 'g', shelf_life: 10, allergens: [], density: 0.3 },
  { canonical: 'fresh_chives', display: 'Fresh Garden Chives', category: 'produce', is_staple: false, unit: 'g', shelf_life: 7, allergens: [], density: 0.3 },
  { canonical: 'thai_basil', display: 'Fresh Thai Basil Leaves', category: 'produce', is_staple: false, unit: 'g', shelf_life: 5, allergens: [], density: 0.3 },
  { canonical: 'kaffir_lime_leaves', display: 'Fresh Kaffir Lime Leaves', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 14, allergens: [], density: 0.3 },
  { canonical: 'fresh_thyme', display: 'Fresh Thyme Sprigs', category: 'produce', is_staple: false, unit: 'g', shelf_life: 14, allergens: [], density: 0.3 },
  { canonical: 'lemon_juice', display: 'Fresh Lemon Juice', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 10, allergens: [], density: 1.02 },
  { canonical: 'lime_juice', display: 'Fresh Lime Juice', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 10, allergens: [], density: 1.02 },
  { canonical: 'broccoli', display: 'Fresh Broccoli Crown', category: 'produce', is_staple: false, unit: 'g', shelf_life: 10, allergens: [], density: 0.37 },
  { canonical: 'eggplant', display: 'Globe Eggplant', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 7, allergens: [], density: 0.4 },
  { canonical: 'thai_eggplant', display: 'Round Thai Green Eggplant', category: 'produce', is_staple: false, unit: 'g', shelf_life: 10, allergens: [], density: 0.45 },
  { canonical: 'zucchini', display: 'Fresh Green Zucchini', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 10, allergens: [], density: 0.5 },
  { canonical: 'yellow_squash', display: 'Yellow Summer Squash', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 10, allergens: [], density: 0.5 },
  { canonical: 'roma_tomatoes', display: 'Ripe Roma Plum Tomatoes', category: 'produce', is_staple: false, unit: 'g', shelf_life: 7, allergens: [], density: 0.65 },
  { canonical: 'red_bell_pepper', display: 'Red Bell Pepper', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 14, allergens: [], density: 0.45 },
  { canonical: 'jalapeno_pepper', display: 'Fresh Jalapeño Chili', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 14, allergens: [], density: 0.4 },
  { canonical: 'avocado', display: 'Ripe Hass Avocado', category: 'produce', is_staple: false, unit: 'piece', shelf_life: 5, allergens: [], density: 0.7 },
  { canonical: 'cremini_mushrooms', display: 'Cremini (Baby Bella) Mushrooms', category: 'produce', is_staple: false, unit: 'g', shelf_life: 7, allergens: [], density: 0.35 },
  { canonical: 'king_oyster_mushrooms', display: 'King Oyster Mushrooms', category: 'produce', is_staple: false, unit: 'g', shelf_life: 10, allergens: [], density: 0.4 },

  // Canned & Packaged
  { canonical: 'canned_crushed_tomatoes', display: 'Canned Crushed San Marzano Tomatoes', category: 'canned', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 1.05 },
  { canonical: 'tomato_paste', display: 'Double-Concentrated Tomato Paste', category: 'canned', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 1.15 },
  { canonical: 'canned_coconut_milk', display: 'Full-Fat Canned Coconut Milk', category: 'canned', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['tree_nut'], density: 0.98 },
  { canonical: 'bamboo_shoots', display: 'Canned Sliced Bamboo Shoots', category: 'canned', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.6 },
  { canonical: 'applesauce', display: 'Unsweetened Natural Applesauce', category: 'canned', is_staple: false, unit: 'g', shelf_life: 365, allergens: [], density: 1.05 },

  // Proteins
  { canonical: 'eggs', display: 'Large Grade-A Eggs', category: 'protein', is_staple: false, unit: 'piece', shelf_life: 35, allergens: ['eggs'], density: 1.0 },
  { canonical: 'guanciale', display: 'Cured Italian Guanciale (Pork Jowl)', category: 'protein', is_staple: false, unit: 'g', shelf_life: 90, allergens: ['pork'], density: 0.95 },
  { canonical: 'pancetta', display: 'Italian Rolled Pancetta / Smoked Bacon', category: 'protein', is_staple: false, unit: 'g', shelf_life: 60, allergens: ['pork'], density: 0.95 },
  { canonical: 'chicken_thighs', display: 'Bone-In Skin-On Chicken Thighs', category: 'protein', is_staple: false, unit: 'g', shelf_life: 4, allergens: ['poultry'], density: 1.0 },
  { canonical: 'chicken_breast', display: 'Boneless Skinless Chicken Breast', category: 'protein', is_staple: false, unit: 'g', shelf_life: 4, allergens: ['poultry'], density: 1.0 },
  { canonical: 'flank_steak', display: 'USDA Choice Beef Flank Steak', category: 'protein', is_staple: false, unit: 'g', shelf_life: 5, allergens: ['beef'], density: 1.0 },
  { canonical: 'ground_beef', display: 'Ground Beef (80/20 Chuck)', category: 'protein', is_staple: false, unit: 'g', shelf_life: 3, allergens: ['beef'], density: 0.95 },
  { canonical: 'ground_turkey', display: 'Lean Ground Turkey (93/7)', category: 'protein', is_staple: false, unit: 'g', shelf_life: 3, allergens: ['poultry'], density: 0.95 },
  { canonical: 'firm_tofu', display: 'Extra-Firm Organic Tofu', category: 'protein', is_staple: false, unit: 'g', shelf_life: 30, allergens: ['soy'], density: 1.0 },
  { canonical: 'shrimp', display: 'Raw Peeled & Deveined Shrimp (26/30)', category: 'protein', is_staple: false, unit: 'g', shelf_life: 2, allergens: ['crustacean_shellfish'], density: 1.0 },

  // Condiments, Acids, Wines, Stocks
  { canonical: 'soy_sauce', display: 'All-Purpose Brewed Soy Sauce (Shoyu)', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['soy', 'wheat'], density: 1.15 },
  { canonical: 'tamari', display: 'San-J Gluten-Free Tamari', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['soy'], density: 1.15 },
  { canonical: 'fish_sauce', display: 'Premium Vietnamese / Thai Fish Sauce', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['fish'], density: 1.2 },
  { canonical: 'cane_vinegar', display: 'Filipino Cane Vinegar (Datu Puti)', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 1095, allergens: [], density: 1.01 },
  { canonical: 'apple_cider_vinegar', display: 'Raw Unfiltered Apple Cider Vinegar', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 1095, allergens: [], density: 1.01 },
  { canonical: 'rice_vinegar', display: 'Unseasoned Japanese Rice Vinegar', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 730, allergens: [], density: 1.01 },
  { canonical: 'white_wine_cooking', display: 'Dry Crisp White Wine (Sauvignon Blanc)', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 30, allergens: ['sulfites'], density: 0.99 },
  { canonical: 'red_wine_cooking', display: 'Dry Full-Bodied Red Wine (Cabernet)', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 30, allergens: ['sulfites'], density: 0.99 },
  { canonical: 'shaoxing_wine', display: 'Shaoxing Chinese Cooking Wine', category: 'condiment', is_staple: false, unit: 'ml', shelf_life: 730, allergens: ['wheat'], density: 1.02 },
  { canonical: 'toasted_sesame_oil', display: '100% Pure Toasted Sesame Oil', category: 'oil_fat', is_staple: false, unit: 'ml', shelf_life: 365, allergens: ['sesame'], density: 0.92 },
  { canonical: 'green_curry_paste', display: 'Authentic Thai Green Curry Paste', category: 'condiment', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['shrimp'], density: 1.1 },
  { canonical: 'mayonnaise', display: 'Whole-Egg Mayonnaise', category: 'condiment', is_staple: false, unit: 'g', shelf_life: 90, allergens: ['eggs'], density: 0.94 },
  { canonical: 'honey', display: '100% Pure Raw Wildflower Honey', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 1825, allergens: [], density: 1.42 },
  { canonical: 'maple_syrup', display: 'Pure Grade-A Dark Maple Syrup', category: 'pantry_dry', is_staple: false, unit: 'ml', shelf_life: 730, allergens: [], density: 1.33 },
  { canonical: 'brown_sugar', display: 'Dark Brown Cane Sugar', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.82 },
  { canonical: 'palm_sugar', display: 'Thai Palm Sugar Cake', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.85 },
  { canonical: 'chicken_broth', display: 'Low-Sodium Chicken Broth', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 365, allergens: ['poultry'], density: 1.01 },
  { canonical: 'beef_broth', display: 'Rich Roasted Beef Bone Broth', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 365, allergens: ['beef'], density: 1.01 },
  { canonical: 'vegetable_broth', display: 'Aromatic Mirepoix Vegetable Broth', category: 'liquid', is_staple: false, unit: 'ml', shelf_life: 365, allergens: [], density: 1.01 },
  { canonical: 'ghee', display: 'Clarified Butter (Desi Ghee)', category: 'oil_fat', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['dairy'], density: 0.905 },

  // Spices & Leaveners
  { canonical: 'ground_cumin', display: 'Ground Roasted Cumin Seed', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.4 },
  { canonical: 'smoked_paprika', display: 'Spanish Smoked Pimentón (Paprika)', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.46 },
  { canonical: 'ground_turmeric', display: 'Ground Turmeric Root Powder', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.5 },
  { canonical: 'garam_masala', display: 'Traditional Punjabi Garam Masala Blend', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 540, allergens: [], density: 0.42 },
  { canonical: 'dried_oregano', display: 'Dried Greek Oregano Leaves', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.25 },
  { canonical: 'bay_leaves', display: 'Whole Dried Turkish Bay Leaves', category: 'spice_seasoning', is_staple: false, unit: 'piece', shelf_life: 730, allergens: [], density: 0.15 },
  { canonical: 'white_pepper', display: 'Finely Ground White Peppercorns', category: 'spice_seasoning', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 0.58 },
  { canonical: 'baking_powder', display: 'Double-Acting Aluminum-Free Baking Powder', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['corn'], density: 0.9 },
  { canonical: 'baking_soda', display: 'Pure Sodium Bicarbonate (Baking Soda)', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 730, allergens: [], density: 1.1 },
  { canonical: 'active_dry_yeast', display: 'Active Dry Baker’s Yeast', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['yeast'], density: 0.7 },
  { canonical: 'instant_yeast', display: 'Rapid Rise Instant Baker’s Yeast', category: 'pantry_dry', is_staple: false, unit: 'g', shelf_life: 365, allergens: ['yeast'], density: 0.7 },
  { canonical: 'sourdough_starter', display: '100% Hydration Active Sourdough Starter', category: 'bakery', is_staple: false, unit: 'g', shelf_life: 7, allergens: ['wheat', 'gluten', 'yeast'], density: 1.05 }
];

// Map substitution originals & targets to canonical ingredients
const substitutionCanonicalMapping = {
  'sub_dairy_buttermilk_milk_lemon': { original: 'buttermilk', substitute: 'whole_milk' },
  'sub_dairy_sour_cream_greek_yogurt': { original: 'sour_cream', substitute: 'greek_yogurt' },
  'sub_dairy_heavy_cream_milk_butter': { original: 'heavy_cream', substitute: 'whole_milk' },
  'sub_dairy_heavy_cream_coconut_cream': { original: 'heavy_cream', substitute: 'coconut_cream' },
  'sub_dairy_butter_olive_oil': { original: 'unsalted_butter', substitute: 'olive_oil' },
  'sub_dairy_ricotta_cottage_cheese': { original: 'ricotta_cheese', substitute: 'cottage_cheese' },
  'sub_dairy_parmesan_pecorino_romano': { original: 'parmesan_cheese', substitute: 'pecorino_romano' },
  'sub_thickener_cornstarch_flour': { original: 'cornstarch', substitute: 'all_purpose_flour' },
  'sub_thickener_cornstarch_arrowroot': { original: 'cornstarch', substitute: 'arrowroot_powder' },
  'sub_thickener_cornstarch_tapioca': { original: 'cornstarch', substitute: 'tapioca_starch' },
  'sub_thickener_egg_binder_flaxseed': { original: 'eggs', substitute: 'flaxseed_meal' },
  'sub_thickener_gelatin_agar_agar': { original: 'animal_gelatin', substitute: 'agar_agar_powder' },
  'sub_aromatic_garlic_cloves_powder': { original: 'garlic_cloves', substitute: 'garlic_powder' },
  'sub_aromatic_shallots_yellow_onion_garlic': { original: 'shallots', substitute: 'yellow_onion' },
  'sub_aromatic_yellow_onion_scallions': { original: 'yellow_onion', substitute: 'scallions' },
  'sub_aromatic_fresh_ginger_ground': { original: 'fresh_ginger', substitute: 'ground_ginger' },
  'sub_aromatic_fresh_cilantro_parsley_lime': { original: 'fresh_cilantro', substitute: 'italian_parsley' },
  'sub_acid_lemon_juice_lime_juice': { original: 'lemon_juice', substitute: 'lime_juice' },
  'sub_acid_white_wine_broth_vinegar': { original: 'white_wine_cooking', substitute: 'chicken_broth' },
  'sub_acid_red_wine_beef_broth_red_vinegar': { original: 'red_wine_cooking', substitute: 'beef_broth' },
  'sub_acid_rice_vinegar_apple_cider_vinegar': { original: 'rice_vinegar', substitute: 'apple_cider_vinegar' },
  'sub_protein_ground_beef_ground_turkey': { original: 'ground_beef', substitute: 'ground_turkey' },
  'sub_protein_chicken_breast_firm_tofu': { original: 'chicken_breast', substitute: 'firm_tofu' },
  'sub_protein_bacon_pancetta_smoked_paprika_mushrooms': { original: 'pancetta', substitute: 'cremini_mushrooms' },
  'sub_protein_eggs_baking_applesauce': { original: 'eggs', substitute: 'applesauce' },
  'sub_protein_shrimp_king_oyster_mushrooms': { original: 'shrimp', substitute: 'king_oyster_mushrooms' },
  'sub_leavener_baking_powder_soda_cream_tartar': { original: 'baking_powder', substitute: 'baking_soda' },
  'sub_leavener_baking_soda_baking_powder': { original: 'baking_soda', substitute: 'baking_powder' },
  'sub_leavener_active_dry_yeast_instant': { original: 'active_dry_yeast', substitute: 'instant_yeast' },
  'sub_leavener_self_rising_flour': { original: 'self_rising_flour', substitute: 'all_purpose_flour' },
  'sub_aromatic_tomato_paste_crushed_tomatoes': { original: 'tomato_paste', substitute: 'canned_crushed_tomatoes' },
  'sub_sweetener_honey_maple_syrup': { original: 'honey', substitute: 'maple_syrup' },
  'sub_condiment_soy_sauce_tamari': { original: 'soy_sauce', substitute: 'tamari' },
  'sub_condiment_fish_sauce_soy_seaweed': { original: 'fish_sauce', substitute: 'soy_sauce' },
  'sub_dairy_mayonnaise_mashed_avocado': { original: 'mayonnaise', substitute: 'avocado' }
};

// 10 Global Starter Recipes Specification
const starterRecipes = [
  {
    slug: 'classic-roman-pasta-carbonara',
    title: 'Classic Roman Pasta Carbonara',
    description: 'The definitive Roman classic made with crispy guanciale, creamy emulsified egg yolks, sharp Pecorino Romano, and an abundance of freshly cracked black pepper. No cream, no peas.',
    cuisine_tags: ['Italian', 'Roman', 'Pasta'],
    category: 'Pasta',
    difficulty: 'medium',
    prep_time_minutes: 10,
    cook_time_minutes: 15,
    servings: 4,
    calories_per_serving: 640,
    nutritional_facts: { protein_g: 28, carbs_g: 72, fat_g: 26, fiber_g: 3, sodium_mg: 820 },
    hero_image_url: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'spaghetti', amount: 400, unit: 'g', display: '400g bronze-cut spaghetti', optional: false, tier: 1 },
      { canonical: 'guanciale', amount: 180, unit: 'g', display: '180g guanciale (or pancetta), diced 1/4-inch thick', optional: false, tier: 1 },
      { canonical: 'eggs', amount: 4, unit: 'piece', display: '4 large egg yolks + 1 whole egg', optional: false, tier: 1 },
      { canonical: 'pecorino_romano', amount: 80, unit: 'g', display: '80g finely grated Pecorino Romano cheese', optional: false, tier: 2 },
      { canonical: 'black_pepper', amount: 5, unit: 'g', display: '2 tsp coarsely cracked black tellicherry peppercorns', optional: false, tier: 0 },
      { canonical: 'salt', amount: 15, unit: 'g', display: '1 tbsp coarse sea salt (for pasta cooking water)', optional: false, tier: 0 }
    ],
    equipment: ['skillet_stainless_steel_12in', 'stockpot_8qt', 'locking_kitchen_tongs_12in', 'balloon_whisk_11in', 'mixing_bowls_nested'],
    steps: [
      {
        step_number: 1,
        title: 'Boil Pasta Water',
        instruction: 'Bring 4 liters of water to a rolling boil in a large 8-12 quart stockpot. Add 15g coarse sea salt once boiling.',
        timer_duration_seconds: 480,
        timer_label: 'Boil Water',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Render the Guanciale',
        instruction: 'Place diced guanciale into a cold 12-inch skillet and set heat to medium-low. Slowly render the pork fat for 8-10 minutes until meat is deeply golden and crisp on the outside while chewy within. Turn off heat and tilt pan to rest.',
        timer_duration_seconds: 540,
        timer_label: 'Render Guanciale',
        is_critical: true,
        techniques: ['searing_protein']
      },
      {
        step_number: 3,
        title: 'Whisk Carbonara Egg Cream',
        instruction: 'In a stainless steel mixing bowl, whisk together 4 egg yolks, 1 whole egg, 80g finely grated Pecorino Romano, and copious cracked black pepper until a thick, uniform paste forms.',
        timer_duration_seconds: 120,
        timer_label: 'Whisk Egg Paste',
        is_critical: false,
        techniques: ['emulsification']
      },
      {
        step_number: 4,
        title: 'Cook Spaghetti Al Dente',
        instruction: 'Drop spaghetti into boiling salted water. Cook for 8 minutes—roughly 2 minutes shy of package directions. Reserve 1 cup (240ml) of starchy pasta water before draining.',
        timer_duration_seconds: 480,
        timer_label: 'Cook Spaghetti',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 5,
        title: 'Emulsify the Sauce (The Mantecatura)',
        instruction: 'Transfer hot spaghetti directly into the guanciale pan using tongs. Ladle in 60ml hot pasta cooking water to temper the egg mixture while whisking constantly. Pour egg paste over the pasta and toss vigorously off the burner for 60 seconds. The residual heat creates an ultra-silky, glossy cream without scrambling the eggs.',
        timer_duration_seconds: 60,
        timer_label: 'Vigorous Toss & Emulsify',
        is_critical: true,
        techniques: ['tempering_liquids', 'emulsification']
      },
      {
        step_number: 6,
        title: 'Plate and Serve Immediately',
        instruction: 'Twirl pasta into warmed bowls. Spoon remaining crispy guanciale bits and pan glaze over the crown. Garnish with extra grated Pecorino Romano and fresh black pepper.',
        timer_duration_seconds: 0,
        timer_label: null,
        is_critical: false,
        techniques: []
      }
    ]
  },
  {
    slug: 'traditional-filipino-chicken-adobo',
    title: 'Traditional Filipino Chicken Adobo',
    description: 'The national comfort dish of the Philippines: chicken thighs slow-braised in cane vinegar, dark soy sauce, crushed garlic heads, black peppercorns, and bay leaves until falling-apart tender and glossy.',
    cuisine_tags: ['Filipino', 'Southeast Asian', 'Braising'],
    category: 'Poultry',
    difficulty: 'easy',
    prep_time_minutes: 15,
    cook_time_minutes: 35,
    servings: 4,
    calories_per_serving: 510,
    nutritional_facts: { protein_g: 42, carbs_g: 10, fat_g: 32, fiber_g: 1, sodium_mg: 1180 },
    hero_image_url: 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'chicken_thighs', amount: 900, unit: 'g', display: '900g bone-in skin-on chicken thighs, trimmed', optional: false, tier: 1 },
      { canonical: 'cane_vinegar', amount: 120, unit: 'ml', display: '1/2 cup (120ml) Filipino cane vinegar (or distilled white vinegar)', optional: false, tier: 2 },
      { canonical: 'soy_sauce', amount: 80, unit: 'ml', display: '1/3 cup (80ml) dark soy sauce', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 10, unit: 'clove', display: '10 large garlic cloves, lightly smashed and peeled', optional: false, tier: 2 },
      { canonical: 'bay_leaves', amount: 4, unit: 'piece', display: '4 dried whole bay leaves', optional: false, tier: 3 },
      { canonical: 'black_pepper', amount: 5, unit: 'g', display: '1 tbsp whole black peppercorns, cracked with skillet bottom', optional: false, tier: 0 },
      { canonical: 'brown_sugar', amount: 15, unit: 'g', display: '1 tbsp dark brown sugar (to balance acidity)', optional: true, tier: 3 },
      { canonical: 'water', amount: 120, unit: 'ml', display: '1/2 cup water', optional: false, tier: 0 },
      { canonical: 'neutral_oil', amount: 15, unit: 'ml', display: '1 tbsp neutral cooking oil', optional: false, tier: 0 }
    ],
    equipment: ['enameled_dutch_oven', 'chef_knife', 'cutting_board_large', 'locking_kitchen_tongs_12in', 'wooden_corner_spoon'],
    steps: [
      {
        step_number: 1,
        title: 'Marinate the Chicken',
        instruction: 'In a large bowl, combine chicken thighs with soy sauce, cane vinegar, smashed garlic cloves, cracked peppercorns, and bay leaves. Toss to coat and marinate for 15-20 minutes at room temperature.',
        timer_duration_seconds: 900,
        timer_label: 'Marinate Chicken',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Sear Chicken Skin',
        instruction: 'Heat neutral oil in a heavy Dutch oven over medium-high heat. Remove chicken from marinade (reserving marinade liquid). Pat chicken skin dry with paper towels. Place skin-side down in the hot pot and sear for 5-6 minutes undisturbed until deep golden brown and crispy.',
        timer_duration_seconds: 360,
        timer_label: 'Sear Chicken Skin',
        is_critical: true,
        techniques: ['searing_protein']
      },
      {
        step_number: 3,
        title: 'Deglaze and Braise',
        instruction: 'Flip chicken thighs over. Pour reserved marinade and 1/2 cup water into the pot. Bring to a rolling boil over high heat, scraping up the browned chicken fond from the pot bottom with a wooden spoon.',
        timer_duration_seconds: 180,
        timer_label: 'Deglaze Fond',
        is_critical: false,
        techniques: ['deglazing_pan']
      },
      {
        step_number: 4,
        title: 'Low & Slow Simmer',
        instruction: 'Cover the Dutch oven with a tight lid, reduce burner to low heat, and braise at a gentle simmer for 25 minutes until chicken registers 175°F (80°C) and meat is fork-tender.',
        timer_duration_seconds: 1500,
        timer_label: 'Braise Chicken',
        is_critical: false,
        techniques: ['braising']
      },
      {
        step_number: 5,
        title: 'Reduce to a Glossy Glaze',
        instruction: 'Uncover pot and stir in brown sugar. Increase heat to medium-high and boil sauce rapidly for 8-10 minutes, basting chicken continuously until liquid reduces into a thick, glossy savory glaze. Serve steaming over fragrant jasmine rice.',
        timer_duration_seconds: 480,
        timer_label: 'Reduce Sauce Glaze',
        is_critical: true,
        techniques: []
      }
    ]
  },
  {
    slug: 'authentic-thai-green-curry-gai',
    title: 'Authentic Thai Green Curry (Gaeng Kiew Wan Gai)',
    description: 'A vibrant, fragrant Bangkok street classic featuring tender chicken breast, Thai baby eggplants, and sweet bamboo shoots bathed in aromatic coconut milk split with green curry paste and fresh Thai basil.',
    cuisine_tags: ['Thai', 'Curry', 'Southeast Asian'],
    category: 'Curry',
    difficulty: 'medium',
    prep_time_minutes: 15,
    cook_time_minutes: 20,
    servings: 4,
    calories_per_serving: 460,
    nutritional_facts: { protein_g: 34, carbs_g: 14, fat_g: 30, fiber_g: 4, sodium_mg: 920 },
    hero_image_url: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'chicken_breast', amount: 500, unit: 'g', display: '500g chicken breast, thinly sliced into bite-sized strips against grain', optional: false, tier: 1 },
      { canonical: 'green_curry_paste', amount: 60, unit: 'g', display: '1/4 cup (60g) authentic Thai green curry paste', optional: false, tier: 2 },
      { canonical: 'canned_coconut_milk', amount: 400, unit: 'ml', display: '1 can (400ml) full-fat coconut milk (separated into top cream and thin liquid)', optional: false, tier: 2 },
      { canonical: 'thai_eggplant', amount: 150, unit: 'g', display: '150g Thai round eggplants, quartered and submerged in salted water', optional: false, tier: 2 },
      { canonical: 'bamboo_shoots', amount: 100, unit: 'g', display: '100g canned sliced bamboo shoots, rinsed and drained', optional: false, tier: 2 },
      { canonical: 'fish_sauce', amount: 30, unit: 'ml', display: '2 tbsp premium fish sauce', optional: false, tier: 3 },
      { canonical: 'palm_sugar', amount: 15, unit: 'g', display: '1 tbsp shaved palm sugar (or light brown sugar)', optional: false, tier: 3 },
      { canonical: 'kaffir_lime_leaves', amount: 5, unit: 'piece', display: '5 fresh kaffir lime leaves, torn and center rib removed', optional: false, tier: 3 },
      { canonical: 'thai_basil', amount: 30, unit: 'g', display: '1 packed cup fresh Thai sweet basil leaves', optional: false, tier: 3 }
    ],
    equipment: ['skillet_stainless_steel_12in', 'chef_knife', 'cutting_board_large', 'wooden_corner_spoon'],
    steps: [
      {
        step_number: 1,
        title: 'Crack the Coconut Cream',
        instruction: 'Open the coconut milk can without shaking. Scoop out the top 1/2 cup of thick coconut cream into a dry 12-inch skillet over medium heat. Simmer for 4-5 minutes until the coconut oil cracks and separates from the solids in glistening pools.',
        timer_duration_seconds: 300,
        timer_label: 'Crack Coconut Cream',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Fry the Curry Paste',
        instruction: 'Add 60g green curry paste into the hot separated coconut oil. Fry vigorously for 2 minutes, breaking up clumps with a wooden spoon until deeply fragrant and oil turns emerald green.',
        timer_duration_seconds: 120,
        timer_label: 'Bloom Curry Paste',
        is_critical: true,
        techniques: ['blooming_spices']
      },
      {
        step_number: 3,
        title: 'Sauté Chicken Slices',
        instruction: 'Add sliced chicken breast into the bubbling curry paste. Sauté for 3 minutes until chicken exterior turns opaque white and is thoroughly coated in spiced paste.',
        timer_duration_seconds: 180,
        timer_label: 'Sauté Chicken',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 4,
        title: 'Simmer Vegetables and Aromatics',
        instruction: 'Pour in the remaining thin coconut milk and 1/4 cup water. Bring to a gentle simmer. Add quartered Thai eggplants, drained bamboo shoots, torn kaffir lime leaves, fish sauce, and palm sugar. Simmer uncovered for 8 minutes until eggplants are tender.',
        timer_duration_seconds: 480,
        timer_label: 'Simmer Curry',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 5,
        title: 'Fold Fresh Thai Basil',
        instruction: 'Turn off burner immediately. Scatter in 1 cup of fresh Thai basil leaves and gently submerge them into the hot curry. The residual heat wilts the basil in 20 seconds while retaining its bright green color and anise aroma. Serve with warm jasmine rice.',
        timer_duration_seconds: 30,
        timer_label: 'Wilt Thai Basil',
        is_critical: false,
        techniques: []
      }
    ]
  },
  {
    slug: 'sichuan-beef-and-broccoli-stir-fry',
    title: 'Sichuan Beef & Broccoli Stir-Fry',
    description: 'Restaurant-quality high-heat stir fry featuring tender velveted flank steak slices and crisp emerald broccoli florets coated in a glossy, savory garlic-ginger soy glaze.',
    cuisine_tags: ['Chinese', 'Sichuan', 'Stir Fry'],
    category: 'Beef',
    difficulty: 'medium',
    prep_time_minutes: 20,
    cook_time_minutes: 10,
    servings: 4,
    calories_per_serving: 420,
    nutritional_facts: { protein_g: 36, carbs_g: 16, fat_g: 22, fiber_g: 4, sodium_mg: 890 },
    hero_image_url: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'flank_steak', amount: 450, unit: 'g', display: '450g beef flank steak, sliced thinly across grain into 2-inch planks', optional: false, tier: 1 },
      { canonical: 'broccoli', amount: 350, unit: 'g', display: '350g broccoli crowns, cut into bite-sized uniform florets', optional: false, tier: 2 },
      { canonical: 'soy_sauce', amount: 45, unit: 'ml', display: '3 tbsp brewed soy sauce (divided: 1 tbsp marinade, 2 tbsp glaze)', optional: false, tier: 3 },
      { canonical: 'shaoxing_wine', amount: 15, unit: 'ml', display: '1 tbsp Shaoxing cooking wine', optional: false, tier: 3 },
      { canonical: 'cornstarch', amount: 20, unit: 'g', display: '4 tsp cornstarch (divided: 2 tsp velvet marinade, 2 tsp glaze slurry)', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 4, unit: 'clove', display: '4 garlic cloves, finely minced', optional: false, tier: 2 },
      { canonical: 'fresh_ginger', amount: 15, unit: 'g', display: '1 tbsp fresh ginger root, finely grated', optional: false, tier: 2 },
      { canonical: 'toasted_sesame_oil', amount: 15, unit: 'ml', display: '1 tbsp pure toasted sesame oil', optional: false, tier: 3 },
      { canonical: 'scallions', amount: 40, unit: 'g', display: '3 scallions, cut into 1.5-inch diagonal segments', optional: false, tier: 2 },
      { canonical: 'neutral_oil', amount: 30, unit: 'ml', display: '2 tbsp high-heat neutral oil', optional: false, tier: 0 }
    ],
    equipment: ['skillet_stainless_steel_12in', 'chef_knife', 'cutting_board_large', 'fine_mesh_sieve_strainer', 'mixing_bowls_nested'],
    steps: [
      {
        step_number: 1,
        title: 'Velvet the Beef',
        instruction: 'Place thinly sliced flank steak into a medium bowl. Add 1 tbsp soy sauce, 1 tbsp Shaoxing wine, 1 tbsp water, and 2 tsp cornstarch. Massage vigorously until all liquid is absorbed into the meat fibers. Let rest for 15 minutes to guarantee tender, velvety beef.',
        timer_duration_seconds: 900,
        timer_label: 'Velvet Beef',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Blanch and Shock Broccoli',
        instruction: 'Drop broccoli florets into a pot of rapidly boiling salted water for 60 seconds until crisp-tender and vibrant emerald green. Immediately plunge into an ice-water bath using a strainer to stop cooking. Drain thoroughly on paper towels.',
        timer_duration_seconds: 60,
        timer_label: 'Blanch Broccoli',
        is_critical: true,
        techniques: ['blanch_and_shock']
      },
      {
        step_number: 3,
        title: 'Mix the Stir-Fry Glaze',
        instruction: 'In a small bowl, whisk 2 tbsp soy sauce, 1 tbsp sesame oil, 2 tsp cornstarch, 1/4 cup water, and a pinch of brown sugar until smooth.',
        timer_duration_seconds: 60,
        timer_label: 'Whisk Glaze Slurry',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 4,
        title: 'High-Heat Beef Sear',
        instruction: 'Heat 1.5 tbsp neutral oil in a 12-inch stainless skillet over maximum high heat until smoking hot. Spread beef slices in a single layer. Sear undisturbed for 90 seconds until a caramelized brown crust forms, then flip and toss for 60 seconds until just pink. Transfer beef to a clean plate.',
        timer_duration_seconds: 150,
        timer_label: 'Sear Beef',
        is_critical: true,
        techniques: ['searing_protein']
      },
      {
        step_number: 5,
        title: 'Wok Finish and Sauce Glaze',
        instruction: 'Add remaining oil, minced garlic, ginger, and scallions to the hot pan. Sauté for 30 seconds until fragrant. Return seared beef and blanched broccoli. Pour in glaze slurry. Toss aggressively over high heat for 60 seconds as the sauce bubbles into a mirror-like lacquer coating every piece.',
        timer_duration_seconds: 90,
        timer_label: 'Toss & Glaze',
        is_critical: false,
        techniques: []
      }
    ]
  },
  {
    slug: 'classic-french-rolled-omelet',
    title: 'Classic French Rolled Omelet',
    description: 'The pinnacle test of French culinary precision: pale golden, smooth cylindrical exterior with zero browning, encasing a creamy, custardy, softly scrambled baveuse center.',
    cuisine_tags: ['French', 'Breakfast', 'Eggs'],
    category: 'Eggs',
    difficulty: 'medium',
    prep_time_minutes: 5,
    cook_time_minutes: 5,
    servings: 1,
    calories_per_serving: 310,
    nutritional_facts: { protein_g: 18, carbs_g: 2, fat_g: 26, fiber_g: 0, sodium_mg: 380 },
    hero_image_url: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'eggs', amount: 3, unit: 'piece', display: '3 large fresh eggs (room temperature)', optional: false, tier: 1 },
      { canonical: 'unsalted_butter', amount: 25, unit: 'g', display: '25g cold unsalted European butter, cut into small cubes (divided)', optional: false, tier: 2 },
      { canonical: 'fresh_chives', amount: 10, unit: 'g', display: '1 tbsp fresh chives, finely snipped', optional: false, tier: 3 },
      { canonical: 'salt', amount: 2, unit: 'g', display: '1/4 tsp fine sea salt', optional: false, tier: 0 },
      { canonical: 'white_pepper', amount: 1, unit: 'g', display: 'Pinch of ground white pepper', optional: false, tier: 3 }
    ],
    equipment: ['skillet_nonstick_10in', 'balloon_whisk_11in', 'heatproof_silicone_spatula', 'mixing_bowls_nested'],
    steps: [
      {
        step_number: 1,
        title: 'Whisk Eggs Uniformly',
        instruction: 'Crack 3 eggs into a bowl. Season with fine sea salt and white pepper. Whisk vigorously for 60 seconds until completely uniform with zero translucent egg white strands remaining.',
        timer_duration_seconds: 60,
        timer_label: 'Whisk Eggs',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Melt Butter on Medium-Low Heat',
        instruction: 'Place an 8 or 10-inch nonstick skillet over medium-low heat. Melt 15g cold butter until foaming across the pan surface. Do not allow butter to sizzle or brown.',
        timer_duration_seconds: 90,
        timer_label: 'Melt Butter',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 3,
        title: 'Rapid Agitation (Small Curds)',
        instruction: 'Pour beaten eggs into skillet. Immediately begin shaking pan back and forth with your left hand while rapidly stirring eggs in tight circles with a heatproof silicone spatula in your right hand. Small creamy curds will form within 60-90 seconds.',
        timer_duration_seconds: 90,
        timer_label: 'Agitate Curds',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 4,
        title: 'Smooth and Form the Sheet',
        instruction: 'When eggs are 80% cooked into a soft, custardy custard (baveuse) with almost no runny liquid, remove skillet from direct heat. Use silicone spatula to smooth the egg surface into an even round disk.',
        timer_duration_seconds: 30,
        timer_label: 'Smooth Egg Sheet',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 5,
        title: 'Roll and Glaze Omelet',
        instruction: 'Tilt pan 45 degrees away from you. Use spatula to gently roll the top third of the omelet downward toward the center, then fold bottom third over. Invert onto a warm plate seam-side down. Rub remaining 10g cold butter across the hot surface for a glistening sheen; scatter snipped chives over top.',
        timer_duration_seconds: 60,
        timer_label: 'Roll and Glaze',
        is_critical: true,
        techniques: ['monter_au_beurre']
      }
    ]
  },
  {
    slug: 'traditional-middle-eastern-shakshuka',
    title: 'Traditional Middle Eastern Shakshuka',
    description: 'A vibrant, spiced North African and Levantine breakfast staple: pasture-raised eggs gently poached in a rich, simmering skillet of crushed tomatoes, sweet bell peppers, caramelized onions, cumin, paprika, and salty feta.',
    cuisine_tags: ['Middle Eastern', 'North African', 'Vegetarian', 'Breakfast'],
    category: 'Eggs',
    difficulty: 'easy',
    prep_time_minutes: 15,
    cook_time_minutes: 25,
    servings: 4,
    calories_per_serving: 320,
    nutritional_facts: { protein_g: 16, carbs_g: 18, fat_g: 22, fiber_g: 5, sodium_mg: 640 },
    hero_image_url: 'https://images.unsplash.com/photo-1590412200988-a436970781fa?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'eggs', amount: 5, unit: 'piece', display: '5 large fresh eggs', optional: false, tier: 1 },
      { canonical: 'canned_crushed_tomatoes', amount: 800, unit: 'g', display: '1 large can (800g) crushed San Marzano tomatoes with juices', optional: false, tier: 2 },
      { canonical: 'red_bell_pepper', amount: 2, unit: 'piece', display: '2 red bell peppers, stemmed, seeded, and cut into 1/2-inch dice', optional: false, tier: 2 },
      { canonical: 'yellow_onion', amount: 1, unit: 'piece', display: '1 large yellow onion, finely diced', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 4, unit: 'clove', display: '4 garlic cloves, thinly sliced', optional: false, tier: 2 },
      { canonical: 'ground_cumin', amount: 6, unit: 'g', display: '1.5 tsp ground cumin', optional: false, tier: 3 },
      { canonical: 'smoked_paprika', amount: 6, unit: 'g', display: '1.5 tsp smoked Spanish paprika', optional: false, tier: 3 },
      { canonical: 'olive_oil', amount: 45, unit: 'ml', display: '3 tbsp extra virgin olive oil', optional: false, tier: 0 },
      { canonical: 'feta_cheese', amount: 75, unit: 'g', display: '75g Greek sheep milk feta, crumbled', optional: true, tier: 2 },
      { canonical: 'fresh_cilantro', amount: 20, unit: 'g', display: '1/4 cup fresh cilantro leaves, chopped', optional: false, tier: 3 },
      { canonical: 'salt', amount: 5, unit: 'g', display: '1 tsp sea salt', optional: false, tier: 0 },
      { canonical: 'black_pepper', amount: 3, unit: 'g', display: '1/2 tsp freshly cracked black pepper', optional: false, tier: 0 }
    ],
    equipment: ['cast_iron_skillet_12in', 'chef_knife', 'cutting_board_large', 'wooden_corner_spoon'],
    steps: [
      {
        step_number: 1,
        title: 'Sweat Aromatics and Peppers',
        instruction: 'Heat olive oil in a 12-inch cast iron skillet over medium heat. Add diced onion and bell pepper with a pinch of sea salt. Cook for 8-10 minutes, stirring occasionally until vegetables are softened, sweet, and lightly caramelized.',
        timer_duration_seconds: 540,
        timer_label: 'Sweat Aromatics',
        is_critical: false,
        techniques: ['sweating_aromatics']
      },
      {
        step_number: 2,
        title: 'Bloom Cumin and Paprika',
        instruction: 'Add sliced garlic, ground cumin, and smoked paprika. Stir continuously in hot olive oil for 60 seconds until fragrant and intoxicatingly aromatic.',
        timer_duration_seconds: 60,
        timer_label: 'Bloom Spices',
        is_critical: true,
        techniques: ['blooming_spices']
      },
      {
        step_number: 3,
        title: 'Simmer Tomato Sauce',
        instruction: 'Pour in crushed tomatoes with juices. Season with black pepper and remaining salt. Simmer uncovered over medium-low heat for 12 minutes, stirring periodically until sauce is thick, rich, and jammy.',
        timer_duration_seconds: 720,
        timer_label: 'Reduce Tomato Sauce',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 4,
        title: 'Poach the Eggs',
        instruction: 'Use the back of a large wooden spoon to make 5 evenly spaced depressions in the simmering sauce. Crack an egg directly into each well. Cover skillet with lid or foil, reduce heat to low, and gently poach for 6-8 minutes until egg whites are opaque and set while yolks remain runny.',
        timer_duration_seconds: 420,
        timer_label: 'Poach Eggs',
        is_critical: true,
        techniques: ['poaching']
      },
      {
        step_number: 5,
        title: 'Garnish and Serve',
        instruction: 'Uncover skillet. Scatter crumbled feta cheese and freshly chopped cilantro over the steaming dish. Serve skillet directly at the table with warm pita bread or crusty sourdough for dipping.',
        timer_duration_seconds: 0,
        timer_label: null,
        is_critical: false,
        techniques: []
      }
    ]
  },
  {
    slug: 'creamy-indian-red-lentil-dahl',
    title: 'Creamy Indian Red Lentil Dahl (Masoor Dal Tadka)',
    description: 'Soul-warming North Indian red lentils simmered into a velvety coconut porridge, finished with a dramatic smoking Tadka tempering of sizzling ghee, cumin seeds, garlic, and fresh ginger.',
    cuisine_tags: ['Indian', 'Vegan', 'Vegetarian', 'Curry'],
    category: 'Vegetarian',
    difficulty: 'easy',
    prep_time_minutes: 10,
    cook_time_minutes: 30,
    servings: 4,
    calories_per_serving: 380,
    nutritional_facts: { protein_g: 22, carbs_g: 48, fat_g: 12, fiber_g: 14, sodium_mg: 580 },
    hero_image_url: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'red_lentils', amount: 250, unit: 'g', display: '250g split red lentils (Masoor Dal), rinsed until clear', optional: false, tier: 1 },
      { canonical: 'yellow_onion', amount: 1, unit: 'piece', display: '1 medium yellow onion, finely diced', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 5, unit: 'clove', display: '5 garlic cloves, minced', optional: false, tier: 2 },
      { canonical: 'fresh_ginger', amount: 20, unit: 'g', display: '1.5 tbsp fresh ginger, finely grated', optional: false, tier: 2 },
      { canonical: 'ground_turmeric', amount: 5, unit: 'g', display: '1 tsp ground turmeric powder', optional: false, tier: 3 },
      { canonical: 'ground_cumin', amount: 6, unit: 'g', display: '1.5 tsp ground cumin seed', optional: false, tier: 3 },
      { canonical: 'garam_masala', amount: 5, unit: 'g', display: '1 tsp authentic garam masala', optional: false, tier: 3 },
      { canonical: 'canned_coconut_milk', amount: 200, unit: 'ml', display: '1/2 can (200ml) full-fat coconut milk', optional: false, tier: 2 },
      { canonical: 'vegetable_broth', amount: 750, unit: 'ml', display: '3 cups (750ml) vegetable broth or water', optional: false, tier: 2 },
      { canonical: 'ghee', amount: 30, unit: 'g', display: '2 tbsp ghee (or virgin coconut oil for vegan)', optional: false, tier: 3 },
      { canonical: 'fresh_cilantro', amount: 15, unit: 'g', display: '1/4 cup fresh cilantro leaves, chopped', optional: false, tier: 3 },
      { canonical: 'salt', amount: 8, unit: 'g', display: '1.5 tsp fine sea salt', optional: false, tier: 0 }
    ],
    equipment: ['saucepan_3qt', 'skillet_stainless_steel_12in', 'fine_mesh_sieve_strainer', 'wooden_corner_spoon'],
    steps: [
      {
        step_number: 1,
        title: 'Rinse Lentils and Simmer',
        instruction: 'Place red lentils into a fine-mesh strainer and rinse under cold water until runoff is completely clear. In a 3-quart saucepan, combine rinsed lentils, 3 cups vegetable broth, ground turmeric, and 1 tsp salt. Bring to a rolling boil over high heat.',
        timer_duration_seconds: 300,
        timer_label: 'Bring to Boil',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Break Down into Porridge',
        instruction: 'Reduce burner to low, cover partially with lid, and simmer gently for 20 minutes, stirring occasionally until lentils collapse into a thick, golden porridge.',
        timer_duration_seconds: 1200,
        timer_label: 'Simmer Dal',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 3,
        title: 'Stir in Coconut Milk',
        instruction: 'Whisk 200ml full-fat coconut milk into the cooked lentils. Simmer for another 5 minutes over gentle heat until velvety and luscious.',
        timer_duration_seconds: 300,
        timer_label: 'Stir in Coconut Milk',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 4,
        title: 'Fry the Spiced Tadka',
        instruction: 'In a small skillet, heat 2 tbsp ghee or coconut oil over medium heat. Add diced onions and sauté for 4-5 minutes until golden brown. Add minced garlic, grated ginger, cumin, and garam masala. Fry vigorously for 60 seconds until bubbling, sizzling, and fragrant.',
        timer_duration_seconds: 300,
        timer_label: 'Fry Tadka',
        is_critical: true,
        techniques: ['blooming_spices', 'sweating_aromatics']
      },
      {
        step_number: 5,
        title: 'Combine Sizzling Tadka',
        instruction: 'Pour sizzling Tadka fat and aromatics directly into the saucepan of warm lentils; it will hiss and crackle violently. Stir thoroughly to incorporate the spiced fat into the dahl. Garnish with chopped fresh cilantro and serve with warm naan or basmati rice.',
        timer_duration_seconds: 60,
        timer_label: 'Incorporate Tadka',
        is_critical: true,
        techniques: []
      }
    ]
  },
  {
    slug: 'classic-provencal-ratatouille',
    title: 'Classic Provençal Ratatouille',
    description: 'The definitive summer stew of Nice, France: firm eggplants, sweet summer zucchini, yellow squash, bell peppers, and ripe Roma tomatoes cooked down gently in olive oil with garlic and thyme until meltingly tender.',
    cuisine_tags: ['French', 'Provençal', 'Vegetarian', 'Vegan'],
    category: 'Vegetarian',
    difficulty: 'medium',
    prep_time_minutes: 25,
    cook_time_minutes: 45,
    servings: 6,
    calories_per_serving: 190,
    nutritional_facts: { protein_g: 4, carbs_g: 18, fat_g: 13, fiber_g: 7, sodium_mg: 340 },
    hero_image_url: 'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'eggplant', amount: 1, unit: 'piece', display: '1 large globe eggplant, cut into 3/4-inch uniform cubes', optional: false, tier: 2 },
      { canonical: 'zucchini', amount: 2, unit: 'piece', display: '2 medium green zucchini, cut into 3/4-inch half-moons', optional: false, tier: 2 },
      { canonical: 'yellow_squash', amount: 2, unit: 'piece', display: '2 yellow summer squash, cut into 3/4-inch half-moons', optional: false, tier: 2 },
      { canonical: 'red_bell_pepper', amount: 2, unit: 'piece', display: '2 red bell peppers, seeded and cut into 3/4-inch dice', optional: false, tier: 2 },
      { canonical: 'roma_tomatoes', amount: 500, unit: 'g', display: '500g ripe Roma tomatoes, peeled, seeded, and coarsely chopped', optional: false, tier: 2 },
      { canonical: 'yellow_onion', amount: 1, unit: 'piece', display: '1 large yellow onion, diced', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 6, unit: 'clove', display: '6 garlic cloves, thinly sliced', optional: false, tier: 2 },
      { canonical: 'olive_oil', amount: 80, unit: 'ml', display: '1/3 cup high-grade extra virgin olive oil (divided)', optional: false, tier: 0 },
      { canonical: 'fresh_thyme', amount: 10, unit: 'g', display: '4 fresh thyme sprigs', optional: false, tier: 3 },
      { canonical: 'dried_oregano', amount: 4, unit: 'g', display: '1 tsp dried oregano', optional: false, tier: 3 },
      { canonical: 'salt', amount: 8, unit: 'g', display: '1.5 tsp fine sea salt', optional: false, tier: 0 },
      { canonical: 'black_pepper', amount: 4, unit: 'g', display: '1/2 tsp freshly ground black pepper', optional: false, tier: 0 }
    ],
    equipment: ['enameled_dutch_oven', 'chef_knife', 'cutting_board_large', 'wooden_corner_spoon'],
    steps: [
      {
        step_number: 1,
        title: 'Salt and Drain Eggplant',
        instruction: 'Toss cubed eggplant with 1 tsp sea salt in a colander. Let rest for 20 minutes to draw out bitter liquids and excess moisture. Press dry thoroughly with paper towels.',
        timer_duration_seconds: 1200,
        timer_label: 'Degorge Eggplant',
        is_critical: true,
        techniques: ['dry_brining']
      },
      {
        step_number: 2,
        title: 'Brown Eggplant in Batches',
        instruction: 'Heat 2 tbsp olive oil in a Dutch oven over medium-high heat. Sear dried eggplant cubes in batches for 5 minutes until browned and caramelized on edges. Remove and set aside in a bowl.',
        timer_duration_seconds: 300,
        timer_label: 'Sear Eggplant',
        is_critical: false,
        techniques: ['searing_protein']
      },
      {
        step_number: 3,
        title: 'Sauté Onions, Peppers, and Aromatics',
        instruction: 'Add another tablespoon of oil to the Dutch oven. Sauté diced onions and bell peppers for 8 minutes until tender and sweet. Add sliced garlic, thyme sprigs, and dried oregano; sauté 1 minute until fragrant.',
        timer_duration_seconds: 540,
        timer_label: 'Sauté Mirepoix',
        is_critical: false,
        techniques: ['sweating_aromatics']
      },
      {
        step_number: 4,
        title: 'Add Squash and Tomatoes',
        instruction: 'Stir in zucchini, yellow summer squash, and chopped Roma tomatoes. Return seared eggplant to the pot. Season with remaining salt and black pepper. Stir gently to marry vegetables.',
        timer_duration_seconds: 180,
        timer_label: 'Marry Vegetables',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 5,
        title: 'Slow Stew to Silky Perfection',
        instruction: 'Cover the Dutch oven with lid slightly ajar. Reduce burner to low heat and simmer gently for 35 minutes, stirring occasionally until all vegetables are soft, silky, and collapsed into their fragrant juices. Finish with a drizzle of fresh raw olive oil.',
        timer_duration_seconds: 2100,
        timer_label: 'Slow Stew Ratatouille',
        is_critical: true,
        techniques: []
      }
    ]
  },
  {
    slug: 'authentic-mexican-guacamole-molcajete',
    title: 'Authentic Mexican Guacamole (Molcajete Style)',
    description: 'The ancient Aztec way: rich Haas avocados coarsely hand-crushed in a volcanic stone mortar with a freshly ground aromatic paste of garlic, serrano chile, red onion, sea salt, lime, and cilantro.',
    cuisine_tags: ['Mexican', 'Appetizer', 'Vegan', 'Dip'],
    category: 'Appetizers',
    difficulty: 'easy',
    prep_time_minutes: 15,
    cook_time_minutes: 0,
    servings: 4,
    calories_per_serving: 240,
    nutritional_facts: { protein_g: 3, carbs_g: 12, fat_g: 22, fiber_g: 9, sodium_mg: 380 },
    hero_image_url: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'avocado', amount: 3, unit: 'piece', display: '3 large ripe Hass avocados (yielding slightly to gentle pressure)', optional: false, tier: 1 },
      { canonical: 'lime_juice', amount: 30, unit: 'ml', display: '2 tbsp fresh lime juice (from 2 juicy limes)', optional: false, tier: 3 },
      { canonical: 'red_onion', amount: 0.5, unit: 'piece', display: '1/2 medium red onion, finely minced', optional: false, tier: 2 },
      { canonical: 'fresh_cilantro', amount: 25, unit: 'g', display: '1/2 cup fresh cilantro leaves and tender stems, finely chopped', optional: false, tier: 3 },
      { canonical: 'jalapeno_pepper', amount: 1, unit: 'piece', display: '1 fresh jalapeño or serrano chile, finely minced (seeds optional for heat)', optional: false, tier: 2 },
      { canonical: 'roma_tomatoes', amount: 1, unit: 'piece', display: '1 ripe Roma tomato, seeds and core discarded, flesh finely diced', optional: false, tier: 2 },
      { canonical: 'garlic_cloves', amount: 1, unit: 'clove', display: '1 small garlic clove, finely grated', optional: false, tier: 2 },
      { canonical: 'salt', amount: 5, unit: 'g', display: '1 tsp coarse sea salt (or to taste)', optional: false, tier: 0 }
    ],
    equipment: ['granite_mortar_and_pestle', 'chef_knife', 'cutting_board_large'],
    steps: [
      {
        step_number: 1,
        title: 'Grind the Flavor Paste (El Majado)',
        instruction: 'In a heavy granite mortar and pestle (molcajete), add the grated garlic clove, 2 tbsp of the minced red onion, half the minced jalapeño, 1 tbsp chopped cilantro, and 1 tsp sea salt. Grind vigorously with pestle against the stone walls for 2 minutes until an aromatic, emerald-green paste forms.',
        timer_duration_seconds: 120,
        timer_label: 'Grind Majado Paste',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Scoop the Avocados',
        instruction: 'Slice avocados in half lengthwise around seed. Twist halves apart and remove pits. Use a large spoon to scoop avocado flesh directly into the mortar over the aromatic paste.',
        timer_duration_seconds: 60,
        timer_label: 'Scoop Avocados',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 3,
        title: 'Coarse Hand Mash',
        instruction: 'Drizzle 2 tbsp fresh lime juice over the avocado. Use the pestle to crush the avocados into the paste, intentionally maintaining substantial creamy chunks. Never puree into baby food.',
        timer_duration_seconds: 60,
        timer_label: 'Coarse Mash',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 4,
        title: 'Fold in Fresh Crisp Ingredients',
        instruction: 'Add remaining minced red onion, remaining jalapeño, diced Roma tomato, and remaining chopped cilantro. Gently fold together with a spoon. Taste and adjust with extra lime juice or sea salt. Serve immediately with warm tortilla chips.',
        timer_duration_seconds: 60,
        timer_label: 'Fold & Season',
        is_critical: false,
        techniques: []
      }
    ]
  },
  {
    slug: 'artisanal-rustic-sourdough-bread',
    title: 'Artisanal Rustic Sourdough Bread',
    description: 'An open-crumb, blistered mahogany sourdough loaf baked in a screaming-hot Dutch oven. Made purely with flour, water, salt, and wild levain through slow cold fermentation.',
    cuisine_tags: ['Baking', 'European', 'Artisan Bread'],
    category: 'Baking',
    difficulty: 'expert',
    prep_time_minutes: 60,
    cook_time_minutes: 45,
    servings: 12,
    calories_per_serving: 195,
    nutritional_facts: { protein_g: 7, carbs_g: 39, fat_g: 1, fiber_g: 3, sodium_mg: 380 },
    hero_image_url: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=1200&auto=format&fit=crop&q=80',
    ingredients: [
      { canonical: 'bread_flour', amount: 450, unit: 'g', display: '450g unbleached strong bread flour (12.7% protein)', optional: false, tier: 1 },
      { canonical: 'whole_wheat_flour', amount: 50, unit: 'g', display: '50g stone-ground whole wheat flour', optional: false, tier: 1 },
      { canonical: 'water', amount: 375, unit: 'ml', display: '375ml lukewarm water (75% hydration)', optional: false, tier: 0 },
      { canonical: 'sourdough_starter', amount: 100, unit: 'g', display: '100g active mature sourdough starter (100% hydration, bubbly and peaked)', optional: false, tier: 1 },
      { canonical: 'salt', amount: 10, unit: 'g', display: '10g fine sea salt', optional: false, tier: 0 }
    ],
    equipment: ['enameled_dutch_oven', 'digital_kitchen_scale_1g', 'mixing_bowls_nested', 'serrated_knife', 'half_sheet_pan'],
    steps: [
      {
        step_number: 1,
        title: 'Flour Autolyse',
        instruction: 'In a large mixing bowl, mix 450g bread flour and 50g whole wheat flour with 350ml water (holding back 25ml) using your hands until no dry flour spots remain. Cover bowl and rest undisturbed for 45 minutes to let enzymes hydrate the gluten strands.',
        timer_duration_seconds: 2700,
        timer_label: 'Autolyse Dough',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 2,
        title: 'Incorporate Levain and Salt',
        instruction: 'Add 100g active bubbly sourdough starter, 10g sea salt, and reserved 25ml water over the dough. Dimple and squeeze dough between fingers for 3 minutes until smooth and elastic.',
        timer_duration_seconds: 180,
        timer_label: 'Incorporate Starter',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 3,
        title: 'Bulk Fermentation & Stretch-and-Folds',
        instruction: 'Perform 4 sets of stretch-and-folds spaced 30 minutes apart over the first 2 hours. Dip wet hands in water, grab underside of dough, stretch upward without tearing, and fold over top. Let dough ferment at 78°F (25°C) until aerated, domed, and increased 50% in volume.',
        timer_duration_seconds: 7200,
        timer_label: 'Bulk Ferment',
        is_critical: true,
        techniques: ['folding_batter']
      },
      {
        step_number: 4,
        title: 'Pre-shape and Final Banneton Proof',
        instruction: 'Turn dough onto an unfloured work surface. Pre-shape into a taut round ball using bench knife. Rest 20 minutes uncovered. Perform final shaping into a tight boule with strong surface tension. Dust with rice flour and transfer seam-side UP into a proofing banneton basket. Chill in refrigerator at 38°F (3°C) for 14-16 hours.',
        timer_duration_seconds: 50400,
        timer_label: 'Cold Retard Proof',
        is_critical: false,
        techniques: []
      },
      {
        step_number: 5,
        title: 'Score and Dutch Oven Steam Bake',
        instruction: 'Preheat oven with Dutch oven inside to 500°F (260°C) for 60 minutes. Invert cold dough onto parchment paper. Score top surface 1/2-inch deep with a razor blade at a 30-degree angle. Lower dough into screaming-hot Dutch oven, drop in 2 ice cubes for steam, cover tightly with lid, reduce oven to 450°F (230°C), and bake for 20 minutes.',
        timer_duration_seconds: 1200,
        timer_label: 'Covered Steam Bake',
        is_critical: true,
        techniques: []
      },
      {
        step_number: 6,
        title: 'Uncover for Mahogany Crust',
        instruction: 'Carefully remove Dutch oven lid. Continue baking uncovered for 22-25 minutes until the crust turns deeply caramelized mahogany blistered and loaf sounds hollow when tapped on bottom. Cool completely on a wire rack for 2 hours before slicing with a serrated knife.',
        timer_duration_seconds: 1320,
        timer_label: 'Crust Caramelization',
        is_critical: false,
        techniques: []
      }
    ]
  }
];

// Build SQL
let sql = `-- ==============================================================================
-- LUTO (Logo: Lu2) Mobile Cooking Platform — Universal Taxonomy & Starter Seed
-- File: supabase/seed.sql
-- Ingests:
--   - Default test kitchen creator profile
--   - 32 Universal Kitchen Equipment items (docs/taxonomies/equipment.json)
--   - 20 Master Cooking Techniques & Skills (docs/taxonomies/techniques.json)
--   - Master Ingredients Dictionary
--   - 35 Dynamic Ingredient Substitutions (docs/taxonomies/substitutions.json)
--   - 10 Diverse Global Starter Recipes with complete step & equipment graphs
-- ==============================================================================

-- 1. Ensure master test kitchen profile exists
INSERT INTO auth.users (id, email, raw_user_meta_data)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'chef@luto.app',
    '{"username": "luto_master_chef", "display_name": "Chef Luto"}'::jsonb
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO profiles (id, username, display_name, avatar_url, bio, measurement_preference, dietary_preferences, skill_level)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'luto_master_chef',
    'Chef Luto (Master Test Kitchen)',
    'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=400&auto=format&fit=crop&q=80',
    'Curated, tested, and resilient kitchen formulations developed by the Luto Open Culinary Engineering Group.',
    'metric',
    ARRAY[]::TEXT[],
    'pro'
)
ON CONFLICT (id) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    avatar_url = EXCLUDED.avatar_url,
    bio = EXCLUDED.bio;

-- 2. Seed Master Kitchen Equipment Dictionary (32 items)
`;

for (const eq of equipmentData.equipment) {
  const eqUUID = getUUID('equipment', eq.canonical_name);
  sql += `INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '${eqUUID}',
    ${escapeSQL(eq.canonical_name)},
    ${escapeSQL(eq.display_name)},
    ${escapeSQL(eq.category)},
    ${eq.is_essential},
    ${escapeSQL(eq.icon_name)},
    ${escapeSQL(eq.description)}
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;\n\n`;
}

sql += `-- 3. Seed Master Cooking Techniques Catalog (20 items)\n`;

for (const tech of techniquesData.techniques) {
  const techUUID = getUUID('technique', tech.canonical_slug);
  const microVideo = `https://storage.luto.app/techniques/${tech.canonical_slug}/micro_1080p.mp4`;
  const gifPreview = `https://storage.luto.app/techniques/${tech.canonical_slug}/preview.gif`;

  sql += `INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '${techUUID}',
    ${escapeSQL(tech.canonical_slug)},
    ${escapeSQL(tech.name)},
    ${escapeSQL(tech.category)},
    ${escapeSQL(tech.difficulty)},
    ${escapeSQL(tech.summary)},
    ${escapeSQL(microVideo)},
    ${escapeSQL(gifPreview)},
    ${sqlArray(tech.key_tips)},
    ${sqlArray(tech.common_mistakes)}
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;\n\n`;
}

sql += `-- 4. Seed Master Ingredients Dictionary\n`;

for (const ing of masterIngredients) {
  const ingUUID = getUUID('ingredient', ing.canonical);
  sql += `INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '${ingUUID}',
    ${escapeSQL(ing.canonical)},
    ${escapeSQL(ing.display)},
    ${escapeSQL(ing.category)},
    ${ing.is_staple},
    ${escapeSQL(ing.unit)},
    ${ing.shelf_life || 'NULL'},
    ${sqlArray(ing.allergens)},
    ${ing.density || 'NULL'}
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;\n\n`;
}

sql += `-- 5. Seed Dynamic Ingredient Substitutions Matrix (35 items)\n`;

for (const sub of substitutionsData.substitutions) {
  const mapping = substitutionCanonicalMapping[sub.id];
  if (!mapping) {
    console.error(`Missing canonical mapping for substitution ${sub.id}`);
    continue;
  }
  const origUUID = getUUID('ingredient', mapping.original);
  const targetUUID = getUUID('ingredient', mapping.substitute);
  const subUUID = getUUID('substitution', sub.id);

  sql += `INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '${subUUID}',
    '${origUUID}',
    '${targetUUID}',
    ${sub.conversion_ratio},
    ${escapeSQL(sub.category)},
    ${sqlArray(sub.applicable_contexts)},
    ${sqlArray(sub.forbidden_contexts)},
    ${escapeSQL(sub.flavor_impact)},
    ${escapeSQL(sub.texture_impact)},
    ${escapeSQL(sub.instructions_and_tips)}
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;\n\n`;
}

sql += `-- 6. Seed 10 Global Starter Recipes\n`;

for (const r of starterRecipes) {
  const recipeUUID = getUUID('recipe', r.slug);
  const authorUUID = '00000000-0000-0000-0000-000000000001';

  sql += `-- Recipe: ${r.title}\n`;
  sql += `INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '${recipeUUID}',
    '${authorUUID}',
    ${escapeSQL(r.title)},
    ${escapeSQL(r.slug)},
    ${escapeSQL(r.description)},
    ${sqlArray(r.cuisine_tags)},
    ${escapeSQL(r.category)},
    ${escapeSQL(r.difficulty)},
    ${r.prep_time_minutes},
    ${r.cook_time_minutes},
    ${r.servings},
    ${r.calories_per_serving},
    '${JSON.stringify(r.nutritional_facts)}'::jsonb,
    ${escapeSQL(r.hero_image_url)},
    'published',
    4.90,
    12,
    1
)
ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    cuisine_tags = EXCLUDED.cuisine_tags,
    category = EXCLUDED.category,
    difficulty = EXCLUDED.difficulty,
    prep_time_minutes = EXCLUDED.prep_time_minutes,
    cook_time_minutes = EXCLUDED.cook_time_minutes,
    servings = EXCLUDED.servings,
    calories_per_serving = EXCLUDED.calories_per_serving,
    nutritional_facts = EXCLUDED.nutritional_facts,
    hero_image_url = EXCLUDED.hero_image_url,
    status = EXCLUDED.status;\n\n`;

  // Ingredients
  r.ingredients.forEach((ing, idx) => {
    const ingUUID = getUUID('ingredient', ing.canonical);
    const riUUID = getUUID('recipe_ingredient', `${r.slug}:${ing.canonical}`);
    sql += `INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('${riUUID}', '${recipeUUID}', '${ingUUID}', ${ing.amount}, ${escapeSQL(ing.unit)}, ${escapeSQL(ing.display)}, ${ing.optional}, ${ing.tier}, ${idx + 1})
ON CONFLICT (id) DO NOTHING;\n`;
  });
  sql += `\n`;

  // Equipment Requirements
  for (const eqSlug of r.equipment) {
    const eqUUID = getUUID('equipment', eqSlug);
    sql += `INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('${recipeUUID}', '${eqUUID}', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;\n`;
  }
  sql += `\n`;

  // Steps
  r.steps.forEach((step) => {
    const stepUUID = getUUID('recipe_step', `${r.slug}:${step.step_number}`);
    sql += `INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('${stepUUID}', '${recipeUUID}', ${step.step_number}, ${escapeSQL(step.title)}, ${escapeSQL(step.instruction)}, ${step.timer_duration_seconds}, ${escapeSQL(step.timer_label)}, ${step.is_critical})
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;\n`;

    // Step Techniques
    for (const techSlug of step.techniques) {
      const techUUID = getUUID('technique', techSlug);
      sql += `INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('${stepUUID}', '${techUUID}')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;\n`;
    }
  });
  sql += `\n`;
}

// Write to seed.sql
const seedFilePath = path.join(__dirname, '..', 'supabase', 'seed.sql');
fs.writeFileSync(seedFilePath, sql, 'utf8');
console.log(`Successfully generated seed.sql at ${seedFilePath} (${Buffer.byteLength(sql)} bytes)`);
