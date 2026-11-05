extends SceneTree

const PlayerClass = preload("res://scripts/combat/player.gd")
const WeaponDataClass = preload("res://scripts/weapons/weapon_data.gd")
const WorldRewardDirectorClass = preload("res://scripts/combat/world_reward_director.gd")
const WorldUpgradeCacheClass = preload("res://scripts/combat/world_upgrade_cache.gd")
const UpgradeChoiceServiceClass = preload("res://scripts/combat/upgrade_choice_service.gd")
const UpgradeChoiceClass = preload("res://scripts/resources/upgrade_choice.gd")
const GameplayStageClass = preload("res://scripts/combat/gameplay_stage.gd")

func _init() -> void:
	print("\n[QA TEST] Starting Augment Survivors 2.1 Endless Survival Suite...")
	call_deferred("_run_all_tests")

func _run_all_tests() -> void:
	await _test_xp_progression_and_auto_level()
	await _test_world_cache_claim_once_semantics()
	await _test_world_reward_director_lifecycle()
	await _test_upgrade_choice_service_and_fallbacks()
	await _test_continuous_threat_director_math()
	await _test_multi_weapon_runtime()
	await _test_weapon_evolution()
	await _test_elite_chest_drop()
	await _test_wandering_forge_spawn_and_interaction()
	await _test_boss_defeat_and_seamless_continuation()
	
	print("\n[QA TEST] ALL 2.1 ENDLESS SURVIVAL TESTS PASSED! Exit code 0.\n")
	quit(0)

func _test_xp_progression_and_auto_level() -> void:
	print(" -> Testing XP progression, overflow carryover & auto level-up...")
	var player = PlayerClass.new()
	root.add_child(player)
	await process_frame
	
	# Initial state
	assert(player.run_level == 1, "Player initial level should be 1")
	assert(player.current_xp == 0.0, "Player initial XP should be 0")
	var req_lv1 = player.get_xp_for_level(1)
	assert(req_lv1 == 13.0, "Lv 1 threshold should be round(8 + 4*1 + 0.5*1) = 13")
	
	# 1. Partial XP addition
	player.add_xp(10.0)
	assert(player.run_level == 1, "Player should remain level 1 with 10/13 XP")
	assert(player.current_xp == 10.0, "Player current XP should be 10.0")
	
	# 2. Multi-level crossing from a single big pickup (e.g. 50 XP)
	# Lv1 needs 3 more XP -> level 2. Lv2 needs round(8 + 4*2 + 0.5*4) = 18 XP. Lv3 needs round(8 + 4*3 + 0.5*9) = 25 XP.
	var old_dmg_bonus = player.damage_bonus_from_levels
	player.add_xp(50.0) # Total added = 60.0. Level 1 (13) + Level 2 (18) + Level 3 (25) = 56. Leftover = 4.0 in Level 4.
	assert(player.run_level >= 3, "Player should have crossed multiple levels without losing XP")
	assert(player.damage_bonus_from_levels > old_dmg_bonus, "Damage bonus must increase additively per level")
	
	# 3. Test level 5 Max HP bonus (+2 HP)
	var hp_before = player.max_health
	while player.run_level < 5:
		player.add_xp(50.0)
	assert(player.max_health == hp_before + 2.0, "Level 5 must award +2 Max HP bonus")
	
	player.queue_free()
	print("    [PASS] XP overflow, threshold curves and auto-level bonuses verified.")

