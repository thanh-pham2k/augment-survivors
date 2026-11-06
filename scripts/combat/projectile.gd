class_name Projectile
extends Area2D

@export var speed: float = 680.0
@export var damage: float = 18.0
@export var element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE

var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 1.3
var shot_index: int = 0
var event_bus: CombatEventBus

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	monitoring = true
	rotation = direction.angle()
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	if sprite:
		sprite.scale = Vector2(0.28, 0.28)
	
	# Configure visual sprite based on element
	match element:
		GlobalEnums.ElementType.FIRE:
			sprite.texture = load("res://assets/sprites/proj_fire.png")
		GlobalEnums.ElementType.ICE:
			sprite.texture = load("res://assets/sprites/proj_ice.png")
		GlobalEnums.ElementType.LIGHTNING:
			sprite.texture = load("res://assets/sprites/proj_lightning.png")
		_:
			sprite.texture = load("res://assets/sprites/proj_fire.png")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

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
		vfx.scale = Vector2(0.2, 0.2)
		get_parent().add_child(vfx)
		var tw = vfx.create_tween()
		tw.parallel().tween_property(vfx, "scale", Vector2(0.45, 0.45), 0.12)
		tw.parallel().tween_property(vfx, "modulate:a", 0.0, 0.14)
		tw.tween_callback(vfx.queue_free)
