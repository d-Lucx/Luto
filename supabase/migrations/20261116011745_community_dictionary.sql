INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, micro_video_url, gif_preview_url, key_tips, common_mistakes)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit, average_shelf_life_days, allergen_tags, density_g_per_ml)
VALUES (
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
