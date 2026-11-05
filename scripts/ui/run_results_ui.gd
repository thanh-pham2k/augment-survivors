class_name RunResultsUI
extends Control

signal play_again_requested
signal menu_requested

@onready var header_label: Label = $PanelContainer/MarginContainer/VBoxMain/Header
@onready var hero_avatar: TextureRect = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/LeftCol/AvatarPanel/HeroAvatar
@onready var augments_grid: HBoxContainer = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/LeftCol/AugmentsGrid
@onready var synergies_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/LeftCol/SynergiesList

@onready var time_val: Label = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/RightCol/StatsGrid/TimeVal
@onready var kills_val: Label = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/RightCol/StatsGrid/KillsVal
@onready var best_val: Label = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/RightCol/StatsGrid/BestVal

@onready var build_summary_label: Label = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/RightCol/BuildSummaryBox/SummaryText
@onready var damage_chart: VBoxContainer = $PanelContainer/MarginContainer/VBoxMain/ContentHBox/RightCol/DamageChartBox

@onready var play_again_btn: Button = get_node_or_null("PanelContainer/MarginContainer/VBoxMain/ActionButtons/PlayAgainButton")
@onready var menu_btn: Button = get_node_or_null("PanelContainer/MarginContainer/VBoxMain/ActionButtons/MenuButton")

func _ready() -> void:
	if play_again_btn:
		play_again_btn.pressed.connect(func(): play_again_requested.emit())
	if menu_btn:
		menu_btn.pressed.connect(func():
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
		)

func show_results(is_victory: bool, time_str: String, kills: int, damage_contrib: Dictionary, synergies: Dictionary, active_augments: Array[AugmentData] = [], extra_stats: Dictionary = {}) -> void:
	visible = true
	get_tree().paused = true
	
	if is_victory:
		header_label.text = "🏆 HUYỀN THOẠI SINH TỒN 🏆"
		header_label.modulate = Color(1.0, 0.88, 0.25)
	else:
		header_label.text = "⚔️ KẾT QUẢ SINH TỒN VÔ TẬN ⚔️"
		header_label.modulate = Color(0.95, 0.45, 0.25)
		
	time_val.text = time_str
	kills_val.text = str(kills)
	var lvl = extra_stats.get("level", 1)
	best_val.text = "Lv. %d" % lvl
	
	# Render Acquired Augments (6 slots)
	for child in augments_grid.get_children():
		child.queue_free()
	for i in range(6):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(44, 44)
		if i < active_augments.size():
			var aug = active_augments[i]
			var tr = TextureRect.new()
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			if aug.icon_path != "" and ResourceLoader.exists(aug.icon_path):
				tr.texture = load(aug.icon_path)
			slot.add_child(tr)
		augments_grid.add_child(slot)
		
	# Render Synergies
	for child in synergies_list.get_children():
		child.queue_free()
	if synergies.is_empty():
		var l = Label.new()
		l.text = "None discovered this run."
		l.modulate = Color(0.7, 0.7, 0.7)
		synergies_list.add_child(l)
	else:
		for syn_id in synergies.keys():
			var s_data = synergies[syn_id]
			var row = HBoxContainer.new()
			var icon_l = Label.new()
			icon_l.text = "⚡"
			icon_l.modulate = Color(1.0, 0.85, 0.2)
			row.add_child(icon_l)
			var text_l = Label.new()
			text_l.text = s_data.get("name", syn_id)
			text_l.modulate = Color(0.95, 0.95, 1.0)
			row.add_child(text_l)
			synergies_list.add_child(row)
			
	# Render Damage Contribution Bars
	for child in damage_chart.get_children():
		child.queue_free()
		
	var total_dmg: float = 0.0
	for k in damage_contrib.keys():
		total_dmg += damage_contrib[k]
	if total_dmg <= 0.0:
		total_dmg = 1.0
		
	var cats = [
		{"name": "Burning (DoT)", "key": "Fire", "color": Color(1.0, 0.45, 0.15)},
		{"name": "Chain Lightning", "key": "Lightning", "color": Color(1.0, 0.9, 0.25)},
		{"name": "Fire Shot", "key": "Physical", "color": Color(1.0, 0.65, 0.2)},
		{"name": "Frostbite (Slow)", "key": "Ice", "color": Color(0.35, 0.8, 1.0)}
	]
	
	for c in cats:
		var val = damage_contrib.get(c["key"], 0.0)
		var pct = int((val / total_dmg) * 100.0)
		
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		
		var lbl = Label.new()
		lbl.custom_minimum_size = Vector2(130, 0)
		lbl.text = c["name"]
		lbl.add_theme_font_size_override("font_size", 13)
		row.add_child(lbl)
		
		var pbar = ProgressBar.new()
		pbar.custom_minimum_size = Vector2(220, 18)
		pbar.value = pct
		pbar.show_percentage = false
		pbar.modulate = c["color"]
		row.add_child(pbar)
		
		var pct_lbl = Label.new()
		pct_lbl.text = str(pct) + "%"
		pct_lbl.custom_minimum_size = Vector2(40, 0)
		pct_lbl.add_theme_font_size_override("font_size", 13)
		row.add_child(pct_lbl)
		
		damage_chart.add_child(row)
		
	# Dynamic build summary based on top damage category
	if damage_contrib.get("Fire", 0.0) > damage_contrib.get("Ice", 0.0):
		build_summary_label.text = "A potent Fire-Lightning build that spreads Burning and chains damage across enemy swarms."
	else:
		build_summary_label.text = "A tactical Frost-Control build slowing enemies and shattering frozen targets."
