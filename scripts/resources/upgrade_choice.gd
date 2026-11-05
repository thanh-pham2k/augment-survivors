class_name UpgradeChoice
extends RefCounted

enum ChoiceType {
	AUGMENT,
	NEW_WEAPON,
	UPGRADE_WEAPON,
	EVOLUTION,
	STAT_BOOST,
	EQUIPMENT
}

var type: ChoiceType = ChoiceType.AUGMENT
var id: String = ""
var title: String = ""
var description: String = ""
var icon_path: String = ""
var icon: Texture2D = null
var rarity: String = "rare" # "common", "rare", "legendary"
var payload: Variant = null

static func create_augment_choice(aug: AugmentData) -> UpgradeChoice:
	var c = UpgradeChoice.new()
	c.type = ChoiceType.AUGMENT
	c.id = aug.id
	c.title = aug.name
	c.description = aug.description
	c.icon_path = aug.icon_path
	c.rarity = "legendary" if aug.rarity == GlobalEnums.AugmentRarity.LEGENDARY else ("rare" if aug.rarity == GlobalEnums.AugmentRarity.RARE else "common")
	c.payload = aug
	return c

static func create_new_weapon_choice(w: WeaponData) -> UpgradeChoice:
	var c = UpgradeChoice.new()
	c.type = ChoiceType.NEW_WEAPON
	c.id = "new_weapon_" + w.id
	c.title = "VŨ KHÍ MỚI: " + w.display_name.to_upper()
	c.description = w.description + "\n(Tự động tấn công độc lập cùng lúc)"
	c.icon = w.icon
	c.icon_path = "res://assets/sprites/weapons/icon_" + w.id + ".png"
	c.rarity = "legendary"
	c.payload = w
	return c

static func create_weapon_upgrade_choice(w: WeaponData) -> UpgradeChoice:
	var c = UpgradeChoice.new()
	c.type = ChoiceType.UPGRADE_WEAPON
	c.id = "upgrade_weapon_" + w.id
	c.title = "%s (CẤP %d)" % [w.display_name, w.level + 1]
	c.description = "+15% Sát thương, +10% Tốc độ bắn, thêm đạn tại cấp chẵn."
	c.icon = w.icon
	c.icon_path = "res://assets/sprites/weapons/icon_" + w.id + ".png"
	c.rarity = "rare"
	c.payload = w
	return c

static func create_evolution_choice(w: WeaponData, evo_id: String, evo_title: String, evo_desc: String, icon_file: String) -> UpgradeChoice:
	var c = UpgradeChoice.new()
	c.type = ChoiceType.EVOLUTION
	c.id = "evo_" + evo_id
	c.title = "✨ TIẾN HÓA: " + evo_title.to_upper()
	c.description = evo_desc + "\n(+60% Sát thương, +Bão đạn diện rộng)"
	c.icon_path = icon_file
	if ResourceLoader.exists(icon_file):
		c.icon = load(icon_file)
	c.rarity = "legendary"
	c.payload = {"weapon": w, "evo_id": evo_id, "evo_title": evo_title, "evo_desc": evo_desc, "icon_path": icon_file}
	return c

static func create_stat_boost_choice(stat_key: String, title_text: String, desc_text: String, icon_file: String, boost_dict: Dictionary) -> UpgradeChoice:
	var c = UpgradeChoice.new()
	c.type = ChoiceType.STAT_BOOST
	c.id = "stat_" + stat_key
	c.title = title_text
	c.description = desc_text
	c.icon_path = icon_file
	c.rarity = "common"
	c.payload = boost_dict
	return c
