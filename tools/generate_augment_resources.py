"""
Generator for Godot 4 .tres Augment Resources
"""
import os

AUGMENTS = [
    {
        "file": "ember_shot.tres",
        "id": "ember_shot",
        "name": "Ember Shot",
        "desc": "Attacks apply Burning damage over time.",
        "rarity": 1, # RARE
        "element": 1, # FIRE
        "icon": "res://assets/icons/ember_shot.png",
        "burn_dps": 12.0
    },
    {
        "file": "wildfire.tres",
        "id": "wildfire",
        "name": "Wildfire",
        "desc": "Burning enemies spread flames to nearby enemies upon death.",
        "rarity": 0, # COMMON
        "element": 1, # FIRE
        "icon": "res://assets/icons/wildfire.png",
        "burn_dps": 8.0
    },
    {
        "file": "frostbite.tres",
        "id": "frostbite",
        "name": "Frostbite",
        "desc": "Attacks apply Chill, reducing enemy movement speed.",
        "rarity": 1, # RARE
        "element": 2, # ICE
        "icon": "res://assets/icons/frostbite.png",
        "chill_slow_pct": 0.4
    },
    {
        "file": "shatter.tres",
        "id": "shatter",
        "name": "Shatter",
        "desc": "Attacks against Chilled enemies deal bonus burst damage.",
        "rarity": 0, # COMMON
        "element": 2, # ICE
        "icon": "res://assets/icons/shatter.png",
        "bonus_damage_pct": 0.35
    },
    {
        "file": "arc_bolt.tres",
        "id": "arc_bolt",
        "name": "Arc Bolt",
        "desc": "Every fourth shot chains lightning to nearby enemies.",
        "rarity": 2, # LEGENDARY
        "element": 3, # LIGHTNING
        "icon": "res://assets/icons/arc_bolt.png",
        "chain_targets": 2
    },
    {
        "file": "overload.tres",
        "id": "overload",
        "name": "Overload",
        "desc": "Chain Lightning interacts with existing status effects, dealing critical damage.",
        "rarity": 1, # RARE
        "element": 3, # LIGHTNING
        "icon": "res://assets/icons/overload.png",
        "bonus_damage_pct": 0.5
    },
    {
        "file": "reaction_catalyst.tres",
        "id": "reaction_catalyst",
        "name": "Reaction Catalyst",
        "desc": "Increases elemental reaction triggers and damage by 30%.",
        "rarity": 1, # RARE
        "element": 0, # NONE
        "icon": "res://assets/icons/reaction_catalyst.png",
        "bonus_damage_pct": 0.3
    },
    {
        "file": "close_quarters.tres",
        "id": "close_quarters",
        "name": "Close Quarters",
        "desc": "Standing close to enemies increases damage dealt by 40%.",
        "rarity": 0, # COMMON
        "element": 0, # NONE
        "icon": "res://assets/icons/close_quarters.png",
        "bonus_damage_pct": 0.4
    }
]

out_dir = "data/augments"
os.makedirs(out_dir, exist_ok=True)

template = """[gd_resource type="Resource" script_class="AugmentData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/synergy/augment_data.gd" id="1_script"]

[resource]
script = ExtResource("1_script")
id = "{id}"
name = "{name}"
description = "{desc}"
rarity = {rarity}
element = {element}
icon_path = "{icon}"
bonus_damage_pct = {bonus_dmg}
burn_dps = {burn_dps}
chill_slow_pct = {chill_slow}
chain_targets = {chain_targets}
proc_chance = 1.0
"""

for a in AUGMENTS:
    content = template.format(
        id=a["id"],
        name=a["name"],
        desc=a["desc"],
        rarity=a["rarity"],
        element=a["element"],
        icon=a["icon"],
        bonus_dmg=a.get("bonus_damage_pct", 0.0),
        burn_dps=a.get("burn_dps", 0.0),
        chill_slow=a.get("chill_slow_pct", 0.0),
        chain_targets=a.get("chain_targets", 0)
    )
    with open(os.path.join(out_dir, a["file"]), "w", encoding="utf-8") as f:
        f.write(content)

print(f"Generated {len(AUGMENTS)} augment resources successfully!")
