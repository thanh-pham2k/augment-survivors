class_name GameplayStage
extends Node2D

@onready var arena: Arena = $Arena
@onready var player: Player = $Player
@onready var event_bus: CombatEventBus = $CombatEventBus
@onready var synergy_engine: SynergyEngine = $SynergyEngine
@onready var draft_ui: AugmentDraftUI = $UI/AugmentDraftUI
@onready var results_ui: RunResultsUI = $UI/RunResultsUI

# Top HUD
@onready var avatar_rect: TextureRect = $UI/TopHUD/HBoxContainer/AvatarRect
@onready var stage_label: Label = $UI/TopHUD/HBoxContainer/StageLabel
@onready var level_label: Label = $UI/TopHUD/HBoxContainer/LevelLabel
@onready var xp_progress_bar: ProgressBar = $UI/TopHUD/HBoxContainer/XPProgressBar
@onready var xp_label: Label = $UI/TopHUD/HBoxContainer/XPProgressBar/XPLabel
@onready var hp_label: Label = $UI/TopHUD/HBoxContainer/HPLabel
@onready var timer_label: Label = $UI/TopHUD/HBoxContainer/TimerLabel
@onready var kills_label: Label = $UI/TopHUD/HBoxContainer/KillsLabel
@onready var gold_label: Label = $UI/TopHUD/HBoxContainer/GoldLabel
@onready var armory_shop_ui: ArmoryShopUI = $UI/ArmoryShopUI

var portrait_normal: Texture2D = preload("res://assets/sprites/ui/portrait_normal.png")
var portrait_hurt: Texture2D = preload("res://assets/sprites/ui/portrait_hurt.png")

# Bottom HUD
@onready var hud_weapon_icon: TextureRect = $UI/BottomHUD/LoadoutHBox/WeaponIcon
@onready var hud_weapon2_icon: TextureRect = get_node_or_null("UI/BottomHUD/LoadoutHBox/Weapon2Icon")
@onready var hud_weapon3_icon: TextureRect = get_node_or_null("UI/BottomHUD/LoadoutHBox/Weapon3Icon")
@onready var hud_relic1_icon: TextureRect = $UI/BottomHUD/LoadoutHBox/Relic1Icon
@onready var hud_relic2_icon: TextureRect = $UI/BottomHUD/LoadoutHBox/Relic2Icon
@onready var augment_slots_container: HBoxContainer = $UI/BottomHUD/LoadoutHBox/AugmentSlots
@onready var dash_button: TextureButton = $UI/BottomHUD/DashButton
@onready var dash_cd_label: Label = $UI/BottomHUD/DashButton/DashCooldownLabel

# Compass Indicator
@onready var cache_pointer: TextureRect = get_node_or_null("UI/CachePointer")

# Synergy Banner
@onready var synergy_banner: PanelContainer = $UI/SynergyBanner
@onready var synergy_banner_title: Label = $UI/SynergyBanner/VBox/Title
@onready var synergy_banner_desc: Label = $UI/SynergyBanner/VBox/Desc

# Boss HUD
@onready var boss_hud: PanelContainer = $UI/BossHUD
@onready var boss_shield_label: Label = $UI/BossHUD/VBox/Header/ShieldStatusLabel
@onready var boss_health_bar: ProgressBar = $UI/BossHUD/VBox/HealthBar
@onready var boss_hp_text: Label = $UI/BossHUD/VBox/HealthBar/HPTextLabel

# Enemy & Object scenes
var skeleton_scene: PackedScene = preload("res://scenes/entities/skeleton_enemy.tscn")
var bat_scene: PackedScene = preload("res://scenes/entities/bat_enemy.tscn")
var mage_scene: PackedScene = preload("res://scenes/entities/dark_mage_enemy.tscn")
var exploder_scene: PackedScene = preload("res://scenes/entities/exploder_enemy.tscn")
var boss_scene: PackedScene = preload("res://scenes/entities/boss_colossus.tscn")
var crystal_scene: PackedScene = preload("res://scenes/entities/crystal_core.tscn")
var portal_scene: PackedScene = preload("res://scenes/combat/stage_portal.tscn")

var rng_manager: RngManager
var all_augments: Array[AugmentData] = []
var active_augments: Array[AugmentData] = []

# Endless Survival & Director Systems (2.1)
var reward_director: WorldRewardDirector
var run_time: float = 0.0
var threat_level: int = 1
var current_stage: int = 1
const SaveManagerClass = preload("res://scripts/meta/save_manager.gd")
var sm: SaveManagerClass:
	get: return SaveManagerClass.get_instance()
