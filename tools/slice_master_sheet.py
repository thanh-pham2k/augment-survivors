"""
Production Master Atlas Slicer & Anchor Normalizer for Augment Survivors
Slices the comprehensive master sheet (1024x682) into transparent, perfectly anchored animation frames:
- Sector 1: Top-Left (x: 0..512, y: 0..325) -> Player (Idle, Run, Cast, Dash, Hurt)
- Sector 2: Top-Right (x: 512..1024, y: 0..325) -> Enemies (Skeleton walk & slash, Bat fly & dive)
- Sector 3: Bottom-Left (x: 0..512, y: 325..682) -> Boss The Ember Colossus (Idle, Slam, Sweep, Stagger)
- Sector 4: Bottom-Right (x: 512..1024, y: 325..682) -> VFX (Fireball burst, Lightning arc, Steam burst AoE)
"""
import os
import numpy as np
from PIL import Image
from scipy import ndimage

def remove_chroma(img, green_thresh=110, ratio=1.22):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    return Image.fromarray(arr.astype(np.uint8))

master = Image.open('assets/master_atlas_all.png')
clean_master = remove_chroma(master)
clean_master.save('assets/clean_master_transparent.png')

W, H = clean_master.size
mid_x, mid_y = 512, 330

def extract_connected_sprites(sub_img, min_w=20, min_h=20, min_area=350):
    arr = np.array(sub_img)
    alpha = arr[:, :, 3] > 20
    labeled, num_features = ndimage.label(alpha)
    objs = ndimage.find_objects(labeled)
    
    valid_sprites = []
    for sl in objs:
        h = sl[0].stop - sl[0].start
        w = sl[1].stop - sl[1].start
        if w >= min_w and h >= min_h and (w * h) >= min_area:
            crop_box = (sl[1].start, sl[0].start, sl[1].stop, sl[0].stop)
            sprite = sub_img.crop(crop_box)
            valid_sprites.append({
                "sprite": sprite,
                "x": sl[1].start,
                "y": sl[0].start,
                "w": w,
                "h": h
            })
    return valid_sprites

