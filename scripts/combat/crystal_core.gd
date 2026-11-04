class_name CrystalCore
extends StaticBody2D

signal crystal_destroyed(crystal: CrystalCore)

@export var max_health: float = 80.0
@export var current_health: float = 80.0

@onready var sprite: Sprite2D = $Sprite2D
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")

func _ready() -> void:
	add_to_group("enemies")
	current_health = max_health

func take_damage(amount: float, element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE, _spawn_popup: bool = true) -> void:
	current_health = max(0.0, current_health - amount)
	
	var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
	dnum.global_position = global_position
	dnum.setup(amount, element)
	get_parent().add_child(dnum)
	
	sprite.modulate = Color(2.0, 1.5, 1.5)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	if current_health <= 0.0:
		crystal_destroyed.emit(self)
		queue_free()

func apply_status(_status: String, _duration: float, _param: float) -> void:
	pass

func has_status(_status: String) -> bool:
	return false
