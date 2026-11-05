import os
import numpy as np
from PIL import Image
from scipy import ndimage

def remove_chroma(img, green_thresh=130, ratio=1.20):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    # Green screen detection with margin
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    
    # Soft alpha feathering on boundary
    alpha = np.where(is_green, 0, 255).astype(np.uint8)
    arr[:, :, 3] = alpha
    return Image.fromarray(arr.astype(np.uint8))

def crop_tight_alpha(img, pad=4):
    arr = np.array(img)
    alpha = arr[:, :, 3] > 10
    if not np.any(alpha):
        return img
    y_indices, x_indices = np.where(alpha)
    y_min, y_max = max(0, y_indices.min() - pad), min(img.height, y_indices.max() + pad + 1)
    x_min, x_max = max(0, x_indices.min() - pad), min(img.width, x_indices.max() + pad + 1)
    return img.crop((x_min, y_min, x_max, y_max))

print("=== Starting Batch Integration ===")

# -------------------------------------------------------------
# 1. BATCH 01: Player Movement (4 Idle, 4 Run)
# -------------------------------------------------------------
os.makedirs("assets/final_sprites/player", exist_ok=True)
b1 = Image.open("assets/incoming/batch_01_player_movement.png")
b1_clean = remove_chroma(b1)

b1_boxes = [
    # Row 1: Idle
    (90, 66, 389, 406),
    (525, 60, 822, 405),
    (945, 55, 1268, 406),
    (1390, 66, 1691, 407),
    # Row 2: Run
    (54, 502, 404, 827),
    (496, 499, 840, 831),
    (931, 501, 1277, 809),
    (1369, 497, 1705, 826)
]

for i in range(4):
    frame = crop_tight_alpha(b1_clean.crop(b1_boxes[i]))
    frame.save(f"assets/final_sprites/player/idle_{i:02d}.png", format="PNG")
print("Saved 4 Player Idle frames")

for i in range(4):
    frame = crop_tight_alpha(b1_clean.crop(b1_boxes[4 + i]))
    frame.save(f"assets/final_sprites/player/run_{i:02d}.png", format="PNG")
print("Saved 4 Player Run frames")

# Save primary player sprite
p_main = crop_tight_alpha(b1_clean.crop(b1_boxes[0]))
# Scale to game standard sprite height (~72px)
p_main_scaled = p_main.resize((int(p_main.width * 72 / p_main.height), 72), Image.Resampling.LANCZOS)
p_main_scaled.save("assets/sprites/player.png", format="PNG")

# -------------------------------------------------------------
# 2. BATCH 02: Player Combat (4 Cast, 2 Dash, 2 Hurt)
# -------------------------------------------------------------
b2 = Image.open("assets/incoming/batch_02_player_combat.png")
b2_clean = remove_chroma(b2)

b2_boxes = [
    # Row 1: Cast
    (34, 105, 360, 395),
    (445, 105, 745, 395),
    (825, 105, 1200, 395),
    (1370, 105, 1670, 395),
    # Row 2: Dash (2) + Hurt (2)
    (50, 550, 360, 790),
    (445, 545, 865, 790),
    (975, 520, 1245, 810),
    (1380, 525, 1650, 810)
]

for i in range(4):
    frame = crop_tight_alpha(b2_clean.crop(b2_boxes[i]))
    frame.save(f"assets/final_sprites/player/cast_{i:02d}.png", format="PNG")
print("Saved 4 Player Cast frames")

for i in range(2):
    frame = crop_tight_alpha(b2_clean.crop(b2_boxes[4 + i]))
    frame.save(f"assets/final_sprites/player/dash_{i:02d}.png", format="PNG")
print("Saved 2 Player Dash frames")

for i in range(2):
    frame = crop_tight_alpha(b2_clean.crop(b2_boxes[6 + i]))
    frame.save(f"assets/final_sprites/player/hurt_{i:02d}.png", format="PNG")
print("Saved 2 Player Hurt frames")

# -------------------------------------------------------------
# 3. BATCH 03: Skeleton Warrior (4 Walk, 4 Slash)
# -------------------------------------------------------------
os.makedirs("assets/final_sprites/skeleton", exist_ok=True)
b3 = Image.open("assets/incoming/batch_03_skeleton_warrior.png")
b3_clean = remove_chroma(b3)

b3_boxes = [
    # Row 1: Walk
    (107, 68, 312, 398),
    (561, 68, 752, 393),
    (991, 68, 1194, 400),
    (1422, 85, 1632, 395),
    # Row 2: Attack Slash
    (89, 476, 357, 814),
    (493, 514, 816, 791),
    (891, 520, 1312, 782),
    (1424, 493, 1651, 806)
]

for i in range(4):
    frame = crop_tight_alpha(b3_clean.crop(b3_boxes[i]))
    frame.save(f"assets/final_sprites/skeleton/walk_{i:02d}.png", format="PNG")
print("Saved 4 Skeleton Walk frames")

for i in range(4):
    frame = crop_tight_alpha(b3_clean.crop(b3_boxes[4 + i]))
    frame.save(f"assets/final_sprites/skeleton/slash_{i:02d}.png", format="PNG")
print("Saved 4 Skeleton Slash frames")

sk_main = crop_tight_alpha(b3_clean.crop(b3_boxes[0]))
sk_scaled = sk_main.resize((int(sk_main.width * 68 / sk_main.height), 68), Image.Resampling.LANCZOS)
sk_scaled.save("assets/sprites/skeleton.png", format="PNG")

