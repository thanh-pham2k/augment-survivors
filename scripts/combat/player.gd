class_name Player
extends CharacterBody2D

signal health_changed(current: float, maximum: float)
signal dash_cooldown_updated(current: float, max_cd: float)
signal gold_changed(current_gold: int)
signal xp_changed(current_xp: float, required_xp: float, level: int)
signal level_up(new_level: int)
signal weapons_updated(weapons: Array[WeaponData])
signal player_died

@export var move_speed: float = 240.0
@export var max_health: float = 120.0
@export var current_health: float = 120.0

# Resource Farming & Upgrades
var current_gold: int = 0
@export var magnet_radius: float = 170.0
@export var damage_multiplier: float = 1.0
@export var projectile_speed_bonus: float = 0.0

# Run Progression & Leveling (2.1 Endless Mode)
var run_level: int = 1
var current_xp: float = 0.0
var damage_bonus_from_levels: float = 0.0 # Capped at 40.0%

# Dash settings
@export var dash_speed: float = 650.0
@export var dash_duration: float = 0.25
@export var dash_cooldown: float = 4.2
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _is_dashing: bool = false
var _dash_direction: Vector2 = Vector2.RIGHT

# Weapon & Equipment Systems (Up to 3 concurrent weapons)
@export var active_weapon: WeaponData = null:
	get:
		if weapons.size() > 0:
			return weapons[0]
		return _legacy_active_weapon
	set(value):
		_legacy_active_weapon = value
		if weapons.is_empty():
			weapons.append(value)
		else:
			weapons[0] = value
var _legacy_active_weapon: WeaponData = null
var weapons: Array[WeaponData] = []
var _weapon_timers: Array[float] = []
var equipped_relics: Array[RelicData] = []

# Auto-fire weapon settings
@export var fire_rate: float = 6.5
var _fire_timer: float = 0.0
var _shot_count: int = 0
var projectile_scene: PackedScene = preload("res://scenes/combat/projectile.tscn")
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")

var event_bus: CombatEventBus
var synergy_engine: SynergyEngine

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")

func _ready() -> void:
	add_to_group("player")
	if weapons.is_empty():
		if _legacy_active_weapon:
			weapons.append(_legacy_active_weapon)
		else:
			var w = WeaponData.new()
			w.id = "inferno_staff"
			w.display_name = "Inferno Staff"
			w.icon = preload("res://assets/sprites/weapons/icon_inferno_staff.png")
			w.base_damage = 25.0
			w.base_fire_rate = 2.0
			w.element = GlobalEnums.ElementType.FIRE
			weapons.append(w)
			_legacy_active_weapon = w
			
	while _weapon_timers.size() < weapons.size():
		_weapon_timers.append(0.0)
		
	current_health = max_health
	health_changed.emit(current_health, max_health)
	xp_changed.emit(current_xp, get_xp_for_level(run_level), run_level)
	if animated_sprite:
		animated_sprite.play("idle")

func get_xp_for_level(lvl: int) -> float:
	# round(8 + 4*level + 0.5*level*level) from BALANCE_BASELINE.json
	return round(8.0 + 4.0 * lvl + 0.5 * lvl * lvl)

func add_xp(amount: float) -> void:
	current_xp += amount
	var req = get_xp_for_level(run_level)
	while current_xp >= req:
		current_xp -= req
		run_level += 1
		damage_bonus_from_levels = min(40.0, damage_bonus_from_levels + 1.0)
		if run_level % 5 == 0:
			max_health += 2.0
			current_health = min(max_health, current_health + 2.0)
			health_changed.emit(current_health, max_health)
		level_up.emit(run_level)
		_spawn_floating_text("LEVEL %d! (+1%% DMG)" % run_level, Color(0.2, 0.9, 1.0))
		req = get_xp_for_level(run_level)
	xp_changed.emit(current_xp, req, run_level)

func add_weapon(w: WeaponData) -> bool:
	for existing in weapons:
		if existing.id == w.id:
			return upgrade_weapon(w.id)
	if weapons.size() < 3:
		weapons.append(w)
		_weapon_timers.append(0.0)
		weapons_updated.emit(weapons)
		_spawn_floating_text("NEW WEAPON: %s" % w.display_name, Color(1.0, 0.85, 0.3))
		return true
	return false

