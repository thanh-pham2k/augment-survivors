class_name Arena
extends Node2D

@export var radius: float = 550.0
@export var floor_color: Color = Color(0.1, 0.11, 0.15)
@export var border_color: Color = Color(0.2, 0.22, 0.3)

func _draw() -> void:
	# Circular arena floor
	draw_circle(Vector2.ZERO, radius, floor_color)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, border_color, 8.0)
	
	# Decorative inner runes / circles
	draw_arc(Vector2.ZERO, radius * 0.6, 0.0, TAU, 48, Color(0.14, 0.16, 0.22), 2.0)
	draw_arc(Vector2.ZERO, radius * 0.3, 0.0, TAU, 32, Color(0.16, 0.18, 0.25), 2.0)
