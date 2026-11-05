class_name EnemyProjectile
extends Area2D

@export var speed: float = 340.0
@export var damage: float = 20.0
@export var lifetime: float = 3.5

var direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	monitoring = true
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	_check_hit(body)

func _on_area_entered(area: Area2D) -> void:
	_check_hit(area.get_parent())

func _check_hit(target: Node) -> void:
	if target and target.is_in_group("player") and target.has_method("take_damage"):
		target.take_damage(damage)
		queue_free()
