class_name WeaponData
extends Resource

@export var id: String = "inferno_staff"
@export var display_name: String = "Inferno Staff"
@export var description: String = "Phóng chùm cầu lửa thiêu rụi kẻ địch diện rộng."
@export var icon: Texture2D
@export var element: GlobalEnums.ElementType = GlobalEnums.ElementType.FIRE
@export var base_damage: float = 25.0
@export var base_fire_rate: float = 2.0
@export var projectile_count: int = 3
@export var projectile_speed: float = 480.0
@export var spread_angle: float = 0.45
@export var pierce_count: int = 0
@export var level: int = 1
@export var max_level: int = 5

# Evolution branches
@export var is_evolved: bool = false
@export var evolution_id: String = "meteor_rain"
@export var evolution_name: String = "Meteor Rain"
@export var evolution_desc: String = "Triệu hồi mưa thiên thạch bùng nổ toàn sàn đấu."
@export var evolution_icon: Texture2D