func upgrade_weapon(weapon_id: String) -> bool:
	for w in weapons:
		if w.id == weapon_id:
			w.level += 1
			w.base_damage *= 1.15
			w.base_fire_rate *= 1.10
			if w.level % 2 == 0:
				w.projectile_count += 1
			weapons_updated.emit(weapons)
			_spawn_floating_text("%s Lv.%d!" % [w.display_name, w.level], Color(1.0, 0.8, 0.2))
			return true
	return false

func evolve_weapon(weapon_id: String, evo_data: Dictionary) -> bool:
	for w in weapons:
		if w.id == weapon_id:
			w.is_evolved = true
			w.evolution_id = evo_data.get("evo_id", "evolved")
			w.display_name = evo_data.get("evo_title", w.display_name)
			w.base_damage *= 1.60
			w.base_fire_rate *= 1.25
			w.projectile_count += 2
			var icon_p = evo_data.get("icon_path", "")
			if icon_p != "" and ResourceLoader.exists(icon_p):
				w.icon = load(icon_p)
			weapons_updated.emit(weapons)
			_spawn_floating_text("ULTIMATE EVOLUTION: %s!" % w.display_name, Color(1.0, 0.85, 0.2))
			return true
	return false

func _physics_process(delta: float) -> void:
	if _dash_cooldown_timer > 0.0:
		_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
		dash_cooldown_updated.emit(_dash_cooldown_timer, dash_cooldown)
		
	if _is_dashing:
		_dash_timer -= delta
		velocity = _dash_direction * dash_speed
		move_and_slide()
		if animated_sprite and animated_sprite.animation != "dash":
			animated_sprite.play("dash")
		if _dash_timer <= 0.0:
			_is_dashing = false
		return
		
	var input_vector := Vector2.ZERO
	
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_vector.x -= 1.0
	if Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_vector.x += 1.0
	if Input.is_action_pressed("move_up") or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_vector.y -= 1.0
	if Input.is_action_pressed("move_down") or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_vector.y += 1.0
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		_dash_direction = input_vector
		if animated_sprite:
			animated_sprite.flip_h = input_vector.x < 0
			if animated_sprite.animation != "walk":
				animated_sprite.play("walk")
		elif sprite:
			sprite.flip_h = input_vector.x < 0
	else:
		if animated_sprite:
			if animated_sprite.animation == "cast" and not animated_sprite.is_playing():
				animated_sprite.play("idle")
			elif animated_sprite.animation != "idle" and animated_sprite.animation != "cast":
				animated_sprite.play("idle")
			
	velocity = input_vector * move_speed
	move_and_slide()
	
	if Input.is_action_just_pressed("dash") or Input.is_key_pressed(KEY_SPACE):
		try_dash()
		
	# Simultaneous Weapon Auto-fire (Milestone WEAP-01)
	while _weapon_timers.size() < weapons.size():
		_weapon_timers.append(0.0)
		
	for i in range(weapons.size()):
		var w = weapons[i]
		_weapon_timers[i] += delta
		var w_rate = w.base_fire_rate * (1.0 + (fire_rate - 2.0) * 0.15)
		var w_interval: float = 1.0 / max(0.1, w_rate)
		while _weapon_timers[i] >= w_interval:
			_weapon_timers[i] -= w_interval
			_fire_weapon(w)

func try_dash() -> bool:
	if _dash_cooldown_timer <= 0.0 and not _is_dashing:
		_is_dashing = true
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		return true
	return false

func _auto_fire() -> void:
	if active_weapon:
		_fire_weapon(active_weapon)

func _fire_weapon(w: WeaponData) -> void:
	if not w:
		return
	if animated_sprite and velocity.length() == 0:
		animated_sprite.play("cast")
		
	_shot_count += 1
	
	var extra_proj: int = synergy_engine.get_total_extra_projectiles() if synergy_engine else 0
	var total_bullets: int = w.projectile_count + extra_proj
	
	var range_bonus: float = synergy_engine.get_total_range_bonus_pct() if synergy_engine else 0.0
	var max_detection_dist: float = 520.0 * (1.0 + range_bonus)
	
	var targets: Array[Node2D] = _find_closest_enemies(total_bullets, max_detection_dist)
	
	if targets.is_empty():
		# Fire spread in moving or facing direction
		var base_dir = velocity.normalized() if velocity.length() > 0 else (Vector2.LEFT if (animated_sprite and animated_sprite.flip_h) else Vector2.RIGHT)
		_spawn_bullet_fan_for_weapon(base_dir, total_bullets, w)
	else:
		# Smart Combat Volley: Focus majority on nearest cluster, cover flankers!
		var primary_target = targets[0]
		var primary_dir = (primary_target.global_position - global_position).normalized()
		
		var flankers: Array[Node2D] = []
		for i in range(1, targets.size()):
			var dir_i = (targets[i].global_position - global_position).normalized()
			if abs(primary_dir.angle_to(dir_i)) > 0.85:
				flankers.append(targets[i])
				
		var flanker_bullets = min(flankers.size(), total_bullets - 1)
		for i in range(flanker_bullets):
			var f_dir = (flankers[i].global_position - global_position).normalized()
			_spawn_bullet_for_weapon(f_dir, w)
			
		var main_bullets = total_bullets - flanker_bullets
		_spawn_bullet_fan_for_weapon(primary_dir, main_bullets, w)

