class_name SynergyEngine
extends Node

@export var event_bus: CombatEventBus

# Active player augments
var active_augments: Dictionary = {} # id -> AugmentData

func initialize(bus: CombatEventBus) -> void:
	event_bus = bus
	if not event_bus.event_emitted.is_connected(_on_event_emitted):
		event_bus.event_emitted.connect(_on_event_emitted)

func add_augment(augment: AugmentData) -> void:
	active_augments[augment.id] = augment
	_check_synergy_combinations()

func has_augment(id: String) -> bool:
	return active_augments.has(id)

func _check_synergy_combinations() -> void:
	if not event_bus:
		return
		
	# 1. Burning Chain (Fire + Lightning: Ember Shot + Arc Bolt)
	if has_augment("ember_shot") and has_augment("arc_bolt"):
		event_bus.register_synergy(
			"burning_chain",
			"Burning Chain",
			"Burning enemies can chain lightning to 2 nearby enemies."
		)

	# 2. Frost Conduit (Ice + Lightning: Frostbite + Arc Bolt)
	if has_augment("frostbite") and has_augment("arc_bolt"):
		event_bus.register_synergy(
			"frost_conduit",
			"Frost Conduit",
			"Chilled enemies struck by chain lightning discharge a freezing shockwave."
		)

	# 3. Scorching Frost / Steam Burst (Fire + Ice: Ember Shot + Frostbite)
	if has_augment("ember_shot") and has_augment("frostbite"):
		event_bus.register_synergy(
			"scorching_frost",
			"Scorching Frost",
			"Hitting an enemy with both Fire and Ice triggers a Steam Burst AoE."
		)

func _on_event_emitted(event_type: String, payload: Dictionary) -> void:
	var depth = payload.get("depth", 0)
	
	match event_type:
		"enemy_hit":
			_handle_enemy_hit(payload, depth)
		"enemy_killed":
			_handle_enemy_killed(payload, depth)

func _handle_enemy_hit(payload: Dictionary, depth: int) -> void:
	var enemy = payload.get("target")
	if not is_instance_valid(enemy) or not enemy.has_method("apply_status"):
		return
		
	var has_fire = has_augment("ember_shot")
	var has_ice = has_augment("frostbite")
	var has_lightning = has_augment("arc_bolt")
	
	# Apply Ember Shot burning
	if has_fire:
		enemy.apply_status("burning", 3.0, 10.0)
		event_bus.record_damage("Fire", 5.0)

	# Apply Frostbite chill
	if has_ice:
		enemy.apply_status("chilled", 3.0, 0.4) # 40% slow
		event_bus.record_damage("Ice", 3.0)

	# Check Steam Burst / Scorching Frost synergy
	if has_fire and has_ice:
		if enemy.has_status("burning") and enemy.has_status("chilled"):
			if event_bus.emit_combat_event("steam_burst", {"origin": enemy.global_position, "radius": 80.0, "damage": 25.0}, depth + 1):
				event_bus.record_damage("Fire", 15.0)
				event_bus.record_damage("Ice", 10.0)

	# Arc Bolt chain
	if has_lightning:
		var shot_count = payload.get("shot_index", 0)
		if shot_count % 4 == 0 or has_augment("overload"):
			_trigger_chain_lightning(enemy, depth)

func _trigger_chain_lightning(source_enemy: Node, depth: int) -> void:
	var tree = source_enemy.get_tree()
	if not tree:
		return
		
	var enemies = tree.get_nodes_in_group("enemies")
	var chained = 0
	var max_chains = 2
	if has_augment("burning_chain") or (has_augment("ember_shot") and has_augment("arc_bolt")):
		max_chains = 3
		
	for e in enemies:
		if chained >= max_chains:
			break
		if e != source_enemy and is_instance_valid(e) and e.has_method("take_damage"):
			var dist = source_enemy.global_position.distance_to(e.global_position)
			if dist < 160.0:
				chained += 1
				event_bus.emit_combat_event("chain_hit", {"source": source_enemy, "target": e, "damage": 18.0}, depth + 1)
				e.take_damage(18.0, GlobalEnums.ElementType.LIGHTNING)
				event_bus.record_damage("Lightning", 18.0)

func _handle_enemy_killed(payload: Dictionary, depth: int) -> void:
	var enemy = payload.get("target")
	if not is_instance_valid(enemy):
		return
		
	# Wildfire augment: spreads fire on death
	if has_augment("wildfire") and enemy.has_status("burning"):
		var tree = enemy.get_tree()
		if tree:
			var enemies = tree.get_nodes_in_group("enemies")
			for e in enemies:
				if e != enemy and is_instance_valid(e) and e.has_method("apply_status"):
					if enemy.global_position.distance_to(e.global_position) < 100.0:
						e.apply_status("burning", 3.0, 8.0)
						event_bus.record_damage("Fire", 8.0)
