class_name XPGem
extends Area2D

@export var value: float = 1.0
var is_attracted: bool = true
var pull_speed: float = 380.0
var _is_collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

var _frames: Array[Texture2D] = []
var _anim_timer: float = 0.0
var _trail_particles: CPUParticles2D = null
var _swoop_phase: float = 0.0
var _swoop_timer: float = 0.0
var _swoop_sign: float = 1.0

func _ready() -> void:
	set_deferred("monitoring", true)
	is_attracted = true
	_swoop_phase = randf() * TAU
	_swoop_sign = 1.0 if randf() > 0.5 else -1.0
	
	_load_frames()
	_create_trail_particles()

func _load_frames() -> void:
	var tier = "t1"
	var target_scale = Vector2(0.48, 0.48)
	if value >= 20.0:
		tier = "t3"
		target_scale = Vector2(0.65, 0.65)
	elif value >= 5.0:
		tier = "t2"
		target_scale = Vector2(0.55, 0.55)
		
	for i in range(4):
		var p = "res://assets/sprites/collectibles/xp_gem_%s_%d.png" % [tier, i]
		if ResourceLoader.exists(p):
			_frames.append(load(p))
			
	if _frames.is_empty():
		var fb = "res://assets/sprites/xp_gem.png"
		if ResourceLoader.exists(fb):
			_frames.append(load(fb))
			
	if sprite:
		sprite.scale = target_scale
		if not _frames.is_empty():
			sprite.texture = _frames[0]

func _create_trail_particles() -> void:
	_trail_particles = CPUParticles2D.new()
	_trail_particles.amount = 14
	_trail_particles.lifetime = 0.22
	_trail_particles.speed_scale = 1.0
	_trail_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	_trail_particles.emission_sphere_radius = 6.0
	_trail_particles.gravity = Vector2.ZERO
	_trail_particles.damping = 15.0
	_trail_particles.scale_amount_min = 3.5
	_trail_particles.scale_amount_max = 6.0
	
	if value >= 20.0:
		_trail_particles.color = Color(1.0, 0.5, 0.95, 0.85)
	elif value >= 5.0:
		_trail_particles.color = Color(0.4, 0.95, 0.6, 0.85)
	else:
		_trail_particles.color = Color(0.25, 0.90, 1.0, 0.85)
		
	add_child(_trail_particles)

func _physics_process(delta: float) -> void:
	if _is_collected:
		return
		
	# Animate gem rotation/shimmer
	if not _frames.is_empty() and sprite:
		_anim_timer += delta * 9.0
		var idx = int(_anim_timer) % _frames.size()
		sprite.texture = _frames[idx]
		
	var player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		return
		
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	if dist <= 0.001:
		collect(player)
		return
		
	var dir = to_player / dist
	var perp = Vector2(-dir.y, dir.x) * _swoop_sign
	
	# Smooth dynamic swoop physics
	_swoop_timer += delta * 6.5
	var swoop_decay = min(1.0, dist / 200.0)
	var lateral_offset = perp * (sin(_swoop_timer + _swoop_phase) * 160.0 * swoop_decay * delta)
	
	var bonus_speed = max(0.0, (player.magnet_radius - 170.0) * 1.5) if ("magnet_radius" in player) else 0.0
	pull_speed = min(1800.0, pull_speed + (1500.0 + bonus_speed) * delta)
	
	var move_step = (pull_speed + bonus_speed) * delta
	if dist <= 38.0 or move_step >= dist:
		global_position = player.global_position
		collect(player)
	else:
		global_position += dir * move_step + lateral_offset

func collect(player: Node2D) -> void:
	if _is_collected:
		return
	_is_collected = true
	set_deferred("monitoring", false)
	if player.has_method("add_xp"):
		player.add_xp(value)
	if player.has_method("play_absorb_fx"):
		player.play_absorb_fx("xp")
	_spawn_sparkle(player)
	queue_free()

func _spawn_sparkle(player: Node2D) -> void:
	if not get_parent():
		return
	var sp = Sprite2D.new()
	var tex = load("res://assets/sprites/vfx/absorb_sparkle_0.png")
	if tex:
		sp.texture = tex
		sp.global_position = player.global_position + Vector2(randf_range(-12, 12), randf_range(-12, 12))
		sp.scale = Vector2(0.65, 0.65)
		if value >= 20.0:
			sp.modulate = Color(1.0, 0.6, 1.0, 0.95)
		elif value >= 5.0:
			sp.modulate = Color(0.5, 1.0, 0.7, 0.95)
		else:
			sp.modulate = Color(0.35, 0.92, 1.0, 0.95)
		get_parent().add_child(sp)
		var tw = sp.create_tween()
		tw.parallel().tween_property(sp, "scale", Vector2(1.25, 1.25), 0.15)
		tw.parallel().tween_property(sp, "modulate:a", 0.0, 0.16)
		tw.parallel().tween_property(sp, "rotation", randf_range(-0.5, 0.5), 0.15)
		tw.tween_callback(sp.queue_free)
