class_name Arena
extends Node2D

@export var radius: float = 650.0

@onready var bg_sprite: Sprite2D = get_node_or_null("ArenaBackground")
@onready var endless_floor: Sprite2D = get_node_or_null("EndlessFloor")

var biome_textures = {
	"cathedral": preload("res://assets/sprites/endless_floor_tile.png"),
	"magma": preload("res://assets/sprites/biome_magma_tile.png"),
	"frost": preload("res://assets/sprites/biome_frost_tile.png")
}

var current_biome: String = "cathedral"

func _ready() -> void:
	if endless_floor:
		endless_floor.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		endless_floor.region_enabled = true
		endless_floor.region_rect = Rect2(-2500, -2000, 5000, 4000)
		endless_floor.z_index = -10
	if bg_sprite:
		bg_sprite.z_index = -5

func set_biome(biome_name: String) -> void:
	if biome_textures.has(biome_name) and endless_floor:
		current_biome = biome_name
		endless_floor.texture = biome_textures[biome_name]
		print("[ARENA] Biome transitioned to: ", biome_name)

func _process(_delta: float) -> void:
	if endless_floor:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var p = players[0] as Node2D
			endless_floor.global_position = p.global_position
			endless_floor.region_rect.position = p.global_position - Vector2(2500, 2000)
