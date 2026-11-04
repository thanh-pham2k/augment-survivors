class_name MainMenu
extends Control

@onready var start_button: Button = $VBoxContainer/StartRun
@onready var codex_button: Button = $VBoxContainer/AugmentCodex
@onready var quit_button: Button = $VBoxContainer/Quit

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	codex_button.pressed.connect(_on_codex_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/combat/gameplay_stage.tscn")

func _on_codex_pressed() -> void:
	pass # Future milestone expansion

func _on_quit_pressed() -> void:
	get_tree().quit()