var portal_spawned: bool = false
var current_portal: StagePortal = null

var draft_milestones: Array[float] = [] # Deprecated in 2.1 in favor of World Upgrade Caches
var boss_spawn_time: float = 480.0 # First boss at 8 minutes
var boss_spawned: bool = false
var spawn_timer: float = 0.0
var _surge_timer: float = 0.0

const SURGE_INTERVAL: float = 24.0

func _ready() -> void:
	rng_manager = RngManager.new()
	rng_manager.initialize_seed(1337)
	
	synergy_engine.initialize(event_bus)
	player.event_bus = event_bus
	player.synergy_engine = synergy_engine
	
	# Initialize World Reward Director
	reward_director = WorldRewardDirector.new()
	add_child(reward_director)
	reward_director.cache_claimed.connect(_on_world_cache_claimed)
	reward_director.forge_spawned.connect(_on_forge_spawned)
	
	# Connect Player signals
	player.health_changed.connect(_on_player_health_changed)
	player.dash_cooldown_updated.connect(_on_dash_cooldown_updated)
	player.gold_changed.connect(func(g): gold_label.text = "🪙 " + str(g))
	player.xp_changed.connect(_on_player_xp_changed)
	player.level_up.connect(_on_player_level_up)
	player.weapons_updated.connect(_update_weapon_icons)
	player.player_died.connect(_on_player_died)
	
	event_bus.synergy_unlocked.connect(_on_synergy_unlocked)
	draft_ui.augment_selected.connect(_on_augment_selected)
	draft_ui.choice_selected.connect(_on_choice_selected)
	results_ui.play_again_requested.connect(_on_play_again)
	dash_button.pressed.connect(func(): player.try_dash())
	
	if armory_shop_ui:
		armory_shop_ui.shop_closed.connect(_on_shop_closed)
	
	_load_all_augments()
	_update_augment_slots_ui()
	_apply_save_data_profile()
	_update_weapon_icons(player.weapons)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_B:
			if not boss_spawned:
				print("[DEBUG] Summoning Boss Colossus via 'B' key!")
				_spawn_boss()
		elif event.keycode == KEY_U:
			print("[DEBUG] Triggering Upgrade Cache Draft via 'U' key!")
			_trigger_draft()
		elif event.keycode == KEY_G:
			if armory_shop_ui:
				print("[DEBUG] Opening Armory Shop via 'G' key!")
				armory_shop_ui.open_shop(player, draft_ui)
		elif event.keycode == KEY_P:
			print("[DEBUG] Spawning Stage Portal via 'P' key!")
			_spawn_stage_portal(current_stage)
		elif event.keycode == KEY_1:
			arena.set_biome("cathedral")
		elif event.keycode == KEY_2:
			arena.set_biome("magma")
		elif event.keycode == KEY_3:
			arena.set_biome("frost")

func _load_all_augments() -> void:
	all_augments.clear()
	var dir = DirAccess.open("res://data/augments")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var aug = load("res://data/augments/" + file_name) as AugmentData
				if aug:
					all_augments.append(aug)
			file_name = dir.get_next()

func _physics_process(delta: float) -> void:
	run_time += delta
	var minutes: float = run_time / 60.0
	threat_level = 1 + int(minutes)
	_update_timer_label()
	kills_label.text = "💀 " + str(event_bus.enemies_defeated)
	
	# 2.1 World Reward Director: Schedule reachable Upgrade Caches
	if reward_director:
		reward_director.update(delta, run_time, event_bus.enemies_defeated, player.global_position, self)
		_update_cache_pointer()
		
	# Check Periodic Boss Colossus (~8 min, and repeats every 8 min)
	if not boss_spawned and run_time >= boss_spawn_time:
		_spawn_boss()
		
	# Dynamic Continuous Swarm Spawning: Stop regular waves when boss is active
	if not boss_spawned:
		spawn_timer += delta
		var current_interval = max(0.28, 0.95 - (minutes / 12.0) * 0.55)
		if spawn_timer >= current_interval:
			spawn_timer = 0.0
			_spawn_wave()
			
		# Periodic Swarm Surge (horde rush every 24s)
		_surge_timer += delta
		if _surge_timer >= SURGE_INTERVAL:
			_surge_timer = 0.0
			_spawn_surge()

