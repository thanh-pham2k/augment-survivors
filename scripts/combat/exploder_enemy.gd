class_name ExploderEnemy
extends BaseEnemy

var is_detonating: bool = false
var detonate_timer: float = 0.0
const DETONATE_DELAY: float = 0.75
const EXPLOSION_RADIUS: float = 110.0
const EXPLOSION_DAMAGE: float = 35.0

var indicator: TelegraphVisualizer

func _ready() -> void:
	super._ready()
	archetype = GlobalEnums.EnemyArchetype.KAMIKAZE_EXPLODER
	max_health = 28.0
	current_health = 28.0
	base_speed = 135.0
	contact_damage = 10.0
	
	indicator = TelegraphVisualizer.new()
	indicator.shape_type = "circle"
	indicator.radius = EXPLOSION_RADIUS
	indicator.fill_color = Color(1.0, 0.2, 0.1, 0.3)
	indicator.outline_color = Color(1.0, 0.4, 0.1, 0.9)
	indicator.visible = false
	add_child(indicator)
	
	if animated_sprite:
		animated_sprite.play("run")

func _behavior_step(delta: float) -> void:
	var player = _get_player()
	if not player:
		return
		
	var dist = global_position.distance_to(player.global_position)
	
	if is_detonating:
		detonate_timer += delta
		velocity = Vector2.ZERO
		indicator.visible = true
		
		# Rapid flash
		var vis = animated_sprite if animated_sprite else sprite
		if vis:
			vis.modulate = Color(2.5, 0.5, 0.2) if fmod(detonate_timer, 0.14) < 0.07 else Color(1.0, 0.2, 0.1)
			
		if detonate_timer >= DETONATE_DELAY:
			_explode()
		return
		
	# Chase player at high speed
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * base_speed * speed_modifier
	move_and_slide()
	
	if animated_sprite:
		animated_sprite.flip_h = dir.x < 0
	elif sprite:
		sprite.flip_h = dir.x < 0
		
	if dist <= 75.0:
		is_detonating = true
		detonate_timer = 0.0
		if animated_sprite:
			animated_sprite.play("detonate")

func _explode() -> void:
	# Damage player if in radius
	var player = _get_player()
	if player and global_position.distance_to(player.global_position) <= EXPLOSION_RADIUS:
		player.take_damage(EXPLOSION_DAMAGE)
		
	# Also damage nearby enemies (friendly fire chain explosion!)
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if is_instance_valid(e) and e != self and e is BaseEnemy:
			if global_position.distance_to(e.global_position) <= EXPLOSION_RADIUS:
				e.take_damage(40.0, GlobalEnums.ElementType.FIRE)
				
	# Visual blast
	var exp_sprite = Sprite2D.new()
	exp_sprite.texture = load("res://assets/final_sprites/vfx/fire_exp.png")
	exp_sprite.global_position = global_position
	exp_sprite.scale = Vector2(1.5, 1.5)
	get_parent().add_child(exp_sprite)
	var tween = create_tween()
	tween.tween_property(exp_sprite, "modulate:a", 0.0, 0.35)
	tween.tween_callback(func(): exp_sprite.queue_free())
	
	if event_bus:
		event_bus.enemies_defeated += 1
	enemy_defeated.emit(self)
	queue_free()
