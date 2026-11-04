class_name BossColossus
extends BaseEnemy

signal boss_shield_changed(crystals_remaining: int)
signal boss_defeated

enum BossPhase {
	NORMAL,
	SHIELD_PHASE
}

enum BossAttack {
	IDLE,
	TELEGRAPH_SLAM,
	SLAM,
	TELEGRAPH_FAN,
	FAN_SWEEP
}

var current_phase: BossPhase = BossPhase.SHIELD_PHASE
var attack_state: BossAttack = BossAttack.IDLE
var attack_timer: float = 0.0
var active_crystals: int = 3
var is_invulnerable: bool = true

@onready var shield_sprite: Node2D = $ShieldVisual
@onready var slam_telegraph: Node2D = $TelegraphSlam
@onready var fan_telegraph: Node2D = $TelegraphFan

func _ready() -> void:
	super._ready()
	archetype = GlobalEnums.EnemyArchetype.BOSS
	max_health = 1200.0
	current_health = 1200.0
	base_speed = 45.0
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
			slam_telegraph.visible = false
			fan_telegraph.visible = false
			
			var dir = (player.global_position - global_position).normalized()
			velocity = dir * base_speed * speed_modifier
			move_and_slide()
			
			if attack_timer >= 3.0:
				attack_timer = 0.0
				if randf() > 0.5:
					attack_state = BossAttack.TELEGRAPH_SLAM
				else:
					attack_state = BossAttack.TELEGRAPH_FAN
					
		BossAttack.TELEGRAPH_SLAM:
			velocity = Vector2.ZERO
			slam_telegraph.visible = true
			# 1.0s warning circle
			if attack_timer >= 1.0:
				attack_timer = 0.0
				attack_state = BossAttack.SLAM
				
		BossAttack.SLAM:
			slam_telegraph.visible = false
			# Check AoE damage to player
			if global_position.distance_to(player.global_position) < 140.0:
				player.take_damage(40.0)
			attack_state = BossAttack.IDLE
			
		BossAttack.TELEGRAPH_FAN:
			velocity = Vector2.ZERO
			fan_telegraph.visible = true
			# 0.8s warning fan
			if attack_timer >= 0.8:
				attack_timer = 0.0
				attack_state = BossAttack.FAN_SWEEP
				
		BossAttack.FAN_SWEEP:
			fan_telegraph.visible = false
			var dir_to_p = (player.global_position - global_position).normalized()
			if global_position.distance_to(player.global_position) < 180.0:
				player.take_damage(35.0)
			attack_state = BossAttack.IDLE
