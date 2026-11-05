class_name WorldRewardDirector
extends Node

signal cache_spawned(cache: WorldUpgradeCache)
signal cache_claimed(cache: WorldUpgradeCache)
signal forge_spawned(forge: WanderingForge)

@export var max_unclaimed: int = 2
@export var first_cache_target_time: float = 25.0
@export var pity_reward_seconds: float = 90.0
@export var arena_bounds: Rect2 = Rect2(-1350, -1350, 2700, 2700)

var cache_scene: PackedScene = preload("res://scenes/combat/world_upgrade_cache.tscn")
var forge_scene: PackedScene = preload("res://scenes/combat/wandering_forge.tscn")
var active_caches: Array[WorldUpgradeCache] = []
var active_forge: WanderingForge = null
var cache_index: int = 0

var _timer: float = 0.0
var _time_since_reward: float = 0.0
var _next_spawn_interval: float = 25.0
var _combat_credit: float = 0.0
var _last_enemies_defeated: int = 0
var next_forge_time: float = 240.0 # First forge at 4 minutes (240s)

func _ready() -> void:
	_next_spawn_interval = randf_range(20.0, 32.0)

func update(delta: float, run_time: float, enemies_defeated: int, player_pos: Vector2, parent_node: Node2D) -> WorldUpgradeCache:
	# Clean up any freed caches
	active_caches = active_caches.filter(func(c): return is_instance_valid(c) and not c.is_queued_for_deletion())
	
	_timer += delta
	_time_since_reward += delta
	
	# Combat credit accumulation: time + enemy kills (distance alone grants zero extra credit)
	var new_kills = max(0, enemies_defeated - _last_enemies_defeated)
	_last_enemies_defeated = enemies_defeated
	_combat_credit += delta + new_kills * 2.5
	
	# Wandering Forge periodic spawn (every 4-5 minutes)
	if not active_forge and run_time >= next_forge_time:
		next_forge_time = run_time + randf_range(240.0, 300.0)
		_spawn_wandering_forge(player_pos, parent_node)

	var can_spawn = active_caches.size() < max_unclaimed
	var reached_interval = _timer >= _next_spawn_interval and _combat_credit >= 20.0
	var hit_pity = _time_since_reward >= pity_reward_seconds and can_spawn
	
	if can_spawn and (reached_interval or hit_pity):
		var spawned = _spawn_new_cache(player_pos, parent_node, run_time)
		_timer = 0.0
		_combat_credit = 0.0
		# Schedule next interval: early (45-85s), late (55-100s)
		if run_time < 300.0:
			_next_spawn_interval = randf_range(45.0, 85.0)
		else:
			_next_spawn_interval = randf_range(55.0, 100.0)
		return spawned
		
	return null

func _spawn_new_cache(player_pos: Vector2, parent_node: Node2D, run_time: float) -> WorldUpgradeCache:
	cache_index += 1
	var c = cache_scene.instantiate() as WorldUpgradeCache
	c.cache_id = "cache_%d" % cache_index
	
	# Bounded RNG rarity
	var roll = randf()
	if run_time >= 360.0 and roll < 0.25:
		c.rarity = "legendary"
	elif roll < 0.65:
		c.rarity = "rare"
	else:
		c.rarity = "common"
		
	var target_pos = find_reachable_spawn_position(player_pos)
	c.global_position = target_pos
	
	c.cache_claimed.connect(func(cache):
		_time_since_reward = 0.0
		active_caches.erase(cache)
		cache_claimed.emit(cache)
	)
	c.cache_despawned.connect(func(cache):
		active_caches.erase(cache)
	)
	
	active_caches.append(c)
	parent_node.add_child(c)
	cache_spawned.emit(c)
	return c

func _spawn_wandering_forge(player_pos: Vector2, parent_node: Node2D) -> WanderingForge:
	var f = forge_scene.instantiate() as WanderingForge
	f.global_position = find_reachable_spawn_position(player_pos)
	active_forge = f
	parent_node.add_child(f)
	f.forge_interacted.connect(func(_fg): active_forge = null)
	f.tree_exited.connect(func(): if active_forge == f: active_forge = null)
	forge_spawned.emit(f)
	return f

func find_reachable_spawn_position(player_pos: Vector2, max_attempts: int = 16) -> Vector2:
	# Annular ring around player between 0.6 and 1.2 screen widths (approx. 520 to 860px)
	var min_dist: float = 520.0
	var max_dist: float = 860.0
	
	for _attempt in range(max_attempts):
		var angle = randf() * TAU
		var dist = randf_range(min_dist, max_dist)
		var candidate = player_pos + Vector2(cos(angle), sin(angle)) * dist
		
		# Clamp to arena bounds
		if arena_bounds.has_point(candidate):
			return candidate
			
	# Fallback clamped position within bounds
	var clamped_x = clampf(player_pos.x + randf_range(-400.0, 400.0), arena_bounds.position.x + 80.0, arena_bounds.end.x - 80.0)
	var clamped_y = clampf(player_pos.y + randf_range(-400.0, 400.0), arena_bounds.position.y + 80.0, arena_bounds.end.y - 80.0)
	return Vector2(clamped_x, clamped_y)

func get_nearest_cache(from_pos: Vector2) -> WorldUpgradeCache:
	active_caches = active_caches.filter(func(c): return is_instance_valid(c) and not c.is_queued_for_deletion())
	if active_caches.is_empty():
		return null
		
	var nearest: WorldUpgradeCache = null
	var min_d: float = INF
	for c in active_caches:
		var d = from_pos.distance_squared_to(c.global_position)
		if d < min_d:
			min_d = d
			nearest = c
	return nearest
