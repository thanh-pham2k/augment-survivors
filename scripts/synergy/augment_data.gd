class_name AugmentData
extends Resource

@export var id: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var rarity: GlobalEnums.AugmentRarity = GlobalEnums.AugmentRarity.COMMON
@export var element: GlobalEnums.ElementType = GlobalEnums.ElementType.NONE
@export var icon_path: String = ""

# Numeric modifier stats
@export var bonus_damage_pct: float = 0.0
@export var burn_dps: float = 0.0
@export var chill_slow_pct: float = 0.0
@export var chain_targets: int = 0
@export var proc_chance: float = 1.0

# Weapon projectile & range modifiers
@export var extra_projectiles: int = 0
@export var spread_angle_deg: float = 0.0
@export var range_bonus_pct: float = 0.0
