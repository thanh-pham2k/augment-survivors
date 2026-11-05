class_name GameplayStage
extends Node2D

@onready var arena: Arena = $Arena
@onready var player: Player = $Player
@onready var event_bus: CombatEventBus = $CombatEventBus
@onready var synergy_engine: SynergyEngine = $SynergyEngine
@onready var draft_ui: AugmentDraftUI = $UI/AugmentDraftUI
@onready var results_ui: RunResultsUI = $UI/RunResultsUI

# Top HUD
@onready var hp_label: Label = $UI/TopHUD/HBoxContainer/HPLabel
@onready var timer_label: Label = $UI/TopHUD/HBoxContainer/TimerLabel
@onready var kills_label: Label = $UI/TopHUD/HBoxContainer/KillsLabel

# Bottom HUD
@onready var augment_slots_container: HBoxContainer = $UI/BottomHUD/AugmentSlots
@onready var dash_button: TextureButton = $UI/BottomHUD/DashButton
@onready var dash_cd_label: Label = $UI/BottomHUD/DashButton/DashCooldownLabel

# Synergy Banner
@onready var synergy_banner: PanelContainer = $UI/SynergyBanner
@onready var synergy_banner_title: Label = $UI/SynergyBanner/VBox/Title
@onready var synergy_banner_desc: Label = $UI/SynergyBanner/VBox/Desc

# Enemy scenes
var skeleton_scene: PackedScene = preload("res://scenes/entities/skeleton_enemy.tscn")
var bat_scene: PackedScene = preload("res://scenes/entities/bat_enemy.tscn")
var boss_scene: PackedScene = preload("res://scenes/entities/boss_colossus.tscn")
var crystal_scene: PackedScene = preload("res://scenes/entities/crystal_core.tscn")

var rng_manager: RngManager
var all_augments: Array[AugmentData] = []
var active_augments: Array[AugmentData] = []

var run_time: float = 0.0
var draft_milestones: Array[float] = [15.0, 45.0, 90.0, 150.0]
var boss_spawn_time: float = 180.0
var boss_spawned: bool = false
var spawn_timer: float = 0.0

func _ready() -> void:
	rng_manager = RngManager.new()
	rng_manager.initialize_seed(1337)
	
	synergy_engine.initialize(event_bus)
	player.event_bus = event_bus
	player.synergy_engine = synergy_engine
	
	player.health_changed.connect(_on_player_health_changed)
	player.dash_cooldown_updated.connect(_on_dash_cooldown_updated)
	player.player_died.connect(_on_player_died)
	
	event_bus.synergy_unlocked.connect(_on_synergy_unlocked)
	draft_ui.augment_selected.connect(_on_augment_selected)
	results_ui.play_again_requested.connect(_on_play_again)
	dash_button.pressed.connect(func(): player.try_dash())
	
	_load_all_augments()
	_update_augment_slots_ui()

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
	_update_timer_label()
	kills_label.text = "💀 " + str(event_bus.enemies_defeated)
	
	# Check Draft Milestones
	if draft_milestones.size() > 0 and run_time >= draft_milestones[0]:
		draft_milestones.pop_front()
		_trigger_draft()
		
	# Check Boss Spawn
	if not boss_spawned and run_time >= boss_spawn_time:
		_spawn_boss()
		
	# Regular enemy spawning
	spawn_timer += delta
	if spawn_timer >= 1.5:
		spawn_timer = 0.0
		_spawn_wave()

func _spawn_wave() -> void:
	var count = 3 + int(run_time / 25.0)
	for i in range(count):
		var angle = randf() * TAU
		var dist = 520.0
		var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		
		var enemy: BaseEnemy
		if randf() > 0.25:
			enemy = skeleton_scene.instantiate() as BaseEnemy
		else:
			enemy = bat_scene.instantiate() as BaseEnemy
			
		enemy.global_position = spawn_pos
		enemy.event_bus = event_bus
		add_child(enemy)

func _spawn_boss() -> void:
	boss_spawned = true
	var boss = boss_scene.instantiate() as BossColossus
	boss.global_position = Vector2(0, -250)
	boss.event_bus = event_bus
	boss.boss_defeated.connect(_on_boss_defeated)
	add_child(boss)
	
	var angles = [0.0, 2.094, 4.188]
	for a in angles:
		var crystal = crystal_scene.instantiate() as CrystalCore
		crystal.global_position = Vector2(cos(a), sin(a)) * 260.0
		crystal.crystal_destroyed.connect(func(_c): boss.on_crystal_destroyed())
		add_child(crystal)

func _trigger_draft() -> void:
	var options = rng_manager.roll_draft(all_augments, 3)
	draft_ui.open_draft(options, active_augments, all_augments, rng_manager)

func _on_augment_selected(augment: AugmentData) -> void:
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
	timer_label.text = "%02d:%02d" % [mins, secs]

func _on_player_died() -> void:
	results_ui.show_results(false, timer_label.text, event_bus.enemies_defeated, event_bus.damage_contribution, event_bus.discovered_synergies, active_augments)

func _on_boss_defeated() -> void:
	results_ui.show_results(true, timer_label.text, event_bus.enemies_defeated, event_bus.damage_contribution, event_bus.discovered_synergies, active_augments)

func _on_play_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
