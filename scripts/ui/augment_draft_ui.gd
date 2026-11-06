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
		col.add_theme_constant_override("separation", 10)
		
		var card_btn = TextureButton.new()
		card_btn.custom_minimum_size = Vector2(270, 435)
		card_btn.ignore_texture_size = true
		card_btn.stretch_mode = TextureButton.STRETCH_SCALE
		card_btn.pivot_offset = Vector2(135, 217)
		
		# Choose authentic Tarot frame based on choice type and rarity
		var frame_path = "res://assets/sprites/ui/card_frame_rare.png"
		var theme_color = Color(0.4, 0.9, 1.0)
		var border_glow = Color(0.3, 0.65, 0.95, 0.7)
		
		if choice.type == UpgradeChoice.ChoiceType.EVOLUTION:
			frame_path = "res://assets/sprites/ui/card_frame_synergy.png"
			theme_color = Color(1.0, 0.45, 0.9)
			border_glow = Color(0.85, 0.35, 0.85, 0.8)
		elif choice.rarity == "legendary" or choice.type == UpgradeChoice.ChoiceType.NEW_WEAPON:
			frame_path = "res://assets/sprites/ui/card_frame_legendary.png"
			theme_color = Color(1.0, 0.85, 0.25)
			border_glow = Color(0.95, 0.75, 0.2, 0.8)
		elif choice.rarity == "common" or choice.type == UpgradeChoice.ChoiceType.STAT_BOOST:
			frame_path = "res://assets/sprites/ui/card_frame_common.png"
			theme_color = Color(0.5, 1.0, 0.6)
			border_glow = Color(0.4, 0.85, 0.5, 0.7)
			
		if ResourceLoader.exists(frame_path):
			card_btn.texture_normal = load(frame_path)
			
		# Safe MarginContainer to keep all elements strictly inside the ornate border
		var margin_container = MarginContainer.new()
		margin_container.set_anchors_preset(PRESET_FULL_RECT)
		margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin_container.add_theme_constant_override("margin_top", 32)
		margin_container.add_theme_constant_override("margin_bottom", 20)
		margin_container.add_theme_constant_override("margin_left", 22)
		margin_container.add_theme_constant_override("margin_right", 22)
		card_btn.add_child(margin_container)
		
		var card_content = VBoxContainer.new()
		card_content.alignment = BoxContainer.ALIGNMENT_CENTER
		card_content.add_theme_constant_override("separation", 6)
		card_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin_container.add_child(card_content)
		
		# 1. Type Badge Label
		var type_label = Label.new()
		match choice.type:
			UpgradeChoice.ChoiceType.NEW_WEAPON:
				type_label.text = "⚡ VŨ KHÍ MỚI ⚡"
			UpgradeChoice.ChoiceType.UPGRADE_WEAPON:
				type_label.text = "⚔️ CẤP VŨ KHÍ ⚔️"
			UpgradeChoice.ChoiceType.EVOLUTION:
				type_label.text = "👑 TIẾN HÓA TỐI THƯỢNG 👑"
			UpgradeChoice.ChoiceType.STAT_BOOST:
				type_label.text = "💎 CHỈ SỐ BỔ TRỢ"
			_:
				type_label.text = "✦ " + choice.rarity.to_upper() + " AUGMENT ✦"
		type_label.modulate = theme_color
		type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		type_label.add_theme_font_size_override("font_size", 11)
		type_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
		type_label.add_theme_constant_override("shadow_offset_x", 1)
		type_label.add_theme_constant_override("shadow_offset_y", 1)
		card_content.add_child(type_label)
		
		# 2. Main Illustration Window (Height: 125px)
		var art_frame = PanelContainer.new()
		art_frame.custom_minimum_size = Vector2(212, 125)
		art_frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		art_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var sb_art = StyleBoxFlat.new()
		sb_art.bg_color = Color(0.04, 0.06, 0.10, 0.90)
		sb_art.border_width_left = 1
		sb_art.border_width_top = 1
		sb_art.border_width_right = 1
		sb_art.border_width_bottom = 1
		sb_art.border_color = border_glow
		sb_art.corner_radius_top_left = 6
		sb_art.corner_radius_top_right = 6
		sb_art.corner_radius_bottom_right = 6
		sb_art.corner_radius_bottom_left = 6
		art_frame.add_theme_stylebox_override("panel", sb_art)
		
		var icon_tr = TextureRect.new()
		icon_tr.custom_minimum_size = Vector2(204, 118)
		icon_tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_tr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon_tr.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		# Check if dedicated HD augment artwork exists
		var aug_art_path = "res://assets/sprites/augments/art_" + choice.id + ".png"
		if choice.type == UpgradeChoice.ChoiceType.AUGMENT and ResourceLoader.exists(aug_art_path):
			icon_tr.texture = load(aug_art_path)
		elif choice.icon:
			icon_tr.texture = choice.icon
		elif choice.icon_path != "" and ResourceLoader.exists(choice.icon_path):
			icon_tr.texture = load(choice.icon_path)
		elif choice.type == UpgradeChoice.ChoiceType.AUGMENT:
			var fallback_icon = "res://assets/icons/" + choice.id + ".png"
			if ResourceLoader.exists(fallback_icon):
				icon_tr.texture = load(fallback_icon)
				
		art_frame.add_child(icon_tr)
		card_content.add_child(art_frame)
		
		# 3. Card Title Ribbon
		var name_l = Label.new()
		name_l.text = choice.title
		name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_l.custom_minimum_size = Vector2(212, 38)
		name_l.add_theme_font_size_override("font_size", 15)
		name_l.add_theme_color_override("font_color", Color(1.0, 0.95, 0.78))
		name_l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
		name_l.add_theme_constant_override("shadow_offset_x", 1)
		name_l.add_theme_constant_override("shadow_offset_y", 1)
		card_content.add_child(name_l)
		
		# 4. Description Box (Dark Obsidian Glass Plaque for 100% Crisp Contrast)
		var desc_panel = PanelContainer.new()
		desc_panel.custom_minimum_size = Vector2(212, 95)
		desc_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var sb_desc = StyleBoxFlat.new()
		sb_desc.bg_color = Color(0.05, 0.07, 0.11, 0.92)
		sb_desc.border_width_left = 1
		sb_desc.border_width_top = 1
		sb_desc.border_width_right = 1
		sb_desc.border_width_bottom = 1
		sb_desc.border_color = Color(0.75, 0.65, 0.40, 0.65)
		sb_desc.corner_radius_top_left = 6
		sb_desc.corner_radius_top_right = 6
		sb_desc.corner_radius_bottom_right = 6
		sb_desc.corner_radius_bottom_left = 6
		sb_desc.content_margin_left = 8
		sb_desc.content_margin_top = 6
		sb_desc.content_margin_right = 8
		sb_desc.content_margin_bottom = 6
		desc_panel.add_theme_stylebox_override("panel", sb_desc)
		
		var desc_l = Label.new()
		desc_l.text = choice.description
		desc_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		desc_l.custom_minimum_size = Vector2(196, 80)
		desc_l.add_theme_font_size_override("font_size", 12)
		desc_l.add_theme_color_override("font_color", Color(0.96, 0.97, 1.0))
		desc_l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
		desc_l.add_theme_constant_override("shadow_offset_x", 1)
		desc_l.add_theme_constant_override("shadow_offset_y", 1)
		desc_panel.add_child(desc_l)
		card_content.add_child(desc_panel)
		
		# 5. Select Hint
		var select_hint = Label.new()
		select_hint.text = "✦ NHẤN ĐỂ CHỌN ✦"
		select_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		select_hint.add_theme_font_size_override("font_size", 10)
		select_hint.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35, 0.85))
		card_content.add_child(select_hint)
		
		# Card Hover Tween
		card_btn.mouse_entered.connect(func():
			var tw = card_btn.create_tween()
			tw.parallel().tween_property(card_btn, "scale", Vector2(1.04, 1.04), 0.12)
			tw.parallel().tween_property(card_btn, "modulate", Color(1.15, 1.15, 1.15), 0.12)
		)
		card_btn.mouse_exited.connect(func():
			var tw = card_btn.create_tween()
			tw.parallel().tween_property(card_btn, "scale", Vector2(1.0, 1.0), 0.12)
			tw.parallel().tween_property(card_btn, "modulate", Color(1.0, 1.0, 1.0), 0.12)
		)
		card_btn.pressed.connect(func(): _select_choice(choice))
		col.add_child(card_btn)
		
		# 6. Individual per-card reroll button (Stylized)
		var slot_reroll_btn = Button.new()
		slot_reroll_btn.custom_minimum_size = Vector2(210, 34)
		slot_reroll_btn.text = "🎲 Đổi Ô Này (" + str(rerolls_left) + ")"
		slot_reroll_btn.disabled = rerolls_left <= 0
		slot_reroll_btn.add_theme_font_size_override("font_size", 12)
		
		var sb_btn = StyleBoxFlat.new()
		sb_btn.bg_color = Color(0.10, 0.14, 0.20, 0.92)
		sb_btn.border_width_left = 1
		sb_btn.border_width_top = 1
		sb_btn.border_width_right = 1
		sb_btn.border_width_bottom = 1
		sb_btn.border_color = Color(0.4, 0.55, 0.7, 0.7)
		sb_btn.corner_radius_top_left = 6
		sb_btn.corner_radius_top_right = 6
		sb_btn.corner_radius_bottom_right = 6
		sb_btn.corner_radius_bottom_left = 6
		slot_reroll_btn.add_theme_stylebox_override("normal", sb_btn)
		
		var sb_btn_hover = sb_btn.duplicate()
		sb_btn_hover.bg_color = Color(0.18, 0.24, 0.35, 0.95)
		sb_btn_hover.border_color = Color(1.0, 0.85, 0.35, 0.95)
		slot_reroll_btn.add_theme_stylebox_override("hover", sb_btn_hover)
		
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
		
		var sb_slot = StyleBoxFlat.new()
		sb_slot.bg_color = Color(0.08, 0.10, 0.16, 0.85)
		sb_slot.border_width_left = 1
		sb_slot.border_width_top = 1
		sb_slot.border_width_right = 1
		sb_slot.border_width_bottom = 1
		sb_slot.border_color = Color(0.35, 0.45, 0.60, 0.6)
		sb_slot.corner_radius_top_left = 6
		sb_slot.corner_radius_top_right = 6
		sb_slot.corner_radius_bottom_right = 6
		sb_slot.corner_radius_bottom_left = 6
		slot.add_theme_stylebox_override("panel", sb_slot)
		
		if i < active_augments.size():
			var aug = active_augments[i]
			sb_slot.border_color = Color(1.0, 0.85, 0.3, 0.85)
			var tr = TextureRect.new()
			tr.custom_minimum_size = Vector2(38, 38)
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			
			var art_path = "res://assets/sprites/augments/art_" + aug.id + ".png"
			if ResourceLoader.exists(art_path):
				tr.texture = load(art_path)
			elif aug.icon_path != "" and ResourceLoader.exists(aug.icon_path):
				tr.texture = load(aug.icon_path)
			elif ResourceLoader.exists("res://assets/icons/" + aug.id + ".png"):
				tr.texture = load("res://assets/icons/" + aug.id + ".png")
			slot.add_child(tr)
			slot.tooltip_text = aug.name + "\n" + aug.description
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
