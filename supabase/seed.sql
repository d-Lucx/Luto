-- ==============================================================================
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
INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'ff012fa6-d603-4a5f-af4d-2adeae806728',
    'chef_knife',
    'Chef''s Knife (8-inch / 20cm)',
    'knives_cutlery',
    true,
    'knife-kitchen',
    'The primary workhorse knife for 90% of prep tasks: chopping, slicing, dicing, and mincing.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '2300283f-2f93-48f7-a977-840d706de3e6',
    'paring_knife',
    'Paring Knife (3.5-inch)',
    'knives_cutlery',
    true,
    'knife-small',
    'Short precision blade designed for peeling, trimming, hulling strawberries, and delicate hand-held knife work.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'b55d53ea-50a8-4289-acf4-ff7e08e34876',
    'serrated_knife',
    'Serrated Bread Knife (9-10 inch)',
    'knives_cutlery',
    false,
    'knife-serrated',
    'Toothed blade for slicing crusty artisanal bread, soft tomatoes, and delicate layer cakes without crushing.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'd4dd603f-6781-434c-ae72-98cdb577c351',
    'cutting_board_large',
    'Large Cutting Board (Wood or High-Density Poly)',
    'prep_tools',
    true,
    'cutting-board',
    'Spacious non-slip food preparation surface (minimum 12x18 inches) to ensure safe, stable knife work.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'd82d43fe-4fed-40d1-a2f3-6ed89537e8db',
    'skillet_stainless_steel_12in',
    '12-Inch Stainless Steel Skillet',
    'cookware',
    true,
    'pan-frying',
    'High-heat cooking pan ideal for searing proteins, creating fond, deglazing pan sauces, and sautéing.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'ea15f2e0-e237-4f50-ab06-3a0d45e4312b',
    'skillet_nonstick_10in',
    '10-Inch Nonstick Skillet',
    'cookware',
    true,
    'pan-egg',
    'Slick surface pan for low-to-medium heat cooking of delicate proteins: scrambled eggs, omelets, and flaky fish fillets.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'a94dd436-e16e-4a12-a14b-99a7dad08bbd',
    'cast_iron_skillet_12in',
    '12-Inch Cast Iron Skillet',
    'cookware',
    false,
    'pan-cast-iron',
    'Heavy thermal mass pan capable of retaining massive heat for deep crust searing, cornbread baking, and stovetop-to-oven transitions.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'ec806f30-bd63-4972-a45d-d87bd336198a',
    'enameled_dutch_oven',
    'Enameled Cast Iron Dutch Oven (5.5 - 6 Quart)',
    'cookware',
    false,
    'pot-dutch-oven',
    'Heavy lidded pot providing even radiative heat for low-and-slow braising, stews, deep-frying, and baking sourdough bread.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '6ab52077-7f77-44b0-af68-a25a24e1d79a',
    'saucepan_3qt',
    '3-Quart Saucepan with Lid',
    'cookware',
    true,
    'pot-saucepan',
    'Everyday pot for simmering grains, boiling rice, making caramel, reducing tomato sauces, and reheating soups.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '973d8c98-8ac0-4aae-ae3c-577dd20675d5',
    'stockpot_8qt',
    '8-12 Quart Large Stockpot',
    'cookware',
    true,
    'pot-large',
    'High-capacity deep vessel for boiling pasta in copious salted water, simmering bone broths, and steaming seafood.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'e8789a8a-4be4-48e4-a6ff-6a31045578c6',
    'half_sheet_pan',
    'Half-Sheet Baking Pan (Rimmed 18x13 inch)',
    'bakeware',
    true,
    'sheet-pan',
    'Heavy 18-gauge aluminum sheet pan for roasting high-temperature vegetables, baking cookies, and sheet-pan dinners.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '1b46681c-c159-4a98-add1-c4ff42611468',
    'wire_cooling_rack',
    'Stainless Steel Wire Rack (Oven-Safe)',
    'bakeware',
    false,
    'grid-rack',
    'Elevated grid that fits inside a sheet pan to allow 360-degree hot air circulation under roasts and crisp chicken wings, and cool baked goods.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '92e2a3fb-96f3-4169-a6a8-6e35456d402c',
    'mixing_bowls_nested',
    'Set of 3 Stainless Steel Mixing Bowls',
    'prep_tools',
    true,
    'bowl-mix',
    'Lightweight, non-reactive nested bowls (1.5qt, 3qt, 5qt) for whisking vinaigrettes, holding mise en place, and proofing dough.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '70dd3e26-74c4-4407-a05e-634d93e8e8bd',
    'fine_mesh_sieve_strainer',
    'Fine-Mesh Sieve / Strainer (8-inch)',
    'prep_tools',
    true,
    'strainer-mesh',
    'Multipurpose wire mesh for draining pasta, sifting flour, rinsing quinoa, and straining silky smooth pan sauces.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '99df19a2-15cc-40e0-a96f-8d396554174f',
    'locking_kitchen_tongs_12in',
    'Stainless Steel Locking Tongs (12-inch)',
    'utensils',
    true,
    'tongs',
    'An extension of the cook''s hand: grabbing, turning hot meats, tossing pasta in sauce, and safely retrieving items from boiling water.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'a35555ea-5702-4b2f-aea8-054257de03fb',
    'slotted_fish_spatula',
    'Slotted Flexible Metal Fish Spatula',
    'utensils',
    true,
    'spatula-metal',
    'Thin, razor-flexible beveled metal turner that easily glides under delicate fish fillets, burgers, and fried eggs without sticking.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '0925d059-6fa6-4222-a50f-3ea127a65d39',
    'heatproof_silicone_spatula',
    'Heat-Resistant Silicone Spatula',
    'utensils',
    true,
    'spatula-rubber',
    'Flexible heat-resistant blade (up to 500°F) for folding batters, scraping every drop of sauce from pans, and making creamy custards.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '8641bd16-6364-4325-adab-535f13c9d73d',
    'balloon_whisk_11in',
    '11-Inch Stainless Steel Whisk',
    'utensils',
    true,
    'whisk',
    'Flexible wire loops for incorporating air into egg whites, emulsifying dressings, and creating smooth, lump-free roux and gravies.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '3a6a3f56-9bdc-42df-a437-834b778d18e8',
    'wooden_corner_spoon',
    'Flat-Edge Wooden Spoon / Spatula',
    'utensils',
    true,
    'spoon-wooden',
    'Rigid, non-reactive tool for scraping flavorful browned bits (fond) from the bottom of pans without scratching.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '6f55293a-81f0-4d91-a956-d2150693b96f',
    'digital_kitchen_scale_1g',
    'Digital Kitchen Gram Scale (1g / 0.05oz precision)',
    'measuring',
    true,
    'scale-digital',
    'The golden standard for accurate baking and cooking consistency. Eliminates cup volume packing variations.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'bd0dd796-8311-4291-af53-b01f54652825',
    'digital_instant_read_thermometer',
    'Digital Instant-Read Meat Thermometer (2-3s response)',
    'measuring',
    true,
    'thermometer',
    'Precision probe for guaranteeing perfect food safety and doneness: medium-rare steaks (130°F), poultry (165°F), and bread (200°F).'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'eddc48df-d94e-421f-abeb-f8df97bba54b',
    'measuring_cups_and_spoons_set',
    'Stainless Steel Dry Measuring Cups & Spoons',
    'measuring',
    true,
    'measuring-cups',
    'Standard standard units (1 cup, 1/2, 1/3, 1/4; 1 tbsp, 1 tsp, 1/2 tsp, 1/4 tsp) for quick spice and liquid dosing.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'fe6088ca-11e1-4774-a1fa-5aa5e1aad581',
    'glass_liquid_measuring_cup_2cup',
    '2-Cup Tempered Glass Liquid Measuring Cup',
    'measuring',
    true,
    'cup-liquid',
    'Clear vessel with spout and meniscus viewing lines for pouring broths, milk, water, and warm oils without spilling.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'cbee3705-8178-4558-abb3-15973f06f4a8',
    'microplane_rasp_grater',
    'Microplane Rasp Zester & Fine Grater',
    'prep_tools',
    false,
    'grater-rasp',
    'Photo-etched teeth that effortlessly zest citrus skins without bitter white pith, and pulverize hard garlic and parmesan into snow.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '5959ab1a-6718-43bf-a2f7-3a6e5a273a69',
    'four_sided_box_grater',
    '4-Sided Stainless Steel Box Grater',
    'prep_tools',
    true,
    'grater-box',
    'Coarse shredding for cheddar, mozzarella, potatoes (hash browns), and carrots.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'b92a34d3-1948-40c6-a47c-aa3054b7bafc',
    'y_peeler_swivel',
    'Ergonomic Y-Shaped Vegetable Peeler',
    'prep_tools',
    true,
    'peeler',
    'High-leverage razor carbon steel or ceramic blade for peeling root vegetables, shaving parmesan ribbons, and citrus peels.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '8b8acbb8-03b3-42ae-a8c8-49e83e0c85a1',
    'immersion_stick_blender',
    'Variable Speed Immersion (Stick) Blender',
    'appliances',
    false,
    'blender-stick',
    'Blends hot soups directly in the cooking pot without dangerous transfers, and whips foolproof 30-second mayonnaise.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '5ea8d884-a229-43b0-aacf-b35dd784c085',
    'food_processor_14cup',
    '14-Cup Kitchen Food Processor',
    'appliances',
    false,
    'appliance-processor',
    'Rapid chopping, pulse pureeing, pastry crust cutting, and mass shredding/slicing via motorized discs.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '8dd96afc-457e-41db-a881-aad4d9a5409d',
    'high_speed_countertop_blender',
    'High-Speed Countertop Blender (Vitamix / Ninja)',
    'appliances',
    false,
    'blender-countertop',
    'High-RPM vortex that pulverizes fibers and seeds into completely silky veloutés, smoothie bowls, and nut butters.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '25505567-4426-478e-ad24-2856cca7c51c',
    'granite_mortar_and_pestle',
    'Heavy Granite Mortar and Pestle (6-inch)',
    'prep_tools',
    false,
    'mortar-pestle',
    'Crushes cell walls of garlic, herbs, and spices simultaneously, releasing volatile aromatic oils that spinning metal blades merely slice.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    '77bfa638-47d9-4ff2-a338-889284cba574',
    'sous_vide_immersion_circulator',
    'Sous Vide Precision Immersion Circulator',
    'appliances',
    false,
    'device-circulator',
    'Maintains temperature water baths to within 0.1°C for edge-to-edge perfect protein doneness and gentle infusion.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

