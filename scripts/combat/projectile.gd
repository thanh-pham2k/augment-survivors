class_name Projectile
extends Area2D

@export var speed: float = 700.0
@export var damage: float = 18.0
@export var element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE

var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 1.3
var shot_index: int = 0
var event_bus: CombatEventBus

@onready var sprite: Sprite2D = $Sprite2D

var _frames: Array[Texture2D] = []
var _anim_timer: float = 0.0
var _trail_particles: CPUParticles2D = null

func _ready() -> void:
	monitoring = true
	rotation = direction.angle()
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	if sprite:
		# Large, impressive high-impact bullet size
		sprite.scale = Vector2(0.62, 0.62)
	
	_load_element_frames()
	_create_trail_particles()

func _load_element_frames() -> void:
	var prefix = "bullet_fire_"
	match element:
		GlobalEnums.ElementType.ICE:
			prefix = "bullet_ice_"
		GlobalEnums.ElementType.LIGHTNING:
			prefix = "bullet_lightning_"
		_:
			prefix = "bullet_fire_"
			
	for i in range(6):
		var p = "res://assets/sprites/projectiles/%s%d.png" % [prefix, i]
		if ResourceLoader.exists(p):
			_frames.append(load(p))
			
	if _frames.is_empty():
		# Fallback to single texture
		var fallback_name = "proj_fire.png"
		if element == GlobalEnums.ElementType.ICE:
			fallback_name = "proj_ice.png"
		elif element == GlobalEnums.ElementType.LIGHTNING:
			fallback_name = "proj_lightning.png"
		var fallback_p = "res://assets/sprites/" + fallback_name
		if ResourceLoader.exists(fallback_p):
			_frames.append(load(fallback_p))
			
	if not _frames.is_empty() and sprite:
		sprite.texture = _frames[0]

func _create_trail_particles() -> void:
	_trail_particles = CPUParticles2D.new()
	_trail_particles.amount = 22
	_trail_particles.lifetime = 0.24
	_trail_particles.speed_scale = 1.2
	_trail_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	_trail_particles.emission_sphere_radius = 6.0
	_trail_particles.gravity = Vector2.ZERO
	_trail_particles.initial_velocity_min = 30.0
	_trail_particles.initial_velocity_max = 60.0
	# Since projectile node is already rotated towards direction, local Vector2.LEFT is exactly backwards!
	_trail_particles.direction = Vector2.LEFT
	_trail_particles.position = Vector2(-22, 0)
	_trail_particles.spread = 22.0
	_trail_particles.scale_amount_min = 4.5
	_trail_particles.scale_amount_max = 8.0
	
	match element:
		GlobalEnums.ElementType.FIRE:
			_trail_particles.color = Color(1.0, 0.65, 0.15, 0.85)
		GlobalEnums.ElementType.ICE:
			_trail_particles.color = Color(0.25, 0.88, 1.0, 0.85)
		GlobalEnums.ElementType.LIGHTNING:
			_trail_particles.color = Color(0.85, 0.45, 1.0, 0.85)
		_:
			_trail_particles.color = Color(1.0, 0.70, 0.20, 0.85)
			
	add_child(_trail_particles)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
		
	# Animate looping elemental flame/javelin frames
	if not _frames.is_empty() and sprite:
		_anim_timer += delta * 16.0
		var frame_idx = int(_anim_timer) % _frames.size()
		sprite.texture = _frames[frame_idx]

func _on_body_entered(body: Node2D) -> void:
	_check_hit(body)

func _on_area_entered(area: Area2D) -> void:
	var target = area.get_parent()
	if target and target != self:
		_check_hit(target)

func _check_hit(target: Node) -> void:
	if not target.is_in_group("enemies"):
		return
		
	if target.has_method("take_damage"):
		target.take_damage(damage, element)
		_spawn_impact_vfx()
		if event_bus:
			event_bus.record_damage("Physical", damage)
			event_bus.emit_combat_event("enemy_hit", {
				"target": target,
				"damage": damage,
				"element": element,
				"shot_index": shot_index
			})
	queue_free()

func _spawn_impact_vfx() -> void:
	if not get_parent():
		return
	var vfx = Sprite2D.new()
	var tex_name = "impact_fire_1.png"
	match element:
		GlobalEnums.ElementType.ICE:
			tex_name = "impact_ice_1.png"
		GlobalEnums.ElementType.LIGHTNING:
			tex_name = "impact_lightning_1.png"
	var tex = load("res://assets/sprites/vfx/" + tex_name)
	if tex:
		vfx.texture = tex
		vfx.global_position = global_position
		vfx.scale = Vector2(0.55, 0.55)
		get_parent().add_child(vfx)
		var tw = vfx.create_tween()
		tw.parallel().tween_property(vfx, "scale", Vector2(1.15, 1.15), 0.15)
		tw.parallel().tween_property(vfx, "modulate:a", 0.0, 0.16)
		tw.tween_callback(vfx.queue_free)
