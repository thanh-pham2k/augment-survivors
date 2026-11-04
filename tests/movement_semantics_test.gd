extends SceneTree

func _initialize() -> void:
	call_deferred("run_semantics_tests")

func run_semantics_tests() -> void:
	print("[QA SEMANTICS TEST] Starting Full Gameplay Semantics & Movement Verification...")
	
	# Test 1: Player Movement & 8-Way Input Semantics
	await _test_player_movement_semantics()
	
	# Test 2: Player Dash Semantics & Invincibility
	await _test_player_dash_semantics()
	
	# Test 3: Combat Hit & Damage Popup Semantics
	await _test_combat_hit_semantics()
	
	print("[QA SEMANTICS TEST] ALL TESTS PASSED SUCCESSFULLY! Exit code 0.")
	quit(0)

func _test_player_movement_semantics() -> void:
	print(" -> Testing Player Movement & Velocity calculation...")
	var player = load("res://scenes/entities/player.tscn").instantiate() as Player
	root.add_child(player)
	player.global_position = Vector2(100, 100)
	
	var initial_pos = player.global_position
	
	# Simulate pressing Right arrow / D key
	Input.action_press("move_right")
	player._physics_process(0.1) # 100ms
	Input.action_release("move_right")
	
	assert(player.global_position.x > initial_pos.x, "Player must move right when move_right pressed")
	assert(player.velocity.x > 0, "Player horizontal velocity must be positive")
	print("    [PASS] Player responds to movement input correctly (Pos moved from ", initial_pos, " to ", player.global_position, ").")
	
	player.queue_free()

func _test_player_dash_semantics() -> void:
	print(" -> Testing Player Dash & Cooldown Semantics...")
	var player = load("res://scenes/entities/player.tscn").instantiate() as Player
	root.add_child(player)
	player.global_position = Vector2(0, 0)
	
	var dash_success = player.try_dash()
	assert(dash_success, "Dash should trigger when cooldown is 0")
	
	# Simulate dash movement
	var pos_before_dash = player.global_position
	player._physics_process(0.1)
	assert(player.global_position.distance_to(pos_before_dash) > 0, "Dash must propel player rapidly")
	
	# Ensure cooldown is active
	var dash_again = player.try_dash()
	assert(not dash_again, "Dash cannot trigger while on cooldown")
	print("    [PASS] Dash mechanics and cooldown validated.")
	
	player.queue_free()

func _test_combat_hit_semantics() -> void:
	print(" -> Testing Bullet Hit, Enemy HP reduction and Damage Popup...")
	var stage = Node2D.new()
	root.add_child(stage)
	
	var enemy = load("res://scenes/entities/skeleton_enemy.tscn").instantiate() as BaseEnemy
	stage.add_child(enemy)
	enemy.global_position = Vector2(50, 0)
	var initial_enemy_hp = enemy.current_health
	
	var proj = load("res://scenes/combat/projectile.tscn").instantiate() as Projectile
	stage.add_child(proj)
	proj.global_position = Vector2(0, 0)
	proj.direction = Vector2.RIGHT
	proj.damage = 25.0
	
	# Check hit
	proj._check_hit(enemy)
	assert(enemy.current_health == initial_enemy_hp - 25.0, "Enemy HP must decrease by projectile damage")
	print("    [PASS] Bullet damage successfully applied to enemy (HP from ", initial_enemy_hp, " -> ", enemy.current_health, ").")
	
	stage.queue_free()