func _update_cache_pointer() -> void:
	if not cache_pointer or not reward_director:
		return
	var nearest = reward_director.get_nearest_cache(player.global_position)
	if not nearest or not is_instance_valid(nearest):
		cache_pointer.visible = false
		return
		
	var viewport = get_viewport_rect()
	var screen_center = viewport.size / 2.0
	var cam_pos = player.global_position
	var to_cache = nearest.global_position - cam_pos
	
	# If on screen (within half viewport):
	if abs(to_cache.x) < screen_center.x - 50.0 and abs(to_cache.y) < screen_center.y - 50.0:
		cache_pointer.visible = false
		return
		
	cache_pointer.visible = true
	var dir = to_cache.normalized()
	cache_pointer.rotation = dir.angle()
	
	var edge_x = clampf(screen_center.x + dir.x * (screen_center.x - 50.0), 45.0, viewport.size.x - 45.0)
	var edge_y = clampf(screen_center.y + dir.y * (screen_center.y - 50.0), 75.0, viewport.size.y - 85.0)
	cache_pointer.global_position = Vector2(edge_x - 14.0, edge_y - 14.0)

func _on_world_cache_claimed(_cache: WorldUpgradeCache) -> void:
	_trigger_upgrade_choice_modal()

func _on_forge_spawned(_forge: WanderingForge) -> void:
	synergy_banner.visible = true
	synergy_banner_title.text = "⚒️ LÒ RÈN LƯU ĐỘNG ĐÃ ĐẾN!"
	synergy_banner_desc.text = "Trạm rèn thần bí đã xuất hiện gần bạn! Hãy bước vào để nâng cấp sức mạnh bằng Vàng!"
	var tw = create_tween()
	tw.tween_interval(4.5)
	tw.tween_callback(func(): synergy_banner.visible = false)

func open_wandering_forge(_forge: WanderingForge = null) -> void:
	if armory_shop_ui:
		armory_shop_ui.open_shop(player, draft_ui)

func _trigger_upgrade_choice_modal() -> void:
	var choices = UpgradeChoiceService.generate_choices(player, active_augments, all_augments, 3)
	draft_ui.open_upgrade_choices(choices, active_augments, player, all_augments, rng_manager)

func _trigger_draft() -> void:
	_trigger_upgrade_choice_modal()

func _on_choice_selected(choice: UpgradeChoice) -> void:
	if choice.type == UpgradeChoice.ChoiceType.AUGMENT and choice.payload is AugmentData:
		if not active_augments.has(choice.payload):
			active_augments.append(choice.payload)
			synergy_engine.add_augment(choice.payload)
			_update_augment_slots_ui()
	_update_weapon_icons(player.weapons)

func _update_weapon_icons(weapons: Array[WeaponData] = []) -> void:
	var w_list = player.weapons if weapons.is_empty() else weapons
	var icon_nodes = [hud_weapon_icon, hud_weapon2_icon, hud_weapon3_icon]
	for i in range(3):
		var node = icon_nodes[i]
		if not node:
			continue
		if i < w_list.size():
			var w = w_list[i]
			var w_path = "res://assets/sprites/weapons/icon_" + w.id + ".png"
			if ResourceLoader.exists(w_path):
				node.texture = load(w_path)
			elif w.icon:
				node.texture = w.icon
			node.visible = true
		else:
			node.visible = false

func _on_player_xp_changed(curr_xp: float, req_xp: float, lvl: int) -> void:
	if level_label:
		level_label.text = "Lv. %d" % lvl
	if xp_progress_bar:
		xp_progress_bar.max_value = req_xp
		xp_progress_bar.value = curr_xp
	if xp_label:
		xp_label.text = "%d / %d XP" % [int(curr_xp), int(req_xp)]

func _on_player_level_up(new_lvl: int) -> void:
	if level_label:
		level_label.text = "Lv. %d" % new_lvl
		var tw = create_tween()
		tw.tween_property(level_label, "scale", Vector2(1.25, 1.25), 0.12)
		tw.tween_property(level_label, "scale", Vector2.ONE, 0.12)

func _spawn_stage_portal(stage_num: int) -> void:
	if portal_spawned:
		return
	portal_spawned = true
	var portal = portal_scene.instantiate() as StagePortal
	portal.global_position = player.global_position + Vector2(0, -170.0)
	portal.portal_entered.connect(_on_portal_entered)
	current_portal = portal
	add_child(portal)
	
	synergy_banner.visible = true
	synergy_banner_title.text = "🌀 CỔNG DỊCH CHUYỂN ĐÃ MỞ!"
	synergy_banner_desc.text = "Bước vào cổng để nâng cấp trang bị tại Lò Rèn & Nhận Thưởng!"
	var tween = create_tween()
	tween.tween_interval(4.5)
	tween.tween_callback(func(): synergy_banner.visible = false)

