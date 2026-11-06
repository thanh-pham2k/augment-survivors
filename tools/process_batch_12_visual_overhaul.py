#!/usr/bin/env python3
"""
Full Automated Processing & Archiving for Batch 12 (Visual Overhaul Suite)
1. Slices projectiles, vfx, gems, coins, shrines, chests, and revamped monsters.
2. Updates core game textures for immediate visual upgrade.
3. Moves processed sheets into assets/archive/ to keep assets/incoming/ pristine.
"""

import os
import shutil
import numpy as np
from PIL import Image

def remove_chroma_green(img, green_thresh=115, ratio=1.15):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    alpha = np.where(is_green, 0, 255).astype(np.uint8)
    arr[:, :, 3] = alpha
    return Image.fromarray(arr.astype(np.uint8))

def remove_black_vfx(img, black_thresh=20):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    brightness = np.maximum(r, np.maximum(g, b))
    alpha = np.where(brightness < black_thresh, 0, np.clip(brightness * 1.35, 0, 255)).astype(np.uint8)
    arr[:, :, 3] = alpha
    return Image.fromarray(arr.astype(np.uint8))

def crop_tight_alpha(img, pad=3):
    arr = np.array(img)
    alpha = arr[:, :, 3] > 15
    if not np.any(alpha):
        return img
    y_indices, x_indices = np.where(alpha)
    y_min, y_max = max(0, y_indices.min() - pad), min(img.height, y_indices.max() + pad + 1)
    x_min, x_max = max(0, x_indices.min() - pad), min(img.width, x_indices.max() + pad + 1)
    return img.crop((x_min, y_min, x_max, y_max))

def slice_row(clean_img, row_idx, num_rows, cols, output_dir, file_prefix, max_size=None):
    os.makedirs(output_dir, exist_ok=True)
    w, h = clean_img.size
    row_h = h / num_rows
    y0 = int(row_idx * row_h)
    y1 = int((row_idx + 1) * row_h)
    
    col_w = w / cols
    saved = []
    for c in range(cols):
        x0 = int(c * col_w)
        x1 = int((c + 1) * col_w)
        cell = clean_img.crop((x0, y0, x1, y1))
        cropped = crop_tight_alpha(cell)
        if max_size and (cropped.width > max_size[0] or cropped.height > max_size[1]):
            cropped.thumbnail(max_size, Image.Resampling.LANCZOS)
        out_name = f"{file_prefix}_{c}.png"
        out_path = os.path.join(output_dir, out_name)
        cropped.save(out_path)
        saved.append(out_path)
    return saved

