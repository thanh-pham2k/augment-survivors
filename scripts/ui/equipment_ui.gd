class_name EquipmentUI
extends Control

signal returned_to_menu

# Header
@onready var gold_label: Label = $Header/GoldContainer/GoldLabel
@onready var back_button: Button = $Header/BackButton

# Active Loadout Displays
@onready var weapon_icon: TextureRect = $MainHBox/LoadoutPanel/VBox/WeaponSlot/HBox/Icon
@onready var weapon_name_label: Label = $MainHBox/LoadoutPanel/VBox/WeaponSlot/HBox/InfoVBox/NameLabel
@onready var weapon_stats_label: Label = $MainHBox/LoadoutPanel/VBox/WeaponSlot/HBox/InfoVBox/StatsLabel
@onready var weapon_upgrade_btn: Button = $MainHBox/LoadoutPanel/VBox/WeaponSlot/UpgradeBtn

@onready var armor_icon: TextureRect = $MainHBox/LoadoutPanel/VBox/ArmorSlot/HBox/Icon
@onready var armor_name_label: Label = $MainHBox/LoadoutPanel/VBox/ArmorSlot/HBox/InfoVBox/NameLabel
@onready var armor_stats_label: Label = $MainHBox/LoadoutPanel/VBox/ArmorSlot/HBox/InfoVBox/StatsLabel

@onready var relic1_icon: TextureRect = $MainHBox/LoadoutPanel/VBox/Relic1Slot/HBox/Icon
@onready var relic1_name_label: Label = $MainHBox/LoadoutPanel/VBox/Relic1Slot/HBox/InfoVBox/NameLabel
@onready var relic1_stats_label: Label = $MainHBox/LoadoutPanel/VBox/Relic1Slot/HBox/InfoVBox/StatsLabel

@onready var relic2_icon: TextureRect = $MainHBox/LoadoutPanel/VBox/Relic2Slot/HBox/Icon
@onready var relic2_name_label: Label = $MainHBox/LoadoutPanel/VBox/Relic2Slot/HBox/InfoVBox/NameLabel
@onready var relic2_stats_label: Label = $MainHBox/LoadoutPanel/VBox/Relic2Slot/HBox/InfoVBox/StatsLabel

# Inventory Grid & Tabs
@onready var tab_weapons_btn: Button = $MainHBox/InventoryPanel/VBox/TabBar/WeaponsTab
@onready var tab_armors_btn: Button = $MainHBox/InventoryPanel/VBox/TabBar/ArmorsTab
@onready var tab_relics_btn: Button = $MainHBox/InventoryPanel/VBox/TabBar/RelicsTab
@onready var inventory_grid: GridContainer = $MainHBox/InventoryPanel/VBox/Scroll/Grid

var current_tab: String = "weapons"
const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
var sm: SaveManagerClass:
	get: return SaveManagerClass.get_instance()

# Item database definitions
var WEAPONS_DB = {
	"inferno_staff": {
		"name": "Inferno Staff",
		"element": "🔥 HỎA",
		"desc": "Bắn chùm cầu lửa thiêu đốt diện rộng.",
		"icon": "res://assets/sprites/weapons/icon_inferno_staff.png",
		"base_dmg": 25.0
	},
	"storm_gauntlet": {
		"name": "Storm Gauntlet",
		"element": "⚡ LÔI",
		"desc": "Phóng tia sét giật liên hoàn nhiều mục tiêu.",
		"icon": "res://assets/sprites/weapons/icon_storm_gauntlet.png",
		"base_dmg": 18.0
	},
	"glacial_spear": {
		"name": "Glacial Spear",
		"element": "❄️ BĂNG",
		"desc": "Phóng ngọn giáo băng xuyên thấu và làm chậm quái.",
		"icon": "res://assets/sprites/weapons/icon_glacial_spear.png",
		"base_dmg": 32.0
	}
}

