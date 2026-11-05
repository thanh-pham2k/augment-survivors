class_name AugmentDraftUI
extends Control

signal augment_selected(augment: AugmentData)
signal choice_selected(choice: UpgradeChoice)

@export var card_container: HBoxContainer
@export var reroll_button: Button
@export var build_slots_container: HBoxContainer

var current_choices: Array[UpgradeChoice] = []
var rerolls_left: int = 3
var rng_manager: RngManager
var augment_pool: Array[AugmentData] = []
var current_player: Player = null
var current_active_augments: Array[AugmentData] = []

func _ready() -> void:
	if reroll_button:
		reroll_button.pressed.connect(_on_reroll_pressed)

func open_draft(options: Array[AugmentData], active_augments: Array[AugmentData], pool: Array[AugmentData], rng: RngManager) -> void:
	var choices: Array[UpgradeChoice] = []
	for opt in options:
		choices.append(UpgradeChoice.create_augment_choice(opt))
	open_upgrade_choices(choices, active_augments, null, pool, rng)

func open_upgrade_choices(
	choices: Array[UpgradeChoice],
	active_augments: Array[AugmentData],
	player: Player,
	pool: Array[AugmentData],
	rng: RngManager = null
) -> void:
	current_choices = choices
	current_player = player
	current_active_augments = active_augments
	augment_pool = pool
	rng_manager = rng
	visible = true
	get_tree().paused = true
	_render_cards()
	_render_current_build(active_augments)
	if reroll_button:
		reroll_button.text = "🎲 REROLL TẤT CẢ (" + str(rerolls_left) + ")"
		reroll_button.disabled = rerolls_left <= 0

