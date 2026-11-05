class_name StagePortal
extends Area2D

signal portal_entered

var _pulse_timer: float = 0.0

@onready var indicator: TelegraphVisualizer = $TelegraphVisualizer
@onready var label: Label = $Label
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")

func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	_pulse_timer += delta * 4.0
	if indicator:
		indicator.radius = 55.0 + sin(_pulse_timer) * 6.0
		indicator.queue_redraw()
	if sprite and sprite.hframes > 1:
		sprite.frame = int(_pulse_timer) % sprite.hframes

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		portal_entered.emit()