func _on_portal_entered() -> void:
	if current_portal and is_instance_valid(current_portal):
		current_portal.queue_free()
		current_portal = null
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if is_instance_valid(e) and not (e is BossColossus):
			e.queue_free()
			
	if armory_shop_ui:
		armory_shop_ui.open_shop(player, draft_ui)

func _on_shop_closed() -> void:
	portal_spawned = false

func _spawn_wave() -> void:
	if boss_spawned:
		return
		
	var minutes: float = run_time / 60.0
	var run_lvl: int = max(1, player.run_level)
	
	# Threat Director formulas from BALANCE_BASELINE.json
	var active_cap = min(140, int(24.0 + 7.0 * minutes))
	var current_enemies = get_tree().get_nodes_in_group("enemies").size()
	if current_enemies >= active_cap:
		return
		
	var target_batch = int(lerp(4.0, 15.0, min(1.0, minutes / 6.0)))
	var count = min(target_batch, active_cap - current_enemies)
	var base_angle = randf() * TAU
	
	# Continuous HP and Damage multipliers
	var hp_scale = 1.0 + 0.07 * minutes + 0.012 * max(0, run_lvl - 1)
	var speed_scale = 1.0 + 0.02 * minutes
	
	for i in range(count):
		var angle = base_angle + (float(i) / count) * TAU + randf_range(-0.25, 0.25)
		var dist = randf_range(520.0, 680.0)
		var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		
		# Composition transitions based on elapsed survival minutes
		var roll = randf()
		var enemy: BaseEnemy
		if minutes < 3.0:
			if roll < 0.60:
				enemy = skeleton_scene.instantiate() as BaseEnemy
			elif roll < 0.88:
				enemy = bat_scene.instantiate() as BaseEnemy
			else:
				enemy = exploder_scene.instantiate() as BaseEnemy
		elif minutes < 6.0:
			if roll < 0.35:
				enemy = skeleton_scene.instantiate() as BaseEnemy
			elif roll < 0.65:
				enemy = bat_scene.instantiate() as BaseEnemy
			elif roll < 0.85:
				enemy = mage_scene.instantiate() as BaseEnemy
			else:
				enemy = exploder_scene.instantiate() as BaseEnemy
		else: # 6+ minutes: high exploder and ranged mage pressure
			if roll < 0.20:
				enemy = skeleton_scene.instantiate() as BaseEnemy
			elif roll < 0.45:
				enemy = bat_scene.instantiate() as BaseEnemy
			elif roll < 0.75:
				enemy = mage_scene.instantiate() as BaseEnemy
			else:
				enemy = exploder_scene.instantiate() as BaseEnemy
			
		enemy.global_position = spawn_pos
		enemy.event_bus = event_bus
		enemy.max_health *= hp_scale
		enemy.current_health = enemy.max_health
		enemy.base_speed *= speed_scale
		
		# 14% chance to spawn an Elite Champion from minute 4+
		if (minutes >= 4.0 or threat_level >= 3) and randf() < 0.14:
			enemy.max_health *= 2.5
			enemy.current_health = enemy.max_health
			enemy.scale = Vector2(1.3, 1.3)
			var vis = enemy.get_node_or_null("AnimatedSprite2D")
			if vis:
				vis.modulate = Color(2.0, 1.8, 0.4) # Golden Elite Aura
				
		add_child(enemy)

func _spawn_surge() -> void:
	if boss_spawned:
		return
	var minutes: float = run_time / 60.0
	var active_cap = min(140, int(24.0 + 7.0 * minutes))
	var current_enemies = get_tree().get_nodes_in_group("enemies").size()
	if current_enemies >= active_cap - 6:
		return
	var surge_count = min(16, active_cap - current_enemies)
	var base_angle = randf() * TAU
	for i in range(surge_count):
		var angle = base_angle + (float(i) / surge_count) * TAU
		var dist = randf_range(540.0, 660.0)
		var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		
		var roll = randf()
		var enemy: BaseEnemy
		if roll < 0.40:
			enemy = skeleton_scene.instantiate() as BaseEnemy
		elif roll < 0.70:
			enemy = bat_scene.instantiate() as BaseEnemy
		elif roll < 0.88:
			enemy = exploder_scene.instantiate() as BaseEnemy
		else:
			enemy = mage_scene.instantiate() as BaseEnemy
			
		enemy.global_position = spawn_pos
		enemy.event_bus = event_bus
		add_child(enemy)

