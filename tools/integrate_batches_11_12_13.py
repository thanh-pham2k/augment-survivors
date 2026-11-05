#!/usr/bin/env python3
import os
import shutil
import numpy as np
from PIL import Image

def process_chroma_key(img_np):
    r = img_np[:, :, 0].astype(np.float32)
    g = img_np[:, :, 1].astype(np.float32)
    b = img_np[:, :, 2].astype(np.float32)
    
    max_rb = np.maximum(r, b)
    greenness = g - max_rb
    
    alpha = np.clip(1.0 - (greenness - 15.0) / 25.0, 0.0, 1.0)
    g_despill = np.minimum(g, max_rb + 5.0)
    
    out = np.zeros((img_np.shape[0], img_np.shape[1], 4), dtype=np.uint8)
    out[:, :, 0] = np.clip(r, 0, 255).astype(np.uint8)
    out[:, :, 1] = np.clip(g_despill, 0, 255).astype(np.uint8)
    out[:, :, 2] = np.clip(b, 0, 255).astype(np.uint8)
    out[:, :, 3] = (alpha * 255.0).astype(np.uint8)
    return out

def extract_and_normalize_grid(source_path, out_dir, prefix, actions, target_canvas=(128, 128), ground_y=112):
    os.makedirs(out_dir, exist_ok=True)
    raw_img = Image.open(source_path).convert('RGB')
    w, h = raw_img.size
    cols, rows = 4, 2
    cw, ch = w // cols, h // rows
    
    rgba_full = process_chroma_key(np.array(raw_img))
    
    frame_idx = 0
    for r in range(rows):
        action_name = actions[r]
        for c in range(cols):
            cell = rgba_full[r*ch : (r+1)*ch, c*cw : (c+1)*cw]
            cell_pil = Image.fromarray(cell, 'RGBA')
            
            # Find bounding box of non-zero alpha
            alpha_mask = cell[:, :, 3] > 20
            y_indices, x_indices = np.where(alpha_mask)
            
            canvas = Image.new('RGBA', target_canvas, (0, 0, 0, 0))
            if len(y_indices) > 0:
                min_x, max_x = x_indices.min(), x_indices.max()
                min_y, max_y = y_indices.min(), y_indices.max()
                char_w = max_x - min_x + 1
                char_h = max_y - min_y + 1
                
                cropped = cell_pil.crop((min_x, min_y, max_x + 1, max_y + 1))
                
                # Scale to fit nicely in 128x128
                max_target_h = 92
                scale = min(1.0, max_target_h / float(char_h))
                new_w = max(1, int(char_w * scale))
                new_h = max(1, int(char_h * scale))
                cropped_resized = cropped.resize((new_w, new_h), Image.Resampling.LANCZOS)
                
                # Center horizontally, lock ground pivot at ground_y
                paste_x = (target_canvas[0] - new_w) // 2
                paste_y = ground_y - new_h
                canvas.paste(cropped_resized, (paste_x, paste_y), cropped_resized)
                
            out_file = os.path.join(out_dir, f"{prefix}_{action_name}_{c:02d}.png")
            canvas.save(out_file)
            print(f"  -> Saved frame: {out_file}")
            frame_idx += 1

def main():
    print("=== Processing Batches 11, 12, 13 ===")
    os.makedirs('assets/incoming', exist_ok=True)
    os.makedirs('assets/sprites', exist_ok=True)
    
    # 1. Batch 11: Endless Floor
    src_b11 = 'assets/image copy.png'
    if os.path.exists(src_b11):
        shutil.copy(src_b11, 'assets/incoming/batch_11_endless_dungeon_floor.png')
        im11 = Image.open(src_b11).convert('RGB').resize((1024, 1024), Image.Resampling.LANCZOS)
        arr11 = np.array(im11, dtype=np.float32)
        margin = 64
        for x in range(margin):
            a = x / float(margin)
            arr11[:, x] = arr11[:, x] * a + arr11[:, 1024 - margin + x] * (1.0 - a)
            arr11[:, 1024 - margin + x] = arr11[:, x]
        for y in range(margin):
            a = y / float(margin)
            arr11[y, :] = arr11[y, :] * a + arr11[1024 - margin + y, :] * (1.0 - a)
            arr11[1024 - margin + y, :] = arr11[y, :]
        out11 = Image.fromarray(np.clip(arr11, 0, 255).astype(np.uint8))
        out11.save('assets/sprites/endless_floor_tile.png')
        print("✓ Batch 11 Endless Floor tile generated: 1024x1024 seamless.")
        
    # 2. Batch 12: Dark Mage Cultist
    src_b12 = 'assets/image copy 2.png'
    if os.path.exists(src_b12):
        shutil.copy(src_b12, 'assets/incoming/batch_12_dark_mage_cultist.png')
        extract_and_normalize_grid(
            src_b12,
            out_dir='assets/final_sprites/mage',
            prefix='mage',
            actions=['walk', 'cast'],
            target_canvas=(128, 128),
            ground_y=112
        )
        print("✓ Batch 12 Dark Mage extracted: 8 frames (walk 4f, cast 4f).")

    # 3. Batch 13: Kamikaze Exploder
    src_b13 = 'assets/image copy 3.png'
    if os.path.exists(src_b13):
        shutil.copy(src_b13, 'assets/incoming/batch_13_kamikaze_exploder.png')
        extract_and_normalize_grid(
            src_b13,
            out_dir='assets/final_sprites/exploder',
            prefix='exploder',
            actions=['run', 'detonate'],
            target_canvas=(128, 128),
            ground_y=112
        )
        print("✓ Batch 13 Kamikaze Exploder extracted: 8 frames (run 4f, detonate 4f).")

    # Clean up temp copies
    for f in ['assets/image copy.png', 'assets/image copy 2.png', 'assets/image copy 3.png']:
        if os.path.exists(f):
            os.remove(f)
            print(f"Removed temp file: {f}")

    print("All 3 batches successfully integrated!")

if __name__ == '__main__':
    main()
