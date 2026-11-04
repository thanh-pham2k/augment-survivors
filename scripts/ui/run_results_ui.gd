class_name RunResultsUI
extends Control

signal play_again_requested

@onready var bg_texture: TextureRect = $Background
@onready var time_label: Label = $VBoxContainer/StatsGrid/TimeValue
@onready var kills_label: Label = $VBoxContainer/StatsGrid/KillsValue
@onready var damage_chart_container: VBoxContainer = $VBoxContainer/DamageChart
@onready var synergies_list: VBoxContainer = $VBoxContainer/SynergiesList
@onready var play_again_btn: Button = $VBoxContainer/PlayAgainButton

func _ready() -> void:
	play_again_btn.pressed.connect(func(): play_again_requested.emit())

func show_results(is_victory: bool, time_str: String, kills: int, damage_contrib: Dictionary, synergies: Dictionary) -> void:
	visible = true
	get_tree().paused = true
	
	var header = $VBoxContainer/Header as Label
	if is_victory:
		header.text = "🏆 VICTORY 🏆"
		header.modulate = Color(1.0, 0.88, 0.2)
	else:
		header.text = "☠ DEFEAT ☠"
		header.modulate = Color(0.9, 0.2, 0.2)
		
	time_label.text = time_str
	kills_label.text = str(kills)
	
	# Render Damage Contribution Bars
	for child in damage_chart_container.get_children():
		child.queue_free()
		
	var total_dmg: float = 0.0
	for k in damage_contrib.keys():
		total_dmg += damage_contrib[k]
	if total_dmg <= 0.0:
		total_dmg = 1.0
		
	var colors = {
		"Fire": Color(1.0, 0.45, 0.1),
		"Ice": Color(0.3, 0.8, 1.0),
		"Lightning": Color(1.0, 0.9, 0.2),
		"Physical": Color(0.9, 0.6, 0.2)
	}
	
	for cat in ["Fire", "Lightning", "Physical", "Ice"]:
		var val = damage_contrib.get(cat, 0.0)
		var pct = int((val / total_dmg) * 100.0)
		
		var row = HBoxContainer.new()
		var lbl = Label.new()
		lbl.custom_minimum_size = Vector2(130, 0)
		lbl.text = cat + ":"
		row.add_child(lbl)
		
		var pbar = ProgressBar.new()
		pbar.custom_minimum_size = Vector2(280, 22)
		pbar.value = pct
		pbar.show_percentage = true
		row.add_child(pbar)
		
		damage_chart_container.add_child(row)
		
	# Render Synergies
	for child in synergies_list.get_children():
		child.queue_free()
		
	if synergies.is_empty():
		var l = Label.new()
		l.text = "None discovered this run."
		synergies_list.add_child(l)
	else:
		for syn_id in synergies.keys():
			var s_data = synergies[syn_id]
			var l = Label.new()
			l.text = "⚡ " + s_data.get("name", syn_id) + " — " + s_data.get("desc", "")
			l.modulate = Color(1.0, 0.9, 0.4)
			synergies_list.add_child(l)