func _spawn_boss() -> void:
	boss_spawned = true
	# Clear regular mobs for the epic duel
	var existing = get_tree().get_nodes_in_group("enemies")
	for e in existing:
		if is_instance_valid(e) and not (e is BossColossus):
			e.queue_free()
			
	var boss = boss_scene.instantiate() as BossColossus
	boss.global_position = player.global_position + Vector2(0, -280)
	boss.event_bus = event_bus
	boss.boss_defeated.connect(_on_boss_defeated)
	
	if boss_hud:
		boss_hud.visible = true
		boss_hud.modulate.a = 0.0
		var fadeIn = create_tween()
		fadeIn.tween_property(boss_hud, "modulate:a", 1.0, 0.5)
		boss_health_bar.max_value = boss.max_health
		boss_health_bar.value = boss.current_health
		boss_hp_text.text = "%d / %d HP" % [int(boss.current_health), int(boss.max_health)]
		boss_shield_label.text = "🛡️ SHIELDED (3 Crystals)"
		boss_shield_label.modulate = Color(0.35, 0.85, 1.0)
		
		boss.boss_health_changed.connect(func(curr, max_h):
			var tw = create_tween()
			tw.tween_property(boss_health_bar, "value", curr, 0.15)
			boss_hp_text.text = "%d / %d HP" % [int(curr), int(max_h)]
		)
		boss.boss_shield_changed.connect(func(crystals_left):
			if crystals_left > 0:
				boss_shield_label.text = "🛡️ SHIELDED (%d Crystals)" % crystals_left
				boss_shield_label.modulate = Color(0.35, 0.85, 1.0)
			else:
				boss_shield_label.text = "⚠️ VULNERABLE (SHIELD BROKEN)!"
				boss_shield_label.modulate = Color(1.0, 0.35, 0.2)
		)
		
	add_child(boss)
	
	var angles = [0.0, 2.094, 4.188]
	for a in angles:
		var crystal = crystal_scene.instantiate() as CrystalCore
		crystal.global_position = boss.global_position + Vector2(cos(a), sin(a)) * 240.0
		crystal.crystal_destroyed.connect(func(_c): boss.on_crystal_destroyed())
		add_child(crystal)

func _on_boss_defeated() -> void:
	boss_spawned = false
	boss_spawn_time = run_time + 480.0 # Reschedule next Colossus in 8 minutes
	
	if boss_hud:
		var tween = create_tween()
		tween.tween_property(boss_hud, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): boss_hud.visible = false)
		
	# Spawn a guaranteed Legendary World Upgrade Cache at boss position!
	if reward_director:
		var boss_cache = reward_director._spawn_new_cache(player.global_position + Vector2(0, -60), self, run_time)
		boss_cache.rarity = "legendary"
		
	synergy_banner.visible = true
	synergy_banner_title.text = "👑 CHÚA TỂ TRÙM ĐÃ BỊ ĐÁNH BẠI!"
	synergy_banner_desc.text = "Kho Báu Huyền Thoại đã xuất hiện! Thử thách sinh tồn tiếp tục..."
	var tw = create_tween()
	tw.tween_interval(5.0)
	tw.tween_callback(func(): synergy_banner.visible = false)

func _on_augment_selected(augment: AugmentData) -> void:
	if not active_augments.has(augment):
		active_augments.append(augment)
		synergy_engine.add_augment(augment)
		_update_augment_slots_ui()

func _update_augment_slots_ui() -> void:
	for child in augment_slots_container.get_children():
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
		augment_slots_container.add_child(slot)

func _on_synergy_unlocked(_id: String, s_name: String, desc: String) -> void:
	synergy_banner.visible = true
	synergy_banner_title.text = s_name.to_upper()
	synergy_banner_desc.text = desc
	var tween = create_tween()
	tween.tween_interval(3.5)
	tween.tween_callback(func(): synergy_banner.visible = false)

func _on_player_health_changed(curr: float, max_h: float) -> void:
	hp_label.text = str(int(curr)) + " / " + str(int(max_h))
	if avatar_rect:
		if curr <= 0.35 * max_h:
			avatar_rect.texture = portrait_hurt
		else:
			avatar_rect.texture = portrait_normal

