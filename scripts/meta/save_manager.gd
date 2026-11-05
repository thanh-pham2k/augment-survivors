class_name SaveManager
extends Node

signal save_data_updated
signal gold_changed(new_gold: int)

static var instance: SaveManager

static func get_instance() -> SaveManager:
	if not instance:
		instance = SaveManager.new()
		instance.name = "SaveManager"
		instance.load_game()
		if Engine.get_main_loop() and Engine.get_main_loop() is SceneTree:
			var tree = Engine.get_main_loop() as SceneTree
			if tree.root and not tree.root.has_node("SaveManager"):
				tree.root.add_child(instance)
	return instance

func _enter_tree() -> void:
	if not instance:
		instance = self

const SAVE_PATH: String = "user://augment_survivors_save.json"

var gold: int = 350 # Default balance for testing
var selected_map: String = "cathedral"

# Equipped loadout
var equipped_weapon: String = "inferno_staff"
var equipped_armor: String = "armor_ember_mantle"
var equipped_relic_1: String = "relic_ember_crown"
var equipped_relic_2: String = "relic_vampire_ring"

# Weapon Levels (1 to 5)
var weapon_levels: Dictionary = {
	"inferno_staff": 1,
	"storm_gauntlet": 1,
	"glacial_spear": 1
}

# Unlocked inventory
var unlocked_weapons: Array = ["inferno_staff", "storm_gauntlet", "glacial_spear"]
var unlocked_armors: Array = ["armor_ember_mantle", "armor_glacial_plate", "armor_shadowguard"]
var unlocked_relics: Array = [
	"relic_ember_crown",
	"relic_vampire_ring",
	"relic_frost_armor",
	"relic_berserker_gloves",
	"relic_arc_capacitor",
	"relic_cursed_hourglass"
]

# Meta Upgrades (Purchased in Blacksmith Shop, level 0 to 5)
var meta_upgrades: Dictionary = {
	"max_hp": 0,         # +15 HP per level
	"move_speed": 0,     # +5% speed per level
	"dash_cooldown": 0,  # -0.3s CD per level
	"magnet_radius": 0,  # +25px magnet per level
	"rerolls": 0         # +1 reroll charge per level
}

func _ready() -> void:
	pass

func reset_to_defaults() -> void:
	gold = 350
	selected_map = "cathedral"
	equipped_weapon = "inferno_staff"
	equipped_armor = "armor_ember_mantle"
	equipped_relic_1 = "relic_ember_crown"
	equipped_relic_2 = "relic_vampire_ring"
	weapon_levels = {
		"inferno_staff": 1,
		"storm_gauntlet": 1,
		"glacial_spear": 1
	}
	unlocked_weapons = ["inferno_staff", "storm_gauntlet", "glacial_spear"]
	unlocked_armors = ["armor_ember_mantle", "armor_glacial_plate", "armor_shadowguard"]
	unlocked_relics = [
		"relic_ember_crown",
		"relic_vampire_ring",
		"relic_frost_armor",
		"relic_berserker_gloves",
		"relic_arc_capacitor",
		"relic_cursed_hourglass"
	]
	meta_upgrades = {
		"max_hp": 0,
		"move_speed": 0,
		"dash_cooldown": 0,
		"magnet_radius": 0,
		"rerolls": 0
	}
	save_game()

func save_game() -> void:
	var data = {
		"gold": gold,
		"selected_map": selected_map,
		"equipped_weapon": equipped_weapon,
		"equipped_armor": equipped_armor,
		"equipped_relic_1": equipped_relic_1,
		"equipped_relic_2": equipped_relic_2,
		"weapon_levels": weapon_levels,
		"unlocked_weapons": unlocked_weapons,
		"unlocked_armors": unlocked_armors,
		"unlocked_relics": unlocked_relics,
		"meta_upgrades": meta_upgrades
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
	save_data_updated.emit()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var err = json.parse(content)
	if err == OK and json.data is Dictionary:
		var d = json.data as Dictionary
		gold = d.get("gold", gold)
		selected_map = d.get("selected_map", selected_map)
		equipped_weapon = d.get("equipped_weapon", equipped_weapon)
		equipped_armor = d.get("equipped_armor", equipped_armor)
		equipped_relic_1 = d.get("equipped_relic_1", equipped_relic_1)
		equipped_relic_2 = d.get("equipped_relic_2", equipped_relic_2)
		
		if d.has("weapon_levels"):
			for k in d["weapon_levels"].keys():
				weapon_levels[k] = int(d["weapon_levels"][k])
		if d.has("unlocked_weapons"):
			unlocked_weapons = d["unlocked_weapons"]
		if d.has("unlocked_armors"):
			unlocked_armors = d["unlocked_armors"]
		if d.has("unlocked_relics"):
			unlocked_relics = d["unlocked_relics"]
		if d.has("meta_upgrades"):
			for k in d["meta_upgrades"].keys():
				meta_upgrades[k] = int(d["meta_upgrades"][k])

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)
	save_game()

func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold)
		save_game()
		return true
	return false

func upgrade_weapon(weapon_id: String, cost: int) -> bool:
	var curr_lvl = weapon_levels.get(weapon_id, 1)
	if curr_lvl >= 5:
		return false
	if spend_gold(cost):
		weapon_levels[weapon_id] = curr_lvl + 1
		save_game()
		return true
	return false

func upgrade_meta(upgrade_key: String, cost: int) -> bool:
	var curr_lvl = meta_upgrades.get(upgrade_key, 0)
	if curr_lvl >= 5:
		return false
	if spend_gold(cost):
		meta_upgrades[upgrade_key] = curr_lvl + 1
		save_game()
		return true
	return false

func get_weapon_damage(weapon_id: String) -> float:
	var base_dmg = 25.0
	match weapon_id:
		"inferno_staff": base_dmg = 25.0
		"storm_gauntlet": base_dmg = 18.0
		"glacial_spear": base_dmg = 32.0
	var lvl = weapon_levels.get(weapon_id, 1)
	return base_dmg * (1.0 + (lvl - 1) * 0.25)

func get_weapon_element(weapon_id: String) -> GlobalEnums.ElementType:
	match weapon_id:
		"inferno_staff": return GlobalEnums.ElementType.FIRE
		"storm_gauntlet": return GlobalEnums.ElementType.LIGHTNING
		"glacial_spear": return GlobalEnums.ElementType.ICE
	return GlobalEnums.ElementType.FIRE
