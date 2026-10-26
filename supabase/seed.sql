-- ==============================================================================
-- LUTO (Logo: Lu2) — Master Seed Data
-- Seeded: 32 Equipment, 20 Techniques, 35 Substitutions, Master Ingredients, 10 Starter Recipes
-- Generated: 2026-10-26T14:28:50.693Z
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

-- 2. Master Equipment Seed (32 items)
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('chef_knife', 'Chef''s Knife (8-inch / 20cm)', 'knives_cutlery', true, 'knife-kitchen', 'The primary workhorse knife for 90% of prep tasks: chopping, slicing, dicing, and mincing.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('paring_knife', 'Paring Knife (3.5-inch)', 'knives_cutlery', true, 'knife-small', 'Short precision blade designed for peeling, trimming, hulling strawberries, and delicate hand-held knife work.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('serrated_knife', 'Serrated Bread Knife (9-10 inch)', 'knives_cutlery', false, 'knife-serrated', 'Toothed blade for slicing crusty artisanal bread, soft tomatoes, and delicate layer cakes without crushing.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('cutting_board_large', 'Large Cutting Board (Wood or High-Density Poly)', 'prep_tools', true, 'cutting-board', 'Spacious non-slip food preparation surface (minimum 12x18 inches) to ensure safe, stable knife work.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('skillet_stainless_steel_12in', '12-Inch Stainless Steel Skillet', 'cookware', true, 'pan-frying', 'High-heat cooking pan ideal for searing proteins, creating fond, deglazing pan sauces, and sautéing.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('skillet_nonstick_10in', '10-Inch Nonstick Skillet', 'cookware', true, 'pan-egg', 'Slick surface pan for low-to-medium heat cooking of delicate proteins: scrambled eggs, omelets, and flaky fish fillets.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('cast_iron_skillet_12in', '12-Inch Cast Iron Skillet', 'cookware', false, 'pan-cast-iron', 'Heavy thermal mass pan capable of retaining massive heat for deep crust searing, cornbread baking, and stovetop-to-oven transitions.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('enameled_dutch_oven', 'Enameled Cast Iron Dutch Oven (5.5 - 6 Quart)', 'cookware', false, 'pot-dutch-oven', 'Heavy lidded pot providing even radiative heat for low-and-slow braising, stews, deep-frying, and baking sourdough bread.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('saucepan_3qt', '3-Quart Saucepan with Lid', 'cookware', true, 'pot-saucepan', 'Everyday pot for simmering grains, boiling rice, making caramel, reducing tomato sauces, and reheating soups.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('stockpot_8qt', '8-12 Quart Large Stockpot', 'cookware', true, 'pot-large', 'High-capacity deep vessel for boiling pasta in copious salted water, simmering bone broths, and steaming seafood.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('half_sheet_pan', 'Half-Sheet Baking Pan (Rimmed 18x13 inch)', 'bakeware', true, 'sheet-pan', 'Heavy 18-gauge aluminum sheet pan for roasting high-temperature vegetables, baking cookies, and sheet-pan dinners.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('wire_cooling_rack', 'Stainless Steel Wire Rack (Oven-Safe)', 'bakeware', false, 'grid-rack', 'Elevated grid that fits inside a sheet pan to allow 360-degree hot air circulation under roasts and crisp chicken wings, and cool baked goods.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('mixing_bowls_nested', 'Set of 3 Stainless Steel Mixing Bowls', 'prep_tools', true, 'bowl-mix', 'Lightweight, non-reactive nested bowls (1.5qt, 3qt, 5qt) for whisking vinaigrettes, holding mise en place, and proofing dough.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('fine_mesh_sieve_strainer', 'Fine-Mesh Sieve / Strainer (8-inch)', 'prep_tools', true, 'strainer-mesh', 'Multipurpose wire mesh for draining pasta, sifting flour, rinsing quinoa, and straining silky smooth pan sauces.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('locking_kitchen_tongs_12in', 'Stainless Steel Locking Tongs (12-inch)', 'utensils', true, 'tongs', 'An extension of the cook''s hand: grabbing, turning hot meats, tossing pasta in sauce, and safely retrieving items from boiling water.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('slotted_fish_spatula', 'Slotted Flexible Metal Fish Spatula', 'utensils', true, 'spatula-metal', 'Thin, razor-flexible beveled metal turner that easily glides under delicate fish fillets, burgers, and fried eggs without sticking.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('heatproof_silicone_spatula', 'Heat-Resistant Silicone Spatula', 'utensils', true, 'spatula-rubber', 'Flexible heat-resistant blade (up to 500°F) for folding batters, scraping every drop of sauce from pans, and making creamy custards.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('balloon_whisk_11in', '11-Inch Stainless Steel Whisk', 'utensils', true, 'whisk', 'Flexible wire loops for incorporating air into egg whites, emulsifying dressings, and creating smooth, lump-free roux and gravies.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('wooden_corner_spoon', 'Flat-Edge Wooden Spoon / Spatula', 'utensils', true, 'spoon-wooden', 'Rigid, non-reactive tool for scraping flavorful browned bits (fond) from the bottom of pans without scratching.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('digital_kitchen_scale_1g', 'Digital Kitchen Gram Scale (1g / 0.05oz precision)', 'measuring', true, 'scale-digital', 'The golden standard for accurate baking and cooking consistency. Eliminates cup volume packing variations.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('digital_instant_read_thermometer', 'Digital Instant-Read Meat Thermometer (2-3s response)', 'measuring', true, 'thermometer', 'Precision probe for guaranteeing perfect food safety and doneness: medium-rare steaks (130°F), poultry (165°F), and bread (200°F).')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('measuring_cups_and_spoons_set', 'Stainless Steel Dry Measuring Cups & Spoons', 'measuring', true, 'measuring-cups', 'Standard standard units (1 cup, 1/2, 1/3, 1/4; 1 tbsp, 1 tsp, 1/2 tsp, 1/4 tsp) for quick spice and liquid dosing.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('glass_liquid_measuring_cup_2cup', '2-Cup Tempered Glass Liquid Measuring Cup', 'measuring', true, 'cup-liquid', 'Clear vessel with spout and meniscus viewing lines for pouring broths, milk, water, and warm oils without spilling.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('microplane_rasp_grater', 'Microplane Rasp Zester & Fine Grater', 'prep_tools', false, 'grater-rasp', 'Photo-etched teeth that effortlessly zest citrus skins without bitter white pith, and pulverize hard garlic and parmesan into snow.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('four_sided_box_grater', '4-Sided Stainless Steel Box Grater', 'prep_tools', true, 'grater-box', 'Coarse shredding for cheddar, mozzarella, potatoes (hash browns), and carrots.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('y_peeler_swivel', 'Ergonomic Y-Shaped Vegetable Peeler', 'prep_tools', true, 'peeler', 'High-leverage razor carbon steel or ceramic blade for peeling root vegetables, shaving parmesan ribbons, and citrus peels.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('immersion_stick_blender', 'Variable Speed Immersion (Stick) Blender', 'appliances', false, 'blender-stick', 'Blends hot soups directly in the cooking pot without dangerous transfers, and whips foolproof 30-second mayonnaise.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('food_processor_14cup', '14-Cup Kitchen Food Processor', 'appliances', false, 'appliance-processor', 'Rapid chopping, pulse pureeing, pastry crust cutting, and mass shredding/slicing via motorized discs.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('high_speed_countertop_blender', 'High-Speed Countertop Blender (Vitamix / Ninja)', 'appliances', false, 'blender-countertop', 'High-RPM vortex that pulverizes fibers and seeds into completely silky veloutés, smoothie bowls, and nut butters.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('granite_mortar_and_pestle', 'Heavy Granite Mortar and Pestle (6-inch)', 'prep_tools', false, 'mortar-pestle', 'Crushes cell walls of garlic, herbs, and spices simultaneously, releasing volatile aromatic oils that spinning metal blades merely slice.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('sous_vide_immersion_circulator', 'Sous Vide Precision Immersion Circulator', 'appliances', false, 'device-circulator', 'Maintains temperature water baths to within 0.1°C for edge-to-edge perfect protein doneness and gentle infusion.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO equipment (canonical_name, display_name, category, is_essential, icon_name, description)
VALUES ('heavy_duty_kitchen_shears', 'Heavy-Duty Take-Apart Kitchen Shears', 'prep_tools', true, 'shears', 'Snipping fresh herbs, cutting twine, opening food packaging, and spatchcocking whole poultry backbones cleanly.')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;

-- 3. Master Techniques Seed (20 items)
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('searing_protein', 'Pan Searing Protein', 'dry_heat', 'beginner', 'Cooking protein at high temperature in a hot pan to trigger the Maillard reaction, developing a deeply flavorful, caramelized brown crust.', ARRAY['Thoroughly pat the protein completely dry with paper towels; surface moisture causes steaming rather than browning.', 'Ensure the pan and oil are shimmering hot before the protein touches the metal.', 'Do not move or poke the meat for the first 3-5 minutes; it will naturally release from the pan once the crust forms.'], ARRAY['Crowding the pan, which drops thermal temperature and traps steam.', 'Flipping prematurely when meat is still adhering to the pan.', 'Using low-smoke-point fats (like extra virgin olive oil or unclarified butter) at scorching heat.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('deglazing_pan', 'Deglazing a Pan', 'sauces_emulsions', 'beginner', 'Pouring a cool liquid (wine, broth, vinegar, or water) into a hot pan after searing to dissolve and incorporate the caramelized browned food particles (fond) stuck to the bottom.', ARRAY['Pour liquid in immediately after removing meat while pan retains thermal heat.', 'Use a flat-edged wooden spoon to aggressively scrape the bottom until smooth.', 'Reduce liquid by at least 50% to concentrate sweetness and cook off harsh alcohol fumes.'], ARRAY['Deglazing a pan with burnt (blackened) fond, which infuses an acrid, bitter taste into the sauce.', 'Adding liquid when the pan has cooled down completely.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('braising', 'Braising (Low & Slow)', 'combination', 'intermediate', 'A combination cooking method where meat/vegetables are first seared at high heat, then slowly simmered partially submerged in flavorful liquid in a covered vessel at low heat.', ARRAY['Liquid should come roughly 1/3 to 1/2 way up the side of the meat, never fully submerged.', 'Keep the oven temperature low (300°F / 150°C) to gently melt tough collagen into succulent gelatin without drying out muscle fibers.', 'Keep lid tightly sealed to prevent steam evaporation.'], ARRAY['Boiling too rapidly, which toughens the protein and turns sauce greasy.', 'Skipping the initial deep browning sear.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('julienne_cut', 'Julienne Cut (Matchstick)', 'knife_skills', 'intermediate', 'Precision knife technique that cuts firm vegetables into uniform matchsticks measuring approximately 1/8 inch x 1/8 inch x 2 inches (3mm x 3mm x 5cm).', ARRAY['Square off the vegetable first by cutting a thin slice off one side so it rests stable without rolling.', 'Cut into 1/8-inch thick planks, stack 2-3 planks, and slice lengthwise into 1/8-inch sticks.', 'Always curl non-knife hand fingertips inward like a claw against the blade face.'], ARRAY['Attempting to cut round vegetables without squaring a flat base first.', 'Uneven stick thicknesses causing erratic cooking rates in stir-fries.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('chiffonade', 'Chiffonade (Herb Ribbons)', 'knife_skills', 'beginner', 'Slicing flat leafy greens or herbs (such as fresh basil, sage, or mint) into thin, delicate ribbons.', ARRAY['Stack 6-8 washed and thoroughly dried leaves from largest to smallest.', 'Roll the leaf stack tightly like a cigar.', 'Slice crosswise into thin 1/16-inch ribbons using a smooth single-pass slicing motion.'], ARRAY['Using a dull knife or pressing straight down, which bruises and blackens the cut edges of delicate basil leaves.', 'Chiffonading wet herbs, resulting in clumps.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('emulsification', 'Emulsification (Sauce Binding)', 'sauces_emulsions', 'intermediate', 'Forcing two naturally unmixable liquids (such as oil and water or vinegar) to combine into a stable, silky uniform suspension using a binding agent like egg yolk, mustard, or honey.', ARRAY['Add the oil very slowly—drop by drop initially—while whisking vigorously until the emulsion takes hold.', 'Ensure base ingredients (egg yolk, acid) are at room temperature.', 'If an emulsion breaks (separates into greasy curdles), whisk 1 tsp warm water in a clean bowl and slowly whisk the broken sauce into it.'], ARRAY['Pouring oil too quickly in a steady stream before the initial emulsion matrix forms.', 'Using ice-cold liquids which inhibit surfactant binding.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('tempering_liquids', 'Tempering Delicate Ingredients', 'sauces_emulsions', 'intermediate', 'Gently raising the temperature of cold, heat-sensitive ingredients (such as beaten eggs, yogurt, or sour cream) before adding them to hot mixtures to prevent curdling or scrambling.', ARRAY['Slowly ladle a small stream of the hot soup/broth into the eggs/dairy while constantly whisking.', 'Once the egg/dairy mixture is lukewarm to warm, pour it steadily back into the main pot while stirring.', 'Keep main pot at low heat; do not boil after incorporating tempered eggs.'], ARRAY['Dumping cold egg yolks or sour cream directly into boiling soup.', 'Failing to whisk continuously during the tempering pour.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('blanch_and_shock', 'Blanching and Shocking', 'moist_heat', 'beginner', 'Boiling vegetables briefly in heavily salted water, then immediately plunging them into an ice water bath to stop the cooking instantly.', ARRAY['Use abundant rolling boiling water (at least 4 quarts per pound of vegetables) heavily salted like sea water.', 'Boil only until crisp-tender (60-90 seconds for green beans, asparagus, or peas).', 'Keep the ice bath properly iced so it remains near 32°F (0°C).'], ARRAY['Leaving vegetables in the ice bath too long after they have cooled, which leaches flavor and nutrients.', 'Inadequate ice volume, which warms up into a lukewarm bath that continues overcooking.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('sweating_aromatics', 'Sweating Aromatics', 'moist_heat', 'beginner', 'Cooking chopped vegetables (onions, celery, carrots, leeks) in fat over low heat with salt, softening them and releasing their natural moisture without browning.', ARRAY['Keep heat strictly on low to medium-low.', 'Add fine salt immediately to draw out cellular moisture via osmosis.', 'Cover pan with lid or parchment paper cartouche to trap steam and encourage even softening.'], ARRAY['Allowing heat to climb until vegetables brown, which imparts caramelized notes rather than sweet, translucent base aromatics.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('folding_batter', 'Folding Delicate Batters', 'baking_pastry', 'intermediate', 'A gentle motion used to incorporate a light, airy ingredient (whipped egg whites or whipped cream) into a heavier batter without deflating the trapped air bubbles.', ARRAY['Use a flexible rubber spatula with a broad head.', 'Cut vertically down through the center of the mixture, sweep across the bottom of the bowl, and lift up along the side, rotating the bowl 90 degrees.', 'Stir in one-third of the light mixture first to lighten the base before gently folding the rest.'], ARRAY['Vigorous circular stirring, which collapses delicate foam bubbles and produces dense, flat cakes.', 'Under-folding leaving large unmixed streaks of raw egg white.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('resting_meat', 'Resting Cooked Meat', 'prep_finishing', 'beginner', 'Allowing cooked meat to sit undisturbed on a warm cutting board before slicing, allowing muscle fibers to relax and redistribute moisture throughout.', ARRAY['Rest steaks for 5-8 minutes; whole roasted chickens for 15 minutes; large roasts for 20-30 minutes.', 'Tent loosely with foil—never wrap tightly, which creates condensation and softens crisp skin or sear.', 'Save all residual cutting board juices and pour back over the sliced meat or whisk into pan gravy.'], ARRAY['Slicing meat straight off the grill or pan, causing high-pressure juices to flood out, leaving meat dry.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('monter_au_beurre', 'Monter au Beurre (Pan Sauce Gloss)', 'sauces_emulsions', 'intermediate', 'Whisking chilled cubes of unsalted butter into a simmering, reduced pan sauce off the heat to create a glossy, velvety consistency and rich mouthfeel.', ARRAY['Butter must be straight from the refrigerator (ice cold) and cubed.', 'Remove the pan from direct heat; residual heat melts butter slowly, maintaining the natural dairy emulsion.', 'Swirl pan constantly in a circular motion until butter is fully emulsified.'], ARRAY['Boiling the sauce while adding butter, which breaks the emulsion into a pool of yellow clarified oil.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('poaching', 'Gentle Poaching', 'moist_heat', 'beginner', 'Submerging delicate foods (eggs, fish, pears) in liquid maintained at a gentle sub-boil (160°F–180°F / 71°C–82°C) with tiny shivers instead of rolling bubbles.', ARRAY['Water should have faint convection currents and tiny bubbles pinned to the bottom of the pot.', 'For poached eggs: add 1 tbsp white vinegar, create a gentle vortex in the water, and slip egg from a small ramekin directly into center.', 'Use aromatic liquid (court-bouillon or seasoned broth) to infuse flavor.'], ARRAY['Allowing liquid to reach a rapid boil, which rips delicate egg whites apart and dries out fish proteins.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('dry_brining', 'Dry Brining', 'prep_finishing', 'beginner', 'Salting meat in advance and letting it rest uncovered on a wire rack in the refrigerator for 4 to 24 hours, enhancing juiciness and promoting razor-crisp skin.', ARRAY['Use approximately 1/2 tsp kosher salt per pound of meat.', 'Rest on an elevated wire cooling rack inside a sheet pan to allow air circulation completely around.', 'Do not cover; the dry refrigerator air dehydrates the skin surface for superior Maillard browning.'], ARRAY['Using fine table salt at the same volume as kosher salt, which severely oversalts the meat.', 'Rinsing the meat after brining (unnecessary and washes away absorbed seasoning).'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('caramelizing_onions', 'True Onion Caramelization', 'dry_heat', 'intermediate', 'Slowly cooking sliced onions over low-to-medium heat for 40-50 minutes until their natural sugars break down into complex, sweet, deeply golden-brown compounds.', ARRAY['Patience is non-negotiable; true caramelization cannot be rushed in 10 minutes without burning.', 'Add a pinch of salt initially to draw out water.', 'Splash 1-2 tbsp water, wine, or stock whenever the fond on the bottom gets too dark to redistribute sugars.'], ARRAY['High heat causing onions to char bitter black on tips before interior sugars break down.', 'Adding baking soda excessively, which makes onions mushy and chemically alkaline.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('blooming_spices', 'Blooming Spices in Fat', 'dry_heat', 'beginner', 'Frying ground or whole spices in warm oil or ghee for 30–60 seconds, which dissolves and amplifies their fat-soluble aromatic flavor compounds (tadka / tempering).', ARRAY['Heat fat over medium-low heat; spices burn easily.', 'Add whole seeds (cumin, mustard, coriander) first until they crackle and pop, then ground spices for 15-20 seconds.', 'Add wet aromatics (onion, garlic, ginger) or liquids immediately after blooming to arrest spice cooking.'], ARRAY['Dumping ground spices into boiling water/soup directly without fat blooming, resulting in raw, dusty flavor.', 'Burning delicate ground paprika or turmeric into bitter black residue.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('roux_making', 'Making a Roux', 'sauces_emulsions', 'beginner', 'Cooking equal parts by weight of fat (usually butter) and all-purpose flour to eliminate raw flour taste and create the foundational thickening base for mother sauces.', ARRAY['White roux (2 min) for Béchamel / mac and cheese.', 'Blond roux (4-5 min) for Velouté / chicken pot pie.', 'Brown or Dark roux (15-30 min) for Creole and Cajun gumbo.', 'Whisk liquid in gradually—hot liquid into warm roux, or cold liquid into hot roux—to prevent lumping.'], ARRAY['Adding liquid all at once, creating stubborn flour dumplings.', 'Under-cooking white roux, resulting in an unpleasant pasty flour flavor.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('supreme_citrus', 'Supreming Citrus', 'knife_skills', 'intermediate', 'Cutting raw citrus fruit segments cleanly away from the bitter peel, white pith, and fibrous membrane walls.', ARRAY['Slice off both top and bottom ends of orange/grapefruit so it stands flat.', 'Curve your chef knife or paring knife along the contour of the fruit, cutting away skin and all white pith.', 'Slice inward on each side of the white dividing membranes to release clean, perfect fruit segments.'], ARRAY['Leaving patches of bitter white pith on fruit edges.', 'Squeezing fruit with excessive hand pressure while cutting.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('sous_vide_cooking', 'Sous Vide & Reverse Sear', 'combination', 'advanced', 'Cooking vacuum-sealed food in a precisely controlled water bath to the exact desired core temperature, followed by a blazing 60-second sear to develop crust.', ARRAY['Ensure airtight vacuum seal so heat transfers uniformly through water immersion.', 'Pat exterior bone-dry before the post-bath sear.', 'Sear on maximum surface heat for no longer than 45-60 seconds per side to avoid cooking beyond the water bath target.'], ARRAY['Searing cold or wet meat from the bag without drying, causing gray band overcooking.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO techniques_and_skills (canonical_slug, title, category, difficulty_level, summary, key_tips, common_mistakes)
VALUES ('blind_baking', 'Blind Baking Pastry Crust', 'baking_pastry', 'intermediate', 'Pre-baking an empty tart or pie crust before adding wet or unbaked fillings, preventing the bottom crust from turning into a soggy, undercooked mess.', ARRAY['Dock (prick) the pastry bottom gently all over with a fork to release trapped air.', 'Line with crumpled parchment paper and fill completely to the brim with ceramic pie weights, dried beans, or raw rice.', 'Bake until edges set (15 min), then remove weights and bake 5-10 min more to crisp the floor.'], ARRAY['Skimping on pie weights, which causes crust walls to slump down into the pan.', 'Adding weights directly onto raw dough without parchment lining.'])
ON CONFLICT (canonical_slug) DO UPDATE SET title = EXCLUDED.title;

-- 4. Master Ingredients Seed
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('salt_fine', 'Fine Sea Salt', 'spice_seasoning', true, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('black_pepper_ground', 'Ground Black Pepper', 'spice_seasoning', true, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('water_tap', 'Water', 'liquid', true, 'ml')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('cooking_oil_neutral', 'Neutral Cooking Oil', 'oil_fat', true, 'ml')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('olive_oil_extra_virgin', 'Extra Virgin Olive Oil', 'oil_fat', false, 'ml')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('butter_unsalted', 'Unsalted Butter', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('garlic_fresh', 'Fresh Garlic Cloves', 'produce', false, 'clove')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('onion_yellow', 'Yellow Onion', 'produce', false, 'piece')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('buttermilk', 'Buttermilk', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('whole_milk_lemon_juice_or_white_vinegar', 'Whole Milk + Lemon Juice (or White Vinegar)', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('sour_cream', 'Sour Cream', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('full_fat_plain_greek_yogurt', 'Full-Fat Plain Greek Yogurt', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('heavy_cream', 'Heavy Cream', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('whole_milk_melted_unsalted_butter', 'Whole Milk + Melted Unsalted Butter', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('canned_coconut_cream', 'Canned Coconut Cream', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('butter_for_cooking', 'Butter (for cooking)', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('extra_virgin_olive_oil', 'Extra Virgin Olive Oil', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ricotta_cheese', 'Ricotta Cheese', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('blended_small_curd_cottage_cheese', 'Blended Small-Curd Cottage Cheese', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('parmesan_parmigiano_reggiano', 'Parmesan (Parmigiano-Reggiano)', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('pecorino_romano', 'Pecorino Romano', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('cornstarch', 'Cornstarch', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('all_purpose_wheat_flour', 'All-Purpose Wheat Flour', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('arrowroot_powder_starch', 'Arrowroot Powder (Starch)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('tapioca_starch_flour', 'Tapioca Starch (Flour)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('egg_as_binder', 'Egg (as binder)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ground_flaxseed_meal_warm_water_flax_egg', 'Ground Flaxseed Meal + Warm Water (Flax Egg)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('animal_gelatin', 'Animal Gelatin', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('agar_agar_powder', 'Agar-Agar Powder', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fresh_garlic_cloves', 'Fresh Garlic Cloves', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('garlic_powder', 'Garlic Powder', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('shallots', 'Shallots', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('minced_yellow_onion_pinch_of_minced_garlic', 'Minced Yellow Onion + Pinch of Minced Garlic', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('yellow_onion_1_medium', 'Yellow Onion (1 medium)', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('scallions_green_onions_white_and_light_green_parts', 'Scallions / Green Onions (white and light green parts)', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fresh_grated_ginger', 'Fresh Grated Ginger', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ground_dried_ginger', 'Ground Dried Ginger', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fresh_cilantro_coriander_leaves', 'Fresh Cilantro (Coriander leaves)', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('flat_leaf_italian_parsley_fresh_lime_zest', 'Flat-Leaf Italian Parsley + Fresh Lime Zest', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fresh_lemon_juice', 'Fresh Lemon Juice', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fresh_lime_juice', 'Fresh Lime Juice', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('dry_white_wine_for_cooking_deglazing', 'Dry White Wine (for cooking/deglazing)', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('vegetable_or_chicken_broth_splash_of_apple_cider_vinegar', 'Vegetable or Chicken Broth + Splash of Apple Cider Vinegar', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('dry_red_wine_for_braising', 'Dry Red Wine (for braising)', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('rich_beef_broth_red_wine_vinegar', 'Rich Beef Broth + Red Wine Vinegar', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('rice_vinegar_unseasoned', 'Rice Vinegar (Unseasoned)', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('apple_cider_vinegar_tiny_pinch_of_sugar', 'Apple Cider Vinegar + Tiny Pinch of Sugar', 'condiment', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ground_beef_80_20', 'Ground Beef (80/20)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ground_turkey_93_7_1_tbsp_olive_oil_or_butter', 'Ground Turkey (93/7) + 1 tbsp Olive Oil or Butter', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('chicken_breast', 'Chicken Breast', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('extra_firm_tofu_pressed_and_cubed', 'Extra-Firm Tofu (Pressed and Cubed)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('pancetta_bacon_for_savory_base', 'Pancetta / Bacon (for savory base)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('diced_cremini_mushrooms_smoked_paprika_olive_oil', 'Diced Cremini Mushrooms + Smoked Paprika + Olive Oil', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('eggs_in_sweet_baking', 'Eggs (in sweet baking)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('unsweetened_applesauce', 'Unsweetened Applesauce', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('shrimp_in_stir_fries_pasta', 'Shrimp (in stir-fries / pasta)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('king_oyster_mushroom_stems_sliced_into_rounds', 'King Oyster Mushroom Stems (sliced into rounds)', 'protein', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('baking_powder_1_tsp', 'Baking Powder (1 tsp)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('baking_soda_1_4_tsp_cream_of_tartar_1_2_tsp', 'Baking Soda (1/4 tsp) + Cream of Tartar (1/2 tsp)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('baking_soda_1_4_tsp', 'Baking Soda (1/4 tsp)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('active_dry_yeast_1_packet_7g', 'Active Dry Yeast (1 packet / 7g)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('instant_rapid_rise_yeast', 'Instant (Rapid Rise) Yeast', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('self_rising_flour_1_cup_120g', 'Self-Rising Flour (1 cup / 120g)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('all_purpose_flour_1_cup_baking_powder_1_5_tsp_fine_salt_1_4_tsp', 'All-Purpose Flour (1 cup) + Baking Powder (1.5 tsp) + Fine Salt (1/4 tsp)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('tomato_paste_2_tbsp_30ml', 'Tomato Paste (2 tbsp / 30ml)', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('canned_crushed_tomatoes_simmered_and_reduced', 'Canned Crushed Tomatoes (simmered and reduced)', 'produce', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('honey', 'Honey', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('pure_maple_syrup', 'Pure Maple Syrup', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('soy_sauce_regular', 'Soy Sauce (Regular)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('tamari_gluten_free', 'Tamari (Gluten-Free)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('fish_sauce_1_tbsp', 'Fish Sauce (1 tbsp)', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('soy_sauce_1_tbsp_minced_dried_nori_or_dried_shiitake_broth', 'Soy Sauce (1 tbsp) + Minced Dried Nori or Dried Shiitake Broth', 'pantry_dry', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('mayonnaise_in_sandwiches_spreads', 'Mayonnaise (in sandwiches / spreads)', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;
INSERT INTO ingredients (canonical_name, display_name, category, is_staple, default_unit)
VALUES ('ripe_mashed_avocado_pinch_of_salt_lemon_juice', 'Ripe Mashed Avocado + Pinch of Salt & Lemon Juice', 'dairy', false, 'g')
ON CONFLICT (canonical_name) DO UPDATE SET display_name = EXCLUDED.display_name;

-- 5. Ingredient Substitutions Matrix Seed (35 items)
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'buttermilk' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'whole_milk_lemon_juice_or_white_vinegar' LIMIT 1),
    1,
    'dairy',
    ARRAY['baking', 'pancake_batter', 'marinades', 'fried_chicken_brine'],
    ARRAY['uncooked_cold_sauces_requiring_authentic_buttermilk_thickness'],
    'Nearly identical acidity; slightly less buttery complexity.',
    'Slightly less viscous than cultured buttermilk.',
    'For 1 cup (240ml) buttermilk: Add 1 tbsp (15ml) lemon juice or white vinegar to a measuring cup, fill with milk to 1 cup mark. Stir and rest 5-10 minutes until slightly curdled.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'sour_cream' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'full_fat_plain_greek_yogurt' LIMIT 1),
    1,
    'dairy',
    ARRAY['baking', 'cold_dips', 'dressings', 'taco_topping'],
    ARRAY['high_heat_boiling_soups_without_starch_stabilizer'],
    'Slightly more tart and tangy with less rich buttery dairy sweetness.',
    'Identical creamy density; slightly less glossy.',
    'Use 1:1. For hot soups or sauces, temper with a few spoonfuls of hot broth before adding to prevent curdling, or whisk in 1/2 tsp cornstarch.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'heavy_cream' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'whole_milk_melted_unsalted_butter' LIMIT 1),
    1,
    'dairy',
    ARRAY['pan_sauces', 'soups', 'casseroles', 'baking'],
    ARRAY['whipped_cream_making'],
    'Rich dairy flavor remains balanced and savory.',
    'Mimics fat content accurately (~36% fat), but lacks the emulsifiers to whip into stiff peaks.',
    'For 1 cup heavy cream: Melt 1/4 cup (57g) unsalted butter and slowly whisk into 3/4 cup (180ml) room temperature whole milk.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'heavy_cream' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'canned_coconut_cream' LIMIT 1),
    1,
    'dairy',
    ARRAY['curries', 'soups', 'vegan_desserts', 'stews', 'vegan_whipped_cream'],
    ARRAY['traditional_french_pan_sauces_requiring_neutral_dairy'],
    'Distinct, pleasant coconut aroma and subtle sweetness.',
    'Equally luscious, rich, and high in saturated fat.',
    'Chill can overnight and scoop the solid top layer for best whipping or sauce thickening results.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'butter_for_cooking' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'extra_virgin_olive_oil' LIMIT 1),
    0.75,
    'dairy',
    ARRAY['sautéing', 'roasting_vegetables', 'savory_baking_focaccia', 'pasta_finishing'],
    ARRAY['laminated_pastries_croissants', 'creaming_method_cakes'],
    'Fruity, peppery olive notes replacing milky, sweet butter notes.',
    'High moisture retention in savory baked goods; crisper vegetable roasts.',
    'Use 3/4 cup oil for every 1 cup butter because oil is 100% fat while butter is 80-82% fat and 16-18% water.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'ricotta_cheese' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'blended_small_curd_cottage_cheese' LIMIT 1),
    1,
    'dairy',
    ARRAY['lasagna', 'stuffed_shells', 'cheesecakes', 'pasta_fillings'],
    ARRAY['cannoli_filling_delicate'],
    'Slightly saltier with subtle tanginess.',
    'Smooth and velvety once blended; drains similarly.',
    'Pulse in a food processor or blender for 30 seconds until completely smooth. Strain through a fine-mesh sieve if very wet.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'parmesan_parmigiano_reggiano' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'pecorino_romano' LIMIT 1),
    0.85,
    'dairy',
    ARRAY['pasta', 'risotto', 'salads', 'gratins', 'pesto'],
    ARRAY[],
    'Noticeably saltier and sharper; sheep milk tang compared to cow milk nuttiness.',
    'Equal hard, dry grating characteristics and melting behavior.',
    'Reduce added salt in the overall recipe by ~25% to account for Pecorino''s natural salinity.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'cornstarch' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'all_purpose_wheat_flour' LIMIT 1),
    2,
    'thickeners',
    ARRAY['gravies', 'stews', 'soups', 'casseroles'],
    ARRAY['glossy_fruit_pie_fillings_clear', 'asian_stir_fry_glazes'],
    'Needs 2-3 minutes of boiling to eliminate raw wheat flour taste.',
    'Opaque and slightly cloudier rather than glossy and transparent.',
    'Use 2 tbsp all-purpose flour for every 1 tbsp cornstarch. Cook in liquid at a simmer for at least 3 minutes.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'cornstarch' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'arrowroot_powder_starch' LIMIT 1),
    1,
    'thickeners',
    ARRAY['acidic_fruit_sauces', 'clear_glazes', 'stir_fries', 'jellies'],
    ARRAY['dairy_based_sauces_causes_slimy_texture', 'extended_high_heat_braises'],
    'Completely neutral and odorless.',
    'Produces brilliant shine and clarity; holds up better in high-acid mixtures (citrus/vinegar).',
    'Whisk with equal parts cold water into a slurry. Add near the end of cooking as extended boiling breaks down arrowroot''s thickening power.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'cornstarch' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'tapioca_starch_flour' LIMIT 1),
    2,
    'thickeners',
    ARRAY['pie_fillings', 'fruit_compotes', 'gluten_free_baking'],
    ARRAY['high_shear_blending'],
    'Neutral; does not mask subtle berry or fruit flavors.',
    'Glossy, slightly chewy/gelatinous; freezes and thaws exceptionally well without weeping.',
    'Use 2 tbsp tapioca starch for every 1 tbsp cornstarch.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'egg_as_binder' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'ground_flaxseed_meal_warm_water_flax_egg' LIMIT 1),
    1,
    'thickeners',
    ARRAY['muffins', 'quick_breads', 'veggie_burgers', 'pancakes', 'cookies'],
    ARRAY['soufflés', 'meringues', 'custards', 'angel_food_cake'],
    'Subtle, nutty earthy undertone.',
    'Provides great moisture and binding; does not provide structural aeration or rise.',
    'For 1 large egg: Mix 1 tbsp (7g) finely ground flaxseed with 3 tbsp (45ml) warm water. Whisk and rest for 10 minutes until gelatinous.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'animal_gelatin' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'agar_agar_powder' LIMIT 1),
    0.5,
    'thickeners',
    ARRAY['panna_cotta', 'jellies', 'glazes', 'vegan_desserts'],
    ARRAY['marshmallows_traditional_chewy_stretch'],
    'Completely flavorless.',
    'Sets firmer and more brittle; melts at 85°C (185°F) rather than body temperature.',
    'Use 1/2 tsp agar powder per 1 tsp powdered gelatin. Must be brought to a rolling boil for 1-2 minutes to activate.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'fresh_garlic_cloves' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'garlic_powder' LIMIT 1),
    0.125,
    'aromatics',
    ARRAY['dry_rubs', 'marinades', 'soups', 'stews', 'sauces'],
    ARRAY['aglio_e_olio', 'fresh_bruschetta', 'raw_caesar_dressing'],
    'Sweeter, more concentrated, less pungent bite than raw allicin.',
    'Completely dissolves into liquids; no texture.',
    'Use 1/8 teaspoon garlic powder per 1 medium fresh garlic clove. Do not use garlic salt.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'shallots' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'minced_yellow_onion_pinch_of_minced_garlic' LIMIT 1),
    1,
    'aromatics',
    ARRAY['vinaigrettes', 'pan_sauces', 'braises', 'stir_fries'],
    ARRAY['fried_crispy_shallots_traditional_asian'],
    'Recreates the delicate, sweet allium balance of onion with a subtle garlic edge.',
    'Finely mince onion to mimic the delicate cell structure of shallot.',
    'Combine 7 parts finely minced yellow or red onion with 1 part grated garlic.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'yellow_onion_1_medium' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'scallions_green_onions_white_and_light_green_parts' LIMIT 1),
    1,
    'aromatics',
    ARRAY['stir_fries', 'fried_rice', 'frittatas', 'quick_sautés'],
    ARRAY['french_onion_soup_deep_caramelization'],
    'Fresher, more vegetal, faster cooking.',
    'Tender and less fibrous; cooks in 60 seconds vs 8 minutes.',
    'Use 6-8 scallions (chopped whites and pale greens) to equal 1 medium chopped onion.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'fresh_grated_ginger' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'ground_dried_ginger' LIMIT 1),
    0.25,
    'aromatics',
    ARRAY['marinades', 'curry_bases', 'spice_cakes', 'cookies'],
    ARRAY['ginger_scallion_sauce', 'fresh_tea_infusion', 'stir_fry_aromatic_blooming'],
    'Pungent and warming, but lacks the bright citrusy zing of fresh rhizome.',
    'Dry powder; no fibrous crunch.',
    'Use 1/4 tsp ground dried ginger per 1 tbsp fresh grated ginger.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'fresh_cilantro_coriander_leaves' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'flat_leaf_italian_parsley_fresh_lime_zest' LIMIT 1),
    1,
    'aromatics',
    ARRAY['salsa', 'guacamole', 'curry_garnish', 'marinades'],
    ARRAY[],
    'Clean herbal notes without the aldehyde soapy perception disliked by genetic non-tasters.',
    'Identical leafy texture and visual presentation.',
    'Finely chop fresh flat-leaf parsley and toss with a touch of finely grated lime zest to provide bright citrus aromatics.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'fresh_lemon_juice' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'fresh_lime_juice' LIMIT 1),
    1,
    'acids',
    ARRAY['cocktails', 'vinaigrettes', 'marinades', 'fish_seasoning', 'baking'],
    ARRAY['traditional_lemon_curd_where_specific_terpene_profile_is_key'],
    'Slightly more floral and herbaceous; equivalent ~5% citric acid concentration.',
    'Identical liquid behavior.',
    'Direct 1:1 replacement in almost every savory and baking application.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'dry_white_wine_for_cooking_deglazing' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'vegetable_or_chicken_broth_splash_of_apple_cider_vinegar' LIMIT 1),
    1,
    'acids',
    ARRAY['risotto', 'pan_deglazing', 'chicken_piccata', 'mussels', 'french_sauces'],
    ARRAY['wine_based_desserts_poached_pears'],
    'Savory depth with clean acidity, without any residual alcohol.',
    'Identical liquid reduction behavior.',
    'For 1/2 cup (120ml) white wine: Use 1/2 cup low-sodium broth mixed with 1 tsp (5ml) white wine vinegar or apple cider vinegar.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'dry_red_wine_for_braising' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'rich_beef_broth_red_wine_vinegar' LIMIT 1),
    1,
    'acids',
    ARRAY['beef_bourguignon', 'short_rib_braise', 'bolognese', 'pan_gravy'],
    ARRAY[],
    'Rich, savory umami with pleasant tartness.',
    'Reduces to a rich glossy glaze.',
    'For 1 cup red wine: Use 7/8 cup beef stock mixed with 2 tbsp red wine vinegar.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'rice_vinegar_unseasoned' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'apple_cider_vinegar_tiny_pinch_of_sugar' LIMIT 1),
    1,
    'acids',
    ARRAY['asian_dressings', 'sushi_rice', 'dipping_sauces', 'pickling'],
    ARRAY[],
    'Fruity apple notes are tempered by the pinch of sugar to match mild rice vinegar.',
    'Identical acidity level (~4-5% acetic acid).',
    'For 1 tbsp rice vinegar: Use 1 tbsp apple cider vinegar plus 1/8 tsp sugar.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'ground_beef_80_20' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'ground_turkey_93_7_1_tbsp_olive_oil_or_butter' LIMIT 1),
    1,
    'proteins',
    ARRAY['tacos', 'bolognese', 'chili', 'meatballs'],
    ARRAY['rare_smash_burgers_relying_on_beef_fat_crust'],
    'Milder, lighter poultry flavor; absorbs spices and seasonings aggressively.',
    'Leaner; adding 1 tbsp healthy fat prevents dry, chalky mouthfeel.',
    'Add 1 tbsp oil, Worcestershire sauce, or 1 tsp soy sauce to amplify savory umami depth.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'chicken_breast' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'extra_firm_tofu_pressed_and_cubed' LIMIT 1),
    1,
    'proteins',
    ARRAY['stir_fries', 'curries', 'salads', 'sheet_pan_roasts'],
    ARRAY['chicken_noodle_soup_broth_making'],
    'Neutral sponge that adopts the surrounding sauce profile completely.',
    'Pleasantly chewy when pressed of excess water and tossed in cornstarch before searing.',
    'Press with a heavy skillet for 15 minutes, cube, toss in 1 tbsp cornstarch, and pan-sear in hot oil until golden.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'pancetta_bacon_for_savory_base' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'diced_cremini_mushrooms_smoked_paprika_olive_oil' LIMIT 1),
    1,
    'proteins',
    ARRAY['pasta_carbonara_vegetarian', 'lentil_soup', 'risotto', 'braises'],
    ARRAY['strips_of_breakfast_bacon'],
    'Deep earthy umami and woodsmoke aroma without pork.',
    'Tender, meaty chew.',
    'Dice mushrooms finely and brown deeply in olive oil with 1/2 tsp smoked paprika, 1/4 tsp salt, and a dash of tamari.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'eggs_in_sweet_baking' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'unsweetened_applesauce' LIMIT 1),
    0.25,
    'proteins',
    ARRAY['brownies', 'muffins', 'quick_breads', 'soft_cookies'],
    ARRAY['meringue', 'custards', 'soufflés', 'crispy_cookies'],
    'Very subtle fruity sweetness; reduces need for added sugar slightly.',
    'Produces extremely tender, dense, moist crumb; does not aerate.',
    'Use 1/4 cup (60g) unsweetened applesauce per 1 large egg. Add 1/4 tsp extra baking powder if rise is needed.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'shrimp_in_stir_fries_pasta' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'king_oyster_mushroom_stems_sliced_into_rounds' LIMIT 1),
    1,
    'proteins',
    ARRAY['garlic_butter_scampi', 'pad_thai', 'stir_fries', 'seafood_paella'],
    ARRAY['raw_ceviche'],
    'Earthy, sweet, and absorbs garlic and white wine butter magnificently.',
    'Remarkably resilient, springy, and scallop/shrimp-like texture.',
    'Slice stems into 1/2-inch thick coins. Score crosshatch pattern on both sides and sear in butter over medium-high heat.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'baking_powder_1_tsp' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'baking_soda_1_4_tsp_cream_of_tartar_1_2_tsp' LIMIT 1),
    0.75,
    'leaveners',
    ARRAY['cakes', 'cookies', 'pancakes', 'biscuits', 'muffins'],
    ARRAY[],
    'Clean, neutral rise; no metallic aftertaste.',
    'Provides identical carbon dioxide release upon hydration and heating.',
    'For 1 tsp baking powder: Mix 1/4 tsp baking soda with 1/2 tsp cream of tartar. Use immediately after mixing wet ingredients.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'baking_soda_1_4_tsp' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'baking_powder_1_tsp' LIMIT 1),
    4,
    'leaveners',
    ARRAY['quick_breads', 'cookies', 'pancakes'],
    ARRAY['recipes_needing_soda_to_neutralize_strong_acids_like_molasses'],
    'Slightly less browning (Maillard reaction is slower without alkaline baking soda).',
    'Provides equivalent lift, but crumb may be slightly lighter in color.',
    'Use 3 to 4 times the amount of baking powder when replacing baking soda. Omit or reduce acidic ingredients if they were only present to activate the soda.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'active_dry_yeast_1_packet_7g' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'instant_rapid_rise_yeast' LIMIT 1),
    0.75,
    'leaveners',
    ARRAY['bread_dough', 'pizza_crust', 'cinnamon_rolls', 'focaccia'],
    ARRAY[],
    'Identical yeast fermentation profile.',
    'Fermentation begins faster; dough rises approximately 15-20% quicker.',
    'Use 3/4 the amount of instant yeast. No need to bloom in warm water; mix directly into dry flour.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'self_rising_flour_1_cup_120g' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'all_purpose_flour_1_cup_baking_powder_1_5_tsp_fine_salt_1_4_tsp' LIMIT 1),
    1,
    'leaveners',
    ARRAY['biscuits', 'pancakes', 'scones', 'quick_breads'],
    ARRAY['yeast_breads'],
    'Identical.',
    'Identical crumb structure and lift.',
    'Whisk together thoroughly or sift twice to ensure uniform dispersion of leavener and salt throughout the flour.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'tomato_paste_2_tbsp_30ml' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'canned_crushed_tomatoes_simmered_and_reduced' LIMIT 1),
    3,
    'aromatics',
    ARRAY['stews', 'pasta_sauces', 'soups', 'chili'],
    ARRAY['dry_rubs', 'pizza_sauce_thickening_without_extra_cooking_time'],
    'Bright, fresh tomato flavor; slightly less caramelized than double-concentrated paste.',
    'Higher water content; must be cooked down.',
    'Simmer 6 tbsp (90ml) crushed or pureed canned tomatoes in a small pan for 5 minutes until reduced to 2 tbsp paste consistency.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'honey' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'pure_maple_syrup' LIMIT 1),
    1,
    'sweeteners',
    ARRAY['vinaigrettes', 'marinades', 'glazes', 'baking', 'tea'],
    ARRAY['recipes_requiring_honey_specific_crystallization'],
    'Woody, caramel maple notes replacing floral honey notes. 100% vegan friendly.',
    'Slightly thinner viscosity at room temperature.',
    'Direct 1:1 replacement by volume.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'soy_sauce_regular' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'tamari_gluten_free' LIMIT 1),
    1,
    'condiments',
    ARRAY['all_asian_dishes', 'marinades', 'dipping_sauces', 'soups'],
    ARRAY[],
    'Rich, deeper, less harsh salinity; smoother umami profile.',
    'Slightly thicker body.',
    'Direct 1:1 replacement. Provides identical dark color and rich savory backbone while making dishes 100% wheat/gluten-free.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'fish_sauce_1_tbsp' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'soy_sauce_1_tbsp_minced_dried_nori_or_dried_shiitake_broth' LIMIT 1),
    1,
    'condiments',
    ARRAY['curries', 'pad_thai', 'pho_broth', 'asian_dressings'],
    ARRAY['raw_papaya_salad_traditional_authenticity'],
    'Provides savory glutamate umami and oceanic salinity without fish/anchovy byproduct.',
    'Identical liquid seasoning behavior.',
    'Whisk 1 tbsp dark soy sauce with 1/4 tsp lime juice and a pinch of powdered dried nori or mushroom powder.'
);
INSERT INTO ingredient_substitutions (
    original_ingredient_id, substitute_ingredient_id, conversion_ratio, category, applicable_contexts, forbidden_contexts, flavor_impact, texture_impact, preparation_note
) VALUES (
    (SELECT id FROM ingredients WHERE canonical_name = 'mayonnaise_in_sandwiches_spreads' LIMIT 1),
    (SELECT id FROM ingredients WHERE canonical_name = 'ripe_mashed_avocado_pinch_of_salt_lemon_juice' LIMIT 1),
    1,
    'dairy',
    ARRAY['sandwich_spread', 'tuna_salad', 'egg_salad', 'wraps'],
    ARRAY['emulsified_aioli', 'tartar_sauce_shelf_life'],
    'Fresh, nutty, rich healthy monounsaturated fat flavor profile.',
    'Smooth, rich, spreadable creaminess.',
    'Mash avocado until completely velvety with a squeeze of fresh lemon to prevent oxidation and provide mayo''s requisite acidity.'
);

-- 6. Ten Global Starter Recipes
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Classic Spaghetti Carbonara',
    'classic-spaghetti-carbonara',
    'Silky, authentic Roman carbonara prepared with egg yolks, Pecorino Romano, guanciale, and cracked black pepper.',
    ARRAY['Italian'],
    'pasta',
    'medium',
    10,
    15,
    4,
    650,
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-spaghetti-carbonara' LIMIT 1),
    1,
    'Boil Pasta Water',
    'Bring a large stockpot of well-salted water to a vigorous rolling boil.',
    600
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-spaghetti-carbonara' LIMIT 1),
    2,
    'Crisp Guanciale',
    'In a cold 12-inch stainless steel skillet, add sliced guanciale. Render over medium-low heat for 8 minutes until golden and crisp.',
    480
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-spaghetti-carbonara' LIMIT 1),
    3,
    'Whisk Egg Mixture',
    'In a mixing bowl, vigorously whisk egg yolks, finely grated Pecorino Romano, and generous freshly ground black pepper into a thick paste.',
    120
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-spaghetti-carbonara' LIMIT 1),
    4,
    'Combine and Emulsify',
    'Transfer al dente spaghetti directly into the guanciale skillet off the heat. Pour egg mixture and 1/4 cup hot pasta water, tossing rapidly until a glossy emulsion coats every strand.',
    180
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Authentic Chicken Adobo',
    'authentic-chicken-adobo',
    'Tender chicken braised in a savory, tangy reduction of soy sauce, cane vinegar, whole black peppercorns, bay leaves, and smashed garlic.',
    ARRAY['Filipino'],
    'braise',
    'easy',
    15,
    35,
    4,
    520,
    'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'authentic-chicken-adobo' LIMIT 1),
    1,
    'Brown Chicken',
    'Heat 1 tbsp oil in a heavy Dutch oven over medium-high heat. Sear chicken thighs skin-side down for 6 minutes until deeply browned.',
    360
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'authentic-chicken-adobo' LIMIT 1),
    2,
    'Simmer Aromatics',
    'Add smashed garlic, soy sauce, cane vinegar, water, bay leaves, and black peppercorns. Bring to a simmer, cover, and cook for 25 minutes.',
    1500
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'authentic-chicken-adobo' LIMIT 1),
    3,
    'Reduce Sauce to Glaze',
    'Remove lid, raise heat to high, and reduce sauce for 7 minutes until thick, glossy, and clinging to chicken.',
    420
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Thai Green Chicken Curry',
    'thai-green-chicken-curry',
    'Fragrant coconut milk curry with tender chicken strips, Thai basil, bamboo shoots, and green curry paste.',
    ARRAY['Thai'],
    'curry',
    'medium',
    15,
    20,
    4,
    580,
    'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'thai-green-chicken-curry' LIMIT 1),
    1,
    'Crack Coconut Cream',
    'Skim 1/2 cup of solid coconut cream from the top of the can and heat in a saucepan over medium heat until oil separates.',
    240
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'thai-green-chicken-curry' LIMIT 1),
    2,
    'Fry Curry Paste',
    'Add green curry paste to the cracked coconut oil and stir-fry for 2 minutes until intensely aromatic.',
    120
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'thai-green-chicken-curry' LIMIT 1),
    3,
    'Simmer Chicken & Basil',
    'Add chicken strips, remaining coconut milk, fish sauce, and palm sugar. Simmer for 12 minutes, then fold in fresh Thai basil leaves.',
    720
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Classic French Rolled Omelet',
    'classic-french-rolled-omelet',
    'Pale golden, tender exterior with a soft, creamy custard center, finished with butter gloss and minced fresh chives.',
    ARRAY['French'],
    'breakfast',
    'medium',
    5,
    3,
    1,
    310,
    'https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-french-rolled-omelet' LIMIT 1),
    1,
    'Beat Eggs Smooth',
    'Whisk 3 large room-temperature eggs with a pinch of fine salt until completely homogenous without visible albumen streaks.',
    90
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-french-rolled-omelet' LIMIT 1),
    2,
    'Vigorous Scramble',
    'Melt 1.5 tbsp butter in a 10-inch nonstick pan over medium-low heat. Pour in eggs and shake pan rapidly while stirring vigorously in circles with a fork.',
    90
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'classic-french-rolled-omelet' LIMIT 1),
    3,
    'Roll and Plate',
    'Smooth surface, tilt pan forward, tap handle with palm to roll omelet onto itself, and invert seam-side down onto a warm plate. Rub surface with cold butter.',
    45
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'North African Shakshuka',
    'north-african-shakshuka',
    'Gently poached eggs in a spiced, chunky tomato, bell pepper, and onion sauce with cumin, paprika, and crumbled feta cheese.',
    ARRAY['Middle Eastern'],
    'breakfast_skillet',
    'easy',
    10,
    25,
    4,
    340,
    'https://images.unsplash.com/photo-1590412200988-a436970781fa?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'north-african-shakshuka' LIMIT 1),
    1,
    'Sauté Aromatics',
    'Heat olive oil in a 12-inch skillet. Sauté onions and bell peppers for 8 minutes until tender and sweet.',
    480
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'north-african-shakshuka' LIMIT 1),
    2,
    'Simmer Tomato Sauce',
    'Add minced garlic, cumin, paprika, and crushed canned tomatoes. Simmer on medium-low for 12 minutes until thickened.',
    720
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'north-african-shakshuka' LIMIT 1),
    3,
    'Poach Eggs in Wells',
    'Create 4 small wells with a spoon, crack eggs into the wells, cover skillet, and simmer for 6 minutes until egg whites are set and yolks remain runny.',
    360
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Szechuan Beef & Broccoli Stir-Fry',
    'szechuan-beef-and-broccoli-stir-fry',
    'Thinly sliced flank steak seared at screaming heat, tossed with crisp broccoli florets and a savory ginger-garlic soy glaze.',
    ARRAY['Chinese'],
    'stir_fry',
    'medium',
    20,
    8,
    4,
    480,
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'szechuan-beef-and-broccoli-stir-fry' LIMIT 1),
    1,
    'Blanch Broccoli',
    'Drop broccoli florets in boiling water for 60 seconds, drain and shock in ice water to lock in deep green color and crunch.',
    60
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'szechuan-beef-and-broccoli-stir-fry' LIMIT 1),
    2,
    'High-Heat Sear',
    'Heat 1 tbsp oil in a smoking wok or stainless skillet. Spread marinated beef in a single layer and sear without moving for 90 seconds per side.',
    180
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'szechuan-beef-and-broccoli-stir-fry' LIMIT 1),
    3,
    'Toss with Sauce',
    'Add ginger, garlic, blanched broccoli, and sauce slurry. Toss furiously for 60 seconds until sauce thickens to a lacquer.',
    60
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Creamy Red Lentil Dahl',
    'creamy-red-lentil-dahl',
    'Hearty, comforting red lentils simmered in coconut milk, turmeric, and ginger, finished with a sizzling tempered cumin-mustard seed tadka.',
    ARRAY['Indian'],
    'soup_stew',
    'easy',
    10,
    25,
    4,
    390,
    'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'creamy-red-lentil-dahl' LIMIT 1),
    1,
    'Simmer Lentils',
    'Combine rinsed red lentils, water, coconut milk, turmeric, and grated ginger in a saucepan. Simmer for 20 minutes until lentils melt tender.',
    1200
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'creamy-red-lentil-dahl' LIMIT 1),
    2,
    'Prepare Tadka',
    'In a small skillet, heat ghee or coconut oil. Fry whole cumin seeds and mustard seeds until they pop and release fragrant oils (30 seconds).',
    30
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'creamy-red-lentil-dahl' LIMIT 1),
    3,
    'Sizzle and Swirl',
    'Pour the hot sizzling spiced tadka oil directly over the cooked dahl and stir in fresh cilantro and lime juice.',
    60
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Provencal Vegetable Ratatouille',
    'provencal-vegetable-ratatouille',
    'Layers of tender summer vegetables (eggplant, zucchini, yellow squash, bell pepper) slow-simmered in a rich tomato, garlic, and thyme reduction.',
    ARRAY['French'],
    'vegetable_stew',
    'medium',
    25,
    40,
    6,
    220,
    'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'provencal-vegetable-ratatouille' LIMIT 1),
    1,
    'Brown Eggplant & Squash',
    'Sauté salted eggplant cubes and zucchini in hot olive oil until golden; set aside.',
    600
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'provencal-vegetable-ratatouille' LIMIT 1),
    2,
    'Build Pipérade Sauce',
    'Cook onions, peppers, garlic, and fresh thyme in olive oil until soft, then simmer with crushed tomatoes for 15 minutes.',
    900
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'provencal-vegetable-ratatouille' LIMIT 1),
    3,
    'Braid and Bake',
    'Combine browned vegetables into the sauce, cover, and simmer on low for 25 minutes until all vegetables are meltingly tender.',
    1500
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Fresh Molcajete Guacamole',
    'fresh-molcajete-guacamole',
    'Silky yet chunky ripe Hass avocados crushed in a mortar with raw lime juice, diced jalapeño, sweet white onion, and cilantro.',
    ARRAY['Mexican'],
    'dips',
    'easy',
    10,
    0,
    4,
    240,
    'https://images.unsplash.com/photo-1584278860047-22db9ff82bed?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'fresh-molcajete-guacamole' LIMIT 1),
    1,
    'Grind Aromatic Paste',
    'In a granite mortar or bowl, crush diced white onion, jalapeño, cilantro stems, and coarse salt with a pestle until a fragrant paste forms.',
    120
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'fresh-molcajete-guacamole' LIMIT 1),
    2,
    'Coarsely Mash Avocado',
    'Halve avocados, scoop flesh into mortar, and mash with pestle or fork, leaving substantial tender chunks for texture.',
    90
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'fresh-molcajete-guacamole' LIMIT 1),
    3,
    'Season and Fold',
    'Gently fold in fresh lime juice and chopped cilantro leaves. Taste and adjust salt before serving with warm tortilla chips.',
    60
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipes (
    author_id, title, slug, description, cuisine_tags, category, difficulty, prep_time_minutes, cook_time_minutes, servings, calories_per_serving, hero_image_url, status, average_rating, ratings_count
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'No-Knead Overnight Sourdough Boule',
    'no-knead-overnight-sourdough-boule',
    'Crisp, blistered artisanal crust with an open, airy, chewy crumb baked in an enameled cast iron Dutch oven.',
    ARRAY['Universal'],
    'bread',
    'hard',
    30,
    45,
    8,
    210,
    'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=800&q=80',
    'published',
    4.90,
    18
) ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'no-knead-overnight-sourdough-boule' LIMIT 1),
    1,
    'Autolyse & Mix',
    'Combine bread flour, water, active sourdough starter, and salt into a shaggy dough. Rest covered for 30 minutes.',
    1800
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'no-knead-overnight-sourdough-boule' LIMIT 1),
    2,
    'Stretch and Fold',
    'Perform 4 sets of stretch-and-folds spaced 30 minutes apart, then bulk ferment for 6 hours until puffy and aerated.',
    7200
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
INSERT INTO recipe_steps (
    recipe_id, step_number, title, instruction, timer_duration_seconds
) VALUES (
    (SELECT id FROM recipes WHERE slug = 'no-knead-overnight-sourdough-boule' LIMIT 1),
    3,
    'Cold Retard & Dutch Oven Bake',
    'Shape into a taut boule, proof overnight in banneton in fridge. Score top and bake covered at 450°F (230°C) for 25 min, then uncovered for 20 min until deep chestnut brown.',
    2700
) ON CONFLICT (recipe_id, step_number) DO UPDATE SET instruction = EXCLUDED.instruction;
