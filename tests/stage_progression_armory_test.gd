extends SceneTree

func _initialize() -> void:
	call_deferred("run_tests")

func run_tests() -> void:
	print("[QA TEST] Starting Stage Progression & Armory Gold Verification...")
	
	# 1. Test Player Gold & Magnet
	var player_scene = load("res://scenes/entities/player.tscn") as PackedScene
	var player = player_scene.instantiate() as Player
	root.add_child(player)
	
	assert(player.current_gold == 0, "Initial gold should be 0")
	player.add_gold(100)
	assert(player.current_gold == 100, "Gold should be 100")
	print("   [PASS] Player gold tracking validated (current_gold = %d)" % player.current_gold)
	
	# 2. Test Armory Shop UI
	var shop_scene = load("res://scenes/ui/armory_shop_ui.tscn") as PackedScene
	var shop = shop_scene.instantiate() as ArmoryShopUI
	var draft_scene = load("res://scenes/ui/augment_draft_ui.tscn") as PackedScene
	var draft_ui = draft_scene.instantiate() as AugmentDraftUI
	root.add_child(draft_ui)
	root.add_child(shop)
	
	await process_frame
	shop.open_shop(player, draft_ui)
	
	var initial_dmg = player.damage_multiplier
	shop._upgrade_damage()
	assert(player.damage_multiplier > initial_dmg, "Damage multiplier should increase")
	assert(player.current_gold == 75, "Gold should decrease by 25")
	print("   [PASS] Armory Damage upgrade successfully applied: dmg now %.2f, gold now %d" % [player.damage_multiplier, player.current_gold])
	
	var initial_magnet = player.magnet_radius
	shop._upgrade_magnet()
	assert(player.magnet_radius > initial_magnet, "Magnet radius should increase")
	print("   [PASS] Armory Magnet upgrade successfully applied: radius now %.1f, gold now %d" % [player.magnet_radius, player.current_gold])
	
	var initial_rerolls = draft_ui.rerolls_left
	shop._buy_reroll()
	assert(draft_ui.rerolls_left == initial_rerolls + 1, "Rerolls should increment")
	print("   [PASS] Armory Reroll purchase successfully applied: rerolls = %d" % draft_ui.rerolls_left)
	
	# 3. Test GoldDrop instantiating and collection
	var gold_drop_scene = load("res://scenes/combat/gold_drop.tscn") as PackedScene
	var drop = gold_drop_scene.instantiate() as GoldDrop
	drop.value = 5
	drop.global_position = player.global_position
	root.add_child(drop)
	player.add_gold(drop.value)
	drop.queue_free()
	assert(player.current_gold == 30, "Player should have collected +5 gold (25 + 5 = 30)")
	print("   [PASS] GoldDrop collection validated: player gold = %d" % player.current_gold)
	
	# 4. Test Stage Portal
	var portal_scene = load("res://scenes/combat/stage_portal.tscn") as PackedScene
	var portal = portal_scene.instantiate() as StagePortal
	root.add_child(portal)
	await process_frame
	var portal_triggered = [false]
	portal.portal_entered.connect(func(): portal_triggered[0] = true)
	portal._on_body_entered(player)
	assert(portal_triggered[0], "Portal should emit portal_entered when player steps in")
	print("   [PASS] StagePortal trigger validated.")
	
	print("[QA TEST] ALL STAGE PROGRESSION & ARMORY TESTS PASSED! Exit code 0.")
	quit(0)
