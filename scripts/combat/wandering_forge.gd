class_name WanderingForge
extends Area2D

signal forge_interacted(forge: WanderingForge)

var is_used: bool = false
var _pulse_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	monitoring = true
	_pulse_timer = randf() * TAU
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if sprite:
		var forge_tex_path = "res://assets/sprites/forge/station_forge.png"
		if ResourceLoader.exists(forge_tex_path):
			sprite.texture = load(forge_tex_path)

func _physics_process(delta: float) -> void:
	if is_used:
		return
	_pulse_timer += delta * 2.5
	if sprite:
		sprite.scale = Vector2(1.0, 1.0) + Vector2(0.04, 0.04) * sin(_pulse_timer)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact(body)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("player"):
		interact(parent)

func interact(player: Node2D) -> void:
	if is_used:
		return
	is_used = true
	monitoring = false
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	forge_interacted.emit(self)
	
	var stage = get_tree().current_scene
	if stage and stage.has_method("open_wandering_forge"):
		stage.open_wandering_forge(self)
		
	# Fade out after interaction
	var tw = create_tween()
	tw.tween_interval(1.5)
	tw.tween_property(self, "modulate:a", 0.0, 1.0)
	tw.tween_callback(queue_free)