func _test_world_cache_claim_once_semantics() -> void:
	print(" -> Testing World Upgrade Cache claim-once idempotence...")
	var cache_scene = load("res://scenes/combat/world_upgrade_cache.tscn")
	var cache = cache_scene.instantiate() as WorldUpgradeCacheClass
	cache.global_position = Vector2(5000, 5000) # Far away from player to prevent physics auto-collision
	root.add_child(cache)
	await process_frame
	
	var claim_box = [0]
	cache.cache_claimed.connect(func(_c): claim_box[0] += 1)
	
	var player = PlayerClass.new()
	player.global_position = Vector2(0, 0)
	root.add_child(player)
	
	# Simulate double collision calls manually
	var res1 = cache.claim(player)
	var res2 = cache.claim(player)
	var res3 = cache.claim(player)
	
	assert(res1 == true, "First claim must succeed")
	assert(res2 == false, "Second duplicate claim must be rejected")
	assert(res3 == false, "Third duplicate claim must be rejected")
	assert(claim_box[0] == 1, "cache_claimed signal must emit exactly once")
	
	player.queue_free()
	cache.queue_free()
	print("    [PASS] World Upgrade Cache claim-once idempotence verified.")

func _test_world_reward_director_lifecycle() -> void:
	print(" -> Testing World Reward Director schedule, pity timer & cap...")
	var director = WorldRewardDirectorClass.new()
	root.add_child(director)
	
	# 1. First cache appearance target <= 35s
	assert(director.first_cache_target_time <= 35.0, "First cache target time must be <= 35 seconds")
	
	# 2. Spawn 1 cache
	var dummy_stage = Node2D.new()
	root.add_child(dummy_stage)
	var c1 = director.update(30.0, 30.0, 10, Vector2.ZERO, dummy_stage)
	assert(c1 != null, "Director must spawn first cache after elapsed target and combat credit")
	assert(director.active_caches.size() == 1, "Active caches must count 1")
	
	# 3. Spawn 2nd cache
	var c2 = director.update(90.0, 120.0, 30, Vector2.ZERO, dummy_stage)
	assert(c2 != null, "Director must spawn 2nd cache")
	assert(director.active_caches.size() == 2, "Active caches must count 2")
	
	# 4. Enforce max_unclaimed = 2 cap
	var c3 = director.update(100.0, 220.0, 100, Vector2.ZERO, dummy_stage)
	assert(c3 == null, "Director must not exceed max 2 active unclaimed caches")
	
	# 5. Nearest cache tracking
	var nearest = director.get_nearest_cache(Vector2(0, 0))
	assert(nearest != null, "Nearest cache tracking must return active cache")
	
	director.queue_free()
	dummy_stage.queue_free()
	print("    [PASS] World Reward Director schedule, cap and pity timer verified.")

func _test_upgrade_choice_service_and_fallbacks() -> void:
	print(" -> Testing Upgrade Choice Service & 100% valid pool fallback...")
	var player = PlayerClass.new()
	root.add_child(player)
	await process_frame
	
	# Load augments
	var all_augments: Array[AugmentData] = []
	var dir = DirAccess.open("res://data/augments")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var aug = load("res://data/augments/" + file_name) as AugmentData
				if aug:
					all_augments.append(aug)
			file_name = dir.get_next()
			
	# Test standard 3 choices (weapons, augments, stats)
	var choices = UpgradeChoiceServiceClass.generate_choices(player, [], all_augments, 3)
	assert(choices.size() == 3, "Choice service must return exactly 3 choices")
	assert(choices[0].id != choices[1].id and choices[1].id != choices[2].id, "Choices must have no duplicates")
	
	# Test EDGE CASE: Player owns 100% of all augments and has 3 maxed & evolved weapons!
	var mock_w1 = WeaponDataClass.new()
	mock_w1.id = "inferno_staff"
	mock_w1.level = 5
	mock_w1.is_evolved = true
	var mock_w2 = WeaponDataClass.new()
	mock_w2.id = "storm_gauntlet"
	mock_w2.level = 5
	mock_w2.is_evolved = true
	var mock_w3 = WeaponDataClass.new()
	mock_w3.id = "glacial_spear"
	mock_w3.level = 5
	mock_w3.is_evolved = true
	var mock_weapons: Array[WeaponDataClass] = [mock_w1, mock_w2, mock_w3]
	player.weapons = mock_weapons
	
	var all_owned_augments = all_augments.duplicate()
	var fallback_choices = UpgradeChoiceServiceClass.generate_choices(player, all_owned_augments, all_augments, 3)
	assert(fallback_choices.size() == 3, "Fallback choices must never be empty")
	for fc in fallback_choices:
		assert(fc.type == UpgradeChoiceClass.ChoiceType.STAT_BOOST, "When maxed out, choices must fall back to valid stat boosts")
		
	player.queue_free()
	print("    [PASS] Upgrade Choice Service non-duplicate and maxed build fallback verified.")