func _render_cards() -> void:
	if not card_container:
		return
	for child in card_container.get_children():
		child.queue_free()
		
	for i in range(current_choices.size()):
		var choice = current_choices[i]
		var col = VBoxContainer.new()
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		col.add_theme_constant_override("separation", 12)
		
		var card_btn = TextureButton.new()
		card_btn.custom_minimum_size = Vector2(260, 420)
		card_btn.ignore_texture_size = true
		card_btn.stretch_mode = TextureButton.STRETCH_SCALE
		card_btn.pivot_offset = Vector2(130, 210)
		
		# Choose authentic Tarot frame based on choice type and rarity
		var frame_path = "res://assets/sprites/ui/card_frame_rare.png"
		if choice.type == UpgradeChoice.ChoiceType.EVOLUTION:
			frame_path = "res://assets/sprites/ui/card_frame_synergy.png"
		elif choice.rarity == "legendary" or choice.type == UpgradeChoice.ChoiceType.NEW_WEAPON:
			frame_path = "res://assets/sprites/ui/card_frame_legendary.png"
		elif choice.rarity == "common" or choice.type == UpgradeChoice.ChoiceType.STAT_BOOST:
			frame_path = "res://assets/sprites/ui/card_frame_common.png"
			
		if ResourceLoader.exists(frame_path):
			card_btn.texture_normal = load(frame_path)
			
		# Safe MarginContainer to keep all elements strictly inside the ornate border
		var margin_container = MarginContainer.new()
		margin_container.set_anchors_preset(PRESET_FULL_RECT)
		margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin_container.add_theme_constant_override("margin_top", 34)
		margin_container.add_theme_constant_override("margin_bottom", 24)
		margin_container.add_theme_constant_override("margin_left", 24)
		margin_container.add_theme_constant_override("margin_right", 24)
		card_btn.add_child(margin_container)
		
		var card_content = VBoxContainer.new()
		card_content.alignment = BoxContainer.ALIGNMENT_CENTER
		card_content.add_theme_constant_override("separation", 10)
		card_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin_container.add_child(card_content)
		
		# 1. Type Badge Label
		var type_label = Label.new()
		match choice.type:
			UpgradeChoice.ChoiceType.NEW_WEAPON:
				type_label.text = "⚡ VŨ KHÍ MỚI ⚡"
				type_label.modulate = Color(1.0, 0.85, 0.2)
			UpgradeChoice.ChoiceType.UPGRADE_WEAPON:
				type_label.text = "⚔️ CẤP VŨ KHÍ ⚔️"
				type_label.modulate = Color(0.4, 0.9, 1.0)
			UpgradeChoice.ChoiceType.EVOLUTION:
				type_label.text = "👑 TIẾN HÓA TỐI THƯỢNG 👑"
				type_label.modulate = Color(1.0, 0.45, 0.9)
			UpgradeChoice.ChoiceType.STAT_BOOST:
				type_label.text = "💎 CHỈ SỐ BỔ TRỢ"
				type_label.modulate = Color(0.5, 1.0, 0.6)
			_:
				type_label.text = "✦ " + choice.rarity.to_upper() + " AUGMENT ✦"
				type_label.modulate = Color(0.9, 0.8, 1.0) if choice.rarity == "legendary" else Color(0.4, 0.9, 1.0)
		type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		type_label.add_theme_font_size_override("font_size", 12)
		card_content.add_child(type_label)
		
		# 2. Asset Icon Pedestal (Fixed size 76x76, guaranteed NEVER to leak out!)
		var icon_pedestal = PanelContainer.new()
		icon_pedestal.custom_minimum_size = Vector2(76, 76)
		icon_pedestal.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon_pedestal.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		icon_pedestal.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var sb = StyleBoxFlat.new()
		sb.bg_color = Color(0.08, 0.12, 0.18, 0.85)
		sb.border_width_left = 2
		sb.border_width_top = 2
		sb.border_width_right = 2
		sb.border_width_bottom = 2
		sb.border_color = Color(0.35, 0.65, 0.85, 0.8)
		sb.corner_radius_top_left = 10
		sb.corner_radius_top_right = 10
		sb.corner_radius_bottom_right = 10
		sb.corner_radius_bottom_left = 10
		icon_pedestal.add_theme_stylebox_override("panel", sb)
		
		var icon_tr = TextureRect.new()
		icon_tr.custom_minimum_size = Vector2(60, 60)
		icon_tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_tr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon_tr.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		# Determine texture safely
		if choice.icon:
			icon_tr.texture = choice.icon
		elif choice.icon_path != "" and ResourceLoader.exists(choice.icon_path):
			icon_tr.texture = load(choice.icon_path)
		elif choice.type == UpgradeChoice.ChoiceType.AUGMENT:
			var fallback_icon = "res://assets/icons/" + choice.id + ".png"
			if ResourceLoader.exists(fallback_icon):
				icon_tr.texture = load(fallback_icon)
				
		icon_pedestal.add_child(icon_tr)
		card_content.add_child(icon_pedestal)
		
		# 3. Title Label
		var name_l = Label.new()
		name_l.text = choice.title
		name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_l.custom_minimum_size = Vector2(210, 42)
		name_l.add_theme_font_size_override("font_size", 16)
		name_l.add_theme_color_override("font_color", Color(1.0, 0.96, 0.88))
		name_l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
		name_l.add_theme_constant_override("shadow_offset_x", 1)
		name_l.add_theme_constant_override("shadow_offset_y", 1)
		card_content.add_child(name_l)
		
		# 4. Subtle Divider
		var sep = HSeparator.new()
		sep.modulate = Color(1.0, 1.0, 1.0, 0.35)
		card_content.add_child(sep)
		
		# 5. Description Label
		var desc_l = Label.new()
		desc_l.text = choice.description
		desc_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_l.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		desc_l.custom_minimum_size = Vector2(210, 75)
		desc_l.add_theme_font_size_override("font_size", 12)
		desc_l.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
		card_content.add_child(desc_l)
		
		# Card Hover Tween
		card_btn.mouse_entered.connect(func():
			var tw = card_btn.create_tween()
			tw.parallel().tween_property(card_btn, "scale", Vector2(1.035, 1.035), 0.12)
			tw.parallel().tween_property(card_btn, "modulate", Color(1.15, 1.15, 1.15), 0.12)
		)
		card_btn.mouse_exited.connect(func():
			var tw = card_btn.create_tween()
			tw.parallel().tween_property(card_btn, "scale", Vector2(1.0, 1.0), 0.12)
			tw.parallel().tween_property(card_btn, "modulate", Color(1.0, 1.0, 1.0), 0.12)
		)
		card_btn.pressed.connect(func(): _select_choice(choice))
		col.add_child(card_btn)
		
		# 6. Individual per-card reroll button
		var slot_reroll_btn = Button.new()
		slot_reroll_btn.custom_minimum_size = Vector2(200, 36)
		slot_reroll_btn.text = "🎲 Đổi Ô Này (" + str(rerolls_left) + ")"
		slot_reroll_btn.disabled = rerolls_left <= 0
		var slot_idx = i
		slot_reroll_btn.pressed.connect(func(): _reroll_single_slot(slot_idx))
		col.add_child(slot_reroll_btn)
		
		card_container.add_child(col)

