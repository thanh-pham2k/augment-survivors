class_name BaseEnemy
extends CharacterBody2D

signal enemy_defeated(enemy: BaseEnemy)

@export var max_health: float = 50.0
@export var current_health: float = 50.0
@export var base_speed: float = 85.0
@export var contact_damage: float = 10.0
@export var archetype: GlobalEnums.EnemyArchetype = GlobalEnums.EnemyArchetype.SWARM_CHASER

var speed_modifier: float = 1.0
var statuses: Dictionary = {} # name -> {"duration": float, "param": float}
var event_bus: CombatEventBus
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var telegraph_line: Line2D = get_node_or_null("TelegraphLine")

func _ready() -> void:
	add_to_group("enemies")
	current_health = max_health

func _physics_process(delta: float) -> void:
	_update_statuses(delta)
	_behavior_step(delta)

func _update_statuses(delta: float) -> void:
	var to_remove: Array[String] = []
	speed_modifier = 1.0
	
	for s_name in statuses.keys():
		var data = statuses[s_name]
		data["duration"] -= delta
		if data["duration"] <= 0.0:
			to_remove.append(s_name)
		else:
			if s_name == "burning":
				var dps = data["param"]
				take_damage(dps * delta, GlobalEnums.ElementType.FIRE, false)
				sprite.modulate = Color(1.0, 0.5, 0.2)
			elif s_name == "chilled":
				var slow = data["param"]
				speed_modifier *= (1.0 - slow)
				sprite.modulate = Color(0.4, 0.8, 1.0)
				
	for r in to_remove:
		statuses.erase(r)
		
	if statuses.is_empty():
		sprite.modulate = Color.WHITE

func apply_status(status_name: String, duration: float, param: float) -> void:
	statuses[status_name] = {"duration": duration, "param": param}

func has_status(status_name: String) -> bool:
	return statuses.has(status_name)

func take_damage(amount: float, element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE, spawn_popup: bool = true) -> void:
	current_health = max(0.0, current_health - amount)
	
	if spawn_popup:
		var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
		dnum.global_position = global_position
		dnum.setup(amount, element)
		get_parent().add_child(dnum)
		
	# White hit flash
	sprite.modulate = Color(2.0, 2.0, 2.0)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	if current_health <= 0.0:
		_die()

func _die() -> void:
	if event_bus:
		event_bus.enemies_defeated += 1
		event_bus.emit_combat_event("enemy_killed", {"target": self})
	enemy_defeated.emit(self)
	queue_free()

func _behavior_step(delta: float) -> void:
	var player = _get_player()
	if not player:
		return
		
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * base_speed * speed_modifier
	move_and_slide()
	
	# Check collision with player
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("player") and collider.has_method("take_damage"):
			collider.take_damage(contact_damage * delta * 2.0)

func _get_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as Node2D
	return null
