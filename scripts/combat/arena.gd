class_name Arena
extends Node2D

@export var radius: float = 650.0

@onready var bg_sprite: Sprite2D = get_node_or_null("ArenaBackground")

func _draw() -> void:
	# Subtle circular rune boundary
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, Color(0.4, 0.5, 0.7, 0.8), 6.0)
	draw_arc(Vector2.ZERO, radius * 0.7, 0.0, TAU, 48, Color(0.3, 0.4, 0.6, 0.4), 2.0)
	draw_arc(Vector2.ZERO, radius * 0.35, 0.0, TAU, 32, Color(0.35, 0.45, 0.65, 0.4), 2.0)
	
	# Four decorative torches/rune points
	var cardinal_dirs = [Vector2(radius, 0), Vector2(-radius, 0), Vector2(0, radius), Vector2(0, -radius)]
	for p in cardinal_dirs:
		draw_circle(p, 16.0, Color(0.9, 0.4, 0.1, 0.8))
		draw_circle(p, 8.0, Color(1.0, 0.9, 0.4, 1.0))
