#!/usr/bin/env python3
"""
Slice all 8 incoming sheets:
- batch_01_hero_turnaround_death.png
- batch_01_hero_actions_portrait.png
- batch_02_enemy_deaths_ice_wraith.png
- batch_02_elite_champions.png
- batch_04_impacts_and_status.png
- batch_04_synergies_and_dash.png
- batch_07_biome_props_hazards.png
- batch_07_portals_and_forge.png
"""

import os
import numpy as np
from PIL import Image

BASE_DIR = os.path.abspath(os.path.dirname(__file__) + "/..")
INCOMING = os.path.join(BASE_DIR, "assets/incoming")

PLAYER_DIR = os.path.join(BASE_DIR, "assets/final_sprites/player")
SKELETON_DIR = os.path.join(BASE_DIR, "assets/final_sprites/skeleton")
BAT_DIR = os.path.join(BASE_DIR, "assets/final_sprites/bat")
MAGE_DIR = os.path.join(BASE_DIR, "assets/final_sprites/dark_mage")
EXPLODER_DIR = os.path.join(BASE_DIR, "assets/final_sprites/exploder")
ICE_WRAITH_DIR = os.path.join(BASE_DIR, "assets/final_sprites/ice_wraith")
ELITE_CAPTAIN_DIR = os.path.join(BASE_DIR, "assets/final_sprites/elites/bone_captain")
ELITE_ARCANIST_DIR = os.path.join(BASE_DIR, "assets/final_sprites/elites/infernal_arcanist")
VFX_DIR = os.path.join(BASE_DIR, "assets/sprites/vfx")
PROPS_DIR = os.path.join(BASE_DIR, "assets/sprites/props")
PORTALS_DIR = os.path.join(BASE_DIR, "assets/sprites/portals")
FORGE_DIR = os.path.join(BASE_DIR, "assets/sprites/forge")
UI_DIR = os.path.join(BASE_DIR, "assets/sprites/ui")

for d in [PLAYER_DIR, SKELETON_DIR, BAT_DIR, MAGE_DIR, EXPLODER_DIR, ICE_WRAITH_DIR,
          ELITE_CAPTAIN_DIR, ELITE_ARCANIST_DIR, VFX_DIR, PROPS_DIR, PORTALS_DIR, FORGE_DIR, UI_DIR]:
    os.makedirs(d, exist_ok=True)

def remove_green(img: Image.Image, threshold: int = 65, softness: int = 25) -> Image.Image:
    arr = np.array(img.convert("RGBA"))
    r, g, b = arr[:, :, 0].astype(np.int32), arr[:, :, 1].astype(np.int32), arr[:, :, 2].astype(np.int32)
    green_diff = g - np.maximum(r, b)
    alpha = np.ones_like(green_diff, dtype=np.float32) * 255.0
    
    is_pure_green = (green_diff > threshold)
    alpha[is_pure_green] = 0.0
    
    transition = (green_diff > (threshold - softness)) & (~is_pure_green)
    if np.any(transition):
        blend = (green_diff[transition] - (threshold - softness)) / float(softness)
        alpha[transition] = (1.0 - blend) * 255.0
        
    arr[:, :, 3] = np.clip(alpha, 0, 255).astype(np.uint8)
    fringe = (arr[:, :, 3] < 240) & (arr[:, :, 3] > 0) & (g > r)
    arr[fringe, 1] = np.maximum(arr[fringe, 0], arr[fringe, 2])
    return Image.fromarray(arr, "RGBA")

def remove_black_luminance(img: Image.Image) -> Image.Image:
    arr = np.array(img.convert("RGBA"), dtype=np.float32)
    rgb = arr[:, :, :3]
    alpha = np.max(rgb, axis=2)
    alpha[alpha < 12] = 0.0
    safe_alpha = np.maximum(alpha, 1.0)[:, :, None]
    norm_rgb = np.clip(rgb * (255.0 / safe_alpha), 0, 255)
    
    out = np.zeros_like(arr, dtype=np.uint8)
    out[:, :, :3] = norm_rgb.astype(np.uint8)
    out[:, :, 3] = np.clip(alpha, 0, 255).astype(np.uint8)
    return Image.fromarray(out, "RGBA")

def crop_and_trim(img: Image.Image, box):
    crop = img.crop(box)
    bbox = crop.getbbox()
    return crop.crop(bbox) if bbox else crop

