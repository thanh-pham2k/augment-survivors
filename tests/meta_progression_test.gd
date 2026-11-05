extends SceneTree

func _init() -> void:
	print("\n[QA TEST] Starting Gameplay 2.0 Meta-Progression & System Verification...")
	
	const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
	var sm = SaveManagerClass.get_instance()
	assert(sm != null, "SaveManager singleton instance must exist!")
	sm.reset_to_defaults()
	
	# 1. Test SaveManager & File Persistence
	print(" -> Testing SaveManager Persistence & Transactions...")
	var start_gold = sm.gold
	sm.add_gold(150)
	assert(sm.gold == start_gold + 150, "Gold addition failed!")
	
	var spend_success = sm.spend_gold(50)
	assert(spend_success == true, "Spend gold should succeed with sufficient balance!")
	assert(sm.gold == start_gold + 100, "Gold balance after spending incorrect!")
	
	var spend_fail = sm.spend_gold(9999999)
	assert(spend_fail == false, "Spend gold should fail when balance is insufficient!")
	print("    [PASS] Gold transactions verified.")
	
	# 2. Test Weapon Upgrades & Damage Scaling
	print(" -> Testing Weapon Upgrades & Damage Scaling...")
	var base_dmg = sm.get_weapon_damage("inferno_staff")
	assert(base_dmg == 25.0, "Inferno Staff base damage at Lv.1 must be 25.0!")
	
	var upgraded = sm.upgrade_weapon("inferno_staff", 50)
	assert(upgraded == true, "Weapon upgrade to Lv.2 should succeed!")
	assert(sm.weapon_levels["inferno_staff"] == 2, "Inferno Staff level must now be 2!")
	var lvl2_dmg = sm.get_weapon_damage("inferno_staff")
	assert(lvl2_dmg == 31.25, "Inferno Staff damage at Lv.2 must be 31.25 (1.25x)!")
	print("    [PASS] Weapon upgrade mechanics and math verified.")
	
	# 3. Test Meta Upgrades (Blacksmith Shop)
	print(" -> Testing Blacksmith Meta Upgrades...")
	var initial_hp_lvl = sm.meta_upgrades.get("max_hp", 0)
	var meta_success = sm.upgrade_meta("max_hp", 40)
	assert(meta_success == true, "Max HP meta upgrade should succeed!")
	assert(sm.meta_upgrades["max_hp"] == initial_hp_lvl + 1, "Max HP level must increase by 1!")
	print("    [PASS] Meta shop upgrades verified.")
	
	# 4. Test Equipment Loadout & Inventory
	print(" -> Testing Equipment Loadout & Slot Selection...")
	sm.equipped_weapon = "storm_gauntlet"
	sm.equipped_armor = "armor_glacial_plate"
	sm.equipped_relic_1 = "relic_arc_capacitor"
	sm.equipped_relic_2 = "relic_frost_armor"
	sm.save_game()
	
	assert(sm.equipped_weapon == "storm_gauntlet", "Equipped weapon must be storm_gauntlet!")
	assert(sm.get_weapon_element("storm_gauntlet") == GlobalEnums.ElementType.LIGHTNING, "Storm Gauntlet must be LIGHTNING!")
	print("    [PASS] Equipment loadout slots verified.")
	
	# 5. Test Map Selection
	print(" -> Testing Map Selection & Multipliers...")
	sm.selected_map = "magma"
	sm.save_game()
	assert(sm.selected_map == "magma", "Selected map must be magma!")
	print("    [PASS] Map selection verified.")
	
	# 6. Test Scene Instantiations
	print(" -> Testing Scene Instantiation (EquipmentUI, MetaShopUI, MapSelectUI)...")
	var equip_scene = load("res://scenes/ui/equipment_ui.tscn")
	var equip_instance = equip_scene.instantiate() as EquipmentUI
	root.add_child(equip_instance)
	await process_frame
	assert(equip_instance.weapon_name_label.text.contains("Storm Gauntlet"), "EquipmentUI must display equipped Storm Gauntlet!")
	equip_instance.queue_free()
	
	var shop_scene = load("res://scenes/ui/meta_shop_ui.tscn")
	var shop_instance = shop_scene.instantiate() as MetaShopUI
	root.add_child(shop_instance)
	await process_frame
	assert(shop_instance.grid_container.get_child_count() == 5, "MetaShopUI must build 5 upgrade rows!")
	shop_instance.queue_free()
	
	var map_scene = load("res://scenes/ui/map_select_ui.tscn")
	var map_instance = map_scene.instantiate() as MapSelectUI
	root.add_child(map_instance)
	await process_frame
	assert(map_instance.btn_cathedral != null, "MapSelectUI must have Cathedral button!")
	assert(map_instance.btn_magma != null, "MapSelectUI must have Magma button!")
	assert(map_instance.btn_frost != null, "MapSelectUI must have Frost button!")
	map_instance.queue_free()
	print("    [PASS] All UI scenes instantiated and validated successfully.")
	
	# 7. Test GameplayStage Profile Injection
	print(" -> Testing GameplayStage Profile Integration...")
	var stage_scene = load("res://scenes/combat/gameplay_stage.tscn")
	var stage_instance = stage_scene.instantiate() as GameplayStage
	root.add_child(stage_instance)
	await process_frame
	
	assert(stage_instance.player.active_weapon.id == "storm_gauntlet", "Player in combat must have Storm Gauntlet equipped!")
	assert(stage_instance.arena.current_biome == "magma", "Arena must initialize with magma biome!")
	assert(stage_instance.player.max_health > 120.0, "Player max health must reflect Glacial Plate and Max HP meta upgrades!")
	stage_instance.queue_free()
	print("    [PASS] Combat stage seamlessly applied save data profile.")
	
	print("\n[QA TEST] ALL GAMEPLAY 2.0 META PROGRESSION TESTS PASSED! Exit code 0.\n")
	quit(0)
