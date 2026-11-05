class_name XPGem
extends Area2D

@export var value: float = 1.0
var is_attracted: bool = false
var pull_speed: float = 260.0
var _bob_timer: float = 0.0
var _is_collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	monitoring = true
	_bob_timer = randf() * TAU

func _physics_process(delta: float) -> void:
	if _is_collected:
		return
		
	_bob_timer += delta * 4.5
	if sprite and not is_attracted:
		sprite.position.y = sin(_bob_timer) * 3.0
		
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player = players[0]
	if not is_instance_valid(player):
		return
		
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var magnet_range = player.magnet_radius if ("magnet_radius" in player) else 170.0
	
	if dist <= magnet_range:
		is_attracted = true
		
	if is_attracted:
		pull_speed = min(950.0, pull_speed + 850.0 * delta)
		var dir = to_player.normalized()
		global_position += dir * pull_speed * delta
		
		if dist <= 26.0:
			collect(player)

func collect(player: Node2D) -> void:
	if _is_collected:
		return
	_is_collected = true
	monitoring = false
	if player.has_method("add_xp"):
		player.add_xp(value)
	queue_free()