def main():
    incoming = "assets/incoming"
    print("=== Processing Batch 12 Assets ===")

    # 1. Sheet 12A: Projectiles & Impacts (Black background)
    f_12a = os.path.join(incoming, "batch_12a_projectiles.png")
    if os.path.exists(f_12a):
        print(" -> Slicing 12A Projectiles & Impacts...")
        img_12a = Image.open(f_12a)
        clean_12a = remove_black_vfx(img_12a)
        
        # Row 0: Fireball Projectile (6 frames)
        fire_frames = slice_row(clean_12a, 0, 6, 6, "assets/sprites/projectiles", "bullet_fire")
        if fire_frames:
            shutil.copy(fire_frames[1], "assets/sprites/projectiles/bullet_fire.png")
            shutil.copy(fire_frames[1], "assets/sprites/projectile.png")
        
        # Row 1: Frost Javelin Projectile (6 frames)
        ice_frames = slice_row(clean_12a, 1, 6, 6, "assets/sprites/projectiles", "bullet_ice")
        if ice_frames:
            shutil.copy(ice_frames[1], "assets/sprites/projectiles/bullet_ice.png")

        # Row 2: Lightning Plasma Projectile (6 frames)
        light_frames = slice_row(clean_12a, 2, 6, 6, "assets/sprites/projectiles", "bullet_lightning")
        if light_frames:
            shutil.copy(light_frames[1], "assets/sprites/projectiles/bullet_lightning.png")

        # Row 3: Fire Impact (4 frames)
        slice_row(clean_12a, 3, 6, 4, "assets/sprites/vfx", "impact_fire")
        # Row 4: Ice Impact (4 frames)
        slice_row(clean_12a, 4, 6, 4, "assets/sprites/vfx", "impact_ice")
        # Row 5: Lightning Impact (4 frames)
        slice_row(clean_12a, 5, 6, 4, "assets/sprites/vfx", "impact_lightning")
        print("    [DONE] Projectiles and impacts extracted.")

    # 2. Sheet 12C: Gems & Coins (Green background)
    f_12c = os.path.join(incoming, "batch_12c_gems_and_coins.png")
    if os.path.exists(f_12c):
        print(" -> Slicing 12C Gems & Coins...")
        img_12c = Image.open(f_12c)
        clean_12c = remove_chroma_green(img_12c)

        # Row 0: Small Soul Gem (4 frames)
        gem_t1 = slice_row(clean_12c, 0, 6, 4, "assets/sprites/collectibles", "xp_gem_t1")
        if gem_t1:
            shutil.copy(gem_t1[0], "assets/sprites/xp_gem.png")
            shutil.copy(gem_t1[0], "assets/sprites/collectibles/xp_gem_default.png")

        # Row 1: Medium Mana Shard (4 frames)
        slice_row(clean_12c, 1, 6, 4, "assets/sprites/collectibles", "xp_gem_t2")
        # Row 2: Large Arcane Cluster (4 frames)
        slice_row(clean_12c, 2, 6, 4, "assets/sprites/collectibles", "xp_gem_t3")

        # Row 3: Ancient Dragon Coin (4 frames)
        coins = slice_row(clean_12c, 3, 6, 4, "assets/sprites/collectibles", "gold_coin")
        if coins:
            shutil.copy(coins[0], "assets/sprites/gold_coin.png")

        # Row 4: Coin Pouch (4 frames)
        slice_row(clean_12c, 4, 6, 4, "assets/sprites/collectibles", "gold_pouch")

        # Row 5: Absorption Sparkle Burst (4 frames)
        slice_row(clean_12c, 5, 6, 4, "assets/sprites/vfx", "absorb_sparkle")
        print("    [DONE] Gems, coins, and absorption bursts extracted.")

    # 3. Sheet 12D: Cache & Chests (Green background)
    f_12d = os.path.join(incoming, "batch_12d_cache_and_chests.png")
    if os.path.exists(f_12d):
        print(" -> Slicing 12D Shrines & Chests...")
        img_12d = Image.open(f_12d)
        clean_12d = remove_chroma_green(img_12d)

        # Row 0: World Upgrade Monolith (6 frames)
        cache_frames = slice_row(clean_12d, 0, 6, 6, "assets/sprites/interactive", "upgrade_monolith")
        if cache_frames:
            os.makedirs("assets/sprites/interactive", exist_ok=True)
            shutil.copy(cache_frames[0], "assets/sprites/interactive/world_upgrade_cache.png")
            shutil.copy(cache_frames[0], "assets/sprites/world_upgrade_cache.png")

        # Row 2: Wooden Chest (3 frames)
        slice_row(clean_12d, 2, 6, 3, "assets/sprites/interactive", "chest_wood")
        # Row 3: Royal Gilded Chest (3 frames)
        slice_row(clean_12d, 3, 6, 3, "assets/sprites/interactive", "chest_gold")
        # Row 4: Boss Reliquary Vault (3 frames)
        slice_row(clean_12d, 4, 6, 3, "assets/sprites/interactive", "chest_boss")
        print("    [DONE] Shrines and chests extracted.")

    # 4. Sheet 12E: Spells & Telegraphs (Black background)
    f_12e = os.path.join(incoming, "batch_12e_spells_and_telegraphs.png")
    if os.path.exists(f_12e):
        print(" -> Slicing 12E Spells & Telegraphs...")
        img_12e = Image.open(f_12e)
        clean_12e = remove_black_vfx(img_12e)

        # Row 0: Inferno Ring AoE (6 frames)
        slice_row(clean_12e, 0, 6, 6, "assets/sprites/vfx", "spell_inferno_ring")
        # Row 1: Glacial Frost Nova AoE (6 frames)
        slice_row(clean_12e, 1, 6, 6, "assets/sprites/vfx", "spell_frost_nova")
        # Row 2: Lightning Storm AoE (6 frames)
        slice_row(clean_12e, 2, 6, 6, "assets/sprites/vfx", "spell_lightning_storm")
        # Row 3: Threat Circle Telegraph (4 frames)
        slice_row(clean_12e, 3, 6, 4, "assets/sprites/vfx", "telegraph_circle")
        # Row 4: Boss Slam Cone (4 frames)
        slice_row(clean_12e, 4, 6, 4, "assets/sprites/vfx", "telegraph_cone")
        print("    [DONE] Spells and telegraphs extracted.")

    # 5. Sheet 12F: Skeleton & Bat (Green background)
    f_12f = os.path.join(incoming, "batch_12f_skeleton_and_bat.png")
    if os.path.exists(f_12f):
        print(" -> Slicing 12F Skeleton & Bat...")
        img_12f = Image.open(f_12f)
        clean_12f = remove_chroma_green(img_12f)

        # Row 0: Skeleton Walk (4 frames)
        skel_walk = slice_row(clean_12f, 0, 6, 4, "assets/final_sprites/skeleton", "walk")
        for i, p in enumerate(skel_walk):
            shutil.copy(p, f"assets/final_sprites/skeleton/skeleton_frame_0{i}.png")
        # Row 1: Skeleton Attack (4 frames)
        slice_row(clean_12f, 1, 6, 4, "assets/final_sprites/skeleton", "attack")
        # Row 2: Skeleton Death (4 frames)
        slice_row(clean_12f, 2, 6, 4, "assets/final_sprites/skeleton", "death")

        # Row 3: Bat Fly (4 frames)
        bat_fly = slice_row(clean_12f, 3, 6, 4, "assets/final_sprites/bat", "fly")
        for i, p in enumerate(bat_fly):
            shutil.copy(p, f"assets/final_sprites/bat/bat_frame_0{i}.png")
        # Row 4: Bat Screech (4 frames)
        slice_row(clean_12f, 4, 6, 4, "assets/final_sprites/bat", "dive")
        # Row 5: Bat Death (4 frames)
        slice_row(clean_12f, 5, 6, 4, "assets/final_sprites/bat", "death")
        print("    [DONE] Skeleton and Bat sprites updated.")

    # 6. Sheet 12G: Exploder & Mage (Green background)
    f_12g = os.path.join(incoming, "batch_12g_exploder_and_mage.png")
    if os.path.exists(f_12g):
        print(" -> Slicing 12G Exploder & Mage...")
        img_12g = Image.open(f_12g)
        clean_12g = remove_chroma_green(img_12g)

        # Row 0: Exploder Run (4 frames)
        exp_run = slice_row(clean_12g, 0, 6, 4, "assets/final_sprites/exploder", "run")
        for i, p in enumerate(exp_run):
            shutil.copy(p, f"assets/final_sprites/exploder/exploder_0{i}.png")
        # Row 1: Exploder Ignite (3 frames)
        slice_row(clean_12g, 1, 6, 3, "assets/final_sprites/exploder", "ignite")
        # Row 2: Exploder Explode (5 frames)
        slice_row(clean_12g, 2, 6, 5, "assets/final_sprites/exploder", "explode")

        # Row 3: Dark Mage Hover (4 frames)
        mage_hover = slice_row(clean_12g, 3, 6, 4, "assets/final_sprites/dark_mage", "hover")
        for i, p in enumerate(mage_hover):
            shutil.copy(p, f"assets/final_sprites/dark_mage/mage_0{i}.png")
        # Row 4: Dark Mage Cast (4 frames)
        slice_row(clean_12g, 4, 6, 4, "assets/final_sprites/dark_mage", "cast")
        # Row 5: Dark Mage Death (4 frames)
        slice_row(clean_12g, 5, 6, 4, "assets/final_sprites/dark_mage", "death")
        print("    [DONE] Exploder and Dark Mage sprites updated.")

    # 7. Sheet 12H: Elite & Boss (Green background)
    f_12h = os.path.join(incoming, "batch_12h_elite_and_boss.png")
    if os.path.exists(f_12h):
        print(" -> Slicing 12H Elite & Boss...")
        img_12h = Image.open(f_12h)
        clean_12h = remove_chroma_green(img_12h)

        # Row 0: Dread Knight Walk (4 frames)
        slice_row(clean_12h, 0, 6, 4, "assets/final_sprites/elite", "walk")
        # Row 1: Dread Knight Heavy Strike (4 frames)
        slice_row(clean_12h, 1, 6, 4, "assets/final_sprites/elite", "attack")
        # Row 2: Dread Knight Death (4 frames)
        slice_row(clean_12h, 2, 6, 4, "assets/final_sprites/elite", "death")

        # Row 3: Boss Colossus Idle (4 frames)
        boss_idle = slice_row(clean_12h, 3, 6, 4, "assets/final_sprites/boss", "idle")
        for i, p in enumerate(boss_idle):
            shutil.copy(p, f"assets/final_sprites/boss/boss_frame_0{i}.png")
            shutil.copy(p, f"assets/final_sprites/boss/boss_0{i}.png")
        # Row 4: Boss Slam (4 frames)
        slice_row(clean_12h, 4, 6, 4, "assets/final_sprites/boss", "slam")
        # Row 5: Boss Laser (4 frames)
        slice_row(clean_12h, 5, 6, 4, "assets/final_sprites/boss", "laser")
        print("    [DONE] Dread Knight and Boss Colossus sprites updated.")

    print("\n=== Archiving Processed Files ===")
    archive_dir = "assets/archive"
    batch12_archive = os.path.join(archive_dir, "batch_12")
    legacy_archive = os.path.join(archive_dir, "legacy_batches")
    os.makedirs(batch12_archive, exist_ok=True)
    os.makedirs(legacy_archive, exist_ok=True)

    for fname in os.listdir(incoming):
        fpath = os.path.join(incoming, fname)
        if not os.path.isfile(fpath):
            continue
        if fname.startswith("batch_12"):
            dest = os.path.join(batch12_archive, fname)
            shutil.move(fpath, dest)
            print(f"Moved {fname} -> {batch12_archive}/")
        else:
            dest = os.path.join(legacy_archive, fname)
            shutil.move(fpath, dest)
            print(f"Moved {fname} -> {legacy_archive}/")

    print("\n=== Finished! assets/incoming is now clean and empty! ===")

if __name__ == "__main__":
    main()