var ARMORS_DB = {
	"armor_ember_mantle": {
		"name": "Ember Mantle",
		"element": "🔥 Hỏa Giáp",
		"desc": "+25 Máu Tối Đa & Kháng Cháy",
		"icon": "res://assets/sprites/equipment/armor_ember_mantle.png"
	},
	"armor_glacial_plate": {
		"name": "Glacial Plate",
		"element": "❄️ Băng Giáp",
		"desc": "+35 Máu Tối Đa & Làm Chậm Kẻ Địch Gần",
		"icon": "res://assets/sprites/equipment/armor_glacial_plate.png"
	},
	"armor_shadowguard": {
		"name": "Shadowguard Mail",
		"element": "🌑 Ám Giáp",
		"desc": "+20 Máu Tối Đa & +15% Tốc Độ Né Dash",
		"icon": "res://assets/sprites/equipment/armor_shadowguard.png"
	}
}

var RELICS_DB = {
	"relic_ember_crown": {
		"name": "Ember Crown",
		"desc": "+30% Sát Thương Lửa",
		"icon": "res://assets/sprites/equipment/relic_ember_crown.png"
	},
	"relic_vampire_ring": {
		"name": "Vampire Ring",
		"desc": "Hồi 1 Máu mỗi 25 quái tiêu diệt",
		"icon": "res://assets/sprites/equipment/relic_vampire_ring.png"
	},
	"relic_frost_armor": {
		"name": "Frost Amulet",
		"desc": "Kẻ địch chạm trúng bị Đóng Băng 1.2s",
		"icon": "res://assets/sprites/equipment/relic_frost_armor.png"
	},
	"relic_berserker_gloves": {
		"name": "Berserker Gloves",
		"desc": "+25% Tốc Độ Bắn khi Máu dưới 50%",
		"icon": "res://assets/sprites/equipment/relic_berserker_gloves.png"
	},
	"relic_arc_capacitor": {
		"name": "Arc Capacitor",
		"desc": "Tia sét nảy thêm +2 mục tiêu",
		"icon": "res://assets/sprites/equipment/relic_arc_capacitor.png"
	},
	"relic_cursed_hourglass": {
		"name": "Cursed Hourglass",
		"desc": "-20% Hồi chiêu Dash & +10% Quái xuất hiện",
		"icon": "res://assets/sprites/equipment/relic_cursed_hourglass.png"
	}
}

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	if tab_weapons_btn:
		tab_weapons_btn.pressed.connect(func(): _switch_tab("weapons"))
	if tab_armors_btn:
		tab_armors_btn.pressed.connect(func(): _switch_tab("armors"))
	if tab_relics_btn:
		tab_relics_btn.pressed.connect(func(): _switch_tab("relics"))
	if weapon_upgrade_btn:
		weapon_upgrade_btn.pressed.connect(_on_upgrade_weapon_pressed)
		
	refresh_ui()

func refresh_ui() -> void:
	if gold_label and sm:
		gold_label.text = str(sm.gold)
		
	_update_loadout_slots()
	_populate_inventory_grid()

func _update_loadout_slots() -> void:
	if not sm:
		return
		
	# Weapon
	var w_id = sm.equipped_weapon
	if WEAPONS_DB.has(w_id):
		var w_data = WEAPONS_DB[w_id]
		var lvl = sm.weapon_levels.get(w_id, 1)
		var dmg = sm.get_weapon_damage(w_id)
		weapon_name_label.text = "%s (Cấp %d/5) %s" % [w_data["name"], lvl, w_data["element"]]
		weapon_stats_label.text = "Sát thương: %.1f • %s" % [dmg, w_data["desc"]]
		if ResourceLoader.exists(w_data["icon"]):
			weapon_icon.texture = load(w_data["icon"])
			
		var upgrade_cost = 50 * lvl
		if lvl >= 5:
			weapon_upgrade_btn.text = "⭐ TỐI ĐA"
			weapon_upgrade_btn.disabled = true
		else:
			weapon_upgrade_btn.text = "⚡ NÂNG CẤP (%d 🪙)" % upgrade_cost
			weapon_upgrade_btn.disabled = (sm.gold < upgrade_cost)

	# Armor
	var a_id = sm.equipped_armor
	if ARMORS_DB.has(a_id):
		var a_data = ARMORS_DB[a_id]
		armor_name_label.text = "%s (%s)" % [a_data["name"], a_data["element"]]
		armor_stats_label.text = a_data["desc"]
		if ResourceLoader.exists(a_data["icon"]):
			armor_icon.texture = load(a_data["icon"])

	# Relic 1
	var r1_id = sm.equipped_relic_1
	if RELICS_DB.has(r1_id):
		var r1_data = RELICS_DB[r1_id]
		relic1_name_label.text = r1_data["name"]
		relic1_stats_label.text = r1_data["desc"]
		if ResourceLoader.exists(r1_data["icon"]):
			relic1_icon.texture = load(r1_data["icon"])

	# Relic 2
	var r2_id = sm.equipped_relic_2
	if RELICS_DB.has(r2_id):
		var r2_data = RELICS_DB[r2_id]
		relic2_name_label.text = r2_data["name"]
		relic2_stats_label.text = r2_data["desc"]
		if ResourceLoader.exists(r2_data["icon"]):
			relic2_icon.texture = load(r2_data["icon"])

