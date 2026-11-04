class_name AugmentDraftUI
extends Control

signal augment_selected(augment: AugmentData)

@export var card_container: HBoxContainer
@export var reroll_button: Button
@export var build_slots_container: HBoxContainer

var current_options: Array[AugmentData] = []
var rerolls_left: int = 2
var rng_manager: RngManager
var augment_pool: Array[AugmentData] = []

func _ready() -> void:
	if reroll_button:
		reroll_button.pressed.connect(_on_reroll_pressed)

func open_draft(options: Array[AugmentData], active_augments: Array[AugmentData], pool: Array[AugmentData], rng: RngManager) -> void:
	current_options = options
	augment_pool = pool
	rng_manager = rng
	visible = true
	get_tree().paused = true
	_render_cards()
	_render_current_build(active_augments)
	if reroll_button:
		reroll_button.text = "REROLL (" + str(rerolls_left) + ")"
		reroll_button.disabled = rerolls_left <= 0

func _render_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()
		
	for aug in current_options:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(240, 320)
		
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 12)
		
		# Rarity Label
		var r_label = Label.new()
		var r_text = "COMMON"
		var r_color = Color(0.8, 0.8, 0.8)
		if aug.rarity == GlobalEnums.AugmentRarity.RARE:
			r_text = "RARE"
			r_color = Color(0.3, 0.7, 1.0)
		elif aug.rarity == GlobalEnums.AugmentRarity.LEGENDARY:
			r_text = "LEGENDARY"
			r_color = Color(1.0, 0.8, 0.2)
		r_label.text = r_text
		r_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		r_label.modulate = r_color
		vbox.add_child(r_label)
		
		# Icon
		var tex_rect = TextureRect.new()
		tex_rect.custom_minimum_size = Vector2(64, 64)
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if aug.icon_path != "" and ResourceLoader.exists(aug.icon_path):
			tex_rect.texture = load(aug.icon_path)
		vbox.add_child(tex_rect)
		
		# Name
		var name_label = Label.new()
		name_label.text = aug.name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 18)
		vbox.add_child(name_label)
		
		# Description
		var desc_label = Label.new()
		desc_label.text = aug.description
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(desc_label)
		
		# Select Button
		var btn = Button.new()
		btn.text = "SELECT"
		btn.pressed.connect(func(): _select_augment(aug))
		vbox.add_child(btn)
		
		panel.add_child(vbox)
		card_container.add_child(panel)

func _render_current_build(active_augments: Array[AugmentData]) -> void:
	if not build_slots_container:
		return
	for child in build_slots_container.get_children():
		child.queue_free()
		
	for i in range(6):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(40, 40)
		if i < active_augments.size():
			var aug = active_augments[i]
			var tr = TextureRect.new()
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			if aug.icon_path != "" and ResourceLoader.exists(aug.icon_path):
				tr.texture = load(aug.icon_path)
			slot.add_child(tr)
		build_slots_container.add_child(slot)

func _select_augment(aug: AugmentData) -> void:
	visible = false
	get_tree().paused = false
	augment_selected.emit(aug)

func _on_reroll_pressed() -> void:
	if rerolls_left > 0 and rng_manager:
		rerolls_left -= 1
		if reroll_button:
			reroll_button.text = "REROLL (" + str(rerolls_left) + ")"
			reroll_button.disabled = rerolls_left <= 0
		current_options = rng_manager.roll_draft(augment_pool, 3)
		_render_cards()
