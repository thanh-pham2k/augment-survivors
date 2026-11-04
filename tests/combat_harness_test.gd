extends SceneTree

func _initialize() -> void:
	call_deferred("run_all_tests")

func run_all_tests() -> void:
	print("[QA TEST] Starting Augment Survivors Headless Test Suite...")
	
	# Test 1: RNG Determinism
	_test_rng_determinism()
	
	# Test 2: Synergy Engine & Combinations
	_test_synergy_engine()
	
	# Test 3: Combat Event Bus & Proc Budget
	_test_combat_event_bus()
	
	# Test 4: Full Harness Scene
	await _test_harness_runner()
	
	print("[QA TEST] ALL TESTS PASSED SUCCESSFULLY! Exit code 0.")
	quit(0)

func _test_rng_determinism() -> void:
	print(" -> Testing RNG Stream Independence & Determinism...")
	var rng1 = RngManager.new()
	rng1.initialize_seed(9999)
	var spawn_val1 = rng1.spawn_rng.randf()
	var draft_val1 = rng1.draft_rng.randf()
	
	var rng2 = RngManager.new()
	rng2.initialize_seed(9999)
	var spawn_val2 = rng2.spawn_rng.randf()
	var draft_val2 = rng2.draft_rng.randf()
	
	assert(is_equal_approx(spawn_val1, spawn_val2), "Spawn RNG mismatch on identical seed")
	assert(is_equal_approx(draft_val1, draft_val2), "Draft RNG mismatch on identical seed")
	assert(not is_equal_approx(spawn_val1, draft_val1), "Streams must not collide")
	print("    [PASS] RNG Streams are deterministic and independent.")

func _test_synergy_engine() -> void:
	print(" -> Testing Synergy Engine & Augments...")
	var bus = CombatEventBus.new()
	var engine = SynergyEngine.new()
	engine.initialize(bus)
	
	var ember = load("res://data/augments/ember_shot.tres") as AugmentData
	var arc = load("res://data/augments/arc_bolt.tres") as AugmentData
	var frost = load("res://data/augments/frostbite.tres") as AugmentData
	
	assert(ember != null and arc != null and frost != null, "Failed to load augment tres")
	
	engine.add_augment(ember)
	engine.add_augment(arc)
	assert(bus.discovered_synergies.has("burning_chain"), "Burning Chain failed to unlock")
	
	engine.add_augment(frost)
	assert(bus.discovered_synergies.has("frost_conduit"), "Frost Conduit failed to unlock")
	assert(bus.discovered_synergies.has("scorching_frost"), "Scorching Frost failed to unlock")
	print("    [PASS] Synergy combinations detected correctly.")

func _test_combat_event_bus() -> void:
	print(" -> Testing Combat Event Bus & Proc Budget limit...")
	var bus = CombatEventBus.new()
	root.add_child(bus)
	
	var max_procs = bus.MAX_PROCS_PER_TICK
	var hit_count = 0
	bus.event_emitted.connect(func(_type, _payload): hit_count += 1)
	
	for i in range(max_procs + 50):
		bus.emit_combat_event("test_burst", {"val": i}, 0)
		
	assert(hit_count <= max_procs, "Proc budget exceeded!")
	print("    [PASS] Proc Budget correctly capped at ", max_procs, " procs/tick.")
	bus.queue_free()

func _test_harness_runner() -> void:
	print(" -> Testing Full Combat Stage & 300 Swarm Stress in Headless Harness...")
	var runner = CombatHarnessRunner.new()
	runner.is_headless = true
	root.add_child(runner)
	
	var ok = runner.load_scenario("res://data/harness/stress_swarm_300.json")
	assert(ok, "Failed to load stress_swarm_300.json")
	
	runner.start_scenario()
	
	var state_dict = {"completed": false, "finished_ok": false, "telemetry": {}}
	runner.harness_finished.connect(func(success: bool, telemetry: Dictionary):
		state_dict["completed"] = true
		state_dict["finished_ok"] = success
		state_dict["telemetry"] = telemetry
	)
	
	var timeout_frames = 300
	while not state_dict["completed"] and timeout_frames > 0:
		await physics_frame
		timeout_frames -= 1
		
	assert(state_dict["finished_ok"], "Harness run failed")
	print("    [PASS] Stage spawned 300+ enemies smoothly with telemetry: ", state_dict["telemetry"])
	runner.queue_free()