def process_batch_01a():
    print("[*] Processing Batch 01A: Hero Turnaround & Death...")
    raw = Image.open(os.path.join(INCOMING, "batch_01_hero_turnaround_death.png"))
    clean = remove_green(raw)
    
    # Row 0: 4 Turnaround Poses
    poses = [("turnaround_front.png", (158, 26, 453, 483)),
             ("turnaround_back.png", (531, 26, 808, 483)),
             ("turnaround_left.png", (933, 26, 1148, 483)),
             ("turnaround_right.png", (1210, 26, 1466, 483))]
    for name, box in poses:
        crop_and_trim(clean, box).save(os.path.join(PLAYER_DIR, name))
        
    # Row 1: 6 Death frames
    step = 1672 / 6.0
    for i in range(6):
        box = (int(i * step), 548, int((i + 1) * step), 887)
        crop_and_trim(clean, box).save(os.path.join(PLAYER_DIR, f"death_{i:02d}.png"))
    print("  -> Saved player turnaround and 6 death frames")

def process_batch_01b():
    print("[*] Processing Batch 01B: Hero Victory, Pickup & Portraits...")
    raw = Image.open(os.path.join(INCOMING, "batch_01_hero_actions_portrait.png"))
    clean = remove_green(raw)
    
    # Row 0: 4 Victory frames
    v_cols = [(160, 351), (516, 755), (882, 1134), (1263, 1541)]
    for i, (x1, x2) in enumerate(v_cols):
        crop_and_trim(clean, (x1, 0, x2, 331)).save(os.path.join(PLAYER_DIR, f"victory_{i:02d}.png"))
        
    # Row 1: 4 Pickup frames
    p_cols = [(156, 389), (531, 787), (873, 1141), (1291, 1490)]
    for i, (x1, x2) in enumerate(p_cols):
        crop_and_trim(clean, (x1, 363, x2, 597)).save(os.path.join(PLAYER_DIR, f"pickup_{i:02d}.png"))
        
    # Row 2: 2 Portraits
    crop_and_trim(clean, (463, 614, 785, 926)).save(os.path.join(UI_DIR, "portrait_normal.png"))
    crop_and_trim(clean, (868, 614, 1193, 926)).save(os.path.join(UI_DIR, "portrait_hurt.png"))
    print("  -> Saved player victory, pickup and 2 HUD portraits")

def process_batch_02a():
    print("[*] Processing Batch 02A: Ice Wraith & Enemy Hurt/Death...")
    raw = Image.open(os.path.join(INCOMING, "batch_02_enemy_deaths_ice_wraith.png"))
    clean = remove_green(raw)
    
    # Row 0: Ice Wraith (8 frames: 4 hover, 4 cast)
    w_step = 1672 / 8.0
    for i in range(8):
        box = (int(i * w_step), 18, int((i + 1) * w_step), 197)
        name = f"hover_{i:02d}.png" if i < 4 else f"cast_{i-4:02d}.png"
        crop_and_trim(clean, box).save(os.path.join(ICE_WRAITH_DIR, name))
        
    # Row 1: Skeleton Death (4f)
    sk_cols = [(70, 267), (361, 560), (652, 883), (960, 1248)]
    for i, (x1, x2) in enumerate(sk_cols):
        crop_and_trim(clean, (x1, 212, x2, 377)).save(os.path.join(SKELETON_DIR, f"death_{i:02d}.png"))
        
    # Row 2: Bat Death (4f)
    bat_cols = [(42, 310), (366, 634), (689, 932), (1008, 1225)]
    for i, (x1, x2) in enumerate(bat_cols):
        crop_and_trim(clean, (x1, 400, x2, 522)).save(os.path.join(BAT_DIR, f"death_{i:02d}.png"))
        
    # Row 3: Dark Mage Death (4f)
    mage_cols = [(86, 281), (387, 578), (679, 932), (1019, 1255)]
    for i, (x1, x2) in enumerate(mage_cols):
        crop_and_trim(clean, (x1, 534, x2, 710)).save(os.path.join(MAGE_DIR, f"death_{i:02d}.png"))
        
    # Row 4: Exploder Death (4f)
    exp_cols = [(69, 272), (400, 622), (708, 993), (1080, 1443)]
    for i, (x1, x2) in enumerate(exp_cols):
        crop_and_trim(clean, (x1, 724, x2, 909)).save(os.path.join(EXPLODER_DIR, f"death_{i:02d}.png"))
    print("  -> Saved Ice Wraith actions and 4 enemy death sequences")

