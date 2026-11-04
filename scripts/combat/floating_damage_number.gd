class_name FloatingDamageNumber
extends Node2D

@onready var label: Label = $Label

var velocity: Vector2 = Vector2(0, -60)
var lifetime: float = 0.8
var current_time: float = 0.0

func setup(amount: float, element: GlobalEnums.ElementType, is_crit: bool = false) -> void:
	if not is_node_ready():
		await ready
	label.text = str(int(amount))
	
	match element:
		GlobalEnums.ElementType.FIRE:
			label.modulate = Color(1.0, 0.4, 0.1)
		GlobalEnums.ElementType.ICE:
			label.modulate = Color(0.3, 0.8, 1.0)
		GlobalEnums.ElementType.LIGHTNING:
			label.modulate = Color(1.0, 0.9, 0.2)
		_:
			label.modulate = Color(1.0, 1.0, 1.0)
			
	if is_crit:
		scale = Vector2(1.5, 1.5)
		label.modulate = Color(1.0, 0.2, 0.2)

func _process(delta: float) -> void:
	current_time += delta
	position += velocity * delta
	modulate.a = 1.0 - (current_time / lifetime)
	if current_time >= lifetime:
		queue_free()
