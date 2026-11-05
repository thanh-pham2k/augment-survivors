class_name MapSelectUI
extends Control

signal returned_to_menu
signal map_selected(map_id: String)

@onready var gold_label: Label = $Header/GoldContainer/GoldLabel
@onready var back_button: Button = $Header/BackButton

@onready var btn_cathedral: Button = $HBox/CardCathedral/DepartBtn
@onready var btn_magma: Button = $HBox/CardMagma/DepartBtn
@onready var btn_frost: Button = $HBox/CardFrost/DepartBtn

const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
var sm: SaveManagerClass:
	get: return SaveManagerClass.get_instance()

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	if btn_cathedral:
		btn_cathedral.pressed.connect(func(): _select_and_launch("cathedral"))
	if btn_magma:
		btn_magma.pressed.connect(func(): _select_and_launch("magma"))
	if btn_frost:
		btn_frost.pressed.connect(func(): _select_and_launch("frost"))
		
	if gold_label and sm:
		gold_label.text = str(sm.gold)

func _select_and_launch(map_id: String) -> void:
	if sm:
		sm.selected_map = map_id
		sm.save_game()
	map_selected.emit(map_id)
	get_tree().change_scene_to_file("res://scenes/combat/gameplay_stage.tscn")

func _on_back_pressed() -> void:
	returned_to_menu.emit()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