func _switch_tab(tab: String) -> void:
	current_tab = tab
	tab_weapons_btn.modulate = Color(1.2, 1.2, 1.2) if tab == "weapons" else Color(0.7, 0.7, 0.7)
	tab_armors_btn.modulate = Color(1.2, 1.2, 1.2) if tab == "armors" else Color(0.7, 0.7, 0.7)
	tab_relics_btn.modulate = Color(1.2, 1.2, 1.2) if tab == "relics" else Color(0.7, 0.7, 0.7)
	_populate_inventory_grid()

func _populate_inventory_grid() -> void:
	if not inventory_grid or not sm:
		return
		
	for c in inventory_grid.get_children():
		c.queue_free()
		
	var item_list: Array = []
	var db = {}
	var currently_equipped = []
	
	match current_tab:
		"weapons":
			item_list = sm.unlocked_weapons
			db = WEAPONS_DB
			currently_equipped = [sm.equipped_weapon]
		"armors":
			item_list = sm.unlocked_armors
			db = ARMORS_DB
			currently_equipped = [sm.equipped_armor]
		"relics":
			item_list = sm.unlocked_relics
			db = RELICS_DB
			currently_equipped = [sm.equipped_relic_1, sm.equipped_relic_2]
			
	for item_id in item_list:
		if not db.has(item_id):
			continue
		var data = db[item_id]
		var is_equipped = item_id in currently_equipped
		
		var card_btn = Button.new()
		card_btn.custom_minimum_size = Vector2(170, 190)
		card_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		var vb = VBoxContainer.new()
		vb.set_anchors_preset(Control.PRESET_FULL_RECT)
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		vb.add_theme_constant_override("separation", 6)
		card_btn.add_child(vb)
		
		var icon_rect = TextureRect.new()
		icon_rect.custom_minimum_size = Vector2(72, 72)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if ResourceLoader.exists(data["icon"]):
			icon_rect.texture = load(data["icon"])
		vb.add_child(icon_rect)
		
		var name_lbl = Label.new()
		name_lbl.text = data["name"]
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.add_theme_font_size_override("font_size", 14)
		vb.add_child(name_lbl)
		
		var status_lbl = Label.new()
		if is_equipped:
			status_lbl.text = "✓ ĐANG DÙNG"
			status_lbl.modulate = Color(0.4, 1.0, 0.4)
			card_btn.modulate = Color(1.15, 1.15, 1.15)
		else:
			status_lbl.text = "[Nhấp để Trang Bị]"
			status_lbl.modulate = Color(0.7, 0.7, 0.8)
		status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status_lbl.add_theme_font_size_override("font_size", 12)
		vb.add_child(status_lbl)
		
		var captured_id = item_id
		card_btn.pressed.connect(func(): _equip_item(captured_id))
		inventory_grid.add_child(card_btn)

func _equip_item(item_id: String) -> void:
	if not sm:
		return
	match current_tab:
		"weapons":
			sm.equipped_weapon = item_id
		"armors":
			sm.equipped_armor = item_id
		"relics":
			if sm.equipped_relic_1 != item_id:
				sm.equipped_relic_2 = sm.equipped_relic_1
				sm.equipped_relic_1 = item_id
	sm.save_game()
	refresh_ui()

func _on_upgrade_weapon_pressed() -> void:
	if not sm:
		return
	var w_id = sm.equipped_weapon
	var lvl = sm.weapon_levels.get(w_id, 1)
	var cost = 50 * lvl
	if sm.upgrade_weapon(w_id, cost):
		refresh_ui()

func _on_back_pressed() -> void:
	returned_to_menu.emit()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
