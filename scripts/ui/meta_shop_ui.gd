class_name MetaShopUI
extends Control

signal returned_to_menu

@onready var gold_label: Label = $Header/GoldContainer/GoldLabel
@onready var back_button: Button = $Header/BackButton
@onready var grid_container: VBoxContainer = $ScrollContainer/VBoxContainer

const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
var sm: SaveManagerClass:
	get: return SaveManagerClass.get_instance()

const UPGRADES_CONFIG = {
	"max_hp": {
		"title": "Trái Tim Bất Diệt (Max HP)",
		"badge_icon": "res://assets/sprites/ui/badge_max_hp.png",
		"desc": "+15 Máu tối đa vĩnh viễn cho mọi cuộc viễn chinh",
		"base_cost": 40,
		"cost_step": 30,
		"per_level_text": "+15 HP / cấp"
	},
	"move_speed": {
		"title": "Đôi Giày Phong Lôi (Tốc Chạy)",
		"badge_icon": "res://assets/sprites/ui/badge_move_speed.png",
		"desc": "+5% Tốc độ di chuyển cơ bản",
		"base_cost": 35,
		"cost_step": 25,
		"per_level_text": "+5% Speed / cấp"
	},
	"dash_cooldown": {
		"title": "Bóng Ma Hư Không (Hồi Dash)",
		"badge_icon": "res://assets/sprites/ui/badge_dash_cooldown.png",
		"desc": "-0.3s Thời gian hồi chiêu Lướt (Dash)",
		"base_cost": 50,
		"cost_step": 40,
		"per_level_text": "-0.3s CD / cấp"
	},
	"magnet_radius": {
		"title": "Nam Châm Tinh Thể (Hút Vàng)",
		"badge_icon": "res://assets/sprites/ui/badge_magnet_radius.png",
		"desc": "+30px Bán kính tự động hút tiền vàng rơi trên sàn",
		"base_cost": 30,
		"cost_step": 20,
		"per_level_text": "+30px Bán kính / cấp"
	},
	"rerolls": {
		"title": "Xúc Xắc Vận Mệnh (Đổi Thẻ)",
		"badge_icon": "res://assets/sprites/ui/badge_rerolls.png",
		"desc": "+1 Lượt xúc xắc đổ lại thẻ nâng cấp Augment mỗi trận",
		"base_cost": 60,
		"cost_step": 50,
		"per_level_text": "+1 Reroll / cấp"
	}
}

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	refresh_ui()

func refresh_ui() -> void:
	if gold_label and sm:
		gold_label.text = str(sm.gold)
	_build_upgrade_rows()

func _build_upgrade_rows() -> void:
	if not grid_container or not sm:
		return
		
	for c in grid_container.get_children():
		c.queue_free()
		
	for u_key in ["max_hp", "move_speed", "dash_cooldown", "magnet_radius", "rerolls"]:
		var cfg = UPGRADES_CONFIG[u_key]
		var curr_lvl = sm.meta_upgrades.get(u_key, 0)
		var cost = cfg["base_cost"] + curr_lvl * cfg["cost_step"]
		var is_max = curr_lvl >= 5
		
		var row_panel = PanelContainer.new()
		row_panel.custom_minimum_size = Vector2(0, 85)
		
		var hb = HBoxContainer.new()
		hb.add_theme_constant_override("separation", 18)
		row_panel.add_child(hb)
		
		# Icon Badge Box
		var icon_rect = TextureRect.new()
		icon_rect.custom_minimum_size = Vector2(72, 72)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if ResourceLoader.exists(cfg["badge_icon"]):
			icon_rect.texture = load(cfg["badge_icon"])
		hb.add_child(icon_rect)
		
		# Info VBox
		var vb = VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		hb.add_child(vb)
		
		var title_lbl = Label.new()
		title_lbl.text = "%s — Cấp %d/5" % [cfg["title"], curr_lvl]
		title_lbl.add_theme_font_size_override("font_size", 16)
		title_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.5))
		vb.add_child(title_lbl)
		
		var desc_lbl = Label.new()
		desc_lbl.text = "%s (%s)" % [cfg["desc"], cfg["per_level_text"]]
		desc_lbl.add_theme_font_size_override("font_size", 13)
		desc_lbl.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
		vb.add_child(desc_lbl)
		
		# Level pips visual: e.g. [ ■ ■ ■ □ □ ]
		var pips_lbl = Label.new()
		var pips_str = ""
		for i in range(5):
			if i < curr_lvl:
				pips_str += "🔷 "
			else:
				pips_str += "🔹 "
		pips_lbl.text = pips_str.strip_edges()
		pips_lbl.add_theme_font_size_override("font_size", 12)
		vb.add_child(pips_lbl)
		
		# Upgrade Button
		var buy_btn = Button.new()
		buy_btn.custom_minimum_size = Vector2(210, 50)
		buy_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		buy_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		if is_max:
			buy_btn.text = "⭐ TỐI ĐA"
			buy_btn.disabled = true
		else:
			buy_btn.text = "RÈN: %d 🪙" % cost
			buy_btn.disabled = (sm.gold < cost)
			
		var captured_key = u_key
		var captured_cost = cost
		buy_btn.pressed.connect(func(): _buy_upgrade(captured_key, captured_cost))
		hb.add_child(buy_btn)
		
		grid_container.add_child(row_panel)

func _buy_upgrade(upgrade_key: String, cost: int) -> void:
	if not sm:
		return
	if sm.upgrade_meta(upgrade_key, cost):
		refresh_ui()

func _on_back_pressed() -> void:
	returned_to_menu.emit()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