func _reroll_single_slot(slot_idx: int) -> void:
	if rerolls_left <= 0 or slot_idx >= current_choices.size():
		return
	rerolls_left -= 1
	_update_reroll_button_text()
	
	var new_batch = UpgradeChoiceService.generate_choices(current_player, current_active_augments, augment_pool, 4)
	for cand in new_batch:
		var exists = false
		for c in current_choices:
			if c.id == cand.id:
				exists = true
				break
		if not exists:
			current_choices[slot_idx] = cand
			break
	_render_cards()

func _update_reroll_button_text() -> void:
	if reroll_button:
		reroll_button.text = "🎲 REROLL TẤT CẢ (" + str(rerolls_left) + ")"
		reroll_button.disabled = rerolls_left <= 0

func _render_current_build(active_augments: Array[AugmentData]) -> void:
	if not build_slots_container:
		return
	for child in build_slots_container.get_children():
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
			elif ResourceLoader.exists("res://assets/icons/" + aug.id + ".png"):
				tr.texture = load("res://assets/icons/" + aug.id + ".png")
			slot.add_child(tr)
		build_slots_container.add_child(slot)

func _select_choice(choice: UpgradeChoice) -> void:
	visible = false
	get_tree().paused = false
	
	match choice.type:
		UpgradeChoice.ChoiceType.AUGMENT:
			if choice.payload is AugmentData:
				augment_selected.emit(choice.payload)
		UpgradeChoice.ChoiceType.NEW_WEAPON:
			if current_player and choice.payload is WeaponData:
				current_player.add_weapon(choice.payload)
		UpgradeChoice.ChoiceType.UPGRADE_WEAPON:
			if current_player and choice.payload is WeaponData:
				current_player.upgrade_weapon(choice.payload.id)
		UpgradeChoice.ChoiceType.EVOLUTION:
			if current_player and choice.payload is Dictionary:
				var w = choice.payload.get("weapon")
				if w is WeaponData:
					current_player.evolve_weapon(w.id, choice.payload)
		UpgradeChoice.ChoiceType.STAT_BOOST:
			if current_player and choice.payload is Dictionary:
				_apply_stat_boost(current_player, choice.payload)
				
	choice_selected.emit(choice)

func _apply_stat_boost(p: Player, boost: Dictionary) -> void:
	match boost.get("type", ""):
		"damage":
			p.damage_multiplier += boost.get("value", 0.15)
			p._spawn_floating_text("+15% DAMAGE!", Color(1.0, 0.4, 0.2))
		"max_hp":
			var val = boost.get("value", 25.0)
			p.max_health += val
			p.current_health = min(p.max_health, p.current_health + val)
			p.health_changed.emit(p.current_health, p.max_health)
			p._spawn_floating_text("+25 MAX HP!", Color(0.2, 1.0, 0.4))
		"move_speed":
			p.move_speed *= (1.0 + boost.get("value", 0.12))
			p._spawn_floating_text("+12% SPEED!", Color(0.3, 0.8, 1.0))
		"dash_cd":
			p.dash_cooldown = max(1.2, p.dash_cooldown - boost.get("value", 0.4))
			p._spawn_floating_text("DASH CD REDUCED!", Color(1.0, 0.9, 0.2))
		"magnet":
			p.magnet_radius += boost.get("value", 35.0)
			p._spawn_floating_text("+35 MAGNET!", Color(0.8, 0.4, 1.0))

func _on_reroll_pressed() -> void:
	if rerolls_left > 0:
		rerolls_left -= 1
		_update_reroll_button_text()
		current_choices = UpgradeChoiceService.generate_choices(current_player, current_active_augments, augment_pool, 3)
		_render_cards()