func _spawn_bullet_fan(base_direction: Vector2, count: int = 3) -> void:
	if active_weapon:
		_spawn_bullet_fan_for_weapon(base_direction, count, active_weapon)
	else:
		_spawn_bullet(base_direction)

func _spawn_bullet_fan_for_weapon(base_direction: Vector2, count: int, w: WeaponData) -> void:
	if count <= 1:
		_spawn_bullet_for_weapon(base_direction, w)
		return
		
	var spread_val = max(0.2, w.spread_angle) if w else 0.24
	var total_spread = min(1.25, spread_val * (count - 1))
	var half_spread = total_spread / 2.0
	for i in range(count):
		var t = float(i) / float(count - 1)
		var angle = -half_spread + t * total_spread
		_spawn_bullet_for_weapon(base_direction.rotated(angle), w)

func _spawn_bullet(dir: Vector2) -> void:
	if active_weapon:
		_spawn_bullet_for_weapon(dir, active_weapon)

func _spawn_bullet_for_weapon(dir: Vector2, w: WeaponData) -> void:
	var proj = projectile_scene.instantiate() as Projectile
	proj.global_position = global_position
	proj.direction = dir
	proj.rotation = dir.angle()
	
	var level_dmg_factor = 1.0 + (damage_bonus_from_levels / 100.0)
	if w:
		proj.damage = w.base_damage * level_dmg_factor * damage_multiplier
		proj.element = w.element
		proj.speed = w.projectile_speed + projectile_speed_bonus
	else:
		proj.damage = 25.0 * level_dmg_factor * damage_multiplier
		proj.speed += projectile_speed_bonus
		
	proj.shot_index = _shot_count
	proj.event_bus = event_bus
	
	if synergy_engine:
		if synergy_engine.has_augment("arc_bolt") and _shot_count % 4 == 0:
			proj.element = GlobalEnums.ElementType.LIGHTNING
		elif synergy_engine.has_augment("frostbite"):
			proj.element = GlobalEnums.ElementType.ICE
		elif synergy_engine.has_augment("ember_shot"):
			proj.element = GlobalEnums.ElementType.FIRE
			
	get_parent().add_child(proj)

func _spawn_floating_text(text: String, col: Color) -> void:
	if not get_parent():
		return
	var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
	dnum.global_position = global_position + Vector2(0, -32)
	dnum.setup_text(text, col)
	get_parent().call_deferred("add_child", dnum)

func _find_closest_enemies(count: int = 3, max_dist: float = 550.0) -> Array[Node2D]:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var valid_enemies: Array[Dictionary] = []
	for e in enemies:
		if is_instance_valid(e) and e is Node2D:
			var d = global_position.distance_to(e.global_position)
			if d <= max_dist:
				valid_enemies.append({"node": e, "dist": d})
			
	valid_enemies.sort_custom(func(a, b): return a["dist"] < b["dist"])
	
	var res: Array[Node2D] = []
	for i in range(min(count, valid_enemies.size())):
		res.append(valid_enemies[i]["node"])
	return res

func take_damage(amount: float) -> void:
	if _is_dashing:
		return
	current_health = max(0.0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
	dnum.global_position = global_position
	dnum.setup(amount, GlobalEnums.ElementType.NONE, true)
	get_parent().add_child(dnum)
	
	var target_vis = animated_sprite if animated_sprite else sprite
	if target_vis:
		target_vis.modulate = Color(1.0, 0.2, 0.2)
		var tween = create_tween()
		tween.tween_property(target_vis, "modulate", Color.WHITE, 0.15)
	
	if current_health <= 0.0:
		if animated_sprite and animated_sprite.sprite_frames.has_animation("death"):
			animated_sprite.play("death")
		player_died.emit()

func add_gold(amount: int) -> void:
	current_gold += amount
	gold_changed.emit(current_gold)
