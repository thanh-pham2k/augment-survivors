class_name BatEnemy
extends BaseEnemy

enum BatState {
	FLANKING,
	TELEGRAPHING,
	DASHING
}

var state: BatState = BatState.FLANKING
var flank_angle: float = 0.0
var flank_distance: float = 160.0
var timer: float = 0.0
var dash_target: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	archetype = GlobalEnums.EnemyArchetype.FLANKER
	base_speed = 110.0
	contact_damage = 15.0
	flank_angle = randf() * TAU

func _behavior_step(delta: float) -> void:
	var player = _get_player()
	if not player:
		return
		
	timer += delta
	
	match state:
		BatState.FLANKING:
			if telegraph_line:
				telegraph_line.visible = false
			# Orbit around player
			flank_angle += 1.5 * delta
			var desired_pos = player.global_position + Vector2(cos(flank_angle), sin(flank_angle)) * flank_distance
			var dir = (desired_pos - global_position).normalized()
			velocity = dir * base_speed * speed_modifier
			move_and_slide()
			
			if timer >= 3.0:
				timer = 0.0
				state = BatState.TELEGRAPHING
				dash_target = player.global_position
				
		BatState.TELEGRAPHING:
			velocity = Vector2.ZERO
			# Show Red Telegraph Line
			if telegraph_line:
				telegraph_line.visible = true
				telegraph_line.clear_points()
				telegraph_line.add_point(Vector2.ZERO)
				telegraph_line.add_point(to_local(dash_target))
				telegraph_line.default_color = Color(1.0, 0.2, 0.2, 0.8)
				
			if timer >= 0.7: # 0.7s telegraph warning
				timer = 0.0
				state = BatState.DASHING
				if telegraph_line:
					telegraph_line.visible = false
					
		BatState.DASHING:
			var dir = (dash_target - global_position).normalized()
			velocity = dir * base_speed * 3.0 * speed_modifier
			move_and_slide()
			
			if timer >= 0.4 or global_position.distance_to(dash_target) < 15.0:
				timer = 0.0
				state = BatState.FLANKING
				
	# Contact damage with player
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("player") and collider.has_method("take_damage"):
			collider.take_damage(contact_damage * delta * 2.0)