def process_batch_02b():
    print("[*] Processing Batch 02B: Elite Champions & Spawn Vortex...")
    raw = Image.open(os.path.join(INCOMING, "batch_02_elite_champions.png"))
    clean = remove_green(raw)
    
    # Top section: Elite Bone Captain (Move 4f, Cleave 4f, Hurt/Death 4f)
    clean.crop((20, 10, 830, 360)).save(os.path.join(ELITE_CAPTAIN_DIR, "bone_captain_actions.png"))
    
    # Middle section: Elite Infernal Arcanist (Float 4f, Dual Barrage 4f, Death 4f)
    clean.crop((20, 370, 1650, 720)).save(os.path.join(ELITE_ARCANIST_DIR, "infernal_arcanist_actions.png"))
    
    # Bottom section: Vortex & Auras
    clean.crop((20, 740, 1100, 930)).save(os.path.join(VFX_DIR, "elite_spawn_vortex.png"))
    crop_and_trim(clean, (1100, 740, 1400, 930)).save(os.path.join(VFX_DIR, "elite_aura_gold.png"))
    crop_and_trim(clean, (1400, 740, 1660, 930)).save(os.path.join(VFX_DIR, "champion_crest.png"))
    print("  -> Saved Elite Bone Captain, Infernal Arcanist, vortex and auras")

def process_batch_04():
    print("[*] Processing Batch 04: Combat Feedback, Status & Synergies...")
    raw_a = Image.open(os.path.join(INCOMING, "batch_04_impacts_and_status.png"))
    clean_a = remove_black_luminance(raw_a)
    clean_a.save(os.path.join(VFX_DIR, "combat_impacts_and_status_sheet.png"))
    
    # Slicing rows: Hit Sparks, Crit Burst, Burn, Freeze, Shock
    h = clean_a.size[1] // 5
    clean_a.crop((0, 0 * h, clean_a.size[0], 1 * h)).save(os.path.join(VFX_DIR, "vfx_hit_sparks_strip.png"))
    clean_a.crop((0, 1 * h, clean_a.size[0], 2 * h)).save(os.path.join(VFX_DIR, "vfx_critical_burst_strip.png"))
    clean_a.crop((0, 2 * h, clean_a.size[0], 3 * h)).save(os.path.join(VFX_DIR, "vfx_status_burning_strip.png"))
    clean_a.crop((0, 3 * h, clean_a.size[0], 4 * h)).save(os.path.join(VFX_DIR, "vfx_status_chilled_strip.png"))
    clean_a.crop((0, 4 * h, clean_a.size[0], 5 * h)).save(os.path.join(VFX_DIR, "vfx_status_shock_strip.png"))
    
    raw_b = Image.open(os.path.join(INCOMING, "batch_04_synergies_and_dash.png"))
    clean_b = remove_black_luminance(raw_b)
    clean_b.crop((0, 7, clean_b.size[0], 242)).save(os.path.join(VFX_DIR, "vfx_steam_burst_strip.png"))
    clean_b.crop((0, 258, clean_b.size[0], 436)).save(os.path.join(VFX_DIR, "vfx_burning_chain_strip.png"))
    clean_b.crop((0, 488, clean_b.size[0], 626)).save(os.path.join(VFX_DIR, "vfx_dash_trail_strip.png"))
    clean_b.crop((0, 662, clean_b.size[0], 905)).save(os.path.join(VFX_DIR, "vfx_shield_break_strip.png"))
    print("  -> Saved all hit feedback, status overlays, synergies and dash trail")

def process_batch_07():
    print("[*] Processing Batch 07: Stages, Props, Portals & Forge...")
    raw_a = Image.open(os.path.join(INCOMING, "batch_07_biome_props_hazards.png"))
    clean_a = remove_green(raw_a)
    clean_a.crop((0, 0, clean_a.size[0], 310)).save(os.path.join(PROPS_DIR, "cathedral_props_strip.png"))
    clean_a.crop((0, 310, clean_a.size[0], 620)).save(os.path.join(PROPS_DIR, "infernal_props_strip.png"))
    clean_a.crop((0, 620, clean_a.size[0], clean_a.size[1])).save(os.path.join(PROPS_DIR, "frozen_props_strip.png"))
    
    raw_b = Image.open(os.path.join(INCOMING, "batch_07_portals_and_forge.png"))
    clean_b = remove_green(raw_b)
    
    # Row 0: Safe Portal (4 frames)
    clean_b.crop((0, 12, clean_b.size[0], 308)).save(os.path.join(PORTALS_DIR, "portal_safe_strip.png"))
    
    # Row 1: Corrupted Portal (4 frames)
    clean_b.crop((0, 318, clean_b.size[0], 611)).save(os.path.join(PORTALS_DIR, "portal_corrupted_strip.png"))
    
    # Row 2: Forge (4 props)
    clean_b.crop((0, 613, clean_b.size[0], 930)).save(os.path.join(FORGE_DIR, "forge_stations_strip.png"))
    print("  -> Saved 3 biomes props, safe portal, corrupted portal and blacksmith forge")

def main():
    process_batch_01a()
    process_batch_01b()
    process_batch_02a()
    process_batch_02b()
    process_batch_04()
    process_batch_07()
    print("[SUCCESS] All 8 new Gameplay 2.0 asset sheets sliced and deployed successfully!")

if __name__ == "__main__":
    main()
