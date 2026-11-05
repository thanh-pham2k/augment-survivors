class_name ArmoryShopUI
extends Control

signal shop_closed

@onready var gold_title: Label = $Panel/VBox/GoldTitle
@onready var btn_damage: Button = $Panel/VBox/Grid/DmgUpgrade/Btn
@onready var btn_speed: Button = $Panel/VBox/Grid/SpeedUpgrade/Btn
@onready var btn_magnet: Button = $Panel/VBox/Grid/MagnetUpgrade/Btn
@onready var btn_heal: Button = $Panel/VBox/Grid/HealUpgrade/Btn
@onready var btn_reroll: Button = $Panel/VBox/Grid/RerollUpgrade/Btn
@onready var close_btn: Button = $Panel/VBox/CloseBtn

var player: Player
var draft_ui: AugmentDraftUI

var lvl_damage: int = 0
var lvl_speed: int = 0
var lvl_magnet: int = 0
var lvl_heal: int = 0

const COST_DAMAGE: int = 25
const COST_SPEED: int = 20
const COST_MAGNET: int = 15
const COST_HEAL: int = 30
const COST_REROLL: int = 35

func _ready() -> void:
	if close_btn:
		close_btn.pressed.connect(_on_close_pressed)
	if btn_damage:
		btn_damage.pressed.connect(_upgrade_damage)
	if btn_speed:
		btn_speed.pressed.connect(_upgrade_speed)
	if btn_magnet:
		btn_magnet.pressed.connect(_upgrade_magnet)
	if btn_heal:
		btn_heal.pressed.connect(_upgrade_heal)
	if btn_reroll:
		btn_reroll.pressed.connect(_buy_reroll)

func open_shop(p: Player, d_ui: AugmentDraftUI) -> void:
	player = p
	draft_ui = d_ui
	visible = true
	if is_inside_tree() and get_tree():
		get_tree().paused = true
	if is_node_ready():
		_update_ui()

func _update_ui() -> void:
	if not player or not gold_title:
		return
	gold_title.text = "🪙 TÀI NGUYÊN HIỆN CÓ: %d VÀNG" % player.current_gold
	
	btn_damage.text = "🗡️ Sát Thương +20%% (Cấp %d/5) — Giá %d Vàng" % [lvl_damage, COST_DAMAGE + lvl_damage * 10]
	btn_damage.disabled = (lvl_damage >= 5) or (player.current_gold < COST_DAMAGE + lvl_damage * 10)
	
	btn_speed.text = "🏹 Tốc Độ Đạn +15%% (Cấp %d/5) — Giá %d Vàng" % [lvl_speed, COST_SPEED + lvl_speed * 10]
	btn_speed.disabled = (lvl_speed >= 5) or (player.current_gold < COST_SPEED + lvl_speed * 10)
	
	btn_magnet.text = "🧲 Bán Kính Nam Châm +35%% (Cấp %d/5) — Giá %d Vàng" % [lvl_magnet, COST_MAGNET + lvl_magnet * 5]
	btn_magnet.disabled = (lvl_magnet >= 5) or (player.current_gold < COST_MAGNET + lvl_magnet * 5)
	
	btn_heal.text = "🧪 Sinh Lực & Hồi Máu (+25 HP) (Cấp %d/5) — Giá %d Vàng" % [lvl_heal, COST_HEAL + lvl_heal * 10]
	btn_heal.disabled = (lvl_heal >= 5) or (player.current_gold < COST_HEAL + lvl_heal * 10)
	
	var r_count = draft_ui.rerolls_left if draft_ui else 0
	btn_reroll.text = "🎲 Mua +1 Xúc Xắc Reroll (Hiện có %d) — Giá %d Vàng" % [r_count, COST_REROLL]
	btn_reroll.disabled = player.current_gold < COST_REROLL

func _upgrade_damage() -> void:
	var cost = COST_DAMAGE + lvl_damage * 10
	if player.current_gold >= cost and lvl_damage < 5:
		player.add_gold(-cost)
		player.damage_multiplier += 0.20
		lvl_damage += 1
		_update_ui()

func _upgrade_speed() -> void:
	var cost = COST_SPEED + lvl_speed * 10
	if player.current_gold >= cost and lvl_speed < 5:
		player.add_gold(-cost)
		player.projectile_speed_bonus += 80.0
		lvl_speed += 1
		_update_ui()

func _upgrade_magnet() -> void:
	var cost = COST_MAGNET + lvl_magnet * 5
	if player.current_gold >= cost and lvl_magnet < 5:
		player.add_gold(-cost)
		player.magnet_radius += 60.0
		lvl_magnet += 1
		_update_ui()

func _upgrade_heal() -> void:
	var cost = COST_HEAL + lvl_heal * 10
	if player.current_gold >= cost and lvl_heal < 5:
		player.add_gold(-cost)
		player.max_health += 25.0
		player.current_health = player.max_health
		player.health_changed.emit(player.current_health, player.max_health)
		lvl_heal += 1
		_update_ui()

func _buy_reroll() -> void:
	if player.current_gold >= COST_REROLL and draft_ui:
		player.add_gold(-COST_REROLL)
		draft_ui.rerolls_left += 1
		_update_ui()

func _on_close_pressed() -> void:
	visible = false
	get_tree().paused = false
	shop_closed.emit()
