class_name RelicData
extends Resource

@export var id: String = "ember_crown"
@export var display_name: String = "Ember Crown"
@export var description: String = "Tăng +30% sát thương nguyên tố Lửa và tăng kích thước quả cầu lửa."
@export var icon: Texture2D
@export var rarity: String = "rare" # common, rare, legendary

# Stat modifiers
@export var bonus_damage_pct: float = 0.3
@export var bonus_fire_rate_pct: float = 0.0
@export var bonus_hp: float = 0.0
@export var bonus_speed: float = 0.0
@export var lifesteal_pct: float = 0.0
