class_name Player
extends CharacterBody2D

signal health_changed(current: float, maximum: float)
signal dash_cooldown_updated(current: float, max_cd: float)
signal player_died

@export var move_speed: float = 240.0
@export var max_health: float = 120.0
@export var current_health: float = 120.0

# Dash settings
@export var dash_speed: float = 650.0
@export var dash_duration: float = 0.25
@export var dash_cooldown: float = 4.2
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _is_dashing: bool = false
var _dash_direction: Vector2 = Vector2.RIGHT

# Auto-fire weapon settings
@export var fire_rate: float = 1.3
var _fire_timer: float = 0.0
var _shot_count: int = 0
var projectile_scene: PackedScene = preload("res://scenes/combat/projectile.tscn")
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")

var event_bus: CombatEventBus
var synergy_engine: SynergyEngine

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)
	if animated_sprite:
		animated_sprite.play("idle")

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
		if animated_sprite and animated_sprite.animation != "idle" and animated_sprite.animation != "cast":
			animated_sprite.play("idle")
			
	velocity = input_vector * move_speed
	move_and_slide()
	
	if Input.is_action_just_pressed("dash") or Input.is_key_pressed(KEY_SPACE):
		try_dash()
		
	_fire_timer += delta
	if _fire_timer >= 1.0 / fire_rate:
		_fire_timer = 0.0
		_auto_fire()

func try_dash() -> bool:
	if _dash_cooldown_timer <= 0.0 and not _is_dashing:
		_is_dashing = true
		_dash_timer = dash_duration
		_dash_cooldown_timer = dash_cooldown
		return true
	return false

func _auto_fire() -> void:
	# Smart Multi-Direction Targeting:
	# Find up to 3 closest distinct enemies to fire in multiple directions!
	var targets = _find_closest_enemies(3)
	
	if animated_sprite and velocity.length() == 0:
		animated_sprite.play("cast")
		
	_shot_count += 1
	
	if targets.is_empty():
		# Fire spread in moving or facing direction
		var base_dir = velocity.normalized() if velocity.length() > 0 else (Vector2.LEFT if (animated_sprite and animated_sprite.flip_h) else Vector2.RIGHT)
		_spawn_bullet_fan(base_dir)
	else:
		# Fire directly towards up to 3 targets around the player!
		for t in targets:
			var dir_to_target = (t.global_position - global_position).normalized()
			_spawn_bullet(dir_to_target)

func _spawn_bullet_fan(base_direction: Vector2) -> void:
	var angles = [-0.22, 0.0, 0.22]
	for a in angles:
		_spawn_bullet(base_direction.rotated(a))

func _spawn_bullet(dir: Vector2) -> void:
	var proj = projectile_scene.instantiate() as Projectile
	proj.global_position = global_position
	proj.direction = dir
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

func _find_closest_enemies(count: int = 3) -> Array[Node2D]:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var valid_enemies: Array[Dictionary] = []
	for e in enemies:
		if is_instance_valid(e) and e is Node2D:
			var d = global_position.distance_to(e.global_position)
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
		player_died.emit()
