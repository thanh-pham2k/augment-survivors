#!/usr/bin/env python3
"""
Process the 4 incoming Gameplay 2.0 asset sheets:
1. batch_03_starter_weapons.png
2. batch_05_relics_and_armors.png
3. batch_06_weapon_evolutions.png
4. batch_06_blank_card_frames.png

Removes #00FF00 green screen with edge de-fringing,
slices all icons, frames, and VFX with bounding box precision,
and saves them to proper runtime asset directories.
"""

import os
import numpy as np
from PIL import Image

BASE_DIR = os.path.abspath(os.path.dirname(__file__) + "/..")
INCOMING_DIR = os.path.join(BASE_DIR, "assets/incoming")
WEAPONS_DIR = os.path.join(BASE_DIR, "assets/sprites/weapons")
EQUIPMENT_DIR = os.path.join(BASE_DIR, "assets/sprites/equipment")
UI_DIR = os.path.join(BASE_DIR, "assets/sprites/ui")

for d in [WEAPONS_DIR, EQUIPMENT_DIR, UI_DIR]:
    os.makedirs(d, exist_ok=True)

def remove_green(img: Image.Image, threshold: int = 65, softness: int = 25) -> Image.Image:
    arr = np.array(img.convert("RGBA"))
    r = arr[:, :, 0].astype(np.int32)
    g = arr[:, :, 1].astype(np.int32)
    b = arr[:, :, 2].astype(np.int32)
    
    green_diff = g - np.maximum(r, b)
    alpha = np.ones_like(green_diff, dtype=np.float32) * 255.0
    
    is_pure_green = (green_diff > threshold)
    alpha[is_pure_green] = 0.0
    
    transition = (green_diff > (threshold - softness)) & (~is_pure_green)
    if np.any(transition):
        blend = (green_diff[transition] - (threshold - softness)) / float(softness)
        alpha[transition] = (1.0 - blend) * 255.0
        
    arr[:, :, 3] = np.clip(alpha, 0, 255).astype(np.uint8)
    
    # Desaturate green fringe on semi-transparent boundary
    fringe = (arr[:, :, 3] < 240) & (arr[:, :, 3] > 0) & (g > r)
    arr[fringe, 1] = np.maximum(arr[fringe, 0], arr[fringe, 2])
    
    return Image.fromarray(arr, "RGBA")

def crop_and_trim(img: Image.Image, box):
    crop = img.crop(box)
    bbox = crop.getbbox()
    if bbox:
        return crop.crop(bbox)
    return crop

def process_batch_03():
    print("[*] Processing Batch 03: Starter Weapons Arsenal...")
    src_path = os.path.join(INCOMING_DIR, "batch_03_starter_weapons.png")
    if not os.path.exists(src_path):
        print("[!] File not found:", src_path)
        return
        
    raw = Image.open(src_path)
    clean = remove_green(raw)
    
    # Row 0: 3 Weapon Icons
    icons = [
        ("icon_inferno_staff.png", (341, 9, 637, 294)),
        ("icon_storm_gauntlet.png", (689, 9, 984, 294)),
        ("icon_glacial_spear.png", (1035, 9, 1331, 294))
    ]
    for name, box in icons:
        out_img = crop_and_trim(clean, box)
        out_img.save(os.path.join(WEAPONS_DIR, name))
        print(f"  -> Saved icon: {name} ({out_img.size})")

    # Row 1: Inferno Staff Fan Projectiles & Impacts
    # Projectile fan stages (left side), Impacts (right side)
    clean.crop((30, 311, 840, 480)).save(os.path.join(WEAPONS_DIR, "inferno_fire_fan_strip.png"))
    clean.crop((880, 311, 1650, 480)).save(os.path.join(WEAPONS_DIR, "inferno_impact_strip.png"))
    print("  -> Saved inferno VFX strips")

    # Row 2: Storm Gauntlet Chain Lightning & Impacts
    clean.crop((30, 505, 860, 680)).save(os.path.join(WEAPONS_DIR, "storm_chain_arc_strip.png"))
    clean.crop((880, 505, 1650, 680)).save(os.path.join(WEAPONS_DIR, "storm_impact_strip.png"))
    print("  -> Saved storm VFX strips")

    # Row 3: Glacial Spear Piercing & Impacts
    clean.crop((30, 714, 870, 889)).save(os.path.join(WEAPONS_DIR, "glacial_spear_strip.png"))
    clean.crop((890, 714, 1650, 889)).save(os.path.join(WEAPONS_DIR, "glacial_impact_strip.png"))
    print("  -> Saved glacial VFX strips")