# -------------------------------------------------------------
# 4. BATCH 04: Shadow Bat (4 Fly, 4 Dive)
# -------------------------------------------------------------
os.makedirs("assets/final_sprites/bat", exist_ok=True)
b4 = Image.open("assets/incoming/batch_04_shadow_bat.png")
b4_clean = remove_chroma(b4)

b4_boxes = [
    # Row 1: Fly
    (60, 94, 378, 326),
    (483, 185, 812, 396),
    (881, 189, 1322, 324),
    (1362, 151, 1706, 328),
    # Row 2: Dive
    (81, 507, 327, 776),
    (539, 560, 765, 770),
    (927, 536, 1233, 797),
    (1382, 516, 1726, 745)
]

for i in range(4):
    frame = crop_tight_alpha(b4_clean.crop(b4_boxes[i]))
    frame.save(f"assets/final_sprites/bat/fly_{i:02d}.png", format="PNG")
print("Saved 4 Bat Fly frames")

for i in range(4):
    frame = crop_tight_alpha(b4_clean.crop(b4_boxes[4 + i]))
    frame.save(f"assets/final_sprites/bat/dive_{i:02d}.png", format="PNG")
print("Saved 4 Bat Dive frames")

bat_main = crop_tight_alpha(b4_clean.crop(b4_boxes[0]))
bat_scaled = bat_main.resize((int(bat_main.width * 46 / bat_main.height), 46), Image.Resampling.LANCZOS)
bat_scaled.save("assets/sprites/bat.png", format="PNG")

# -------------------------------------------------------------
# 5. BATCH 05: Boss Ember Colossus (6 frames)
# -------------------------------------------------------------
os.makedirs("assets/final_sprites/boss", exist_ok=True)
b5 = Image.open("assets/incoming/batch_05_boss_colossus.png")
b5_clean = remove_chroma(b5)

b5_boxes = [
    (17, 55, 476, 460),
    (540, 11, 961, 460),
    (1012, 99, 1526, 482),
    (32, 549, 460, 958),
    (522, 544, 1035, 958),
    (1060, 561, 1522, 958)
]

for i in range(6):
    frame = crop_tight_alpha(b5_clean.crop(b5_boxes[i]))
    frame.save(f"assets/final_sprites/boss/boss_{i:02d}.png", format="PNG")
print("Saved 6 Boss frames")

boss_main = crop_tight_alpha(b5_clean.crop(b5_boxes[0]))
boss_scaled = boss_main.resize((int(boss_main.width * 140 / boss_main.height), 140), Image.Resampling.LANCZOS)
boss_scaled.save("assets/sprites/boss_colossus.png", format="PNG")

# -------------------------------------------------------------
# 6. BATCH 06: VFX Projectiles & Explosions
# -------------------------------------------------------------
os.makedirs("assets/final_sprites/vfx", exist_ok=True)
b6 = Image.open("assets/incoming/batch_06_elemental_vfx.png")
b6_clean = remove_chroma(b6)

# Fireball missile
fire_proj = crop_tight_alpha(b6_clean.crop((63, 157, 415, 316)))
fire_proj_scaled = fire_proj.resize((int(fire_proj.width * 36 / fire_proj.height), 36), Image.Resampling.LANCZOS)
fire_proj_scaled.save("assets/sprites/proj_fire.png", format="PNG")
print("Saved High-Res Fireball projectile")

# Chain Lightning Bolt
lt_proj = crop_tight_alpha(b6_clean.crop((56, 485, 376, 815)))
lt_proj_scaled = lt_proj.resize((48, int(lt_proj.height * 48 / lt_proj.width)), Image.Resampling.LANCZOS)
lt_proj_scaled.save("assets/sprites/proj_lightning.png", format="PNG")
print("Saved High-Res Lightning projectile")

# Fire Explosion
fire_exp = crop_tight_alpha(b6_clean.crop((897, 67, 1295, 380)))
fire_exp.save("assets/final_sprites/vfx/fire_exp.png", format="PNG")

# Steam Burst Explosion
steam_exp = crop_tight_alpha(b6_clean.crop((905, 473, 1299, 796)))
steam_exp.save("assets/final_sprites/vfx/steam_exp.png", format="PNG")
print("Saved VFX Explosions")

# -------------------------------------------------------------
# 7. BATCH 07: Augment Cards Ultra HD
# -------------------------------------------------------------
b7 = Image.open("assets/incoming/batch_07_augment_cards_hd.png")
b7_clean = remove_chroma(b7)

# 1086x1448 layout: 3 cols x 2 rows
b7_boxes = [
    ("card_ember_shot.png", (24, 48, 365, 680)),
    ("card_frostbite.png", (375, 48, 715, 680)),
    ("card_arc_bolt.png", (725, 48, 1065, 680)),
    ("card_burning_chain.png", (24, 710, 365, 1390)),
    ("card_frost_conduit.png", (375, 710, 715, 1390)),
    ("card_wildfire.png", (725, 710, 1065, 1390))
]

for name, box in b7_boxes:
    card = crop_tight_alpha(b7_clean.crop(box))
    card.save(f"assets/sprites/{name}", format="PNG")
    print(f"Saved Ultra HD {name}: {card.size}")

print("=== ALL BATCHES INTEGRATED SUCCESSFULLY ===")