func _on_dash_cooldown_updated(curr: float, _max_cd: float) -> void:
	if curr <= 0.0:
		dash_cd_label.text = ""
		dash_button.disabled = false
		dash_button.modulate = Color.WHITE
	else:
		dash_cd_label.text = str(snappedf(curr, 0.1)) + "s"
		dash_button.disabled = true
		dash_button.modulate = Color(0.6, 0.6, 0.6, 0.8)

func _update_timer_label() -> void:
	var mins = int(run_time) / 60
	var secs = int(run_time) % 60
	if threat_level > 1:
		timer_label.text = "%02d:%02d (T%d)" % [mins, secs, threat_level]
	else:
		timer_label.text = "%02d:%02d" % [mins, secs]

func _on_player_died() -> void:
	if boss_hud:
		boss_hud.visible = false
	_bank_run_gold()
	results_ui.show_results(false, timer_label.text, event_bus.enemies_defeated, event_bus.damage_contribution, event_bus.discovered_synergies, active_augments, {"level": player.run_level, "gold": player.current_gold})

func _bank_run_gold() -> void:
	if not sm or player.current_gold <= 0:
		return
	var mult = 1.0
	if sm.selected_map == "magma":
		mult = 1.25
	elif sm.selected_map == "frost":
		mult = 1.50
	var final_gold = int(player.current_gold * mult)
	sm.add_gold(final_gold)
	print("[RUN COMPLETE] Banked %d Gold (Bonus Multiplier: %.2fx) into SaveManager!" % [final_gold, mult])

func _apply_save_data_profile() -> void:
	if not sm:
		return
		
	# Apply Map (Single Endless Arena defaults to Cathedral, respects profile if set)
	var map_biome = sm.selected_map if sm and sm.selected_map != "" else "cathedral"
	arena.set_biome(map_biome)
	stage_label.text = "🏰 THÁNH ĐƯỜNG VÔ TẬN"
		
	# Apply Meta Upgrades to Player
	var hp_bonus = sm.meta_upgrades.get("max_hp", 0) * 15.0
	player.max_health = 120.0 + hp_bonus
	player.current_health = player.max_health
	
	var speed_bonus = sm.meta_upgrades.get("move_speed", 0) * 0.05
	player.move_speed = 240.0 * (1.0 + speed_bonus)
	
	var dash_reduction = sm.meta_upgrades.get("dash_cooldown", 0) * 0.3
	player.dash_cooldown = max(1.8, 4.2 - dash_reduction)
	
	var magnet_bonus = sm.meta_upgrades.get("magnet_radius", 0) * 30.0
	player.magnet_radius = 170.0 + magnet_bonus
	
	if draft_ui:
		draft_ui.rerolls_left = 2 + sm.meta_upgrades.get("rerolls", 0)
		
	# Equip Starter Weapon
	var w_id = sm.equipped_weapon
	var start_w = WeaponData.new()
	start_w.id = w_id
	start_w.base_damage = sm.get_weapon_damage(w_id)
	start_w.element = sm.get_weapon_element(w_id)
	player.weapons = [start_w]
	player.active_weapon = start_w
	
	if hud_relic1_icon:
		var r1_path = "res://assets/sprites/equipment/" + sm.equipped_relic_1 + ".png"
		if ResourceLoader.exists(r1_path):
			hud_relic1_icon.texture = load(r1_path)

	if hud_relic2_icon:
		var r2_path = "res://assets/sprites/equipment/" + sm.equipped_relic_2 + ".png"
		if ResourceLoader.exists(r2_path):
			hud_relic2_icon.texture = load(r2_path)
	
	# Apply Armor
	match sm.equipped_armor:
		"armor_ember_mantle":
			player.max_health += 25.0
			player.current_health = player.max_health
		"armor_glacial_plate":
			player.max_health += 35.0
			player.current_health = player.max_health
		"armor_shadowguard":
			player.max_health += 20.0
			player.dash_speed *= 1.15
			player.current_health = player.max_health
			
	# Apply Relics
	for r_id in [sm.equipped_relic_1, sm.equipped_relic_2]:
		if r_id == "relic_ember_crown":
			player.damage_multiplier += 0.30
		elif r_id == "relic_cursed_hourglass":
			player.dash_cooldown = max(1.2, player.dash_cooldown * 0.8)
			
	player.health_changed.emit(player.current_health, player.max_health)

func _on_play_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