def process_batch_05():
    print("[*] Processing Batch 05A: Relics & Armors...")
    src_path = os.path.join(INCOMING_DIR, "batch_05_relics_and_armors.png")
    if not os.path.exists(src_path):
        print("[!] File not found:", src_path)
        return
        
    raw = Image.open(src_path)
    clean = remove_green(raw)
    
    # 3x3 Grid of 9 Icons
    grid = [
        # Row 0: Relics
        ("relic_ember_crown.png", (36, 16, 418, 409)),
        ("relic_vampire_ring.png", (441, 16, 817, 409)),
        ("relic_frost_armor.png", (839, 16, 1217, 409)),
        # Row 1: Relics
        ("relic_berserker_gloves.png", (36, 412, 419, 805)),
        ("relic_arc_capacitor.png", (442, 412, 819, 805)),
        ("relic_cursed_hourglass.png", (839, 412, 1218, 805)),
        # Row 2: Armors
        ("armor_ember_mantle.png", (36, 807, 417, 1202)),
        ("armor_glacial_plate.png", (442, 807, 817, 1202)),
        ("armor_shadowguard.png", (839, 807, 1219, 1202))
    ]
    
    for name, box in grid:
        out_img = crop_and_trim(clean, box)
        out_img.save(os.path.join(EQUIPMENT_DIR, name))
        print(f"  -> Saved equipment icon: {name} ({out_img.size})")

def process_batch_06_evolutions():
    print("[*] Processing Batch 06A: Weapon Evolutions...")
    src_path = os.path.join(INCOMING_DIR, "batch_06_weapon_evolutions.png")
    if not os.path.exists(src_path):
        print("[!] File not found:", src_path)
        return
        
    raw = Image.open(src_path)
    clean = remove_green(raw)
    
    # Row 0: 6 Evolution Icons
    # We slice each diamond by bounding around its center
    step = 1672 / 6.0
    evo_names = [
        "evo_meteor_rain.png",
        "evo_hellfire_barrage.png",
        "evo_thunderstorm.png",
        "evo_voltaic_lance.png",
        "evo_frozen_tempest.png",
        "evo_glacial_impaler.png"
    ]
    for i, name in enumerate(evo_names):
        x1 = int(i * step)
        x2 = int((i + 1) * step)
        crop = clean.crop((x1, 10, x2, 300))
        trimmed = crop_and_trim(clean, (x1, 10, x2, 300))
        trimmed.save(os.path.join(WEAPONS_DIR, name))
        print(f"  -> Saved evolution icon: {name} ({trimmed.size})")

    # VFX Strips for each evolution
    clean.crop((30, 327, 810, 476)).save(os.path.join(WEAPONS_DIR, "evo_meteor_rain_vfx.png"))
    clean.crop((850, 327, 1650, 476)).save(os.path.join(WEAPONS_DIR, "evo_hellfire_barrage_vfx.png"))
    clean.crop((30, 514, 810, 676)).save(os.path.join(WEAPONS_DIR, "evo_thunderstorm_vfx.png"))
    clean.crop((850, 514, 1650, 676)).save(os.path.join(WEAPONS_DIR, "evo_voltaic_lance_vfx.png"))
    clean.crop((30, 711, 810, 900)).save(os.path.join(WEAPONS_DIR, "evo_frozen_tempest_vfx.png"))
    clean.crop((850, 711, 1650, 900)).save(os.path.join(WEAPONS_DIR, "evo_glacial_impaler_vfx.png"))
    print("  -> Saved all 6 evolution VFX strips")

def process_batch_06_cards():
    print("[*] Processing Batch 06B: Card Frames, Dice & Evolution Banner...")
    src_path = os.path.join(INCOMING_DIR, "batch_06_blank_card_frames.png")
    if not os.path.exists(src_path):
        print("[!] File not found:", src_path)
        return
        
    raw = Image.open(src_path)
    clean = remove_green(raw)
    
    # 4 Tarot Card Frames
    cards = [
        ("card_frame_common.png", (53, 9, 404, 617)),
        ("card_frame_rare.png", (453, 9, 823, 617)),
        ("card_frame_legendary.png", (851, 9, 1237, 617)),
        ("card_frame_synergy.png", (1260, 9, 1657, 617))
    ]
    for name, box in cards:
        out_img = crop_and_trim(clean, box)
        out_img.save(os.path.join(UI_DIR, name))
        print(f"  -> Saved card frame: {name} ({out_img.size})")
        
    # 4 Dice Frames
    dices = [
        ("dice_reroll_00.png", (54, 629, 241, 920)),
        ("dice_reroll_01.png", (266, 629, 487, 920)),
        ("dice_reroll_02.png", (506, 629, 748, 920)),
        ("dice_reroll_03.png", (765, 629, 990, 920))
    ]
    for name, box in dices:
        out_img = crop_and_trim(clean, box)
        out_img.save(os.path.join(UI_DIR, name))
        print(f"  -> Saved dice icon: {name} ({out_img.size})")

    # Evolution Banner
    banner_img = crop_and_trim(clean, (1004, 629, 1655, 920))
    banner_img.save(os.path.join(UI_DIR, "banner_evolution_available.png"))
    print(f"  -> Saved banner: banner_evolution_available.png ({banner_img.size})")

def main():
    process_batch_03()
    process_batch_05()
    process_batch_06_evolutions()
    process_batch_06_cards()
    print("[SUCCESS] All incoming Gameplay 2.0 assets successfully sliced and deployed!")

if __name__ == "__main__":
    main()
