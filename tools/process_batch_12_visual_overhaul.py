#!/usr/bin/env python3
"""
Batch 12: Visual Overhaul Suite (Projectiles, Resources & Skills/Monsters)
Automatically processes and slices incoming batch 12 asset sheets.
"""

import os
import sys
import numpy as np
from PIL import Image

def remove_chroma_green(img, green_thresh=110, ratio=1.18):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    alpha = np.where(is_green, 0, 255).astype(np.uint8)
    arr[:, :, 3] = alpha
    return Image.fromarray(arr.astype(np.uint8))

def remove_black_vfx(img, black_thresh=20):
    """Additive black removal preserving glowing halos and ember alpha."""
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    brightness = np.maximum(r, np.maximum(g, b))
    alpha = np.where(brightness < black_thresh, 0, np.clip(brightness * 1.25, 0, 255)).astype(np.uint8)
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

def slice_grid(img, rows, cols, output_dir, prefix, is_vfx=False, target_size=None):
    os.makedirs(output_dir, exist_ok=True)
    clean_img = remove_black_vfx(img) if is_vfx else remove_chroma_green(img)
    w, h = clean_img.size
    cell_w = w / cols
    cell_h = h / rows
    
    saved_paths = []
    idx = 0
    for r in range(rows):
        for c in range(cols):
            x0 = int(c * cell_w)
            y0 = int(r * cell_h)
            x1 = int((c + 1) * cell_w)
            y1 = int((r + 1) * cell_h)
            cell = clean_img.crop((x0, y0, x1, y1))
            cropped = crop_tight_alpha(cell)
            if target_size:
                cropped = cropped.resize(target_size, Image.Resampling.LANCZOS)
            out_file = os.path.join(output_dir, f"{prefix}_{r}_{c}.png")
            cropped.save(out_file)
            saved_paths.append(out_file)
            idx += 1
    return saved_paths

def main():
    incoming_dir = "assets/incoming"
    print("=== Scanning assets/incoming for Batch 12 assets ===")
    
    # 1. Projectiles: batch_12a_projectiles.png
    p_path = os.path.join(incoming_dir, "batch_12a_projectiles.png")
    if os.path.exists(p_path):
        print("Processing batch_12a_projectiles.png...")
        img = Image.open(p_path)
        slice_grid(img, 6, 6, "assets/sprites/projectiles/v2", "proj", is_vfx=True)
        print(" -> Sliced projectiles into assets/sprites/projectiles/v2/")

    # 2. Evolved: batch_12b_evolved_projectiles.png
    p_path = os.path.join(incoming_dir, "batch_12b_evolved_projectiles.png")
    if os.path.exists(p_path):
        print("Processing batch_12b_evolved_projectiles.png...")
        img = Image.open(p_path)
        slice_grid(img, 4, 6, "assets/sprites/projectiles/evolved_v2", "evo_proj", is_vfx=True)
        print(" -> Sliced evolved projectiles into assets/sprites/projectiles/evolved_v2/")

    # 3. Resources: batch_12c_gems_and_coins.png
    p_path = os.path.join(incoming_dir, "batch_12c_gems_and_coins.png")
    if os.path.exists(p_path):
        print("Processing batch_12c_gems_and_coins.png...")
        img = Image.open(p_path)
        slice_grid(img, 6, 4, "assets/sprites/collectibles/v2", "res", is_vfx=False)
        print(" -> Sliced resources into assets/sprites/collectibles/v2/")

    # 4. Cache & Chests: batch_12d_cache_and_chests.png
    p_path = os.path.join(incoming_dir, "batch_12d_cache_and_chests.png")
    if os.path.exists(p_path):
        print("Processing batch_12d_cache_and_chests.png...")
        img = Image.open(p_path)
        slice_grid(img, 4, 6, "assets/sprites/interactive/v2", "cache", is_vfx=False)
        print(" -> Sliced interactive objects into assets/sprites/interactive/v2/")

    # 5. Spells & Telegraphs: batch_12e_spells_and_telegraphs.png
    p_path = os.path.join(incoming_dir, "batch_12e_spells_and_telegraphs.png")
    if os.path.exists(p_path):
        print("Processing batch_12e_spells_and_telegraphs.png...")
        img = Image.open(p_path)
        slice_grid(img, 5, 6, "assets/sprites/vfx/spells_v2", "spell", is_vfx=True)
        print(" -> Sliced spells & telegraphs into assets/sprites/vfx/spells_v2/")

    # 6. Enemies: Skeleton & Bat
    p_path = os.path.join(incoming_dir, "batch_12f_skeleton_and_bat.png")
    if os.path.exists(p_path):
        print("Processing batch_12f_skeleton_and_bat.png...")
        img = Image.open(p_path)
        slice_grid(img, 6, 4, "assets/sprites/enemies/v2_skeleton_bat", "mob", is_vfx=False)
        print(" -> Sliced skeleton and bat into assets/sprites/enemies/v2_skeleton_bat/")

    # 7. Enemies: Exploder & Mage
    p_path = os.path.join(incoming_dir, "batch_12g_exploder_and_mage.png")
    if os.path.exists(p_path):
        print("Processing batch_12g_exploder_and_mage.png...")
        img = Image.open(p_path)
        slice_grid(img, 6, 4, "assets/sprites/enemies/v2_exploder_mage", "mob", is_vfx=False)
        print(" -> Sliced exploder and mage into assets/sprites/enemies/v2_exploder_mage/")

    # 8. Boss & Elite
    p_path = os.path.join(incoming_dir, "batch_12h_elite_and_boss.png")
    if os.path.exists(p_path):
        print("Processing batch_12h_elite_and_boss.png...")
        img = Image.open(p_path)
        slice_grid(img, 6, 4, "assets/sprites/enemies/v2_elite_boss", "titan", is_vfx=False)
        print(" -> Sliced elite & boss into assets/sprites/enemies/v2_elite_boss/")

    print("=== Scanning complete ===")

if __name__ == "__main__":
    main()