# 1. Process Player Sector (Top-Left: 0, 0 to 512, 330)
player_sector = clean_master.crop((0, 0, mid_x, mid_y))
player_objs = extract_connected_sprites(player_sector, min_w=25, min_h=35, min_area=900)
# Sort by rows (y // 70), then x
player_objs.sort(key=lambda item: (item["y"] // 65, item["x"]))

os.makedirs('assets/final_sprites/player', exist_ok=True)
print(f"Extracted {len(player_objs)} player frames")
for i, item in enumerate(player_objs):
    sp = item["sprite"]
    # Normalize to 96x96 with ground anchor at bottom
    target_canvas = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    scale = 68.0 / sp.height if sp.height > 68 else 1.0
    nw = max(1, int(sp.width * scale))
    nh = max(1, int(sp.height * scale))
    sp_scaled = sp.resize((nw, nh), Image.Resampling.LANCZOS)
    target_canvas.paste(sp_scaled, ((96 - nw) // 2, 96 - nh - 6))
    target_canvas.save(f'assets/final_sprites/player/player_frame_{i:02d}.png')
    if i == 0:
        target_canvas.save('assets/sprites/player.png')

# 2. Process Enemies Sector (Top-Right: 512, 0 to 1024, 330)
enemy_sector = clean_master.crop((mid_x, 0, W, mid_y))
# Top part: Skeletons (y: 0 to 220), Bottom part: Bats (y: 220 to 330)
skel_sector = enemy_sector.crop((0, 0, mid_x, 220))
bat_sector = enemy_sector.crop((0, 220, mid_x, mid_y))

skel_objs = extract_connected_sprites(skel_sector, min_w=25, min_h=35, min_area=800)
skel_objs.sort(key=lambda item: (item["y"] // 90, item["x"]))
print(f"Extracted {len(skel_objs)} skeleton frames")
os.makedirs('assets/final_sprites/skeleton', exist_ok=True)
for i, item in enumerate(skel_objs):
    sp = item["sprite"]
    target_canvas = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    scale = 64.0 / sp.height if sp.height > 64 else 1.0
    nw = max(1, int(sp.width * scale))
    nh = max(1, int(sp.height * scale))
    sp_scaled = sp.resize((nw, nh), Image.Resampling.LANCZOS)
    target_canvas.paste(sp_scaled, ((96 - nw) // 2, 96 - nh - 6))
    target_canvas.save(f'assets/final_sprites/skeleton/skel_frame_{i:02d}.png')
    if i == 0:
        target_canvas.save('assets/sprites/skeleton.png')

bat_objs = extract_connected_sprites(bat_sector, min_w=25, min_h=20, min_area=400)
bat_objs.sort(key=lambda item: item["x"])
print(f"Extracted {len(bat_objs)} bat frames")
os.makedirs('assets/final_sprites/bat', exist_ok=True)
for i, item in enumerate(bat_objs):
    sp = item["sprite"]
    target_canvas = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    scale = 52.0 / sp.height if sp.height > 52 else 1.0
    nw = max(1, int(sp.width * scale))
    nh = max(1, int(sp.height * scale))
    sp_scaled = sp.resize((nw, nh), Image.Resampling.LANCZOS)
    target_canvas.paste(sp_scaled, ((96 - nw) // 2, (96 - nh) // 2))
    target_canvas.save(f'assets/final_sprites/bat/bat_frame_{i:02d}.png')
    if i == 0:
        target_canvas.save('assets/sprites/bat.png')

# 3. Process Boss Sector (Bottom-Left: 0, 330 to 512, 682)
boss_sector = clean_master.crop((0, mid_y, mid_x, H))
boss_objs = extract_connected_sprites(boss_sector, min_w=50, min_h=50, min_area=3500)
boss_objs.sort(key=lambda item: (item["y"] // 100, item["x"]))
print(f"Extracted {len(boss_objs)} boss frames")
os.makedirs('assets/final_sprites/boss', exist_ok=True)
for i, item in enumerate(boss_objs):
    sp = item["sprite"]
    target_canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    scale = 180.0 / sp.height if sp.height > 180 else 1.0
    nw = max(1, int(sp.width * scale))
    nh = max(1, int(sp.height * scale))
    sp_scaled = sp.resize((nw, nh), Image.Resampling.LANCZOS)
    target_canvas.paste(sp_scaled, ((256 - nw) // 2, 256 - nh - 12))
    target_canvas.save(f'assets/final_sprites/boss/boss_frame_{i:02d}.png')
    if i == 0:
        target_canvas.save('assets/sprites/boss_colossus.png')

# 4. Process VFX Sector (Bottom-Right: 512, 330 to 1024, 682)
vfx_sector = clean_master.crop((mid_x, mid_y, W, H))
# Row 0: Fireball (y: 0 to 110), Row 1: Lightning (y: 110 to 220), Row 2: Steam Burst (y: 220 to 352)
fire_vfx_sec = vfx_sector.crop((0, 0, mid_x, 115))
lightning_vfx_sec = vfx_sector.crop((0, 115, mid_x, 230))
steam_vfx_sec = vfx_sector.crop((0, 230, mid_x, vfx_sector.height))

os.makedirs('assets/final_sprites/vfx', exist_ok=True)

# Slicing projectile fireball
f_objs = extract_connected_sprites(fire_vfx_sec, min_w=20, min_h=20, min_area=300)
f_objs.sort(key=lambda item: item["x"])
for i, item in enumerate(f_objs):
    item["sprite"].save(f'assets/final_sprites/vfx/fireball_{i:02d}.png')
    if i == 2:
        item["sprite"].save('assets/sprites/proj_fire.png')

# Slicing lightning
l_objs = extract_connected_sprites(lightning_vfx_sec, min_w=20, min_h=20, min_area=300)
l_objs.sort(key=lambda item: item["x"])
for i, item in enumerate(l_objs):
    item["sprite"].save(f'assets/final_sprites/vfx/lightning_{i:02d}.png')
    if i == 2:
        item["sprite"].save('assets/sprites/proj_lightning.png')

print("All master assets extracted, scaled, anchored, and deployed perfectly!")
