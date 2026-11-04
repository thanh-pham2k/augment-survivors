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

var card_textures = {
	"ember_shot": "res://assets/sprites/card_ember_shot.png",
	"frostbite": "res://assets/sprites/card_frostbite.png",
	"arc_bolt": "res://assets/sprites/card_arc_bolt.png"
}

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
		reroll_button.text = "🎲 REROLL (" + str(rerolls_left) + ")"
		reroll_button.disabled = rerolls_left <= 0

func _render_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()
		
	for aug in current_options:
		var card_btn = TextureButton.new()
		card_btn.custom_minimum_size = Vector2(240, 360)
		card_btn.ignore_texture_size = false
		card_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		# If we have the authentic reference card texture:
		if card_textures.has(aug.id) and ResourceLoader.exists(card_textures[aug.id]):
			card_btn.texture_normal = load(card_textures[aug.id])
		else:
			# Fallback stylish card
			var panel = PanelContainer.new()
			panel.custom_minimum_size = Vector2(240, 360)
			var vbox = VBoxContainer.new()
			vbox.alignment = BoxContainer.ALIGNMENT_CENTER
			vbox.add_theme_constant_override("separation", 14)
			
			var r_label = Label.new()
			r_label.text = "RARE" if aug.rarity == GlobalEnums.AugmentRarity.RARE else ("LEGENDARY" if aug.rarity == GlobalEnums.AugmentRarity.LEGENDARY else "COMMON")
			r_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			vbox.add_child(r_label)
			
			var icon_tr = TextureRect.new()
			icon_tr.custom_minimum_size = Vector2(80, 80)
			icon_tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			if aug.icon_path != "" and ResourceLoader.exists(aug.icon_path):
				icon_tr.texture = load(aug.icon_path)
			vbox.add_child(icon_tr)
			
			var name_l = Label.new()
			name_l.text = aug.name
			name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			name_l.add_theme_font_size_override("font_size", 20)
			vbox.add_child(name_l)
			
			var desc_l = Label.new()
			desc_l.text = aug.description
			desc_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			desc_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			vbox.add_child(desc_l)
			
			panel.add_child(vbox)
			card_btn.add_child(panel)
			
		card_btn.pressed.connect(func(): _select_augment(aug))
		card_container.add_child(card_btn)

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
			reroll_button.text = "🎲 REROLL (" + str(rerolls_left) + ")"
			reroll_button.disabled = rerolls_left <= 0
		current_options = rng_manager.roll_draft(augment_pool, 3)
		_render_cards()
