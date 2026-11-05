class_name MainMenu
extends Control

@onready var start_button: BaseButton = $RightPanel/VBoxContainer/StartRun
@onready var equipment_button: BaseButton = $RightPanel/VBoxContainer/Equipment
@onready var shop_button: BaseButton = $RightPanel/VBoxContainer/Shop
@onready var quit_button: BaseButton = $RightPanel/VBoxContainer/Quit

const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
var sm: SaveManagerClass:
	get: return SaveManagerClass.get_instance()

func _ready() -> void:
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	if equipment_button:
		equipment_button.pressed.connect(_on_equipment_pressed)
	if shop_button:
		shop_button.pressed.connect(_on_shop_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
	
	for btn in [start_button, equipment_button, shop_button, quit_button]:
		if btn:
			btn.mouse_entered.connect(func(): btn.modulate = Color(1.25, 1.25, 1.25))
			btn.mouse_exited.connect(func(): btn.modulate = Color(1.0, 1.0, 1.0))

func _on_start_pressed() -> void:
	# Single Endless Arena — Bấm vào là chơi ngay lập tức!
	if sm:
		sm.selected_map = "cathedral"
	get_tree().change_scene_to_file("res://scenes/combat/gameplay_stage.tscn")

func _on_equipment_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/equipment_ui.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/meta_shop_ui.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
