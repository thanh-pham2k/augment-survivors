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
		if event_bus:
			event_bus.record_damage("Physical", damage)
			event_bus.emit_combat_event("enemy_hit", {
				"target": target,
				"damage": damage,
				"element": element,
				"shot_index": shot_index
			})
	queue_free()