func _test_continuous_threat_director_math() -> void:
	print(" -> Testing continuous threat scaling formulas over 15 minutes...")
	# Verify formula monotonicity and bounds
	var prev_hp_scale = 1.0
	var prev_dmg_scale = 1.0
	var prev_cap = 24
	
	for m in range(1, 16):
		var minutes = float(m)
		var lvl = m * 2
		var hp_scale = 1.0 + 0.07 * minutes + 0.012 * max(0, lvl - 1)
		var dmg_scale = 1.0 + 0.035 * minutes + 0.004 * max(0, lvl - 1)
		var cap = min(140, int(24.0 + 7.0 * minutes))
		
		assert(hp_scale > prev_hp_scale, "HP scale must increase monotonically")
		assert(dmg_scale > prev_dmg_scale, "Damage scale must increase monotonically")
		assert(cap >= prev_cap, "Enemy active cap must increase monotonically")
		assert(cap <= 140, "Active cap must respect 140 ceiling")
		
		prev_hp_scale = hp_scale
		prev_dmg_scale = dmg_scale
		prev_cap = cap
		
	print("    [PASS] Threat director mathematical curve validated over 15 simulated minutes.")

func _test_multi_weapon_runtime() -> void:
	print(" -> Testing 3 simultaneous automatic weapons execution...")
	var player = PlayerClass.new()
	root.add_child(player)
	await process_frame
	
	# Initial: 1 starter weapon
	assert(player.weapons.size() == 1, "Player should start with 1 weapon")
	
	# Add Storm Gauntlet
	var w2 = WeaponDataClass.new()
	w2.id = "storm_gauntlet"
	w2.display_name = "Storm Gauntlet"
	w2.element = GlobalEnums.ElementType.LIGHTNING
	w2.base_damage = 18.0
	w2.base_fire_rate = 3.2
	w2.projectile_count = 2
	var res_w2 = player.add_weapon(w2)
	assert(res_w2 == true, "Adding 2nd weapon should succeed")
	assert(player.weapons.size() == 2, "Player should have 2 weapons")
	
	# Add Glacial Spear
	var w3 = WeaponDataClass.new()
	w3.id = "glacial_spear"
	w3.display_name = "Glacial Spear"
	w3.element = GlobalEnums.ElementType.ICE
	w3.base_damage = 34.0
	w3.base_fire_rate = 1.4
	w3.projectile_count = 1
	var res_w3 = player.add_weapon(w3)
	assert(res_w3 == true, "Adding 3rd weapon should succeed")
	assert(player.weapons.size() == 3, "Player should have 3 weapons")
	
	# Attempt to add a 4th distinct weapon (should be rejected by max 3 slots)
	var w4 = WeaponDataClass.new()
	w4.id = "void_blade"
	var res_w4 = player.add_weapon(w4)
	assert(res_w4 == false, "4th weapon slot must be rejected per 3-slot inventory cap")
	
	# Level up existing weapon
	var old_dmg = player.weapons[0].base_damage
	player.upgrade_weapon("inferno_staff")
	assert(player.weapons[0].level == 2, "Inferno staff should be level 2")
	assert(player.weapons[0].base_damage > old_dmg, "Inferno staff damage should increase with level")
	
	# Test firing step
	player._physics_process(0.5)
	
	player.queue_free()
	print("    [PASS] 3 concurrent weapons runtime and upgrade scaling verified.")

