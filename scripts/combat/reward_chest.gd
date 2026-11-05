class_name RewardChest
extends Area2D

signal chest_opened(chest: RewardChest)

@export var chest_type: String = "silver" # "wooden", "silver", "gold"
var is_opened: bool = false
var _bob_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	monitoring = true
	_bob_timer = randf() * TAU
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if sprite:
		var tex_path = "res://assets/sprites/chests/chest_" + chest_type + ".png"
		if ResourceLoader.exists(tex_path):
			sprite.texture = load(tex_path)

func _physics_process(delta: float) -> void:
	if is_opened:
		return
	_bob_timer += delta * 4.0
	if sprite:
		sprite.position.y = sin(_bob_timer) * 3.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		open_chest(body)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("player"):
		open_chest(parent)

func open_chest(_player: Node2D) -> bool:
	if is_opened:
		return false
	is_opened = true
	monitoring = false
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	chest_opened.emit(self)
	
	var stage = get_tree().current_scene
	if stage and stage.has_method("_trigger_upgrade_choice_modal"):
		stage._trigger_upgrade_choice_modal()
	
	var tw = create_tween()
	tw.parallel().tween_property(self, "scale", Vector2(1.4, 1.4), 0.15)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.20)
	tw.tween_callback(queue_free)
	return true
