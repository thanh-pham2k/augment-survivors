class_name GoldDrop
extends Area2D

@export var value: int = 1
var is_attracted: bool = false
var pull_speed: float = 240.0
var _bob_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	monitoring = true
	_bob_timer = randf() * TAU

func _physics_process(delta: float) -> void:
	_bob_timer += delta * 4.0
	if sprite and not is_attracted:
		sprite.position.y = sin(_bob_timer) * 3.5
		
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player = players[0]
	if not is_instance_valid(player):
		return
		
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var magnet_range = player.magnet_radius if ("magnet_radius" in player) else 160.0
	
	if dist <= magnet_range:
		is_attracted = true
		
	if is_attracted:
		pull_speed = min(900.0, pull_speed + 800.0 * delta)
		var dir = to_player.normalized()
		global_position += dir * pull_speed * delta
		
		if dist <= 26.0:
			if player.has_method("add_gold"):
				player.add_gold(value)
			queue_free()
