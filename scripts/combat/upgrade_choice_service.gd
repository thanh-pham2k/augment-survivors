class_name UpgradeChoiceService
extends RefCounted

const ALL_WEAPON_DEFINITIONS = [
	{
		"id": "inferno_staff",
		"name": "Inferno Staff",
		"desc": "Phóng chùm cầu lửa thiêu rụi kẻ địch diện rộng.",
		"element": GlobalEnums.ElementType.FIRE,
		"base_damage": 25.0,
		"base_fire_rate": 2.2,
		"projectile_count": 3,
		"icon_path": "res://assets/sprites/weapons/icon_inferno_staff.png"
	},
	{
		"id": "storm_gauntlet",
		"name": "Storm Gauntlet",
		"desc": "Tia sét giáng xuống giật truyền qua nhiều mục tiêu lân cận.",
		"element": GlobalEnums.ElementType.LIGHTNING,
		"base_damage": 18.0,
		"base_fire_rate": 3.4,
		"projectile_count": 2,
		"icon_path": "res://assets/sprites/weapons/icon_storm_gauntlet.png"
	},
	{
		"id": "glacial_spear",
		"name": "Glacial Spear",
		"desc": "Mũi giáo băng cực đại đâm xuyên hàng ngũ quái và làm chậm.",
		"element": GlobalEnums.ElementType.ICE,
		"base_damage": 34.0,
		"base_fire_rate": 1.4,
		"projectile_count": 1,
		"icon_path": "res://assets/sprites/weapons/icon_glacial_spear.png"
	}
]

static func generate_choices(
	player: Player,
	active_augments: Array[AugmentData],
	all_augments: Array[AugmentData],
	count: int = 3
) -> Array[UpgradeChoice]:
	var candidates: Array[UpgradeChoice] = []
	var selected: Array[UpgradeChoice] = []
	var chosen_ids: Dictionary = {}
	
	# 1. New Weapon Candidate (if player has < 3 weapons)
	if player and player.weapons.size() < 3:
		var owned_weapon_ids: Array[String] = []
		for w in player.weapons:
			owned_weapon_ids.append(w.id)
			
		for w_def in ALL_WEAPON_DEFINITIONS:
			if not owned_weapon_ids.has(w_def["id"]):
				var new_w = WeaponData.new()
				new_w.id = w_def["id"]
				new_w.display_name = w_def["name"]
				new_w.description = w_def["desc"]
				new_w.element = w_def["element"]
				new_w.base_damage = w_def["base_damage"]
				new_w.base_fire_rate = w_def["base_fire_rate"]
				new_w.projectile_count = w_def["projectile_count"]
				if ResourceLoader.exists(w_def["icon_path"]):
					new_w.icon = load(w_def["icon_path"])
				candidates.append(UpgradeChoice.create_new_weapon_choice(new_w))
				
	# 2. Weapon Level-Up & Evolution Candidates
	if player:
		for w in player.weapons:
			if w.level >= w.max_level and not w.is_evolved:
				match w.id:
					"inferno_staff":
						candidates.append(UpgradeChoice.create_evolution_choice(w, "meteor_rain", "Mưa Thiên Thạch", "Mưa thiên thạch bão lửa dội xuống toàn bộ chiến trường.", "res://assets/sprites/weapons/evo_meteor_rain.png"))
					"storm_gauntlet":
						candidates.append(UpgradeChoice.create_evolution_choice(w, "thunderstorm", "Bão Tố Sấm Sét", "Sấm sét giáng liên hoàn dội chấn động khắp màn hình.", "res://assets/sprites/weapons/evo_thunderstorm.png"))
					"glacial_spear":
						candidates.append(UpgradeChoice.create_evolution_choice(w, "glacial_impaler", "Đại Băng Thần Thương", "Giáo băng xuyên thấu cực hạn đóng băng và gây nổ băng diện rộng.", "res://assets/sprites/weapons/evo_glacial_impaler.png"))
			elif w.level < w.max_level:
				candidates.append(UpgradeChoice.create_weapon_upgrade_choice(w))
				
	# 3. Augment Candidates (unowned augments)
	var active_ids: Array[String] = []
	for a in active_augments:
		active_ids.append(a.id)
		
	for a in all_augments:
		if not active_ids.has(a.id):
			candidates.append(UpgradeChoice.create_augment_choice(a))
			
	# Shuffle candidate pool
	candidates.shuffle()
	
	for c in candidates:
		if not chosen_ids.has(c.id):
			chosen_ids[c.id] = true
			selected.append(c)
			if selected.size() >= count:
				return selected
				
	# 4. Fallback Generic Stats (Guarantees the pool is NEVER empty or duplicate!)
	var fallback_stats = [
		{
			"key": "damage",
			"title": "HỎA LỰC TỐI THƯỢNG",
			"desc": "+15% Tổng Sát Thương của mọi vũ khí.",
			"icon": "res://assets/sprites/ui/badge_max_hp.png",
			"boost": {"type": "damage", "value": 0.15}
		},
		{
			"key": "max_hp",
			"title": "TRÁI TIM CHIẾN BINH",
			"desc": "+25 Máu Tối Đa và lập tức hồi 25 Máu.",
			"icon": "res://assets/sprites/ui/badge_max_hp.png",
			"boost": {"type": "max_hp", "value": 25.0}
		},
		{
			"key": "move_speed",
			"title": "BƯỚC CHÂN GIÓ LỐC",
			"desc": "+12% Tốc Độ Di Chuyển cơ bản.",
			"icon": "res://assets/sprites/ui/badge_move_speed.png",
			"boost": {"type": "move_speed", "value": 0.12}
		},
		{
			"key": "dash_cd",
			"title": "LINH HOẠT THẦN TỐC",
			"desc": "Giảm 0.4s thời gian hồi chiêu Lướt Nhanh.",
			"icon": "res://assets/sprites/ui/badge_dash_cooldown.png",
			"boost": {"type": "dash_cd", "value": 0.4}
		},
		{
			"key": "magnet",
			"title": "TỪ TRƯỜNG HUYỀN BÍ",
			"desc": "+35 Bán kính hút XP Gems và Tiền Vàng.",
			"icon": "res://assets/sprites/ui/badge_magnet_radius.png",
			"boost": {"type": "magnet", "value": 35.0}
		}
	]
	fallback_stats.shuffle()
	
	for f in fallback_stats:
		var stat_id = "stat_" + f["key"]
		if not chosen_ids.has(stat_id):
			chosen_ids[stat_id] = true
			selected.append(UpgradeChoice.create_stat_boost_choice(
				f["key"],
				f["title"],
				f["desc"],
				f["icon"],
				f["boost"]
			))
			if selected.size() >= count:
				break
				
	return selected
