class_name DarkMageEnemy
extends BaseEnemy

enum MageState {
	REPOSITIONING,
	AIMING,
	CASTING
}

var state: MageState = MageState.REPOSITIONING
var timer: float = 0.0
var aim_direction: Vector2 = Vector2.DOWN
var aim_line: Line2D
var enemy_proj_scene: PackedScene = preload("res://scenes/combat/enemy_projectile.tscn")

const PREFERRED_MIN_DIST: float = 240.0
const PREFERRED_MAX_DIST: float = 380.0

func _ready() -> void:
	super._ready()
	archetype = GlobalEnums.EnemyArchetype.RANGED_CASTER
	max_health = 35.0
	current_health = 35.0
	base_speed = 65.0
	contact_damage = 8.0
	
	# Create telegraph aiming line
	aim_line = Line2D.new()
	aim_line.width = 2.0
	aim_line.default_color = Color(1.0, 0.2, 0.8, 0.6)
	aim_line.visible = false
	add_child(aim_line)
	
	if animated_sprite:
		animated_sprite.play("walk")

func _behavior_step(delta: float) -> void:
	var player = _get_player()
	if not player:
		return
		
	timer += delta
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var dir = to_player.normalized()
	
	match state:
		MageState.REPOSITIONING:
			aim_line.visible = false
			if animated_sprite and animated_sprite.animation != "walk":
				animated_sprite.play("walk")
			# Kite: If too close, retreat; if too far, approach
			if dist < PREFERRED_MIN_DIST:
				velocity = -dir * base_speed * speed_modifier
			elif dist > PREFERRED_MAX_DIST:
				velocity = dir * base_speed * speed_modifier
			else:
				# Strafe perpendicularly
				velocity = dir.orthogonal() * (base_speed * 0.7) * speed_modifier
				
			move_and_slide()
			
			if animated_sprite:
				animated_sprite.flip_h = dir.x < 0
			elif sprite:
				sprite.flip_h = dir.x < 0
				
			if timer >= 2.2:
				timer = 0.0
				state = MageState.AIMING
				aim_direction = dir
				if animated_sprite:
					animated_sprite.play("cast")
				
		MageState.AIMING:
			velocity = Vector2.ZERO
			# Lock direction 0.2s before firing to give player a clear dodge window
			if timer < 0.5:
				aim_direction = (player.global_position - global_position).normalized()
				aim_line.default_color = Color(1.0, 0.3, 0.7, 0.45)
				aim_line.width = 1.5
			else:
				# Flashing warning lock-on
				aim_line.default_color = Color(1.0, 0.1, 0.2, 0.9)
				aim_line.width = 3.0

			if animated_sprite:
				animated_sprite.flip_h = aim_direction.x < 0
			aim_line.visible = true
			aim_line.clear_points()
			aim_line.add_point(Vector2.ZERO)
			aim_line.add_point(aim_direction * 400.0)
			
			if timer >= 0.7:
				timer = 0.0
				aim_line.visible = false
				_cast_dark_orb(aim_direction)
				state = MageState.CASTING
				
		MageState.CASTING:
			velocity = Vector2.ZERO
			if timer >= 0.3:
				timer = 0.0
				state = MageState.REPOSITIONING

func _cast_dark_orb(fire_dir: Vector2) -> void:
	var proj = enemy_proj_scene.instantiate() as EnemyProjectile
	proj.global_position = global_position
	proj.direction = fire_dir
	proj.speed = 310.0
	proj.damage = 18.0
	get_parent().add_child(proj)
