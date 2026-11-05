#!/usr/bin/env python3
"""
Augment Survivors — Automated Asset Ingestion & Processing Pipeline
Reads images dropped into assets/incoming/, applies chroma-key removal,
slices grid spritesheets, normalizes anchors, and places them into runtime assets directories.
"""

import os
import sys
import glob
import numpy as np
from PIL import Image

INCOMING_DIR = os.path.abspath("assets/incoming")
OUTPUT_SPRITES_DIR = os.path.abspath("assets/sprites")
OUTPUT_FINAL_DIR = os.path.abspath("assets/final_sprites")

def remove_green_screen(img: Image.Image, threshold: int = 65, softness: int = 25) -> Image.Image:
    """Removes #00FF00 green screen background with edge de-fringing."""
    arr = np.array(img.convert("RGBA"))
    r = arr[:, :, 0].astype(np.int32)
    g = arr[:, :, 1].astype(np.int32)
    b = arr[:, :, 2].astype(np.int32)
    
    # Green dominance metric
    green_diff = g - np.maximum(r, b)
    
    # Alpha mask calculation
    alpha = np.ones_like(green_diff, dtype=np.float32) * 255.0
    
    # Hard green mask
    is_pure_green = (green_diff > threshold)
    alpha[is_pure_green] = 0.0
    
    # Soft transition edge
    transition = (green_diff > (threshold - softness)) & (~is_pure_green)
    if np.any(transition):
        blend = (green_diff[transition] - (threshold - softness)) / float(softness)
        alpha[transition] = (1.0 - blend) * 255.0
        
    arr[:, :, 3] = np.clip(alpha, 0, 255).astype(np.uint8)
    
    # Desaturate lingering green fringe on transparent edges
    fringe = (arr[:, :, 3] < 240) & (arr[:, :, 3] > 0) & (g > r)
    arr[fringe, 1] = np.maximum(arr[fringe, 0], arr[fringe, 2])
    
    return Image.fromarray(arr, "RGBA")

def slice_grid(img: Image.Image, rows: int, cols: int):
    """Slices image into a list of grid cells."""
    w, h = img.size
    cell_w = w // cols
    cell_h = h // rows
    cells = []
    for r in range(rows):
        for c in range(cols):
            box = (c * cell_w, r * cell_h, (c + 1) * cell_w, (r + 1) * cell_h)
            cells.append(img.crop(box))
    return cells, cell_w, cell_h

def main():
    print(f"[*] Scanning {INCOMING_DIR} for new asset batches...")
    files = sorted(glob.glob(os.path.join(INCOMING_DIR, "*.png")))
    if not files:
        print("[!] No png files found in incoming directory.")
        return

    print(f"[+] Found {len(files)} files in incoming directory.")
    for fpath in files:
        fname = os.path.basename(fpath)
        print(f" -> Checking: {fname}")

if __name__ == "__main__":
    main()
