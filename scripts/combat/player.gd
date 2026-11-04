class_name Player
extends CharacterBody2D

signal health_changed(current: float, maximum: float)
signal dash_cooldown_updated(current: float, max_cd: float)
signal player_died

@export var move_speed: float = 160.0
@export var max_health: float = 120.0
@export var current_health: float = 120.0

# Dash settings
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 4.2
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _is_dashing: bool = false
var _dash_direction: Vector2 = Vector2.RIGHT

# Auto-fire weapon settings
@export var fire_rate: float = 1.0 # 1 shot/s
var _fire_timer: float = 0.0
var _shot_count: int = 0
var projectile_scene: PackedScene = preload("res://scenes/combat/projectile.tscn")
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")

var event_bus: CombatEventBus
var synergy_engine: SynergyEngine

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func _physics_process(delta: float) -> void:
	# Update timers
	if _dash_cooldown_timer > 0.0:
		_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
		dash_cooldown_updated.emit(_dash_cooldown_timer, dash_cooldown)
		
	if _is_dashing:
		_dash_timer -= delta
		velocity = _dash_direction * dash_speed
		move_and_slide()
		if _dash_timer <= 0.0:
			_is_dashing = false
		return
		
	# 8-way movement input
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		_dash_direction = input_vector
		if input_vector.x != 0:
			sprite.flip_h = input_vector.x < 0
			
	velocity = input_vector * move_speed
	move_and_slide()
	
	# Dash input
	if Input.is_action_just_pressed("ui_select") or Input.is_key_pressed(KEY_SPACE):
		try_dash()
		
	# Auto-fire weapon
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
	var target = _find_nearest_enemy()
	var base_direction = Vector2.RIGHT
	if target:
		base_direction = (target.global_position - global_position).normalized()
	elif velocity.length() > 0:
		base_direction = velocity.normalized()
		
	# 3-way fan pattern (spread shots)
	var angles = [-0.25, 0.0, 0.25] # in radians (~15 deg spread)
	_shot_count += 1
	
	for a in angles:
		var proj = projectile_scene.instantiate() as Projectile
		proj.global_position = global_position
		proj.direction = base_direction.rotated(a)
		proj.shot_index = _shot_count
		proj.event_bus = event_bus
		
		# Element determination
		if synergy_engine:
			if synergy_engine.has_augment("arc_bolt") and _shot_count % 4 == 0:
				proj.element = GlobalEnums.ElementType.LIGHTNING
			elif synergy_engine.has_augment("frostbite"):
				proj.element = GlobalEnums.ElementType.ICE
			elif synergy_engine.has_augment("ember_shot"):
				proj.element = GlobalEnums.ElementType.FIRE
		
		get_parent().add_child(proj)

func _find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var min_dist: float = 999999.0
	for e in enemies:
		if is_instance_valid(e) and e is Node2D:
			var d = global_position.distance_to(e.global_position)
			if d < min_dist:
				min_dist = d
				nearest = e
	return nearest

func take_damage(amount: float) -> void:
	if _is_dashing:
		return # Invincible during dash
	current_health = max(0.0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	# Damage pop
	var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
	dnum.global_position = global_position
	dnum.setup(amount, GlobalEnums.ElementType.NONE, true)
	get_parent().add_child(dnum)
	
	# Red flash
	sprite.modulate = Color(1.0, 0.2, 0.2)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)
	
	if current_health <= 0.0:
		player_died.emit()
