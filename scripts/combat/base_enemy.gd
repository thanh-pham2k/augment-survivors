class_name BaseEnemy
extends CharacterBody2D

signal enemy_defeated(enemy: BaseEnemy)

@export var max_health: float = 45.0
@export var current_health: float = 45.0
@export var base_speed: float = 75.0
@export var contact_damage: float = 10.0
@export var archetype: GlobalEnums.EnemyArchetype = GlobalEnums.EnemyArchetype.SWARM_CHASER

var speed_modifier: float = 1.0
var statuses: Dictionary = {}
var event_bus: CombatEventBus
var damage_num_scene: PackedScene = preload("res://scenes/combat/floating_damage_number.tscn")
var gold_scene: PackedScene = preload("res://scenes/combat/gold_drop.tscn")
var xp_gem_scene: PackedScene = preload("res://scenes/combat/xp_gem.tscn")
var chest_scene: PackedScene = preload("res://scenes/combat/reward_chest.tscn")

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var telegraph_line: Line2D = get_node_or_null("TelegraphLine")

func _ready() -> void:
	add_to_group("enemies")
	current_health = max_health
	if animated_sprite and animated_sprite.sprite_frames:
		if animated_sprite.sprite_frames.has_animation("walk"):
			animated_sprite.play("walk")
		elif animated_sprite.sprite_frames.has_animation("fly"):
			animated_sprite.play("fly")

func _physics_process(delta: float) -> void:
	_update_statuses(delta)
	_behavior_step(delta)

func _update_statuses(delta: float) -> void:
	var to_remove: Array[String] = []
	speed_modifier = 1.0
	var vis = animated_sprite if animated_sprite else sprite
	
	for s_name in statuses.keys():
		var data = statuses[s_name]
		data["duration"] -= delta
		if data["duration"] <= 0.0:
			to_remove.append(s_name)
		else:
			if s_name == "burning":
				var dps = data["param"]
				take_damage(dps * delta, GlobalEnums.ElementType.FIRE, false)
				if vis:
					vis.modulate = Color(1.0, 0.5, 0.2)
			elif s_name == "chilled":
				var slow = data["param"]
				speed_modifier *= (1.0 - slow)
				if vis:
					vis.modulate = Color(0.4, 0.8, 1.0)
				
	for r in to_remove:
		statuses.erase(r)
		
	if statuses.is_empty() and vis:
		vis.modulate = Color.WHITE

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
		
	var vis = animated_sprite if animated_sprite else sprite
	if vis:
		vis.modulate = Color(2.0, 2.0, 2.0)
		var tween = create_tween()
		tween.tween_property(vis, "modulate", Color.WHITE, 0.1)
	
	if current_health <= 0.0:
		_die()

func _die() -> void:
	if event_bus:
		event_bus.enemies_defeated += 1
		event_bus.emit_combat_event("enemy_killed", {"target": self})
	_spawn_gold()
	_spawn_xp_gem()
	if scale.x > 1.2 or archetype == GlobalEnums.EnemyArchetype.BOSS:
		_spawn_chest()
	enemy_defeated.emit(self)
	queue_free()

func _spawn_chest() -> void:
	if not get_parent():
		return
	var ch = chest_scene.instantiate() as RewardChest
	ch.global_position = global_position
	ch.chest_type = "gold" if archetype == GlobalEnums.EnemyArchetype.BOSS else "silver"
	get_parent().call_deferred("add_child", ch)

func _spawn_xp_gem() -> void:
	if not get_parent():
		return
	var gem = xp_gem_scene.instantiate() as XPGem
	gem.global_position = global_position
	if archetype == GlobalEnums.EnemyArchetype.BOSS:
		gem.value = 50.0
		gem.scale = Vector2(1.8, 1.8)
	elif archetype == GlobalEnums.EnemyArchetype.RANGED_CASTER:
		gem.value = 3.0
	elif archetype == GlobalEnums.EnemyArchetype.KAMIKAZE_EXPLODER:
		gem.value = 2.0
	elif scale.x > 1.2:
		gem.value = 10.0
		gem.scale = Vector2(1.4, 1.4)
	else:
		gem.value = 1.0
	get_parent().call_deferred("add_child", gem)

func _spawn_gold() -> void:
	if not get_parent():
		return
	var g = gold_scene.instantiate() as GoldDrop
	g.global_position = global_position
	if archetype == GlobalEnums.EnemyArchetype.BOSS:
		g.value = 50
		g.scale = Vector2(1.8, 1.8)
	elif archetype == GlobalEnums.EnemyArchetype.RANGED_CASTER:
		g.value = 3
	elif archetype == GlobalEnums.EnemyArchetype.KAMIKAZE_EXPLODER:
		g.value = 2
	elif scale.x > 1.2:
		g.value = 10
		g.scale = Vector2(1.4, 1.4)
	else:
		g.value = 1
	get_parent().call_deferred("add_child", g)

func _behavior_step(delta: float) -> void:
	var player = _get_player()
	if not player:
		return
		
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * base_speed * speed_modifier
	move_and_slide()
	
	if animated_sprite:
		animated_sprite.flip_h = dir.x < 0
	elif sprite:
		sprite.flip_h = dir.x < 0
		
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
