class_name TelegraphVisualizer
extends Node2D

@export var shape_type: String = "circle" # "circle" or "fan"
@export var radius: float = 120.0
@export var fan_angle_deg: float = 90.0
@export var fill_color: Color = Color(1.0, 0.2, 0.2, 0.3)
@export var outline_color: Color = Color(1.0, 0.3, 0.3, 0.9)

func _draw() -> void:
	if not visible:
		return
	if shape_type == "circle":
		draw_circle(Vector2.ZERO, radius, fill_color)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 32, outline_color, 2.0)
	elif shape_type == "fan":
		var points: PackedVector2Array = [Vector2.ZERO]
		var half_rad = deg_to_rad(fan_angle_deg / 2.0)
		var segments = 16
		for i in range(segments + 1):
			var a = -half_rad + (float(i) / segments) * (half_rad * 2.0)
			points.append(Vector2(cos(a), sin(a)) * radius)
		draw_colored_polygon(points, fill_color)
		draw_polyline(points, outline_color, 2.0)
