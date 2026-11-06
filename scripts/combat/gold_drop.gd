class_name GoldDrop
extends Area2D

@export var value: int = 1
var is_attracted: bool = true
var pull_speed: float = 360.0
var _bob_timer: float = 0.0
var _is_collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	set_deferred("monitoring", true)
	is_attracted = true
	_bob_timer = randf() * TAU

func _physics_process(delta: float) -> void:
	if _is_collected:
		return
		
	var player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		return
		
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	# Auto-collect: Always automatically fly directly to player
	is_attracted = true
	var bonus_speed = max(0.0, (player.magnet_radius - 160.0) * 1.2) if ("magnet_radius" in player) else 0.0
	pull_speed = min(1500.0, pull_speed + (1300.0 + bonus_speed) * delta)
	
	var move_step = (pull_speed + bonus_speed) * delta
	if dist <= 36.0 or move_step >= dist:
		global_position = player.global_position
		collect(player)
	else:
		var dir = to_player / dist
		global_position += dir * move_step

func collect(player: Node2D) -> void:
	if _is_collected:
		return
	_is_collected = true
	set_deferred("monitoring", false)
	if player.has_method("add_gold"):
		player.add_gold(value)
	_spawn_sparkle(player)
	queue_free()

func _spawn_sparkle(player: Node2D) -> void:
	if not get_parent():
		return
	var sp = Sprite2D.new()
	var tex = load("res://assets/sprites/vfx/absorb_sparkle_0.png")
	if tex:
		sp.texture = tex
		sp.modulate = Color(1.0, 0.85, 0.2)
		sp.global_position = player.global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		sp.scale = Vector2(0.25, 0.25)
		get_parent().add_child(sp)
		var tw = sp.create_tween()
		tw.parallel().tween_property(sp, "scale", Vector2(0.55, 0.55), 0.15)
		tw.parallel().tween_property(sp, "modulate:a", 0.0, 0.16)
		tw.tween_callback(sp.queue_free)