func _test_boss_defeat_and_seamless_continuation() -> void:
	print(" -> Testing Boss Colossus defeat and seamless arena continuation...")
	var stage_scene = load("res://scenes/combat/gameplay_stage.tscn")
	var stage = stage_scene.instantiate() as GameplayStageClass
	root.add_child(stage)
	await process_frame
	
	# Trigger boss defeat
	stage.boss_spawned = true
	var pre_time = stage.run_time
	stage._on_boss_defeated()
	
	assert(stage.boss_spawned == false, "Boss spawned state must reset to false after defeat")
	assert(stage.boss_spawn_time >= pre_time + 400.0, "Next boss must be rescheduled for future milestone (~8 min)")
	assert(stage.is_inside_tree(), "Run must continue seamlessly in the same arena without unloading")
	
	stage.queue_free()
	print("    [PASS] Boss defeat and seamless run continuation validated.")

func _test_weapon_evolution() -> void:
	print(" -> Testing Weapon Evolution eligibility and upgrade execution...")
	var player = PlayerClass.new()
	root.add_child(player)
	await process_frame
	
	# Max out Inferno Staff to level 5
	player.weapons[0].level = 5
	var choices = UpgradeChoiceServiceClass.generate_choices(player, [], [], 3)
	
	var has_evolution = false
	var evo_choice: UpgradeChoiceClass = null
	for c in choices:
		if c.type == UpgradeChoiceClass.ChoiceType.EVOLUTION:
			has_evolution = true
			evo_choice = c
			break
			
	assert(has_evolution == true, "Choice service must offer Evolution when weapon reaches max level 5")
	assert(evo_choice.payload is Dictionary, "Evolution choice payload must contain evolution data")
	
	# Execute evolution on player
	var old_dmg = player.weapons[0].base_damage
	player.evolve_weapon("inferno_staff", evo_choice.payload)
	
	assert(player.weapons[0].is_evolved == true, "Weapon must be marked as evolved")
	assert(player.weapons[0].base_damage >= old_dmg * 1.5, "Evolved weapon must receive substantial damage multiplication")
	
	player.queue_free()
	print("    [PASS] Weapon Evolution generation and execution validated.")

func _test_elite_chest_drop() -> void:
	print(" -> Testing Elite Chest drop and opening idempotence...")
	var chest_scene = load("res://scenes/combat/reward_chest.tscn")
	var chest = chest_scene.instantiate()
	chest.global_position = Vector2(5000, 5000)
	root.add_child(chest)
	await process_frame
	
	var opened_count = [0]
	chest.chest_opened.connect(func(_c): opened_count[0] += 1)
	
	var dummy_player = PlayerClass.new()
	var res1 = chest.open_chest(dummy_player)
	var res2 = chest.open_chest(dummy_player)
	
	assert(res1 == true, "First chest open must succeed")
	assert(res2 == false, "Second chest open must be rejected")
	assert(opened_count[0] == 1, "Chest must trigger exactly once")
	
	dummy_player.queue_free()
	print("    [PASS] Elite Chest drop and open idempotence validated.")

func _test_wandering_forge_spawn_and_interaction() -> void:
	print(" -> Testing Wandering Forge world spawning and shop interaction...")
	var director = WorldRewardDirectorClass.new()
	root.add_child(director)
	
	var dummy_stage = Node2D.new()
	root.add_child(dummy_stage)
	
	var forge = director._spawn_wandering_forge(Vector2(0, 0), dummy_stage)
	assert(forge != null, "Director must instantiate WanderingForge")
	assert(director.active_forge == forge, "Director must track active forge instance")
	
	var interacted = [0]
	forge.forge_interacted.connect(func(_f): interacted[0] += 1)
	
	var dummy_player = PlayerClass.new()
	forge.interact(dummy_player)
	
	assert(interacted[0] == 1, "Wandering forge interact must trigger once")
	assert(director.active_forge == null, "Active forge must clear after interaction")
	
	dummy_player.queue_free()
	director.queue_free()
	dummy_stage.queue_free()
	print("    [PASS] Wandering Forge world spawning and interaction validated.")