INSERT INTO equipment (id, canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
    'dddcb6a2-585f-47eb-aea5-4325326306e5',
    'heavy_duty_kitchen_shears',
    'Heavy-Duty Take-Apart Kitchen Shears',
    'prep_tools',
    true,
    'shears',
    'Snipping fresh herbs, cutting twine, opening food packaging, and spatchcocking whole poultry backbones cleanly.'
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_essential = EXCLUDED.is_essential,
    icon_name = EXCLUDED.icon_name,
    description = EXCLUDED.description;

-- 3. Seed Master Cooking Techniques Catalog (20 items)
INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'afb387f9-2856-414d-aaea-59fcf429ec03',
    'searing_protein',
    'Pan Searing Protein',
    'dry_heat',
    'beginner',
    'Cooking protein at high temperature in a hot pan to trigger the Maillard reaction, developing a deeply flavorful, caramelized brown crust.',
    'https://storage.luto.app/techniques/searing_protein/micro_1080p.mp4',
    'https://storage.luto.app/techniques/searing_protein/preview.gif',
    '{"Thoroughly pat the protein completely dry with paper towels; surface moisture causes steaming rather than browning.","Ensure the pan and oil are shimmering hot before the protein touches the metal.","Do not move or poke the meat for the first 3-5 minutes; it will naturally release from the pan once the crust forms."}'::text[],
    '{"Crowding the pan, which drops thermal temperature and traps steam.","Flipping prematurely when meat is still adhering to the pan.","Using low-smoke-point fats (like extra virgin olive oil or unclarified butter) at scorching heat."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '3ee5ed40-3713-47e4-a90a-9f4cc4b53369',
    'deglazing_pan',
    'Deglazing a Pan',
    'sauces_emulsions',
    'beginner',
    'Pouring a cool liquid (wine, broth, vinegar, or water) into a hot pan after searing to dissolve and incorporate the caramelized browned food particles (fond) stuck to the bottom.',
    'https://storage.luto.app/techniques/deglazing_pan/micro_1080p.mp4',
    'https://storage.luto.app/techniques/deglazing_pan/preview.gif',
    '{"Pour liquid in immediately after removing meat while pan retains thermal heat.","Use a flat-edged wooden spoon to aggressively scrape the bottom until smooth.","Reduce liquid by at least 50% to concentrate sweetness and cook off harsh alcohol fumes."}'::text[],
    '{"Deglazing a pan with burnt (blackened) fond, which infuses an acrid, bitter taste into the sauce.","Adding liquid when the pan has cooled down completely."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'e787bd7b-246c-40be-a962-dd0cc49c58b0',
    'braising',
    'Braising (Low & Slow)',
    'combination',
    'intermediate',
    'A combination cooking method where meat/vegetables are first seared at high heat, then slowly simmered partially submerged in flavorful liquid in a covered vessel at low heat.',
    'https://storage.luto.app/techniques/braising/micro_1080p.mp4',
    'https://storage.luto.app/techniques/braising/preview.gif',
    '{"Liquid should come roughly 1/3 to 1/2 way up the side of the meat, never fully submerged.","Keep the oven temperature low (300°F / 150°C) to gently melt tough collagen into succulent gelatin without drying out muscle fibers.","Keep lid tightly sealed to prevent steam evaporation."}'::text[],
    '{"Boiling too rapidly, which toughens the protein and turns sauce greasy.","Skipping the initial deep browning sear."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'a03d98fd-871f-445b-ad09-bcb9bd536581',
    'julienne_cut',
    'Julienne Cut (Matchstick)',
    'knife_skills',
    'intermediate',
    'Precision knife technique that cuts firm vegetables into uniform matchsticks measuring approximately 1/8 inch x 1/8 inch x 2 inches (3mm x 3mm x 5cm).',
    'https://storage.luto.app/techniques/julienne_cut/micro_1080p.mp4',
    'https://storage.luto.app/techniques/julienne_cut/preview.gif',
    '{"Square off the vegetable first by cutting a thin slice off one side so it rests stable without rolling.","Cut into 1/8-inch thick planks, stack 2-3 planks, and slice lengthwise into 1/8-inch sticks.","Always curl non-knife hand fingertips inward like a claw against the blade face."}'::text[],
    '{"Attempting to cut round vegetables without squaring a flat base first.","Uneven stick thicknesses causing erratic cooking rates in stir-fries."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '1d056120-6204-4c38-a44f-09b3cde14bc7',
    'chiffonade',
    'Chiffonade (Herb Ribbons)',
    'knife_skills',
    'beginner',
    'Slicing flat leafy greens or herbs (such as fresh basil, sage, or mint) into thin, delicate ribbons.',
    'https://storage.luto.app/techniques/chiffonade/micro_1080p.mp4',
    'https://storage.luto.app/techniques/chiffonade/preview.gif',
    '{"Stack 6-8 washed and thoroughly dried leaves from largest to smallest.","Roll the leaf stack tightly like a cigar.","Slice crosswise into thin 1/16-inch ribbons using a smooth single-pass slicing motion."}'::text[],
    '{"Using a dull knife or pressing straight down, which bruises and blackens the cut edges of delicate basil leaves.","Chiffonading wet herbs, resulting in clumps."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '63deea78-9136-46af-abab-835e60f47d1b',
    'emulsification',
    'Emulsification (Sauce Binding)',
    'sauces_emulsions',
    'intermediate',
    'Forcing two naturally unmixable liquids (such as oil and water or vinegar) to combine into a stable, silky uniform suspension using a binding agent like egg yolk, mustard, or honey.',
    'https://storage.luto.app/techniques/emulsification/micro_1080p.mp4',
    'https://storage.luto.app/techniques/emulsification/preview.gif',
    '{"Add the oil very slowly—drop by drop initially—while whisking vigorously until the emulsion takes hold.","Ensure base ingredients (egg yolk, acid) are at room temperature.","If an emulsion breaks (separates into greasy curdles), whisk 1 tsp warm water in a clean bowl and slowly whisk the broken sauce into it."}'::text[],
    '{"Pouring oil too quickly in a steady stream before the initial emulsion matrix forms.","Using ice-cold liquids which inhibit surfactant binding."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '4d9e0976-b216-40f1-a64c-40efe71d0ace',
    'tempering_liquids',
    'Tempering Delicate Ingredients',
    'sauces_emulsions',
    'intermediate',
    'Gently raising the temperature of cold, heat-sensitive ingredients (such as beaten eggs, yogurt, or sour cream) before adding them to hot mixtures to prevent curdling or scrambling.',
    'https://storage.luto.app/techniques/tempering_liquids/micro_1080p.mp4',
    'https://storage.luto.app/techniques/tempering_liquids/preview.gif',
    '{"Slowly ladle a small stream of the hot soup/broth into the eggs/dairy while constantly whisking.","Once the egg/dairy mixture is lukewarm to warm, pour it steadily back into the main pot while stirring.","Keep main pot at low heat; do not boil after incorporating tempered eggs."}'::text[],
    '{"Dumping cold egg yolks or sour cream directly into boiling soup.","Failing to whisk continuously during the tempering pour."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '9715ac7c-2099-442b-a9ad-d5f192389040',
    'blanch_and_shock',
    'Blanching and Shocking',
    'moist_heat',
    'beginner',
    'Boiling vegetables briefly in heavily salted water, then immediately plunging them into an ice water bath to stop the cooking instantly.',
    'https://storage.luto.app/techniques/blanch_and_shock/micro_1080p.mp4',
    'https://storage.luto.app/techniques/blanch_and_shock/preview.gif',
    '{"Use abundant rolling boiling water (at least 4 quarts per pound of vegetables) heavily salted like sea water.","Boil only until crisp-tender (60-90 seconds for green beans, asparagus, or peas).","Keep the ice bath properly iced so it remains near 32°F (0°C)."}'::text[],
    '{"Leaving vegetables in the ice bath too long after they have cooled, which leaches flavor and nutrients.","Inadequate ice volume, which warms up into a lukewarm bath that continues overcooking."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '6274ef5e-f3cd-4e0b-aab6-4e1735deaa00',
    'sweating_aromatics',
    'Sweating Aromatics',
    'moist_heat',
    'beginner',
    'Cooking chopped vegetables (onions, celery, carrots, leeks) in fat over low heat with salt, softening them and releasing their natural moisture without browning.',
    'https://storage.luto.app/techniques/sweating_aromatics/micro_1080p.mp4',
    'https://storage.luto.app/techniques/sweating_aromatics/preview.gif',
    '{"Keep heat strictly on low to medium-low.","Add fine salt immediately to draw out cellular moisture via osmosis.","Cover pan with lid or parchment paper cartouche to trap steam and encourage even softening."}'::text[],
    '{"Allowing heat to climb until vegetables brown, which imparts caramelized notes rather than sweet, translucent base aromatics."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '8e93d068-7d1a-4392-ac11-34644d646b7a',
    'folding_batter',
    'Folding Delicate Batters',
    'baking_pastry',
    'intermediate',
    'A gentle motion used to incorporate a light, airy ingredient (whipped egg whites or whipped cream) into a heavier batter without deflating the trapped air bubbles.',
    'https://storage.luto.app/techniques/folding_batter/micro_1080p.mp4',
    'https://storage.luto.app/techniques/folding_batter/preview.gif',
    '{"Use a flexible rubber spatula with a broad head.","Cut vertically down through the center of the mixture, sweep across the bottom of the bowl, and lift up along the side, rotating the bowl 90 degrees.","Stir in one-third of the light mixture first to lighten the base before gently folding the rest."}'::text[],
    '{"Vigorous circular stirring, which collapses delicate foam bubbles and produces dense, flat cakes.","Under-folding leaving large unmixed streaks of raw egg white."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'f657024d-1e21-408c-ab91-d3c5f0061e1c',
    'resting_meat',
    'Resting Cooked Meat',
    'prep_finishing',
    'beginner',
    'Allowing cooked meat to sit undisturbed on a warm cutting board before slicing, allowing muscle fibers to relax and redistribute moisture throughout.',
    'https://storage.luto.app/techniques/resting_meat/micro_1080p.mp4',
    'https://storage.luto.app/techniques/resting_meat/preview.gif',
    '{"Rest steaks for 5-8 minutes; whole roasted chickens for 15 minutes; large roasts for 20-30 minutes.","Tent loosely with foil—never wrap tightly, which creates condensation and softens crisp skin or sear.","Save all residual cutting board juices and pour back over the sliced meat or whisk into pan gravy."}'::text[],
    '{"Slicing meat straight off the grill or pan, causing high-pressure juices to flood out, leaving meat dry."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '72364287-4610-4b7e-a57a-d5d51049e1dc',
    'monter_au_beurre',
    'Monter au Beurre (Pan Sauce Gloss)',
    'sauces_emulsions',
    'intermediate',
    'Whisking chilled cubes of unsalted butter into a simmering, reduced pan sauce off the heat to create a glossy, velvety consistency and rich mouthfeel.',
    'https://storage.luto.app/techniques/monter_au_beurre/micro_1080p.mp4',
    'https://storage.luto.app/techniques/monter_au_beurre/preview.gif',
    '{"Butter must be straight from the refrigerator (ice cold) and cubed.","Remove the pan from direct heat; residual heat melts butter slowly, maintaining the natural dairy emulsion.","Swirl pan constantly in a circular motion until butter is fully emulsified."}'::text[],
    '{"Boiling the sauce while adding butter, which breaks the emulsion into a pool of yellow clarified oil."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '931bf54b-12f1-4e0d-a2f0-1d9e5816a1b2',
    'poaching',
    'Gentle Poaching',
    'moist_heat',
    'beginner',
    'Submerging delicate foods (eggs, fish, pears) in liquid maintained at a gentle sub-boil (160°F–180°F / 71°C–82°C) with tiny shivers instead of rolling bubbles.',
    'https://storage.luto.app/techniques/poaching/micro_1080p.mp4',
    'https://storage.luto.app/techniques/poaching/preview.gif',
    '{"Water should have faint convection currents and tiny bubbles pinned to the bottom of the pot.","For poached eggs: add 1 tbsp white vinegar, create a gentle vortex in the water, and slip egg from a small ramekin directly into center.","Use aromatic liquid (court-bouillon or seasoned broth) to infuse flavor."}'::text[],
    '{"Allowing liquid to reach a rapid boil, which rips delicate egg whites apart and dries out fish proteins."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'e2f13cff-34af-4586-aef3-d393751d2de4',
    'dry_brining',
    'Dry Brining',
    'prep_finishing',
    'beginner',
    'Salting meat in advance and letting it rest uncovered on a wire rack in the refrigerator for 4 to 24 hours, enhancing juiciness and promoting razor-crisp skin.',
    'https://storage.luto.app/techniques/dry_brining/micro_1080p.mp4',
    'https://storage.luto.app/techniques/dry_brining/preview.gif',
    '{"Use approximately 1/2 tsp kosher salt per pound of meat.","Rest on an elevated wire cooling rack inside a sheet pan to allow air circulation completely around.","Do not cover; the dry refrigerator air dehydrates the skin surface for superior Maillard browning."}'::text[],
    '{"Using fine table salt at the same volume as kosher salt, which severely oversalts the meat.","Rinsing the meat after brining (unnecessary and washes away absorbed seasoning)."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '0d7a0cb9-7c96-48ad-a39b-ca348d5fd1e7',
    'caramelizing_onions',
    'True Onion Caramelization',
    'dry_heat',
    'intermediate',
    'Slowly cooking sliced onions over low-to-medium heat for 40-50 minutes until their natural sugars break down into complex, sweet, deeply golden-brown compounds.',
    'https://storage.luto.app/techniques/caramelizing_onions/micro_1080p.mp4',
    'https://storage.luto.app/techniques/caramelizing_onions/preview.gif',
    '{"Patience is non-negotiable; true caramelization cannot be rushed in 10 minutes without burning.","Add a pinch of salt initially to draw out water.","Splash 1-2 tbsp water, wine, or stock whenever the fond on the bottom gets too dark to redistribute sugars."}'::text[],
    '{"High heat causing onions to char bitter black on tips before interior sugars break down.","Adding baking soda excessively, which makes onions mushy and chemically alkaline."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '4e76b88a-b1c5-4d82-a6bc-608545f27846',
    'blooming_spices',
    'Blooming Spices in Fat',
    'dry_heat',
    'beginner',
    'Frying ground or whole spices in warm oil or ghee for 30–60 seconds, which dissolves and amplifies their fat-soluble aromatic flavor compounds (tadka / tempering).',
    'https://storage.luto.app/techniques/blooming_spices/micro_1080p.mp4',
    'https://storage.luto.app/techniques/blooming_spices/preview.gif',
    '{"Heat fat over medium-low heat; spices burn easily.","Add whole seeds (cumin, mustard, coriander) first until they crackle and pop, then ground spices for 15-20 seconds.","Add wet aromatics (onion, garlic, ginger) or liquids immediately after blooming to arrest spice cooking."}'::text[],
    '{"Dumping ground spices into boiling water/soup directly without fat blooming, resulting in raw, dusty flavor.","Burning delicate ground paprika or turmeric into bitter black residue."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'e79bf1e9-00e7-4dee-a37d-47014344d568',
    'roux_making',
    'Making a Roux',
    'sauces_emulsions',
    'beginner',
    'Cooking equal parts by weight of fat (usually butter) and all-purpose flour to eliminate raw flour taste and create the foundational thickening base for mother sauces.',
    'https://storage.luto.app/techniques/roux_making/micro_1080p.mp4',
    'https://storage.luto.app/techniques/roux_making/preview.gif',
    '{"White roux (2 min) for Béchamel / mac and cheese.","Blond roux (4-5 min) for Velouté / chicken pot pie.","Brown or Dark roux (15-30 min) for Creole and Cajun gumbo.","Whisk liquid in gradually—hot liquid into warm roux, or cold liquid into hot roux—to prevent lumping."}'::text[],
    '{"Adding liquid all at once, creating stubborn flour dumplings.","Under-cooking white roux, resulting in an unpleasant pasty flour flavor."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    'b9b6f55e-fa40-4dee-a54d-3b8534742cb2',
    'supreme_citrus',
    'Supreming Citrus',
    'knife_skills',
    'intermediate',
    'Cutting raw citrus fruit segments cleanly away from the bitter peel, white pith, and fibrous membrane walls.',
    'https://storage.luto.app/techniques/supreme_citrus/micro_1080p.mp4',
    'https://storage.luto.app/techniques/supreme_citrus/preview.gif',
    '{"Slice off both top and bottom ends of orange/grapefruit so it stands flat.","Curve your chef knife or paring knife along the contour of the fruit, cutting away skin and all white pith.","Slice inward on each side of the white dividing membranes to release clean, perfect fruit segments."}'::text[],
    '{"Leaving patches of bitter white pith on fruit edges.","Squeezing fruit with excessive hand pressure while cutting."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '885e5f5f-c8f0-4d70-acad-93f75a04e93e',
    'sous_vide_cooking',
    'Sous Vide & Reverse Sear',
    'combination',
    'advanced',
    'Cooking vacuum-sealed food in a precisely controlled water bath to the exact desired core temperature, followed by a blazing 60-second sear to develop crust.',
    'https://storage.luto.app/techniques/sous_vide_cooking/micro_1080p.mp4',
    'https://storage.luto.app/techniques/sous_vide_cooking/preview.gif',
    '{"Ensure airtight vacuum seal so heat transfers uniformly through water immersion.","Pat exterior bone-dry before the post-bath sear.","Sear on maximum surface heat for no longer than 45-60 seconds per side to avoid cooking beyond the water bath target."}'::text[],
    '{"Searing cold or wet meat from the bag without drying, causing gray band overcooking."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

INSERT INTO techniques_and_skills (id, canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
    '2d2c95ca-0a22-4bdf-adce-61d7ba00e37d',
    'blind_baking',
    'Blind Baking Pastry Crust',
    'baking_pastry',
    'intermediate',
    'Pre-baking an empty tart or pie crust before adding wet or unbaked fillings, preventing the bottom crust from turning into a soggy, undercooked mess.',
    'https://storage.luto.app/techniques/blind_baking/micro_1080p.mp4',
    'https://storage.luto.app/techniques/blind_baking/preview.gif',
    '{"Dock (prick) the pastry bottom gently all over with a fork to release trapped air.","Line with crumpled parchment paper and fill completely to the brim with ceramic pie weights, dried beans, or raw rice.","Bake until edges set (15 min), then remove weights and bake 5-10 min more to crisp the floor."}'::text[],
    '{"Skimping on pie weights, which causes crust walls to slump down into the pan.","Adding weights directly onto raw dough without parchment lining."}'::text[]
)
ON CONFLICT (canonical_slug) DO UPDATE SET
    title = EXCLUDED.title,
    category = EXCLUDED.category,
    difficulty_level = EXCLUDED.difficulty_level,
    summary = EXCLUDED.summary,
    key_tips = EXCLUDED.key_tips,
    common_mistakes = EXCLUDED.common_mistakes;

-- 4. Seed Master Ingredients Dictionary
INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f8691d3a-d323-4207-a5e9-b6ba78289ac0',
    'salt',
    'Fine Sea Salt',
    'spice_seasoning',
    true,
    'g',
    1825,
    '{}'::text[],
    1.2
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'a089e705-1d76-4569-a737-ab042f04688f',
    'black_pepper',
    'Black Peppercorns (Ground)',
    'spice_seasoning',
    true,
    'g',
    730,
    '{}'::text[],
    0.55
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '5ca73e3e-3265-4855-aa9c-a3d23888ace6',
    'water',
    'Filtered Water',
    'liquid',
    true,
    'ml',
    NULL,
    '{}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'daaf8f89-1ae6-4dfe-ae7a-8177c0f3ac28',
    'neutral_oil',
    'Neutral Cooking Oil (Canola/Vegetable)',
    'oil_fat',
    true,
    'ml',
    365,
    '{}'::text[],
    0.92
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '4b83abe8-0bcf-4162-ad3e-cd21339988d8',
    'olive_oil',
    'Extra Virgin Olive Oil',
    'oil_fat',
    true,
    'ml',
    540,
    '{}'::text[],
    0.915
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b7023985-4e7b-4dc0-a4a3-66690513b045',
    'buttermilk',
    'Cultured Buttermilk',
    'dairy',
    false,
    'ml',
    21,
    '{"dairy"}'::text[],
    1.03
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '210f7b69-e709-4a78-aa63-c0af0823012f',
    'whole_milk',
    'Whole Cow Milk',
    'dairy',
    false,
    'ml',
    14,
    '{"dairy"}'::text[],
    1.03
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b7d169ed-1a84-43c1-a92d-ff6dd3b95a3d',
    'sour_cream',
    'Cultured Sour Cream',
    'dairy',
    false,
    'g',
    21,
    '{"dairy"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '87723d44-545f-46e1-ab8e-0973ff0ec481',
    'greek_yogurt',
    'Full-Fat Plain Greek Yogurt',
    'dairy',
    false,
    'g',
    28,
    '{"dairy"}'::text[],
    1.05
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'e7443d22-a850-4531-a110-5029241079da',
    'heavy_cream',
    'Heavy Whipping Cream (36% Fat)',
    'dairy',
    false,
    'ml',
    28,
    '{"dairy"}'::text[],
    0.99
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'a4a14ec2-59be-4641-a60b-7d20017f70dd',
    'coconut_cream',
    'Canned Coconut Cream',
    'canned',
    false,
    'ml',
    730,
    '{"tree_nut"}'::text[],
    0.95
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ec97a179-7b90-4bdb-a3c4-b9fa6e8566dc',
    'unsalted_butter',
    'Unsalted Butter',
    'dairy',
    false,
    'g',
    90,
    '{"dairy"}'::text[],
    0.911
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'd205bfe7-dbb4-461e-a27e-62be6c4f8ced',
    'ricotta_cheese',
    'Whole Milk Ricotta Cheese',
    'dairy',
    false,
    'g',
    14,
    '{"dairy"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '978b7733-84f4-441e-a43e-77edeab1ef52',
    'cottage_cheese',
    'Small-Curd Cottage Cheese',
    'dairy',
    false,
    'g',
    21,
    '{"dairy"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'c2668e4f-445a-46ef-a31f-7de83fa8e1ff',
    'parmesan_cheese',
    'Parmigiano-Reggiano',
    'dairy',
    false,
    'g',
    180,
    '{"dairy"}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ee56aeb1-e854-47f4-ad10-0ee81e9e474a',
    'pecorino_romano',
    'Pecorino Romano Cheese',
    'dairy',
    false,
    'g',
    180,
    '{"dairy"}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '66e8d410-97b4-4aeb-a125-486f4350b060',
    'feta_cheese',
    'Greek Feta Cheese',
    'dairy',
    false,
    'g',
    60,
    '{"dairy"}'::text[],
    0.75
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'bb63ff62-3445-4c9b-abba-f41f56b0e1ff',
    'cornstarch',
    'Cornstarch (Maize Starch)',
    'pantry_dry',
    false,
    'g',
    730,
    '{"corn"}'::text[],
    0.55
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6845cbc8-69ff-4fe3-a06f-f556401caf06',
    'all_purpose_flour',
    'All-Purpose Wheat Flour',
    'pantry_dry',
    false,
    'g',
    365,
    '{"wheat","gluten"}'::text[],
    0.53
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '91a77c38-e4cc-42bc-acf9-d10ec346e9ff',
    'bread_flour',
    'Unbleached Hard Bread Flour',
    'pantry_dry',
    false,
    'g',
    365,
    '{"wheat","gluten"}'::text[],
    0.55
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'd360313e-11cf-4e2e-a9ed-0a51ad01c86a',
    'whole_wheat_flour',
    'Stone Ground Whole Wheat Flour',
    'pantry_dry',
    false,
    'g',
    180,
    '{"wheat","gluten"}'::text[],
    0.52
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '28278ee8-0b94-4cd4-a0c4-70a98e5c21df',
    'self_rising_flour',
    'Self-Rising Flour',
    'pantry_dry',
    false,
    'g',
    180,
    '{"wheat","gluten"}'::text[],
    0.53
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'cab7b378-5dc9-487e-aa32-44a30ac2f0c7',
    'arrowroot_powder',
    'Arrowroot Starch Powder',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    0.55
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f9033a76-2c8f-4652-a9cd-85065e5ab79d',
    'tapioca_starch',
    'Tapioca Starch (Flour)',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    0.55
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '07e57ae5-cabb-4248-ac74-14489cafb756',
    'flaxseed_meal',
    'Ground Golden Flaxseed Meal',
    'pantry_dry',
    false,
    'g',
    180,
    '{}'::text[],
    0.5
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ea6c6657-87c8-475b-a321-9e66c5ed80de',
    'agar_agar_powder',
    'Agar-Agar Powder',
    'pantry_dry',
    false,
    'g',
    1095,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '93c7491b-0c15-41db-aeb6-94ed8e48b18d',
    'animal_gelatin',
    'Unflavored Gelatin Powder',
    'pantry_dry',
    false,
    'g',
    1095,
    '{}'::text[],
    0.68
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '02bb7cf4-e05d-4d6a-ae0d-0ba0aa516ecb',
    'spaghetti',
    'Bronze-Cut Spaghetti Pasta',
    'pantry_dry',
    false,
    'g',
    730,
    '{"wheat","gluten"}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '0203369c-a47d-418f-a23f-1aa501e7074d',
    'red_lentils',
    'Split Red Lentils (Masoor Dal)',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    0.8
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'a7ad5666-ac60-4987-a7f4-bbad7a200730',
    'garlic_cloves',
    'Fresh Garlic Cloves',
    'produce',
    false,
    'clove',
    60,
    '{}'::text[],
    0.65
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b6618ced-d48d-4ac7-aa96-686f147c523c',
    'garlic_powder',
    'Granulated Garlic Powder',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.45
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '7b03d41b-c3d6-4fd4-a284-f83c3b8439b6',
    'shallots',
    'French Shallots',
    'produce',
    false,
    'g',
    45,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf',
    'yellow_onion',
    'Medium Yellow Onion',
    'produce',
    false,
    'piece',
    45,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b54789f0-4bb0-4a14-ad2f-7d4eb6563997',
    'red_onion',
    'Red Onion',
    'produce',
    false,
    'piece',
    45,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '5b38a1f5-87f0-4a82-a66e-173183daf699',
    'scallions',
    'Fresh Scallions (Green Onions)',
    'produce',
    false,
    'g',
    10,
    '{}'::text[],
    0.4
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6a79e34b-6517-4512-a716-9164fc9c7356',
    'fresh_ginger',
    'Fresh Ginger Root',
    'produce',
    false,
    'g',
    30,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f95ece50-0622-410c-afdb-d806b8ec6477',
    'ground_ginger',
    'Ground Dried Ginger',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.45
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '35333a4d-a32a-4e08-aab8-cea17c182656',
    'fresh_cilantro',
    'Fresh Cilantro (Coriander)',
    'produce',
    false,
    'g',
    7,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f488ea49-f21f-4367-ad98-2f45351b47d8',
    'italian_parsley',
    'Flat-Leaf Italian Parsley',
    'produce',
    false,
    'g',
    10,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '36d2d009-a147-4298-ae12-6280a3d389ae',
    'fresh_chives',
    'Fresh Garden Chives',
    'produce',
    false,
    'g',
    7,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '768eacf2-cf50-40b3-ae46-8ad3f09084a6',
    'thai_basil',
    'Fresh Thai Basil Leaves',
    'produce',
    false,
    'g',
    5,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '12f5f9e7-070d-4ca0-a623-0846f0a55f1e',
    'kaffir_lime_leaves',
    'Fresh Kaffir Lime Leaves',
    'produce',
    false,
    'piece',
    14,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'afa5e8b0-c263-4fb3-a4a7-c83ed41b850e',
    'fresh_thyme',
    'Fresh Thyme Sprigs',
    'produce',
    false,
    'g',
    14,
    '{}'::text[],
    0.3
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '0ca1d9b0-78d9-4ccb-a2c5-41631d195286',
    'lemon_juice',
    'Fresh Lemon Juice',
    'liquid',
    false,
    'ml',
    10,
    '{}'::text[],
    1.02
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '954cd431-4a71-4cd3-a533-22b794168a98',
    'lime_juice',
    'Fresh Lime Juice',
    'liquid',
    false,
    'ml',
    10,
    '{}'::text[],
    1.02
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '13362b68-52f5-4eb8-a195-bd1a60994245',
    'broccoli',
    'Fresh Broccoli Crown',
    'produce',
    false,
    'g',
    10,
    '{}'::text[],
    0.37
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '1adaf7ad-8b21-4010-afc6-5e664ee66990',
    'eggplant',
    'Globe Eggplant',
    'produce',
    false,
    'piece',
    7,
    '{}'::text[],
    0.4
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'c5f2a49f-ef60-46a7-abb9-2beacdd3b80d',
    'thai_eggplant',
    'Round Thai Green Eggplant',
    'produce',
    false,
    'g',
    10,
    '{}'::text[],
    0.45
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '727761b5-201a-4df3-a18e-48845e9c1b77',
    'zucchini',
    'Fresh Green Zucchini',
    'produce',
    false,
    'piece',
    10,
    '{}'::text[],
    0.5
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '1528182d-37bc-4990-a6a5-d69828c1c8bf',
    'yellow_squash',
    'Yellow Summer Squash',
    'produce',
    false,
    'piece',
    10,
    '{}'::text[],
    0.5
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '81a63a89-50cd-45a1-a697-2e4fcbca2406',
    'roma_tomatoes',
    'Ripe Roma Plum Tomatoes',
    'produce',
    false,
    'g',
    7,
    '{}'::text[],
    0.65
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '1041f92c-0f99-4828-aca4-f8a711b59d72',
    'red_bell_pepper',
    'Red Bell Pepper',
    'produce',
    false,
    'piece',
    14,
    '{}'::text[],
    0.45
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '44972570-f557-4a90-aea3-551f0d23d16d',
    'jalapeno_pepper',
    'Fresh Jalapeño Chili',
    'produce',
    false,
    'piece',
    14,
    '{}'::text[],
    0.4
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '89cd9e7e-a62d-4947-a1e1-3528eb8039d6',
    'avocado',
    'Ripe Hass Avocado',
    'produce',
    false,
    'piece',
    5,
    '{}'::text[],
    0.7
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ddb9230f-9faf-4667-ad47-dafaa6c92845',
    'cremini_mushrooms',
    'Cremini (Baby Bella) Mushrooms',
    'produce',
    false,
    'g',
    7,
    '{}'::text[],
    0.35
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'a1777cb5-3bad-44c3-a9c6-a4521abfaeb8',
    'king_oyster_mushrooms',
    'King Oyster Mushrooms',
    'produce',
    false,
    'g',
    10,
    '{}'::text[],
    0.4
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '97f89e71-b1f1-45cf-a2bc-479e37e8a672',
    'canned_crushed_tomatoes',
    'Canned Crushed San Marzano Tomatoes',
    'canned',
    false,
    'g',
    730,
    '{}'::text[],
    1.05
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6af748e2-5394-40f0-a2bc-13f971a24d3d',
    'tomato_paste',
    'Double-Concentrated Tomato Paste',
    'canned',
    false,
    'g',
    730,
    '{}'::text[],
    1.15
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '1eb89569-86b3-4e16-aa16-c9e7cf2b9c9a',
    'canned_coconut_milk',
    'Full-Fat Canned Coconut Milk',
    'canned',
    false,
    'ml',
    730,
    '{"tree_nut"}'::text[],
    0.98
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '8325c047-3a4c-4a87-a8ad-2e3d65e668c1',
    'bamboo_shoots',
    'Canned Sliced Bamboo Shoots',
    'canned',
    false,
    'g',
    730,
    '{}'::text[],
    0.6
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '668d147a-cf51-4158-aae7-7cf0a39fc96a',
    'applesauce',
    'Unsweetened Natural Applesauce',
    'canned',
    false,
    'g',
    365,
    '{}'::text[],
    1.05
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc',
    'eggs',
    'Large Grade-A Eggs',
    'protein',
    false,
    'piece',
    35,
    '{"eggs"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '7bd420a8-8679-43a6-a718-2d8c6bf1fff7',
    'guanciale',
    'Cured Italian Guanciale (Pork Jowl)',
    'protein',
    false,
    'g',
    90,
    '{"pork"}'::text[],
    0.95
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '53a8a675-e765-4370-af31-07d597fc07fd',
    'pancetta',
    'Italian Rolled Pancetta / Smoked Bacon',
    'protein',
    false,
    'g',
    60,
    '{"pork"}'::text[],
    0.95
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'fc9ed934-66eb-49a7-ad6c-122dfaf63094',
    'chicken_thighs',
    'Bone-In Skin-On Chicken Thighs',
    'protein',
    false,
    'g',
    4,
    '{"poultry"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'be0345b8-5b39-4dca-ac62-8ae9ca4772b1',
    'chicken_breast',
    'Boneless Skinless Chicken Breast',
    'protein',
    false,
    'g',
    4,
    '{"poultry"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'e0f64dc2-884f-4bb7-a8eb-39c96079a621',
    'flank_steak',
    'USDA Choice Beef Flank Steak',
    'protein',
    false,
    'g',
    5,
    '{"beef"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '8db1ac69-c2da-4c7c-aa7e-656ea5e4fb66',
    'ground_beef',
    'Ground Beef (80/20 Chuck)',
    'protein',
    false,
    'g',
    3,
    '{"beef"}'::text[],
    0.95
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'a9c3d2a7-6ea0-44dc-a066-9359ff786f82',
    'ground_turkey',
    'Lean Ground Turkey (93/7)',
    'protein',
    false,
    'g',
    3,
    '{"poultry"}'::text[],
    0.95
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '8da9df02-65de-4129-a158-b9875b6fdd49',
    'firm_tofu',
    'Extra-Firm Organic Tofu',
    'protein',
    false,
    'g',
    30,
    '{"soy"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '7d45492f-c795-4c69-a86a-6a409181d87c',
    'shrimp',
    'Raw Peeled & Deveined Shrimp (26/30)',
    'protein',
    false,
    'g',
    2,
    '{"crustacean_shellfish"}'::text[],
    1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b8c44047-2be9-4f80-a955-b0dcb7aa4450',
    'soy_sauce',
    'All-Purpose Brewed Soy Sauce (Shoyu)',
    'condiment',
    false,
    'ml',
    730,
    '{"soy","wheat"}'::text[],
    1.15
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '31c483fb-de28-4960-a38a-48142b9b7687',
    'tamari',
    'San-J Gluten-Free Tamari',
    'condiment',
    false,
    'ml',
    730,
    '{"soy"}'::text[],
    1.15
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b2727c6b-2e8c-4b40-a14a-9192099f7678',
    'fish_sauce',
    'Premium Vietnamese / Thai Fish Sauce',
    'condiment',
    false,
    'ml',
    730,
    '{"fish"}'::text[],
    1.2
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '049909ef-0ae7-4cb3-a033-ada24516a7e4',
    'cane_vinegar',
    'Filipino Cane Vinegar (Datu Puti)',
    'condiment',
    false,
    'ml',
    1095,
    '{}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f0b59020-c9ad-4d7e-aa4d-e97f15db9613',
    'apple_cider_vinegar',
    'Raw Unfiltered Apple Cider Vinegar',
    'condiment',
    false,
    'ml',
    1095,
    '{}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '591ba47e-5418-4e2e-aec2-ec569a7b267f',
    'rice_vinegar',
    'Unseasoned Japanese Rice Vinegar',
    'condiment',
    false,
    'ml',
    730,
    '{}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ae651d85-b618-46b2-afa9-fb8ff3409625',
    'white_wine_cooking',
    'Dry Crisp White Wine (Sauvignon Blanc)',
    'liquid',
    false,
    'ml',
    30,
    '{"sulfites"}'::text[],
    0.99
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '42e444aa-addb-429d-a70a-52bec489b8fe',
    'red_wine_cooking',
    'Dry Full-Bodied Red Wine (Cabernet)',
    'liquid',
    false,
    'ml',
    30,
    '{"sulfites"}'::text[],
    0.99
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'f4553f56-85fa-4a92-a970-f7d3af596824',
    'shaoxing_wine',
    'Shaoxing Chinese Cooking Wine',
    'condiment',
    false,
    'ml',
    730,
    '{"wheat"}'::text[],
    1.02
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '72576604-c61c-4903-a253-744880639b0b',
    'toasted_sesame_oil',
    '100% Pure Toasted Sesame Oil',
    'oil_fat',
    false,
    'ml',
    365,
    '{"sesame"}'::text[],
    0.92
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '94e61fcc-d48e-48d1-ab56-be9b4785f67c',
    'green_curry_paste',
    'Authentic Thai Green Curry Paste',
    'condiment',
    false,
    'g',
    365,
    '{"shrimp"}'::text[],
    1.1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'c1b036b5-d3e3-40c5-a452-3d22b6866f59',
    'mayonnaise',
    'Whole-Egg Mayonnaise',
    'condiment',
    false,
    'g',
    90,
    '{"eggs"}'::text[],
    0.94
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '0626c172-756e-4293-a56a-afbe8367e914',
    'honey',
    '100% Pure Raw Wildflower Honey',
    'pantry_dry',
    false,
    'g',
    1825,
    '{}'::text[],
    1.42
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '47bb68fd-8229-4587-aec1-1b862830a30a',
    'maple_syrup',
    'Pure Grade-A Dark Maple Syrup',
    'pantry_dry',
    false,
    'ml',
    730,
    '{}'::text[],
    1.33
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'e9530c19-14d5-482b-a4a6-23d271b4b681',
    'brown_sugar',
    'Dark Brown Cane Sugar',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    0.82
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '2e1bd99f-41d8-4212-adcd-9cfd4b07a1dd',
    'palm_sugar',
    'Thai Palm Sugar Cake',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    0.85
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '3cd5751d-f2e8-4f07-ae27-ee7444e5c9b3',
    'chicken_broth',
    'Low-Sodium Chicken Broth',
    'liquid',
    false,
    'ml',
    365,
    '{"poultry"}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6525ceb6-58b6-4218-a71e-8008ebaf676b',
    'beef_broth',
    'Rich Roasted Beef Bone Broth',
    'liquid',
    false,
    'ml',
    365,
    '{"beef"}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '4d49c59d-e8bf-4e63-a3b5-e561fe1e4f2c',
    'vegetable_broth',
    'Aromatic Mirepoix Vegetable Broth',
    'liquid',
    false,
    'ml',
    365,
    '{}'::text[],
    1.01
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '08d0b1fa-04f7-4847-a0a1-8df9a260409a',
    'ghee',
    'Clarified Butter (Desi Ghee)',
    'oil_fat',
    false,
    'g',
    365,
    '{"dairy"}'::text[],
    0.905
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '5e408eb5-8901-4a6b-aad4-534aa3ed31b4',
    'ground_cumin',
    'Ground Roasted Cumin Seed',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.4
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'ee3e066e-454a-437d-a788-b17223256d5e',
    'smoked_paprika',
    'Spanish Smoked Pimentón (Paprika)',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.46
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '8d2cc387-cd3a-42c0-a1f9-b2914cf055f2',
    'ground_turmeric',
    'Ground Turmeric Root Powder',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.5
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '4e8c41cb-41a8-445f-af30-3d4826e344d2',
    'garam_masala',
    'Traditional Punjabi Garam Masala Blend',
    'spice_seasoning',
    false,
    'g',
    540,
    '{}'::text[],
    0.42
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '8bdb2847-8530-4866-a473-6b955210159e',
    'dried_oregano',
    'Dried Greek Oregano Leaves',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.25
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'b9add8a4-7929-4faa-a1e8-6f6bfbd8b733',
    'bay_leaves',
    'Whole Dried Turkish Bay Leaves',
    'spice_seasoning',
    false,
    'piece',
    730,
    '{}'::text[],
    0.15
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '04b84863-0c73-4b53-a00d-db5a7a4e58d2',
    'white_pepper',
    'Finely Ground White Peppercorns',
    'spice_seasoning',
    false,
    'g',
    730,
    '{}'::text[],
    0.58
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '88232f1a-cd2b-4e63-a929-9564c89b52a0',
    'baking_powder',
    'Double-Acting Aluminum-Free Baking Powder',
    'pantry_dry',
    false,
    'g',
    365,
    '{"corn"}'::text[],
    0.9
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6a2176ad-2e11-43d6-a567-2c0efa0d7157',
    'baking_soda',
    'Pure Sodium Bicarbonate (Baking Soda)',
    'pantry_dry',
    false,
    'g',
    730,
    '{}'::text[],
    1.1
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    'edf3b274-9f67-488c-a4b9-04e36e42557f',
    'active_dry_yeast',
    'Active Dry Baker’s Yeast',
    'pantry_dry',
    false,
    'g',
    365,
    '{"yeast"}'::text[],
    0.7
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '6194f6da-cc52-4a88-a95b-be742e2da1c1',
    'instant_yeast',
    'Rapid Rise Instant Baker’s Yeast',
    'pantry_dry',
    false,
    'g',
    365,
    '{"yeast"}'::text[],
    0.7
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

INSERT INTO ingredients (id, canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
    '53972238-cf03-43bb-aaf2-2e800097180e',
    'sourdough_starter',
    '100% Hydration Active Sourdough Starter',
    'bakery',
    false,
    'g',
    7,
    '{"wheat","gluten","yeast"}'::text[],
    1.05
)
ON CONFLICT (canonical_name) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    category = EXCLUDED.category,
    is_staple = EXCLUDED.is_staple,
    default_unit = EXCLUDED.default_unit,
    average_shelf_life_days = EXCLUDED.average_shelf_life_days,
    allergen_tags = EXCLUDED.allergen_tags,
    density_g_per_ml = EXCLUDED.density_g_per_ml;

-- 5. Seed Dynamic Ingredient Substitutions Matrix (35 items)
INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'af12778c-7b6d-450d-a26a-2d7f98b803f2',
    'b7023985-4e7b-4dc0-a4a3-66690513b045',
    '210f7b69-e709-4a78-aa63-c0af0823012f',
    1,
    'dairy',
    '{"baking","pancake_batter","marinades","fried_chicken_brine"}'::text[],
    '{"uncooked_cold_sauces_requiring_authentic_buttermilk_thickness"}'::text[],
    'Nearly identical acidity; slightly less buttery complexity.',
    'Slightly less viscous than cultured buttermilk.',
    'For 1 cup (240ml) buttermilk: Add 1 tbsp (15ml) lemon juice or white vinegar to a measuring cup, fill with milk to 1 cup mark. Stir and rest 5-10 minutes until slightly curdled.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '3222a658-633d-467b-a0fb-ff5648167418',
    'b7d169ed-1a84-43c1-a92d-ff6dd3b95a3d',
    '87723d44-545f-46e1-ab8e-0973ff0ec481',
    1,
    'dairy',
    '{"baking","cold_dips","dressings","taco_topping"}'::text[],
    '{"high_heat_boiling_soups_without_starch_stabilizer"}'::text[],
    'Slightly more tart and tangy with less rich buttery dairy sweetness.',
    'Identical creamy density; slightly less glossy.',
    'Use 1:1. For hot soups or sauces, temper with a few spoonfuls of hot broth before adding to prevent curdling, or whisk in 1/2 tsp cornstarch.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '4a3fb728-b636-4584-ab5e-216b88117d10',
    'e7443d22-a850-4531-a110-5029241079da',
    '210f7b69-e709-4a78-aa63-c0af0823012f',
    1,
    'dairy',
    '{"pan_sauces","soups","casseroles","baking"}'::text[],
    '{"whipped_cream_making"}'::text[],
    'Rich dairy flavor remains balanced and savory.',
    'Mimics fat content accurately (~36% fat), but lacks the emulsifiers to whip into stiff peaks.',
    'For 1 cup heavy cream: Melt 1/4 cup (57g) unsalted butter and slowly whisk into 3/4 cup (180ml) room temperature whole milk.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '11a6d041-5cd1-4c50-a988-a1d358ba2d19',
    'e7443d22-a850-4531-a110-5029241079da',
    'a4a14ec2-59be-4641-a60b-7d20017f70dd',
    1,
    'dairy',
    '{"curries","soups","vegan_desserts","stews","vegan_whipped_cream"}'::text[],
    '{"traditional_french_pan_sauces_requiring_neutral_dairy"}'::text[],
    'Distinct, pleasant coconut aroma and subtle sweetness.',
    'Equally luscious, rich, and high in saturated fat.',
    'Chill can overnight and scoop the solid top layer for best whipping or sauce thickening results.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '81ff6c59-21b7-41e1-a49e-67553472845c',
    'ec97a179-7b90-4bdb-a3c4-b9fa6e8566dc',
    '4b83abe8-0bcf-4162-ad3e-cd21339988d8',
    0.75,
    'dairy',
    '{"sautéing","roasting_vegetables","savory_baking_focaccia","pasta_finishing"}'::text[],
    '{"laminated_pastries_croissants","creaming_method_cakes"}'::text[],
    'Fruity, peppery olive notes replacing milky, sweet butter notes.',
    'High moisture retention in savory baked goods; crisper vegetable roasts.',
    'Use 3/4 cup oil for every 1 cup butter because oil is 100% fat while butter is 80-82% fat and 16-18% water.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '793c3db8-0d9a-4035-aebf-4f7282997715',
    'd205bfe7-dbb4-461e-a27e-62be6c4f8ced',
    '978b7733-84f4-441e-a43e-77edeab1ef52',
    1,
    'dairy',
    '{"lasagna","stuffed_shells","cheesecakes","pasta_fillings"}'::text[],
    '{"cannoli_filling_delicate"}'::text[],
    'Slightly saltier with subtle tanginess.',
    'Smooth and velvety once blended; drains similarly.',
    'Pulse in a food processor or blender for 30 seconds until completely smooth. Strain through a fine-mesh sieve if very wet.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'b58f073f-5161-432f-a061-b9488110358f',
    'c2668e4f-445a-46ef-a31f-7de83fa8e1ff',
    'ee56aeb1-e854-47f4-ad10-0ee81e9e474a',
    0.85,
    'dairy',
    '{"pasta","risotto","salads","gratins","pesto"}'::text[],
    '{}'::text[],
    'Noticeably saltier and sharper; sheep milk tang compared to cow milk nuttiness.',
    'Equal hard, dry grating characteristics and melting behavior.',
    'Reduce added salt in the overall recipe by ~25% to account for Pecorino''s natural salinity.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '4525d60e-3fb9-49c9-adda-e42997fc5e8c',
    'bb63ff62-3445-4c9b-abba-f41f56b0e1ff',
    '6845cbc8-69ff-4fe3-a06f-f556401caf06',
    2,
    'thickeners',
    '{"gravies","stews","soups","casseroles"}'::text[],
    '{"glossy_fruit_pie_fillings_clear","asian_stir_fry_glazes"}'::text[],
    'Needs 2-3 minutes of boiling to eliminate raw wheat flour taste.',
    'Opaque and slightly cloudier rather than glossy and transparent.',
    'Use 2 tbsp all-purpose flour for every 1 tbsp cornstarch. Cook in liquid at a simmer for at least 3 minutes.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'e3290fd2-8c07-4042-a178-6e278968c7c4',
    'bb63ff62-3445-4c9b-abba-f41f56b0e1ff',
    'cab7b378-5dc9-487e-aa32-44a30ac2f0c7',
    1,
    'thickeners',
    '{"acidic_fruit_sauces","clear_glazes","stir_fries","jellies"}'::text[],
    '{"dairy_based_sauces_causes_slimy_texture","extended_high_heat_braises"}'::text[],
    'Completely neutral and odorless.',
    'Produces brilliant shine and clarity; holds up better in high-acid mixtures (citrus/vinegar).',
    'Whisk with equal parts cold water into a slurry. Add near the end of cooking as extended boiling breaks down arrowroot''s thickening power.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'b6e69d01-5c1f-48a1-af9f-636fac8d30bd',
    'bb63ff62-3445-4c9b-abba-f41f56b0e1ff',
    'f9033a76-2c8f-4652-a9cd-85065e5ab79d',
    2,
    'thickeners',
    '{"pie_fillings","fruit_compotes","gluten_free_baking"}'::text[],
    '{"high_shear_blending"}'::text[],
    'Neutral; does not mask subtle berry or fruit flavors.',
    'Glossy, slightly chewy/gelatinous; freezes and thaws exceptionally well without weeping.',
    'Use 2 tbsp tapioca starch for every 1 tbsp cornstarch.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '0c90b537-cc54-4c86-ae79-47c7071f6f6f',
    'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc',
    '07e57ae5-cabb-4248-ac74-14489cafb756',
    1,
    'thickeners',
    '{"muffins","quick_breads","veggie_burgers","pancakes","cookies"}'::text[],
    '{"soufflés","meringues","custards","angel_food_cake"}'::text[],
    'Subtle, nutty earthy undertone.',
    'Provides great moisture and binding; does not provide structural aeration or rise.',
    'For 1 large egg: Mix 1 tbsp (7g) finely ground flaxseed with 3 tbsp (45ml) warm water. Whisk and rest for 10 minutes until gelatinous.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'f8893767-3b0c-4e81-a019-4468753e6805',
    '93c7491b-0c15-41db-aeb6-94ed8e48b18d',
    'ea6c6657-87c8-475b-a321-9e66c5ed80de',
    0.5,
    'thickeners',
    '{"panna_cotta","jellies","glazes","vegan_desserts"}'::text[],
    '{"marshmallows_traditional_chewy_stretch"}'::text[],
    'Completely flavorless.',
    'Sets firmer and more brittle; melts at 85°C (185°F) rather than body temperature.',
    'Use 1/2 tsp agar powder per 1 tsp powdered gelatin. Must be brought to a rolling boil for 1-2 minutes to activate.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'cb0d31f3-53d9-4f6a-aa70-e6a071a633e3',
    'a7ad5666-ac60-4987-a7f4-bbad7a200730',
    'b6618ced-d48d-4ac7-aa96-686f147c523c',
    0.125,
    'aromatics',
    '{"dry_rubs","marinades","soups","stews","sauces"}'::text[],
    '{"aglio_e_olio","fresh_bruschetta","raw_caesar_dressing"}'::text[],
    'Sweeter, more concentrated, less pungent bite than raw allicin.',
    'Completely dissolves into liquids; no texture.',
    'Use 1/8 teaspoon garlic powder per 1 medium fresh garlic clove. Do not use garlic salt.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '27486a89-7dfa-457e-a4c1-14f661122dec',
    '7b03d41b-c3d6-4fd4-a284-f83c3b8439b6',
    'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf',
    1,
    'aromatics',
    '{"vinaigrettes","pan_sauces","braises","stir_fries"}'::text[],
    '{"fried_crispy_shallots_traditional_asian"}'::text[],
    'Recreates the delicate, sweet allium balance of onion with a subtle garlic edge.',
    'Finely mince onion to mimic the delicate cell structure of shallot.',
    'Combine 7 parts finely minced yellow or red onion with 1 part grated garlic.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'a968cb8b-0b1d-4c85-ae23-26f97282bc0d',
    'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf',
    '5b38a1f5-87f0-4a82-a66e-173183daf699',
    1,
    'aromatics',
    '{"stir_fries","fried_rice","frittatas","quick_sautés"}'::text[],
    '{"french_onion_soup_deep_caramelization"}'::text[],
    'Fresher, more vegetal, faster cooking.',
    'Tender and less fibrous; cooks in 60 seconds vs 8 minutes.',
    'Use 6-8 scallions (chopped whites and pale greens) to equal 1 medium chopped onion.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '7ed81d5a-79d6-4d66-abc4-ec1a8c3c9c43',
    '6a79e34b-6517-4512-a716-9164fc9c7356',
    'f95ece50-0622-410c-afdb-d806b8ec6477',
    0.25,
    'aromatics',
    '{"marinades","curry_bases","spice_cakes","cookies"}'::text[],
    '{"ginger_scallion_sauce","fresh_tea_infusion","stir_fry_aromatic_blooming"}'::text[],
    'Pungent and warming, but lacks the bright citrusy zing of fresh rhizome.',
    'Dry powder; no fibrous crunch.',
    'Use 1/4 tsp ground dried ginger per 1 tbsp fresh grated ginger.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'de8dc706-91c0-4ade-a9ef-ca4a0782ae1a',
    '35333a4d-a32a-4e08-aab8-cea17c182656',
    'f488ea49-f21f-4367-ad98-2f45351b47d8',
    1,
    'aromatics',
    '{"salsa","guacamole","curry_garnish","marinades"}'::text[],
    '{}'::text[],
    'Clean herbal notes without the aldehyde soapy perception disliked by genetic non-tasters.',
    'Identical leafy texture and visual presentation.',
    'Finely chop fresh flat-leaf parsley and toss with a touch of finely grated lime zest to provide bright citrus aromatics.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'd69d3ec1-a4ca-4e9c-a5f8-785e5ee44023',
    '0ca1d9b0-78d9-4ccb-a2c5-41631d195286',
    '954cd431-4a71-4cd3-a533-22b794168a98',
    1,
    'acids',
    '{"cocktails","vinaigrettes","marinades","fish_seasoning","baking"}'::text[],
    '{"traditional_lemon_curd_where_specific_terpene_profile_is_key"}'::text[],
    'Slightly more floral and herbaceous; equivalent ~5% citric acid concentration.',
    'Identical liquid behavior.',
    'Direct 1:1 replacement in almost every savory and baking application.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '901a7c2a-e245-4fd3-a357-a6f6d82aaee8',
    'ae651d85-b618-46b2-afa9-fb8ff3409625',
    '3cd5751d-f2e8-4f07-ae27-ee7444e5c9b3',
    1,
    'acids',
    '{"risotto","pan_deglazing","chicken_piccata","mussels","french_sauces"}'::text[],
    '{"wine_based_desserts_poached_pears"}'::text[],
    'Savory depth with clean acidity, without any residual alcohol.',
    'Identical liquid reduction behavior.',
    'For 1/2 cup (120ml) white wine: Use 1/2 cup low-sodium broth mixed with 1 tsp (5ml) white wine vinegar or apple cider vinegar.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '887ef5f7-146b-4e71-a999-fd432a2c328e',
    '42e444aa-addb-429d-a70a-52bec489b8fe',
    '6525ceb6-58b6-4218-a71e-8008ebaf676b',
    1,
    'acids',
    '{"beef_bourguignon","short_rib_braise","bolognese","pan_gravy"}'::text[],
    '{}'::text[],
    'Rich, savory umami with pleasant tartness.',
    'Reduces to a rich glossy glaze.',
    'For 1 cup red wine: Use 7/8 cup beef stock mixed with 2 tbsp red wine vinegar.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '50abbb68-688b-4e94-a272-548f164cf222',
    '591ba47e-5418-4e2e-aec2-ec569a7b267f',
    'f0b59020-c9ad-4d7e-aa4d-e97f15db9613',
    1,
    'acids',
    '{"asian_dressings","sushi_rice","dipping_sauces","pickling"}'::text[],
    '{}'::text[],
    'Fruity apple notes are tempered by the pinch of sugar to match mild rice vinegar.',
    'Identical acidity level (~4-5% acetic acid).',
    'For 1 tbsp rice vinegar: Use 1 tbsp apple cider vinegar plus 1/8 tsp sugar.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '828d92b3-ac22-4e5c-a98a-7563ef08437e',
    '8db1ac69-c2da-4c7c-aa7e-656ea5e4fb66',
    'a9c3d2a7-6ea0-44dc-a066-9359ff786f82',
    1,
    'proteins',
    '{"tacos","bolognese","chili","meatballs"}'::text[],
    '{"rare_smash_burgers_relying_on_beef_fat_crust"}'::text[],
    'Milder, lighter poultry flavor; absorbs spices and seasonings aggressively.',
    'Leaner; adding 1 tbsp healthy fat prevents dry, chalky mouthfeel.',
    'Add 1 tbsp oil, Worcestershire sauce, or 1 tsp soy sauce to amplify savory umami depth.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '2629f247-0ce8-4846-a691-88ec0630d4b3',
    'be0345b8-5b39-4dca-ac62-8ae9ca4772b1',
    '8da9df02-65de-4129-a158-b9875b6fdd49',
    1,
    'proteins',
    '{"stir_fries","curries","salads","sheet_pan_roasts"}'::text[],
    '{"chicken_noodle_soup_broth_making"}'::text[],
    'Neutral sponge that adopts the surrounding sauce profile completely.',
    'Pleasantly chewy when pressed of excess water and tossed in cornstarch before searing.',
    'Press with a heavy skillet for 15 minutes, cube, toss in 1 tbsp cornstarch, and pan-sear in hot oil until golden.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'adb32823-2509-4cff-a4d2-ed0b2ae92442',
    '53a8a675-e765-4370-af31-07d597fc07fd',
    'ddb9230f-9faf-4667-ad47-dafaa6c92845',
    1,
    'proteins',
    '{"pasta_carbonara_vegetarian","lentil_soup","risotto","braises"}'::text[],
    '{"strips_of_breakfast_bacon"}'::text[],
    'Deep earthy umami and woodsmoke aroma without pork.',
    'Tender, meaty chew.',
    'Dice mushrooms finely and brown deeply in olive oil with 1/2 tsp smoked paprika, 1/4 tsp salt, and a dash of tamari.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'b3ca7541-cdc4-4d36-af88-36eb1decd4a2',
    'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc',
    '668d147a-cf51-4158-aae7-7cf0a39fc96a',
    0.25,
    'proteins',
    '{"brownies","muffins","quick_breads","soft_cookies"}'::text[],
    '{"meringue","custards","soufflés","crispy_cookies"}'::text[],
    'Very subtle fruity sweetness; reduces need for added sugar slightly.',
    'Produces extremely tender, dense, moist crumb; does not aerate.',
    'Use 1/4 cup (60g) unsweetened applesauce per 1 large egg. Add 1/4 tsp extra baking powder if rise is needed.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '06ffb7df-02ae-447a-af0d-a2e6984488a7',
    '7d45492f-c795-4c69-a86a-6a409181d87c',
    'a1777cb5-3bad-44c3-a9c6-a4521abfaeb8',
    1,
    'proteins',
    '{"garlic_butter_scampi","pad_thai","stir_fries","seafood_paella"}'::text[],
    '{"raw_ceviche"}'::text[],
    'Earthy, sweet, and absorbs garlic and white wine butter magnificently.',
    'Remarkably resilient, springy, and scallop/shrimp-like texture.',
    'Slice stems into 1/2-inch thick coins. Score crosshatch pattern on both sides and sear in butter over medium-high heat.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '290d68e3-1022-4bcf-ad7b-9ffda2f37a1a',
    '88232f1a-cd2b-4e63-a929-9564c89b52a0',
    '6a2176ad-2e11-43d6-a567-2c0efa0d7157',
    0.75,
    'leaveners',
    '{"cakes","cookies","pancakes","biscuits","muffins"}'::text[],
    '{}'::text[],
    'Clean, neutral rise; no metallic aftertaste.',
    'Provides identical carbon dioxide release upon hydration and heating.',
    'For 1 tsp baking powder: Mix 1/4 tsp baking soda with 1/2 tsp cream of tartar. Use immediately after mixing wet ingredients.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'd41d6dd8-72c8-413d-a8c2-37ef8da59d44',
    '6a2176ad-2e11-43d6-a567-2c0efa0d7157',
    '88232f1a-cd2b-4e63-a929-9564c89b52a0',
    4,
    'leaveners',
    '{"quick_breads","cookies","pancakes"}'::text[],
    '{"recipes_needing_soda_to_neutralize_strong_acids_like_molasses"}'::text[],
    'Slightly less browning (Maillard reaction is slower without alkaline baking soda).',
    'Provides equivalent lift, but crumb may be slightly lighter in color.',
    'Use 3 to 4 times the amount of baking powder when replacing baking soda. Omit or reduce acidic ingredients if they were only present to activate the soda.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'd5d93c41-1284-4d12-a75e-788a3d5773f7',
    'edf3b274-9f67-488c-a4b9-04e36e42557f',
    '6194f6da-cc52-4a88-a95b-be742e2da1c1',
    0.75,
    'leaveners',
    '{"bread_dough","pizza_crust","cinnamon_rolls","focaccia"}'::text[],
    '{}'::text[],
    'Identical yeast fermentation profile.',
    'Fermentation begins faster; dough rises approximately 15-20% quicker.',
    'Use 3/4 the amount of instant yeast. No need to bloom in warm water; mix directly into dry flour.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '1d7f683a-03d0-48ac-a20f-9f2910c5c585',
    '28278ee8-0b94-4cd4-a0c4-70a98e5c21df',
    '6845cbc8-69ff-4fe3-a06f-f556401caf06',
    1,
    'leaveners',
    '{"biscuits","pancakes","scones","quick_breads"}'::text[],
    '{"yeast_breads"}'::text[],
    'Identical.',
    'Identical crumb structure and lift.',
    'Whisk together thoroughly or sift twice to ensure uniform dispersion of leavener and salt throughout the flour.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '1e1edeaf-5a51-482a-a1ec-54f988330290',
    '6af748e2-5394-40f0-a2bc-13f971a24d3d',
    '97f89e71-b1f1-45cf-a2bc-479e37e8a672',
    3,
    'aromatics',
    '{"stews","pasta_sauces","soups","chili"}'::text[],
    '{"dry_rubs","pizza_sauce_thickening_without_extra_cooking_time"}'::text[],
    'Bright, fresh tomato flavor; slightly less caramelized than double-concentrated paste.',
    'Higher water content; must be cooked down.',
    'Simmer 6 tbsp (90ml) crushed or pureed canned tomatoes in a small pan for 5 minutes until reduced to 2 tbsp paste consistency.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '468948ec-9ec1-49cf-a889-67d844ab2b2b',
    '0626c172-756e-4293-a56a-afbe8367e914',
    '47bb68fd-8229-4587-aec1-1b862830a30a',
    1,
    'sweeteners',
    '{"vinaigrettes","marinades","glazes","baking","tea"}'::text[],
    '{"recipes_requiring_honey_specific_crystallization"}'::text[],
    'Woody, caramel maple notes replacing floral honey notes. 100% vegan friendly.',
    'Slightly thinner viscosity at room temperature.',
    'Direct 1:1 replacement by volume.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '95a018eb-e0fa-44ae-a164-434c9147eb79',
    'b8c44047-2be9-4f80-a955-b0dcb7aa4450',
    '31c483fb-de28-4960-a38a-48142b9b7687',
    1,
    'condiments',
    '{"all_asian_dishes","marinades","dipping_sauces","soups"}'::text[],
    '{}'::text[],
    'Rich, deeper, less harsh salinity; smoother umami profile.',
    'Slightly thicker body.',
    'Direct 1:1 replacement. Provides identical dark color and rich savory backbone while making dishes 100% wheat/gluten-free.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    '66a5cbe4-2ad5-474a-a99c-5afbcd5b130c',
    'b2727c6b-2e8c-4b40-a14a-9192099f7678',
    'b8c44047-2be9-4f80-a955-b0dcb7aa4450',
    1,
    'condiments',
    '{"curries","pad_thai","pho_broth","asian_dressings"}'::text[],
    '{"raw_papaya_salad_traditional_authenticity"}'::text[],
    'Provides savory glutamate umami and oceanic salinity without fish/anchovy byproduct.',
    'Identical liquid seasoning behavior.',
    'Whisk 1 tbsp dark soy sauce with 1/4 tsp lime juice and a pinch of powdered dried nori or mushroom powder.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

INSERT INTO ingredient_substitutions (id, original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note)
VALUES (
    'b46b72d5-19a6-4f29-ad92-b819e48506ee',
    'c1b036b5-d3e3-40c5-a452-3d22b6866f59',
    '89cd9e7e-a62d-4947-a1e1-3528eb8039d6',
    1,
    'dairy',
    '{"sandwich_spread","tuna_salad","egg_salad","wraps"}'::text[],
    '{"emulsified_aioli","tartar_sauce_shelf_life"}'::text[],
    'Fresh, nutty, rich healthy monounsaturated fat flavor profile.',
    'Smooth, rich, spreadable creaminess.',
    'Mash avocado until completely velvety with a squeeze of fresh lemon to prevent oxidation and provide mayo''s requisite acidity.'
)
ON CONFLICT (id) DO UPDATE SET
    conversion_ratio = EXCLUDED.conversion_ratio,
    category = EXCLUDED.category,
    applicable_contexts = EXCLUDED.applicable_contexts,
    forbidden_contexts = EXCLUDED.forbidden_contexts,
    flavor_impact = EXCLUDED.flavor_impact,
    texture_impact = EXCLUDED.texture_impact,
    preparation_note = EXCLUDED.preparation_note;

-- 6. Seed 10 Global Starter Recipes
-- Recipe: Classic Roman Pasta Carbonara
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8',
    '00000000-0000-0000-0000-000000000001',
    'Classic Roman Pasta Carbonara',
    'classic-roman-pasta-carbonara',
    'The definitive Roman classic made with crispy guanciale, creamy emulsified egg yolks, sharp Pecorino Romano, and an abundance of freshly cracked black pepper. No cream, no peas.',
    '{"Italian","Roman","Pasta"}'::text[],
    'Pasta',
    'medium',
    10,
    15,
    4,
    640,
    '{"protein_g":28,"carbs_g":72,"fat_g":26,"fiber_g":3,"sodium_mg":820}'::jsonb,
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('81694210-6cb3-4af4-a865-2e0aa7d73ee2', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '02bb7cf4-e05d-4d6a-ae0d-0ba0aa516ecb', 400, 'g', '400g bronze-cut spaghetti', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('9ecb83cf-e1ec-4067-a848-6dc4e3f17847', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '7bd420a8-8679-43a6-a718-2d8c6bf1fff7', 180, 'g', '180g guanciale (or pancetta), diced 1/4-inch thick', false, 1, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('32341ae7-a846-4162-aa4a-b891bc41a53e', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc', 4, 'piece', '4 large egg yolks + 1 whole egg', false, 1, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('0b1af4ee-56e6-479b-af3b-a68ef521d98d', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 'ee56aeb1-e854-47f4-ad10-0ee81e9e474a', 80, 'g', '80g finely grated Pecorino Romano cheese', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('868bd033-fa36-415c-a4e9-aa0040097a3e', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 'a089e705-1d76-4569-a737-ab042f04688f', 5, 'g', '2 tsp coarsely cracked black tellicherry peppercorns', false, 0, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('9d8eb081-cb0a-4ca1-a643-58078213a7ce', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 15, 'g', '1 tbsp coarse sea salt (for pasta cooking water)', false, 0, 6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 'd82d43fe-4fed-40d1-a2f3-6ed89537e8db', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '973d8c98-8ac0-4aae-ae3c-577dd20675d5', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '99df19a2-15cc-40e0-a96f-8d396554174f', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '8641bd16-6364-4325-adab-535f13c9d73d', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', '92e2a3fb-96f3-4169-a6a8-6e35456d402c', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('985d9374-5563-46cd-a122-72eb8b4a6775', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 1, 'Boil Pasta Water', 'Bring 4 liters of water to a rolling boil in a large 8-12 quart stockpot. Add 15g coarse sea salt once boiling.', 480, 'Boil Water', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('02d4d5c7-af48-466f-a85e-0c0aac81e5f5', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 2, 'Render the Guanciale', 'Place diced guanciale into a cold 12-inch skillet and set heat to medium-low. Slowly render the pork fat for 8-10 minutes until meat is deeply golden and crisp on the outside while chewy within. Turn off heat and tilt pan to rest.', 540, 'Render Guanciale', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('02d4d5c7-af48-466f-a85e-0c0aac81e5f5', 'afb387f9-2856-414d-aaea-59fcf429ec03')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('23f7135d-e019-4ac9-ae98-2c91c2290a35', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 3, 'Whisk Carbonara Egg Cream', 'In a stainless steel mixing bowl, whisk together 4 egg yolks, 1 whole egg, 80g finely grated Pecorino Romano, and copious cracked black pepper until a thick, uniform paste forms.', 120, 'Whisk Egg Paste', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('23f7135d-e019-4ac9-ae98-2c91c2290a35', '63deea78-9136-46af-abab-835e60f47d1b')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('b612da1c-d0f1-4240-ad81-55ea1d229fca', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 4, 'Cook Spaghetti Al Dente', 'Drop spaghetti into boiling salted water. Cook for 8 minutes—roughly 2 minutes shy of package directions. Reserve 1 cup (240ml) of starchy pasta water before draining.', 480, 'Cook Spaghetti', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('c3aefd24-8932-499f-a21c-281f373fe445', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 5, 'Emulsify the Sauce (The Mantecatura)', 'Transfer hot spaghetti directly into the guanciale pan using tongs. Ladle in 60ml hot pasta cooking water to temper the egg mixture while whisking constantly. Pour egg paste over the pasta and toss vigorously off the burner for 60 seconds. The residual heat creates an ultra-silky, glossy cream without scrambling the eggs.', 60, 'Vigorous Toss & Emulsify', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('c3aefd24-8932-499f-a21c-281f373fe445', '4d9e0976-b216-40f1-a64c-40efe71d0ace')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('c3aefd24-8932-499f-a21c-281f373fe445', '63deea78-9136-46af-abab-835e60f47d1b')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('33babb0d-17e9-43ce-af62-f1f2974f57c7', 'e44a4ea5-ea89-48e7-ad1d-ea24f2b4e1e8', 6, 'Plate and Serve Immediately', 'Twirl pasta into warmed bowls. Spoon remaining crispy guanciale bits and pan glaze over the crown. Garnish with extra grated Pecorino Romano and fresh black pepper.', 0, NULL, false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Traditional Filipino Chicken Adobo
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    'f5009494-58a2-4958-aa12-1701f2cc1d59',
    '00000000-0000-0000-0000-000000000001',
    'Traditional Filipino Chicken Adobo',
    'traditional-filipino-chicken-adobo',
    'The national comfort dish of the Philippines: chicken thighs slow-braised in cane vinegar, dark soy sauce, crushed garlic heads, black peppercorns, and bay leaves until falling-apart tender and glossy.',
    '{"Filipino","Southeast Asian","Braising"}'::text[],
    'Poultry',
    'easy',
    15,
    35,
    4,
    510,
    '{"protein_g":42,"carbs_g":10,"fat_g":32,"fiber_g":1,"sodium_mg":1180}'::jsonb,
    'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('539053ef-910e-4602-a17f-9ea51480f3de', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'fc9ed934-66eb-49a7-ad6c-122dfaf63094', 900, 'g', '900g bone-in skin-on chicken thighs, trimmed', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('8e9c37b7-f29e-4a06-a7c4-3d5ac9227e6d', 'f5009494-58a2-4958-aa12-1701f2cc1d59', '049909ef-0ae7-4cb3-a033-ada24516a7e4', 120, 'ml', '1/2 cup (120ml) Filipino cane vinegar (or distilled white vinegar)', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b09c9b87-4771-4cf1-a8e2-d715311e1f16', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'b8c44047-2be9-4f80-a955-b0dcb7aa4450', 80, 'ml', '1/3 cup (80ml) dark soy sauce', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('be64bb7b-73a7-4356-a304-b986df15ea90', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 10, 'clove', '10 large garlic cloves, lightly smashed and peeled', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('a17a8885-2b71-441c-ab18-474e68146d7e', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'b9add8a4-7929-4faa-a1e8-6f6bfbd8b733', 4, 'piece', '4 dried whole bay leaves', false, 3, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('adf0845d-1fcb-4850-a07a-56390d7655d5', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'a089e705-1d76-4569-a737-ab042f04688f', 5, 'g', '1 tbsp whole black peppercorns, cracked with skillet bottom', false, 0, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('bd4b7500-1827-4f3d-a0d3-af076bfc84b8', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'e9530c19-14d5-482b-a4a6-23d271b4b681', 15, 'g', '1 tbsp dark brown sugar (to balance acidity)', true, 3, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('512b861d-86cd-44c5-a1d2-5cf49b4e466d', 'f5009494-58a2-4958-aa12-1701f2cc1d59', '5ca73e3e-3265-4855-aa9c-a3d23888ace6', 120, 'ml', '1/2 cup water', false, 0, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('5b2778a2-e56a-43d3-a8e6-8f636e6a92fc', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 'daaf8f89-1ae6-4dfe-ae7a-8177c0f3ac28', 15, 'ml', '1 tbsp neutral cooking oil', false, 0, 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f5009494-58a2-4958-aa12-1701f2cc1d59', 'ec806f30-bd63-4972-a45d-d87bd336198a', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f5009494-58a2-4958-aa12-1701f2cc1d59', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f5009494-58a2-4958-aa12-1701f2cc1d59', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f5009494-58a2-4958-aa12-1701f2cc1d59', '99df19a2-15cc-40e0-a96f-8d396554174f', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f5009494-58a2-4958-aa12-1701f2cc1d59', '3a6a3f56-9bdc-42df-a437-834b778d18e8', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('abf68c6a-8e93-4341-ac58-07ea44828e68', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 1, 'Marinate the Chicken', 'In a large bowl, combine chicken thighs with soy sauce, cane vinegar, smashed garlic cloves, cracked peppercorns, and bay leaves. Toss to coat and marinate for 15-20 minutes at room temperature.', 900, 'Marinate Chicken', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('1387db64-fd9f-4a64-ab6f-17ce0a80c41c', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 2, 'Sear Chicken Skin', 'Heat neutral oil in a heavy Dutch oven over medium-high heat. Remove chicken from marinade (reserving marinade liquid). Pat chicken skin dry with paper towels. Place skin-side down in the hot pot and sear for 5-6 minutes undisturbed until deep golden brown and crispy.', 360, 'Sear Chicken Skin', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('1387db64-fd9f-4a64-ab6f-17ce0a80c41c', 'afb387f9-2856-414d-aaea-59fcf429ec03')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('4c467634-812b-42d5-a70f-3497bbac6caa', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 3, 'Deglaze and Braise', 'Flip chicken thighs over. Pour reserved marinade and 1/2 cup water into the pot. Bring to a rolling boil over high heat, scraping up the browned chicken fond from the pot bottom with a wooden spoon.', 180, 'Deglaze Fond', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('4c467634-812b-42d5-a70f-3497bbac6caa', '3ee5ed40-3713-47e4-a90a-9f4cc4b53369')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('c161e10c-154b-45e2-a29a-838b59c0f3e9', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 4, 'Low & Slow Simmer', 'Cover the Dutch oven with a tight lid, reduce burner to low heat, and braise at a gentle simmer for 25 minutes until chicken registers 175°F (80°C) and meat is fork-tender.', 1500, 'Braise Chicken', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('c161e10c-154b-45e2-a29a-838b59c0f3e9', 'e787bd7b-246c-40be-a962-dd0cc49c58b0')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('89e36ee9-ed2d-4c16-a9a8-ed17c72edb16', 'f5009494-58a2-4958-aa12-1701f2cc1d59', 5, 'Reduce to a Glossy Glaze', 'Uncover pot and stir in brown sugar. Increase heat to medium-high and boil sauce rapidly for 8-10 minutes, basting chicken continuously until liquid reduces into a thick, glossy savory glaze. Serve steaming over fragrant jasmine rice.', 480, 'Reduce Sauce Glaze', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Authentic Thai Green Curry (Gaeng Kiew Wan Gai)
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '598b12db-2406-48c5-a84c-94c78f18b7b2',
    '00000000-0000-0000-0000-000000000001',
    'Authentic Thai Green Curry (Gaeng Kiew Wan Gai)',
    'authentic-thai-green-curry-gai',
    'A vibrant, fragrant Bangkok street classic featuring tender chicken breast, Thai baby eggplants, and sweet bamboo shoots bathed in aromatic coconut milk split with green curry paste and fresh Thai basil.',
    '{"Thai","Curry","Southeast Asian"}'::text[],
    'Curry',
    'medium',
    15,
    20,
    4,
    460,
    '{"protein_g":34,"carbs_g":14,"fat_g":30,"fiber_g":4,"sodium_mg":920}'::jsonb,
    'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('c0142e06-7948-498d-a4d1-38682ef536d8', '598b12db-2406-48c5-a84c-94c78f18b7b2', 'be0345b8-5b39-4dca-ac62-8ae9ca4772b1', 500, 'g', '500g chicken breast, thinly sliced into bite-sized strips against grain', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('0983da14-546c-49c7-a9b9-e40dbc0c7441', '598b12db-2406-48c5-a84c-94c78f18b7b2', '94e61fcc-d48e-48d1-ab56-be9b4785f67c', 60, 'g', '1/4 cup (60g) authentic Thai green curry paste', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('8392141a-1314-4c78-a39e-123f6d2932a7', '598b12db-2406-48c5-a84c-94c78f18b7b2', '1eb89569-86b3-4e16-aa16-c9e7cf2b9c9a', 400, 'ml', '1 can (400ml) full-fat coconut milk (separated into top cream and thin liquid)', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b60c75a2-6889-44a2-acf1-e127a4ee83b4', '598b12db-2406-48c5-a84c-94c78f18b7b2', 'c5f2a49f-ef60-46a7-abb9-2beacdd3b80d', 150, 'g', '150g Thai round eggplants, quartered and submerged in salted water', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('21839f2c-f87b-43a1-a529-1ef85a0d8090', '598b12db-2406-48c5-a84c-94c78f18b7b2', '8325c047-3a4c-4a87-a8ad-2e3d65e668c1', 100, 'g', '100g canned sliced bamboo shoots, rinsed and drained', false, 2, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('082af695-c0c4-4472-ac49-1bdbcd9737bd', '598b12db-2406-48c5-a84c-94c78f18b7b2', 'b2727c6b-2e8c-4b40-a14a-9192099f7678', 30, 'ml', '2 tbsp premium fish sauce', false, 3, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('168a32de-f250-44f4-ab84-edf0e5d74038', '598b12db-2406-48c5-a84c-94c78f18b7b2', '2e1bd99f-41d8-4212-adcd-9cfd4b07a1dd', 15, 'g', '1 tbsp shaved palm sugar (or light brown sugar)', false, 3, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('59868813-8d49-431b-a81e-5da68abe1fb3', '598b12db-2406-48c5-a84c-94c78f18b7b2', '12f5f9e7-070d-4ca0-a623-0846f0a55f1e', 5, 'piece', '5 fresh kaffir lime leaves, torn and center rib removed', false, 3, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('51c656a3-a263-475b-a2c5-82ff069886c8', '598b12db-2406-48c5-a84c-94c78f18b7b2', '768eacf2-cf50-40b3-ae46-8ad3f09084a6', 30, 'g', '1 packed cup fresh Thai sweet basil leaves', false, 3, 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('598b12db-2406-48c5-a84c-94c78f18b7b2', 'd82d43fe-4fed-40d1-a2f3-6ed89537e8db', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('598b12db-2406-48c5-a84c-94c78f18b7b2', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('598b12db-2406-48c5-a84c-94c78f18b7b2', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('598b12db-2406-48c5-a84c-94c78f18b7b2', '3a6a3f56-9bdc-42df-a437-834b778d18e8', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('183efb42-ff44-4f53-a56a-4ebbd53d736d', '598b12db-2406-48c5-a84c-94c78f18b7b2', 1, 'Crack the Coconut Cream', 'Open the coconut milk can without shaking. Scoop out the top 1/2 cup of thick coconut cream into a dry 12-inch skillet over medium heat. Simmer for 4-5 minutes until the coconut oil cracks and separates from the solids in glistening pools.', 300, 'Crack Coconut Cream', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('12a129fc-cb67-40fc-a77f-241babee86da', '598b12db-2406-48c5-a84c-94c78f18b7b2', 2, 'Fry the Curry Paste', 'Add 60g green curry paste into the hot separated coconut oil. Fry vigorously for 2 minutes, breaking up clumps with a wooden spoon until deeply fragrant and oil turns emerald green.', 120, 'Bloom Curry Paste', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('12a129fc-cb67-40fc-a77f-241babee86da', '4e76b88a-b1c5-4d82-a6bc-608545f27846')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('e6224c7b-2498-4225-a79a-46507c3b6d0e', '598b12db-2406-48c5-a84c-94c78f18b7b2', 3, 'Sauté Chicken Slices', 'Add sliced chicken breast into the bubbling curry paste. Sauté for 3 minutes until chicken exterior turns opaque white and is thoroughly coated in spiced paste.', 180, 'Sauté Chicken', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('b4c8e59f-f0a0-464a-abad-ff5c6f13f4ae', '598b12db-2406-48c5-a84c-94c78f18b7b2', 4, 'Simmer Vegetables and Aromatics', 'Pour in the remaining thin coconut milk and 1/4 cup water. Bring to a gentle simmer. Add quartered Thai eggplants, drained bamboo shoots, torn kaffir lime leaves, fish sauce, and palm sugar. Simmer uncovered for 8 minutes until eggplants are tender.', 480, 'Simmer Curry', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('ed2a0f68-cf35-4236-a41e-a6b0f33a9375', '598b12db-2406-48c5-a84c-94c78f18b7b2', 5, 'Fold Fresh Thai Basil', 'Turn off burner immediately. Scatter in 1 cup of fresh Thai basil leaves and gently submerge them into the hot curry. The residual heat wilts the basil in 20 seconds while retaining its bright green color and anise aroma. Serve with warm jasmine rice.', 30, 'Wilt Thai Basil', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Sichuan Beef & Broccoli Stir-Fry
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '5918c7a3-43c2-42c1-af01-9b46f6b3c693',
    '00000000-0000-0000-0000-000000000001',
    'Sichuan Beef & Broccoli Stir-Fry',
    'sichuan-beef-and-broccoli-stir-fry',
    'Restaurant-quality high-heat stir fry featuring tender velveted flank steak slices and crisp emerald broccoli florets coated in a glossy, savory garlic-ginger soy glaze.',
    '{"Chinese","Sichuan","Stir Fry"}'::text[],
    'Beef',
    'medium',
    20,
    10,
    4,
    420,
    '{"protein_g":36,"carbs_g":16,"fat_g":22,"fiber_g":4,"sodium_mg":890}'::jsonb,
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b29b55e1-cdb9-471a-ab6e-4906dc56ca2a', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'e0f64dc2-884f-4bb7-a8eb-39c96079a621', 450, 'g', '450g beef flank steak, sliced thinly across grain into 2-inch planks', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('f54f0ef3-0df8-49f7-af6d-2f5daa7285ac', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', '13362b68-52f5-4eb8-a195-bd1a60994245', 350, 'g', '350g broccoli crowns, cut into bite-sized uniform florets', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('3a315123-2296-43da-a0a2-edf59749c8e5', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'b8c44047-2be9-4f80-a955-b0dcb7aa4450', 45, 'ml', '3 tbsp brewed soy sauce (divided: 1 tbsp marinade, 2 tbsp glaze)', false, 3, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d607cbec-cff9-419f-a673-80c0d0f5f592', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'f4553f56-85fa-4a92-a970-f7d3af596824', 15, 'ml', '1 tbsp Shaoxing cooking wine', false, 3, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('80ceb525-5bdd-4be0-a8ae-41d9e8a7d37a', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'bb63ff62-3445-4c9b-abba-f41f56b0e1ff', 20, 'g', '4 tsp cornstarch (divided: 2 tsp velvet marinade, 2 tsp glaze slurry)', false, 2, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('fe11bb89-f9e4-4f80-aac2-73073f160603', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 4, 'clove', '4 garlic cloves, finely minced', false, 2, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('0ac3eb05-4395-4186-a6ee-7efd7f445342', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', '6a79e34b-6517-4512-a716-9164fc9c7356', 15, 'g', '1 tbsp fresh ginger root, finely grated', false, 2, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('7a25024f-28a5-4511-a183-c0488bf0a6f7', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', '72576604-c61c-4903-a253-744880639b0b', 15, 'ml', '1 tbsp pure toasted sesame oil', false, 3, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('32fc0581-e48a-4409-a2ad-d91bb598260b', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', '5b38a1f5-87f0-4a82-a66e-173183daf699', 40, 'g', '3 scallions, cut into 1.5-inch diagonal segments', false, 2, 9)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('53663862-d73d-453f-a0e3-24f4e0eb8303', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'daaf8f89-1ae6-4dfe-ae7a-8177c0f3ac28', 30, 'ml', '2 tbsp high-heat neutral oil', false, 0, 10)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'd82d43fe-4fed-40d1-a2f3-6ed89537e8db', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('5918c7a3-43c2-42c1-af01-9b46f6b3c693', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('5918c7a3-43c2-42c1-af01-9b46f6b3c693', '70dd3e26-74c4-4407-a05e-634d93e8e8bd', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('5918c7a3-43c2-42c1-af01-9b46f6b3c693', '92e2a3fb-96f3-4169-a6a8-6e35456d402c', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('d38a370a-ccea-4df9-acf8-711c7c40b3c3', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 1, 'Velvet the Beef', 'Place thinly sliced flank steak into a medium bowl. Add 1 tbsp soy sauce, 1 tbsp Shaoxing wine, 1 tbsp water, and 2 tsp cornstarch. Massage vigorously until all liquid is absorbed into the meat fibers. Let rest for 15 minutes to guarantee tender, velvety beef.', 900, 'Velvet Beef', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('13b54972-4fb5-4128-a8d8-ce1f3312fdfc', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 2, 'Blanch and Shock Broccoli', 'Drop broccoli florets into a pot of rapidly boiling salted water for 60 seconds until crisp-tender and vibrant emerald green. Immediately plunge into an ice-water bath using a strainer to stop cooking. Drain thoroughly on paper towels.', 60, 'Blanch Broccoli', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('13b54972-4fb5-4128-a8d8-ce1f3312fdfc', '9715ac7c-2099-442b-a9ad-d5f192389040')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('048d82d5-7578-4acb-afc3-46d7a2b1e959', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 3, 'Mix the Stir-Fry Glaze', 'In a small bowl, whisk 2 tbsp soy sauce, 1 tbsp sesame oil, 2 tsp cornstarch, 1/4 cup water, and a pinch of brown sugar until smooth.', 60, 'Whisk Glaze Slurry', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('219a241f-7559-42cf-ac07-9ebd7c63da3b', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 4, 'High-Heat Beef Sear', 'Heat 1.5 tbsp neutral oil in a 12-inch stainless skillet over maximum high heat until smoking hot. Spread beef slices in a single layer. Sear undisturbed for 90 seconds until a caramelized brown crust forms, then flip and toss for 60 seconds until just pink. Transfer beef to a clean plate.', 150, 'Sear Beef', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('219a241f-7559-42cf-ac07-9ebd7c63da3b', 'afb387f9-2856-414d-aaea-59fcf429ec03')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('a2759fb6-6615-4821-a0ce-7849b0db8e85', '5918c7a3-43c2-42c1-af01-9b46f6b3c693', 5, 'Wok Finish and Sauce Glaze', 'Add remaining oil, minced garlic, ginger, and scallions to the hot pan. Sauté for 30 seconds until fragrant. Return seared beef and blanched broccoli. Pour in glaze slurry. Toss aggressively over high heat for 60 seconds as the sauce bubbles into a mirror-like lacquer coating every piece.', 90, 'Toss & Glaze', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Classic French Rolled Omelet
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '2c591532-6d48-4e7e-afe5-850c63340a3f',
    '00000000-0000-0000-0000-000000000001',
    'Classic French Rolled Omelet',
    'classic-french-rolled-omelet',
    'The pinnacle test of French culinary precision: pale golden, smooth cylindrical exterior with zero browning, encasing a creamy, custardy, softly scrambled baveuse center.',
    '{"French","Breakfast","Eggs"}'::text[],
    'Eggs',
    'medium',
    5,
    5,
    1,
    310,
    '{"protein_g":18,"carbs_g":2,"fat_g":26,"fiber_g":0,"sodium_mg":380}'::jsonb,
    'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('167a8e77-f8e0-42bb-acaa-148064eca9aa', '2c591532-6d48-4e7e-afe5-850c63340a3f', 'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc', 3, 'piece', '3 large fresh eggs (room temperature)', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('52b10683-c3a1-4f7b-a34b-9a90c084d427', '2c591532-6d48-4e7e-afe5-850c63340a3f', 'ec97a179-7b90-4bdb-a3c4-b9fa6e8566dc', 25, 'g', '25g cold unsalted European butter, cut into small cubes (divided)', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('c3efeed8-18ca-46f4-a522-beca4c736fbc', '2c591532-6d48-4e7e-afe5-850c63340a3f', '36d2d009-a147-4298-ae12-6280a3d389ae', 10, 'g', '1 tbsp fresh chives, finely snipped', false, 3, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('a02d3d7a-b0c8-4044-a1c9-2f89eefb3a36', '2c591532-6d48-4e7e-afe5-850c63340a3f', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 2, 'g', '1/4 tsp fine sea salt', false, 0, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('ebdbff07-c33e-4dc0-adcd-27f71ba99f61', '2c591532-6d48-4e7e-afe5-850c63340a3f', '04b84863-0c73-4b53-a00d-db5a7a4e58d2', 1, 'g', 'Pinch of ground white pepper', false, 3, 5)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('2c591532-6d48-4e7e-afe5-850c63340a3f', 'ea15f2e0-e237-4f50-ab06-3a0d45e4312b', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('2c591532-6d48-4e7e-afe5-850c63340a3f', '8641bd16-6364-4325-adab-535f13c9d73d', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('2c591532-6d48-4e7e-afe5-850c63340a3f', '0925d059-6fa6-4222-a50f-3ea127a65d39', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('2c591532-6d48-4e7e-afe5-850c63340a3f', '92e2a3fb-96f3-4169-a6a8-6e35456d402c', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('5c27da0c-93a2-4a58-a158-e9441ccc617c', '2c591532-6d48-4e7e-afe5-850c63340a3f', 1, 'Whisk Eggs Uniformly', 'Crack 3 eggs into a bowl. Season with fine sea salt and white pepper. Whisk vigorously for 60 seconds until completely uniform with zero translucent egg white strands remaining.', 60, 'Whisk Eggs', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('209d00fb-97b6-4d5d-a5f7-d37e2ed52c69', '2c591532-6d48-4e7e-afe5-850c63340a3f', 2, 'Melt Butter on Medium-Low Heat', 'Place an 8 or 10-inch nonstick skillet over medium-low heat. Melt 15g cold butter until foaming across the pan surface. Do not allow butter to sizzle or brown.', 90, 'Melt Butter', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('0b0e8a2f-1a18-4a20-a260-7807fbe37e1f', '2c591532-6d48-4e7e-afe5-850c63340a3f', 3, 'Rapid Agitation (Small Curds)', 'Pour beaten eggs into skillet. Immediately begin shaking pan back and forth with your left hand while rapidly stirring eggs in tight circles with a heatproof silicone spatula in your right hand. Small creamy curds will form within 60-90 seconds.', 90, 'Agitate Curds', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('ca6d9053-a824-4d9b-a020-1190a0628ebd', '2c591532-6d48-4e7e-afe5-850c63340a3f', 4, 'Smooth and Form the Sheet', 'When eggs are 80% cooked into a soft, custardy custard (baveuse) with almost no runny liquid, remove skillet from direct heat. Use silicone spatula to smooth the egg surface into an even round disk.', 30, 'Smooth Egg Sheet', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('60ce381c-bd36-4d89-acee-1eec663a8035', '2c591532-6d48-4e7e-afe5-850c63340a3f', 5, 'Roll and Glaze Omelet', 'Tilt pan 45 degrees away from you. Use spatula to gently roll the top third of the omelet downward toward the center, then fold bottom third over. Invert onto a warm plate seam-side down. Rub remaining 10g cold butter across the hot surface for a glistening sheen; scatter snipped chives over top.', 60, 'Roll and Glaze', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('60ce381c-bd36-4d89-acee-1eec663a8035', '72364287-4610-4b7e-a57a-d5d51049e1dc')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;

-- Recipe: Traditional Middle Eastern Shakshuka
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d',
    '00000000-0000-0000-0000-000000000001',
    'Traditional Middle Eastern Shakshuka',
    'traditional-middle-eastern-shakshuka',
    'A vibrant, spiced North African and Levantine breakfast staple: pasture-raised eggs gently poached in a rich, simmering skillet of crushed tomatoes, sweet bell peppers, caramelized onions, cumin, paprika, and salty feta.',
    '{"Middle Eastern","North African","Vegetarian","Breakfast"}'::text[],
    'Eggs',
    'easy',
    15,
    25,
    4,
    320,
    '{"protein_g":16,"carbs_g":18,"fat_g":22,"fiber_g":5,"sodium_mg":640}'::jsonb,
    'https://images.unsplash.com/photo-1590412200988-a436970781fa?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('e1d92f2f-9e3a-46fd-a003-558bb6cbf315', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'c41999b1-8f9c-4646-adfc-3e71d2e8d4bc', 5, 'piece', '5 large fresh eggs', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('6328b870-3b0e-4680-af28-032e74c42b49', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '97f89e71-b1f1-45cf-a2bc-479e37e8a672', 800, 'g', '1 large can (800g) crushed San Marzano tomatoes with juices', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('f399adb6-2a74-4ba6-a665-4e0c1e9acee7', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '1041f92c-0f99-4828-aca4-f8a711b59d72', 2, 'piece', '2 red bell peppers, stemmed, seeded, and cut into 1/2-inch dice', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('e0284cdc-8cfb-40c9-acf0-a25bf8ca45c1', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf', 1, 'piece', '1 large yellow onion, finely diced', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('ba07dd09-d533-4db5-a6bd-cbf9a4730a8f', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 4, 'clove', '4 garlic cloves, thinly sliced', false, 2, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('a4830892-03da-493a-ab50-36f067e4eb8b', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '5e408eb5-8901-4a6b-aad4-534aa3ed31b4', 6, 'g', '1.5 tsp ground cumin', false, 3, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d15ef4b4-6057-48ad-a802-9534b4ecbfce', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'ee3e066e-454a-437d-a788-b17223256d5e', 6, 'g', '1.5 tsp smoked Spanish paprika', false, 3, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('4bf9d2f0-81ac-440d-adc7-e0b2163bd97b', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '4b83abe8-0bcf-4162-ad3e-cd21339988d8', 45, 'ml', '3 tbsp extra virgin olive oil', false, 0, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b4abc928-61d8-485d-a8e1-6f2218dd8b5e', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '66e8d410-97b4-4aeb-a125-486f4350b060', 75, 'g', '75g Greek sheep milk feta, crumbled', true, 2, 9)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('565b4031-a65b-4a37-a3a4-8ef8f84575f1', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '35333a4d-a32a-4e08-aab8-cea17c182656', 20, 'g', '1/4 cup fresh cilantro leaves, chopped', false, 3, 10)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('7cc6a910-3b1d-44ab-a947-8d9774103431', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 5, 'g', '1 tsp sea salt', false, 0, 11)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('33e23318-0cde-45c2-a353-1f4f0bc1f703', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'a089e705-1d76-4569-a737-ab042f04688f', 3, 'g', '1/2 tsp freshly cracked black pepper', false, 0, 12)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'a94dd436-e16e-4a12-a14b-99a7dad08bbd', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', '3a6a3f56-9bdc-42df-a437-834b778d18e8', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('969d670f-8ae0-4a92-a790-cf6de9974efd', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 1, 'Sweat Aromatics and Peppers', 'Heat olive oil in a 12-inch cast iron skillet over medium heat. Add diced onion and bell pepper with a pinch of sea salt. Cook for 8-10 minutes, stirring occasionally until vegetables are softened, sweet, and lightly caramelized.', 540, 'Sweat Aromatics', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('969d670f-8ae0-4a92-a790-cf6de9974efd', '6274ef5e-f3cd-4e0b-aab6-4e1735deaa00')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('b4ef1a98-b77b-47f6-af29-d032589e6a38', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 2, 'Bloom Cumin and Paprika', 'Add sliced garlic, ground cumin, and smoked paprika. Stir continuously in hot olive oil for 60 seconds until fragrant and intoxicatingly aromatic.', 60, 'Bloom Spices', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('b4ef1a98-b77b-47f6-af29-d032589e6a38', '4e76b88a-b1c5-4d82-a6bc-608545f27846')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('bf4b6872-993b-4685-af19-95bbb13b5582', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 3, 'Simmer Tomato Sauce', 'Pour in crushed tomatoes with juices. Season with black pepper and remaining salt. Simmer uncovered over medium-low heat for 12 minutes, stirring periodically until sauce is thick, rich, and jammy.', 720, 'Reduce Tomato Sauce', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('af691aa7-f90a-4003-a3fc-fa011c4fede2', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 4, 'Poach the Eggs', 'Use the back of a large wooden spoon to make 5 evenly spaced depressions in the simmering sauce. Crack an egg directly into each well. Cover skillet with lid or foil, reduce heat to low, and gently poach for 6-8 minutes until egg whites are opaque and set while yolks remain runny.', 420, 'Poach Eggs', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('af691aa7-f90a-4003-a3fc-fa011c4fede2', '931bf54b-12f1-4e0d-a2f0-1d9e5816a1b2')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('69241e20-33d1-4bb7-aa7f-2c8a8b90b0ce', 'e0635ba2-0d62-4a14-ad7f-beb0c1a5a30d', 5, 'Garnish and Serve', 'Uncover skillet. Scatter crumbled feta cheese and freshly chopped cilantro over the steaming dish. Serve skillet directly at the table with warm pita bread or crusty sourdough for dipping.', 0, NULL, false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Creamy Indian Red Lentil Dahl (Masoor Dal Tadka)
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    'f3b64520-2298-4f3f-adf3-8083c8a5a127',
    '00000000-0000-0000-0000-000000000001',
    'Creamy Indian Red Lentil Dahl (Masoor Dal Tadka)',
    'creamy-indian-red-lentil-dahl',
    'Soul-warming North Indian red lentils simmered into a velvety coconut porridge, finished with a dramatic smoking Tadka tempering of sizzling ghee, cumin seeds, garlic, and fresh ginger.',
    '{"Indian","Vegan","Vegetarian","Curry"}'::text[],
    'Vegetarian',
    'easy',
    10,
    30,
    4,
    380,
    '{"protein_g":22,"carbs_g":48,"fat_g":12,"fiber_g":14,"sodium_mg":580}'::jsonb,
    'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b5f12eab-a85d-486d-a1bf-a48ab2d6afba', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '0203369c-a47d-418f-a23f-1aa501e7074d', 250, 'g', '250g split red lentils (Masoor Dal), rinsed until clear', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('f539fdda-1461-41eb-a2da-93f0e032442a', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf', 1, 'piece', '1 medium yellow onion, finely diced', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('ddb57505-60a5-4f3d-a58b-b5893c7e2feb', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 5, 'clove', '5 garlic cloves, minced', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('805c539a-8978-410d-af9b-3c21ba77e31c', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '6a79e34b-6517-4512-a716-9164fc9c7356', 20, 'g', '1.5 tbsp fresh ginger, finely grated', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('38a0b05a-1ca4-4049-ae0a-ee4c44aa1cf2', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '8d2cc387-cd3a-42c0-a1f9-b2914cf055f2', 5, 'g', '1 tsp ground turmeric powder', false, 3, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('cfb70ad0-57f3-41b1-a8e3-b6e098956cb7', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '5e408eb5-8901-4a6b-aad4-534aa3ed31b4', 6, 'g', '1.5 tsp ground cumin seed', false, 3, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d18cdc86-386d-461d-ab20-0fe26bda91bd', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '4e8c41cb-41a8-445f-af30-3d4826e344d2', 5, 'g', '1 tsp authentic garam masala', false, 3, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('2747d19e-27a9-4d56-aabd-df69e43acb4e', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '1eb89569-86b3-4e16-aa16-c9e7cf2b9c9a', 200, 'ml', '1/2 can (200ml) full-fat coconut milk', false, 2, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('41a977d1-07d8-41ca-a8b5-db5f4768b262', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '4d49c59d-e8bf-4e63-a3b5-e561fe1e4f2c', 750, 'ml', '3 cups (750ml) vegetable broth or water', false, 2, 9)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('901a11d6-b664-4bf5-a83a-c8b4ce3545ef', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '08d0b1fa-04f7-4847-a0a1-8df9a260409a', 30, 'g', '2 tbsp ghee (or virgin coconut oil for vegan)', false, 3, 10)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('5f049b5e-3353-4881-aa96-c478276f4665', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', '35333a4d-a32a-4e08-aab8-cea17c182656', 15, 'g', '1/4 cup fresh cilantro leaves, chopped', false, 3, 11)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d21349bc-4df3-4554-ae2e-7716c87561c7', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 8, 'g', '1.5 tsp fine sea salt', false, 0, 12)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f3b64520-2298-4f3f-adf3-8083c8a5a127', '6ab52077-7f77-44b0-af68-a25a24e1d79a', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f3b64520-2298-4f3f-adf3-8083c8a5a127', 'd82d43fe-4fed-40d1-a2f3-6ed89537e8db', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f3b64520-2298-4f3f-adf3-8083c8a5a127', '70dd3e26-74c4-4407-a05e-634d93e8e8bd', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('f3b64520-2298-4f3f-adf3-8083c8a5a127', '3a6a3f56-9bdc-42df-a437-834b778d18e8', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('56920f20-5e6e-487f-a1f5-eb18fe393302', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 1, 'Rinse Lentils and Simmer', 'Place red lentils into a fine-mesh strainer and rinse under cold water until runoff is completely clear. In a 3-quart saucepan, combine rinsed lentils, 3 cups vegetable broth, ground turmeric, and 1 tsp salt. Bring to a rolling boil over high heat.', 300, 'Bring to Boil', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('95429c4f-c7b2-4091-a3d6-fa066b311ffb', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 2, 'Break Down into Porridge', 'Reduce burner to low, cover partially with lid, and simmer gently for 20 minutes, stirring occasionally until lentils collapse into a thick, golden porridge.', 1200, 'Simmer Dal', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('efc21a2a-3f9b-4be8-a6df-eeceea27f638', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 3, 'Stir in Coconut Milk', 'Whisk 200ml full-fat coconut milk into the cooked lentils. Simmer for another 5 minutes over gentle heat until velvety and luscious.', 300, 'Stir in Coconut Milk', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('0950e197-9e17-4e8d-a88a-6ef77566ea62', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 4, 'Fry the Spiced Tadka', 'In a small skillet, heat 2 tbsp ghee or coconut oil over medium heat. Add diced onions and sauté for 4-5 minutes until golden brown. Add minced garlic, grated ginger, cumin, and garam masala. Fry vigorously for 60 seconds until bubbling, sizzling, and fragrant.', 300, 'Fry Tadka', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('0950e197-9e17-4e8d-a88a-6ef77566ea62', '4e76b88a-b1c5-4d82-a6bc-608545f27846')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('0950e197-9e17-4e8d-a88a-6ef77566ea62', '6274ef5e-f3cd-4e0b-aab6-4e1735deaa00')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('3861cde4-4e06-450c-ae54-5a856cb8eb6c', 'f3b64520-2298-4f3f-adf3-8083c8a5a127', 5, 'Combine Sizzling Tadka', 'Pour sizzling Tadka fat and aromatics directly into the saucepan of warm lentils; it will hiss and crackle violently. Stir thoroughly to incorporate the spiced fat into the dahl. Garnish with chopped fresh cilantro and serve with warm naan or basmati rice.', 60, 'Incorporate Tadka', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Classic Provençal Ratatouille
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '9ebb538b-d25b-4751-a3c9-0736d91c7d8c',
    '00000000-0000-0000-0000-000000000001',
    'Classic Provençal Ratatouille',
    'classic-provencal-ratatouille',
    'The definitive summer stew of Nice, France: firm eggplants, sweet summer zucchini, yellow squash, bell peppers, and ripe Roma tomatoes cooked down gently in olive oil with garlic and thyme until meltingly tender.',
    '{"French","Provençal","Vegetarian","Vegan"}'::text[],
    'Vegetarian',
    'medium',
    25,
    45,
    6,
    190,
    '{"protein_g":4,"carbs_g":18,"fat_g":13,"fiber_g":7,"sodium_mg":340}'::jsonb,
    'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('b0e80662-a05d-40b3-acd5-e524347b2ad1', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '1adaf7ad-8b21-4010-afc6-5e664ee66990', 1, 'piece', '1 large globe eggplant, cut into 3/4-inch uniform cubes', false, 2, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('3160d93d-f445-430e-acf6-e8a081e1eebe', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '727761b5-201a-4df3-a18e-48845e9c1b77', 2, 'piece', '2 medium green zucchini, cut into 3/4-inch half-moons', false, 2, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('49c0fa68-d910-4abe-ad14-6759558aa07b', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '1528182d-37bc-4990-a6a5-d69828c1c8bf', 2, 'piece', '2 yellow summer squash, cut into 3/4-inch half-moons', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('60ad0e97-1ebe-4a46-a380-2a2eb63a3b19', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '1041f92c-0f99-4828-aca4-f8a711b59d72', 2, 'piece', '2 red bell peppers, seeded and cut into 3/4-inch dice', false, 2, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('3a5dd47f-befc-418b-a26c-ad4cc282b474', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '81a63a89-50cd-45a1-a697-2e4fcbca2406', 500, 'g', '500g ripe Roma tomatoes, peeled, seeded, and coarsely chopped', false, 2, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('825cf85a-c6c2-40f8-aaa4-3146f21af75b', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'c47c9f1a-a3c6-45ef-a7ad-28c3a77f9ebf', 1, 'piece', '1 large yellow onion, diced', false, 2, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('3bcb1763-36eb-4b4d-a203-d6d6577395bf', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 6, 'clove', '6 garlic cloves, thinly sliced', false, 2, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('dcf708a6-a8f0-44a3-ade4-4d5f67b2333a', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '4b83abe8-0bcf-4162-ad3e-cd21339988d8', 80, 'ml', '1/3 cup high-grade extra virgin olive oil (divided)', false, 0, 8)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('6469b971-cbd4-4ba0-a002-3c6bf31d538a', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'afa5e8b0-c263-4fb3-a4a7-c83ed41b850e', 10, 'g', '4 fresh thyme sprigs', false, 3, 9)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('eedfedfc-cb03-4a35-a89d-536d7b220a69', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '8bdb2847-8530-4866-a473-6b955210159e', 4, 'g', '1 tsp dried oregano', false, 3, 10)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d53e1ac8-1fbe-42ae-a1ee-c609ae66ade3', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 8, 'g', '1.5 tsp fine sea salt', false, 0, 11)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('32d6100f-7378-477b-a360-9a788ff6b84e', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'a089e705-1d76-4569-a737-ab042f04688f', 4, 'g', '1/2 tsp freshly ground black pepper', false, 0, 12)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'ec806f30-bd63-4972-a45d-d87bd336198a', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('9ebb538b-d25b-4751-a3c9-0736d91c7d8c', '3a6a3f56-9bdc-42df-a437-834b778d18e8', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('438c179e-d032-4741-ae4e-451f4a65428b', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 1, 'Salt and Drain Eggplant', 'Toss cubed eggplant with 1 tsp sea salt in a colander. Let rest for 20 minutes to draw out bitter liquids and excess moisture. Press dry thoroughly with paper towels.', 1200, 'Degorge Eggplant', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('438c179e-d032-4741-ae4e-451f4a65428b', 'e2f13cff-34af-4586-aef3-d393751d2de4')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('7e74251b-987e-4928-a0b9-4a242eaf2d53', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 2, 'Brown Eggplant in Batches', 'Heat 2 tbsp olive oil in a Dutch oven over medium-high heat. Sear dried eggplant cubes in batches for 5 minutes until browned and caramelized on edges. Remove and set aside in a bowl.', 300, 'Sear Eggplant', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('7e74251b-987e-4928-a0b9-4a242eaf2d53', 'afb387f9-2856-414d-aaea-59fcf429ec03')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('e01413f0-5868-442d-a1df-c8f099c2f771', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 3, 'Sauté Onions, Peppers, and Aromatics', 'Add another tablespoon of oil to the Dutch oven. Sauté diced onions and bell peppers for 8 minutes until tender and sweet. Add sliced garlic, thyme sprigs, and dried oregano; sauté 1 minute until fragrant.', 540, 'Sauté Mirepoix', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('e01413f0-5868-442d-a1df-c8f099c2f771', '6274ef5e-f3cd-4e0b-aab6-4e1735deaa00')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('de413655-72ee-4722-a9c8-9dc9b0e843c5', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 4, 'Add Squash and Tomatoes', 'Stir in zucchini, yellow summer squash, and chopped Roma tomatoes. Return seared eggplant to the pot. Season with remaining salt and black pepper. Stir gently to marry vegetables.', 180, 'Marry Vegetables', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('418a7436-9218-4853-a36a-128476760f7d', '9ebb538b-d25b-4751-a3c9-0736d91c7d8c', 5, 'Slow Stew to Silky Perfection', 'Cover the Dutch oven with lid slightly ajar. Reduce burner to low heat and simmer gently for 35 minutes, stirring occasionally until all vegetables are soft, silky, and collapsed into their fragrant juices. Finish with a drizzle of fresh raw olive oil.', 2100, 'Slow Stew Ratatouille', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Authentic Mexican Guacamole (Molcajete Style)
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    'db6beba7-de4a-4604-a56a-efeb95da87d3',
    '00000000-0000-0000-0000-000000000001',
    'Authentic Mexican Guacamole (Molcajete Style)',
    'authentic-mexican-guacamole-molcajete',
    'The ancient Aztec way: rich Haas avocados coarsely hand-crushed in a volcanic stone mortar with a freshly ground aromatic paste of garlic, serrano chile, red onion, sea salt, lime, and cilantro.',
    '{"Mexican","Appetizer","Vegan","Dip"}'::text[],
    'Appetizers',
    'easy',
    15,
    0,
    4,
    240,
    '{"protein_g":3,"carbs_g":12,"fat_g":22,"fiber_g":9,"sodium_mg":380}'::jsonb,
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('e13c23e9-c2a3-4be6-ac2c-b0cffb3f10ab', 'db6beba7-de4a-4604-a56a-efeb95da87d3', '89cd9e7e-a62d-4947-a1e1-3528eb8039d6', 3, 'piece', '3 large ripe Hass avocados (yielding slightly to gentle pressure)', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('73d7407b-7135-497d-a6bc-e7fbe2a464ea', 'db6beba7-de4a-4604-a56a-efeb95da87d3', '954cd431-4a71-4cd3-a533-22b794168a98', 30, 'ml', '2 tbsp fresh lime juice (from 2 juicy limes)', false, 3, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('d9aa3bb7-8ecc-477e-a0c0-e96a6d3db9cf', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 'b54789f0-4bb0-4a14-ad2f-7d4eb6563997', 0.5, 'piece', '1/2 medium red onion, finely minced', false, 2, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('1cd50e1c-f141-48c2-a232-956d5df83f9c', 'db6beba7-de4a-4604-a56a-efeb95da87d3', '35333a4d-a32a-4e08-aab8-cea17c182656', 25, 'g', '1/2 cup fresh cilantro leaves and tender stems, finely chopped', false, 3, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('cf0628e6-8a1b-418e-aa82-6b1ef874a314', 'db6beba7-de4a-4604-a56a-efeb95da87d3', '44972570-f557-4a90-aea3-551f0d23d16d', 1, 'piece', '1 fresh jalapeño or serrano chile, finely minced (seeds optional for heat)', false, 2, 5)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('a669a30f-e7dd-4586-ae60-98c95c5381d1', 'db6beba7-de4a-4604-a56a-efeb95da87d3', '81a63a89-50cd-45a1-a697-2e4fcbca2406', 1, 'piece', '1 ripe Roma tomato, seeds and core discarded, flesh finely diced', false, 2, 6)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('aa30c6ec-20f3-480f-af66-1d800b408cd7', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 'a7ad5666-ac60-4987-a7f4-bbad7a200730', 1, 'clove', '1 small garlic clove, finely grated', false, 2, 7)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('1763b290-1c09-459d-a58e-6053174f66fb', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 5, 'g', '1 tsp coarse sea salt (or to taste)', false, 0, 8)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('db6beba7-de4a-4604-a56a-efeb95da87d3', '25505567-4426-478e-ad24-2856cca7c51c', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('db6beba7-de4a-4604-a56a-efeb95da87d3', 'ff012fa6-d603-4a5f-af4d-2adeae806728', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('db6beba7-de4a-4604-a56a-efeb95da87d3', 'd4dd603f-6781-434c-ae72-98cdb577c351', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('c866d233-4be3-4045-ab6c-d0ce982ba4eb', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 1, 'Grind the Flavor Paste (El Majado)', 'In a heavy granite mortar and pestle (molcajete), add the grated garlic clove, 2 tbsp of the minced red onion, half the minced jalapeño, 1 tbsp chopped cilantro, and 1 tsp sea salt. Grind vigorously with pestle against the stone walls for 2 minutes until an aromatic, emerald-green paste forms.', 120, 'Grind Majado Paste', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('d5483404-78b9-48b2-a43a-d4b852b89ac2', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 2, 'Scoop the Avocados', 'Slice avocados in half lengthwise around seed. Twist halves apart and remove pits. Use a large spoon to scoop avocado flesh directly into the mortar over the aromatic paste.', 60, 'Scoop Avocados', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('af2cae69-0407-473e-a73d-138ea88e0a69', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 3, 'Coarse Hand Mash', 'Drizzle 2 tbsp fresh lime juice over the avocado. Use the pestle to crush the avocados into the paste, intentionally maintaining substantial creamy chunks. Never puree into baby food.', 60, 'Coarse Mash', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('cb173eed-58f3-4ebc-a31b-75d9a4d5788e', 'db6beba7-de4a-4604-a56a-efeb95da87d3', 4, 'Fold in Fresh Crisp Ingredients', 'Add remaining minced red onion, remaining jalapeño, diced Roma tomato, and remaining chopped cilantro. Gently fold together with a spoon. Taste and adjust with extra lime juice or sea salt. Serve immediately with warm tortilla chips.', 60, 'Fold & Season', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

-- Recipe: Artisanal Rustic Sourdough Bread
INSERT INTO recipes (id, author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, nutritional_facts, hero_image_url, status, average_rating, ratings_count, version)
VALUES (
    '0dad0575-15f5-4232-a318-88109906ff9a',
    '00000000-0000-0000-0000-000000000001',
    'Artisanal Rustic Sourdough Bread',
    'artisanal-rustic-sourdough-bread',
    'An open-crumb, blistered mahogany sourdough loaf baked in a screaming-hot Dutch oven. Made purely with flour, water, salt, and wild levain through slow cold fermentation.',
    '{"Baking","European","Artisan Bread"}'::text[],
    'Baking',
    'expert',
    60,
    45,
    12,
    195,
    '{"protein_g":7,"carbs_g":39,"fat_g":1,"fiber_g":3,"sodium_mg":380}'::jsonb,
    'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=1200&auto=format&fit=crop&q=80',
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
    status = EXCLUDED.status;

INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('76340dca-cbba-4542-aa20-aea81d9c1f9c', '0dad0575-15f5-4232-a318-88109906ff9a', '91a77c38-e4cc-42bc-acf9-d10ec346e9ff', 450, 'g', '450g unbleached strong bread flour (12.7% protein)', false, 1, 1)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('66b9134d-735b-401a-a361-5fe19b41358c', '0dad0575-15f5-4232-a318-88109906ff9a', 'd360313e-11cf-4e2e-a9ed-0a51ad01c86a', 50, 'g', '50g stone-ground whole wheat flour', false, 1, 2)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('0e8a575b-dadc-4b61-a533-4fac3f717e73', '0dad0575-15f5-4232-a318-88109906ff9a', '5ca73e3e-3265-4855-aa9c-a3d23888ace6', 375, 'ml', '375ml lukewarm water (75% hydration)', false, 0, 3)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('97df715c-8141-4a16-ab5f-235e0275a7ae', '0dad0575-15f5-4232-a318-88109906ff9a', '53972238-cf03-43bb-aaf2-2e800097180e', 100, 'g', '100g active mature sourdough starter (100% hydration, bubbly and peaked)', false, 1, 4)
ON CONFLICT (id) DO NOTHING;
INSERT INTO recipe_ingredients (id, recipe_id, ingredient_id, amount, unit, display_text, is_optional, tier, sort_order)
VALUES ('2323023f-1620-417d-a9fb-3adffbdd6ec0', '0dad0575-15f5-4232-a318-88109906ff9a', 'f8691d3a-d323-4207-a5e9-b6ba78289ac0', 10, 'g', '10g fine sea salt', false, 0, 5)
ON CONFLICT (id) DO NOTHING;

INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('0dad0575-15f5-4232-a318-88109906ff9a', 'ec806f30-bd63-4972-a45d-d87bd336198a', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('0dad0575-15f5-4232-a318-88109906ff9a', '6f55293a-81f0-4d91-a956-d2150693b96f', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('0dad0575-15f5-4232-a318-88109906ff9a', '92e2a3fb-96f3-4169-a6a8-6e35456d402c', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('0dad0575-15f5-4232-a318-88109906ff9a', 'b55d53ea-50a8-4289-acf4-ff7e08e34876', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;
INSERT INTO equipment_requirements (recipe_id, equipment_id, is_required, notes)
VALUES ('0dad0575-15f5-4232-a318-88109906ff9a', 'e8789a8a-4be4-48e4-a6ff-6a31045578c6', true, NULL)
ON CONFLICT (recipe_id, equipment_id) DO NOTHING;

INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('2a2a86ba-1050-4d4b-a931-16f2f78a7b64', '0dad0575-15f5-4232-a318-88109906ff9a', 1, 'Flour Autolyse', 'In a large mixing bowl, mix 450g bread flour and 50g whole wheat flour with 350ml water (holding back 25ml) using your hands until no dry flour spots remain. Cover bowl and rest undisturbed for 45 minutes to let enzymes hydrate the gluten strands.', 2700, 'Autolyse Dough', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('1780db23-8a0d-4daf-a445-8ccea68d4890', '0dad0575-15f5-4232-a318-88109906ff9a', 2, 'Incorporate Levain and Salt', 'Add 100g active bubbly sourdough starter, 10g sea salt, and reserved 25ml water over the dough. Dimple and squeeze dough between fingers for 3 minutes until smooth and elastic.', 180, 'Incorporate Starter', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('799e5c62-ff55-4033-a12e-d150bb20949d', '0dad0575-15f5-4232-a318-88109906ff9a', 3, 'Bulk Fermentation & Stretch-and-Folds', 'Perform 4 sets of stretch-and-folds spaced 30 minutes apart over the first 2 hours. Dip wet hands in water, grab underside of dough, stretch upward without tearing, and fold over top. Let dough ferment at 78°F (25°C) until aerated, domed, and increased 50% in volume.', 7200, 'Bulk Ferment', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_step_techniques (recipe_step_id, technique_id)
VALUES ('799e5c62-ff55-4033-a12e-d150bb20949d', '8e93d068-7d1a-4392-ac11-34644d646b7a')
ON CONFLICT (recipe_step_id, technique_id) DO NOTHING;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('764c802f-7a17-47c1-ac50-f26865f71c86', '0dad0575-15f5-4232-a318-88109906ff9a', 4, 'Pre-shape and Final Banneton Proof', 'Turn dough onto an unfloured work surface. Pre-shape into a taut round ball using bench knife. Rest 20 minutes uncovered. Perform final shaping into a tight boule with strong surface tension. Dust with rice flour and transfer seam-side UP into a proofing banneton basket. Chill in refrigerator at 38°F (3°C) for 14-16 hours.', 50400, 'Cold Retard Proof', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('59fa071c-7c67-459a-a063-ce58c40799a8', '0dad0575-15f5-4232-a318-88109906ff9a', 5, 'Score and Dutch Oven Steam Bake', 'Preheat oven with Dutch oven inside to 500°F (260°C) for 60 minutes. Invert cold dough onto parchment paper. Score top surface 1/2-inch deep with a razor blade at a 30-degree angle. Lower dough into screaming-hot Dutch oven, drop in 2 ice cubes for steam, cover tightly with lid, reduce oven to 450°F (230°C), and bake for 20 minutes.', 1200, 'Covered Steam Bake', true)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;
INSERT INTO recipe_steps (id, recipe_id, step_number, title, instruction, timer_duration_seconds, timer_label, is_critical)
VALUES ('18c3b0f7-1feb-4147-a7cc-448bbcef0c80', '0dad0575-15f5-4232-a318-88109906ff9a', 6, 'Uncover for Mahogany Crust', 'Carefully remove Dutch oven lid. Continue baking uncovered for 22-25 minutes until the crust turns deeply caramelized mahogany blistered and loaf sounds hollow when tapped on bottom. Cool completely on a wire rack for 2 hours before slicing with a serrated knife.', 1320, 'Crust Caramelization', false)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    title = EXCLUDED.title,
    instruction = EXCLUDED.instruction,
    timer_duration_seconds = EXCLUDED.timer_duration_seconds,
    timer_label = EXCLUDED.timer_label,
    is_critical = EXCLUDED.is_critical;

