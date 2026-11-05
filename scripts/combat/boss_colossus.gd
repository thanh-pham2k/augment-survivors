class_name BossColossus
extends BaseEnemy

signal boss_shield_changed(crystals_remaining: int)
signal boss_health_changed(current: float, maximum: float)
signal boss_defeated

enum BossPhase {
	NORMAL,
	SHIELD_PHASE
}

enum BossAttack {
	IDLE,
	TELEGRAPH_SLAM,
	SLAM,
	TELEGRAPH_CHARGE,
	CHARGE,
	TELEGRAPH_METEORS,
	METEORS
}

var current_phase: BossPhase = BossPhase.SHIELD_PHASE
var attack_state: BossAttack = BossAttack.IDLE
var attack_timer: float = 0.0
var active_crystals: int = 3
var is_invulnerable: bool = true

var charge_direction: Vector2 = Vector2.DOWN
var charge_duration: float = 0.65

var enemy_proj_scene: PackedScene = preload("res://scenes/combat/enemy_projectile.tscn")

@onready var shield_sprite: Node2D = $ShieldVisual
@onready var slam_telegraph: Node2D = $TelegraphSlam
@onready var fan_telegraph: Node2D = $TelegraphFan
@onready var charge_telegraph: Node2D = $TelegraphCharge

func _ready() -> void:
	super._ready()
	archetype = GlobalEnums.EnemyArchetype.BOSS
	max_health = 1200.0
	current_health = 1200.0
	base_speed = 55.0
	contact_damage = 30.0
	is_invulnerable = true
	_update_shield_visual()

func take_damage(amount: float, element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE, spawn_popup: bool = true) -> void:
	if is_invulnerable:
		if spawn_popup:
			var dnum = damage_num_scene.instantiate() as FloatingDamageNumber
			dnum.global_position = global_position
			dnum.setup(0, element) # Immune!
			get_parent().add_child(dnum)
		return
	super.take_damage(amount, element, spawn_popup)
	boss_health_changed.emit(current_health, max_health)

func _die() -> void:
	boss_defeated.emit()
	super._die()

func on_crystal_destroyed() -> void:
	active_crystals = max(0, active_crystals - 1)
	boss_shield_changed.emit(active_crystals)
	if active_crystals <= 0:
		is_invulnerable = false
		current_phase = BossPhase.NORMAL
		_update_shield_visual()

func _update_shield_visual() -> void:
	if shield_sprite:
		shield_sprite.visible = is_invulnerable

