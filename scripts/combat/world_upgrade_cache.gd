class_name WorldUpgradeCache
extends Area2D

signal cache_claimed(cache: WorldUpgradeCache)
signal cache_despawned(cache: WorldUpgradeCache)

enum CacheState { AVAILABLE, CLAIMED, DESPAWNED }

@export var cache_id: String = ""
@export var rarity: String = "rare" # "common", "rare", "legendary"
@export var lifetime: float = 120.0

var state: CacheState = CacheState.AVAILABLE
var _pulse_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	monitoring = true
	_pulse_timer = randf() * TAU
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if rarity == "legendary":
		modulate = Color(1.3, 1.1, 0.4)
	elif rarity == "rare":
		modulate = Color(0.6, 1.2, 1.4)
	else:
		modulate = Color(1.0, 1.0, 1.0)

func _physics_process(delta: float) -> void:
	if state != CacheState.AVAILABLE:
		return
		
	_pulse_timer += delta * 3.0
	if sprite:
		# Floating crystal pulse
		sprite.position.y = sin(_pulse_timer) * 4.0
		
	lifetime -= delta
	if lifetime <= 0.0:
		_despawn()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		claim(body)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("player"):
		claim(parent)

func claim(player: Node2D) -> bool:
	if state != CacheState.AVAILABLE:
		return false
	state = CacheState.CLAIMED
	set_deferred("monitoring", false)
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	cache_claimed.emit(self)
	
	# Shrink & glow tween
	var tw = create_tween()
	tw.parallel().tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 0.18)
	tw.tween_callback(queue_free)
	return true

func _despawn() -> void:
	if state != CacheState.AVAILABLE:
		return
	state = CacheState.DESPAWNED
	set_deferred("monitoring", false)
	cache_despawned.emit(self)
	queue_free()