func _behavior_step(delta: float) -> void:
	attack_timer += delta
	var player = _get_player()
	if not player:
		return
		
	match attack_state:
		BossAttack.IDLE:
			_hide_all_telegraphs()
			
			var dir = (player.global_position - global_position).normalized()
			velocity = dir * base_speed * speed_modifier
			move_and_slide()
			
			if animated_sprite:
				animated_sprite.flip_h = dir.x < 0
			elif sprite:
				sprite.flip_h = dir.x < 0
			
			if attack_timer >= 2.6:
				attack_timer = 0.0
				var roll = randf()
				if roll < 0.40:
					attack_state = BossAttack.TELEGRAPH_SLAM
				elif roll < 0.75:
					attack_state = BossAttack.TELEGRAPH_CHARGE
					charge_direction = (player.global_position - global_position).normalized()
				else:
					attack_state = BossAttack.TELEGRAPH_METEORS
					
		BossAttack.TELEGRAPH_SLAM:
			velocity = Vector2.ZERO
			slam_telegraph.visible = true
			if attack_timer >= 1.0:
				attack_timer = 0.0
				attack_state = BossAttack.SLAM
				
		BossAttack.SLAM:
			slam_telegraph.visible = false
			# 1. Melee epicenter damage
			if global_position.distance_to(player.global_position) < 180.0:
				player.take_damage(45.0)
				
			# 2. Expanding radial shockwave ring of 12 fiery projectiles
			var proj_count = 12
			for i in range(proj_count):
				var angle = (float(i) / proj_count) * TAU
				var p_dir = Vector2(cos(angle), sin(angle))
				var ep = enemy_proj_scene.instantiate() as EnemyProjectile
				ep.global_position = global_position
				ep.direction = p_dir
				ep.speed = 340.0
				ep.damage = 22.0
				get_parent().add_child(ep)
				
			attack_state = BossAttack.IDLE
			
		BossAttack.TELEGRAPH_CHARGE:
			velocity = Vector2.ZERO
			charge_telegraph.visible = true
			charge_telegraph.rotation = charge_direction.angle()
			
			# Modulate warning flash
			if sprite:
				sprite.modulate = Color(1.8, 0.4, 0.4) if fmod(attack_timer, 0.2) < 0.1 else Color.WHITE
				
			if attack_timer >= 0.85:
				attack_timer = 0.0
				charge_telegraph.visible = false
				if sprite:
					sprite.modulate = Color.WHITE
				attack_state = BossAttack.CHARGE
				
		BossAttack.CHARGE:
			velocity = charge_direction * 520.0
			move_and_slide()
			
			# Check contact impact during rush
			if global_position.distance_to(player.global_position) < 65.0:
				player.take_damage(40.0)
				
			if attack_timer >= charge_duration:
				attack_timer = 0.0
				velocity = Vector2.ZERO
				attack_state = BossAttack.IDLE
				
		BossAttack.TELEGRAPH_METEORS:
			velocity = Vector2.ZERO
			if sprite:
				sprite.modulate = Color(1.5, 0.8, 0.2)
			if attack_timer >= 1.0:
				attack_timer = 0.0
				if sprite:
					sprite.modulate = Color.WHITE
				_trigger_meteor_barrage(player)
				attack_state = BossAttack.IDLE

func _trigger_meteor_barrage(player: Node2D) -> void:
	# Spawn 3 targeted meteor impact zones around player
	var positions: Array[Vector2] = [
		player.global_position,
		player.global_position + (player.velocity * 0.45),
		player.global_position + Vector2(randf_range(-90, 90), randf_range(-90, 90))
	]
	
	for i in range(positions.size()):
		var target_pos = positions[i]
		# Delay each meteor slightly for a cascade rain effect
		var delay = 0.25 * i
		get_tree().create_timer(delay).timeout.connect(func():
			_spawn_meteor_impact(target_pos)
		)

func _spawn_meteor_impact(pos: Vector2) -> void:
	var indicator = TelegraphVisualizer.new()
	indicator.shape_type = "circle"
	indicator.radius = 80.0
	indicator.fill_color = Color(1.0, 0.3, 0.1, 0.35)
	indicator.outline_color = Color(1.0, 0.5, 0.2, 1.0)
	indicator.global_position = pos
	get_parent().add_child(indicator)
	
	# After 0.9s delay, meteor crashes down
	var tween = create_tween()
	tween.tween_interval(0.9)
	tween.tween_callback(func():
		indicator.queue_free()
		# Check damage to player
		var p = _get_player()
		if p and p.global_position.distance_to(pos) <= 80.0:
			p.take_damage(45.0)
			
		# Visual explosion burst
		var exp_sprite = Sprite2D.new()
		exp_sprite.texture = load("res://assets/final_sprites/vfx/fire_exp.png")
		exp_sprite.global_position = pos
		exp_sprite.scale = Vector2(1.8, 1.8)
		get_parent().add_child(exp_sprite)
		var exp_tween = create_tween()
		exp_tween.tween_property(exp_sprite, "modulate:a", 0.0, 0.4)
		exp_tween.tween_callback(func(): exp_sprite.queue_free())
	)

func _hide_all_telegraphs() -> void:
	if slam_telegraph:
		slam_telegraph.visible = false
	if fan_telegraph:
		fan_telegraph.visible = false
	if charge_telegraph:
		charge_telegraph.visible = false
