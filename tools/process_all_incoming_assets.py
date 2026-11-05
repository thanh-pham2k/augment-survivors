"""
Production-Grade Texture Atlas & Sprite Slicer for Augment Survivors
Processes all 5 batch files from assets/new_asset:
1. image.png -> Player 8 frames (Idle 1-2, Walk 1-2, Cast 1-2, Dash, Hurt) -> player_atlas.png (128x128 grid)
2. image copy.png -> Enemies 8 frames (Skeleton 1-4, Bat 1-4) -> enemies_atlas.png (128x128 grid)
3. image copy 2.png -> Boss 6 frames (Colossus 1-4, Crystal 1-2) -> boss_atlas.png (256x256 grid)
4. image copy 3.png -> 6 Tarot-style Draft Cards (Ember, Frost, Arc, Burning Chain, Frost Conduit, Wildfire)
5. image copy 4.png -> Projectiles & HUD Icons (Fireball, Frost Shard, Arc Bolt, Steam, Dash, Avatar, Shield, Skull)
"""
import os
import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage

def remove_green_screen(img, tolerance_ratio=1.28, min_g=115):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    
    # Precise chroma-key mask for solid bright green #00FF00
    is_green = (g > min_g) & (g > r * tolerance_ratio) & (g > b * tolerance_ratio)
    
    # Also soften green spill on outer fringes
    spill = (g > r) & (g > b) & is_green
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    
    out = Image.fromarray(arr.astype(np.uint8))
    return out

def slice_grid(image_path, rows, cols, out_dir, prefix, target_size=(128, 128), align_bottom=True):
    os.makedirs(out_dir, exist_ok=True)
    src = Image.open(image_path)
    clean = remove_green_screen(src)
    
    w, h = clean.size
    cell_w = w // cols
    cell_h = h // rows
    
    sliced_frames = []
    
    frame_idx = 0
    for r in range(rows):
        for c in range(cols):
            box = (c * cell_w, r * cell_h, (c + 1) * cell_w, (r + 1) * cell_h)
            cell = clean.crop(box)
            
            # Crop tightly to non-transparent alpha
            bbox = cell.getchannel('A').getbbox()
            if bbox:
                # Add small padding if possible
                pad = 4
                padded_box = (
                    max(0, bbox[0] - pad),
                    max(0, bbox[1] - pad),
                    min(cell.width, bbox[2] + pad),
                    min(cell.height, bbox[3] + pad)
                )
                sprite = cell.crop(padded_box)
            else:
                sprite = cell
                
            # Create normalized uniform canvas
            canvas = Image.new("RGBA", target_size, (0, 0, 0, 0))
            
            # Scale proportionally to fit target canvas
            max_w, max_h = int(target_size[0] * 0.88), int(target_size[1] * 0.88)
            ratio = min(max_w / sprite.width, max_h / sprite.height)
            new_w = max(1, int(sprite.width * ratio))
            new_h = max(1, int(sprite.height * ratio))
            sprite_scaled = sprite.resize((new_w, new_h), Image.Resampling.LANCZOS)
            
            pos_x = (target_size[0] - new_w) // 2
            if align_bottom:
                pos_y = target_size[1] - new_h - 6 # Anchor feet 6px from bottom
            else:
                pos_y = (target_size[1] - new_h) // 2 # Center for icons/cards
                
            canvas.paste(sprite_scaled, (pos_x, pos_y), sprite_scaled)
            
            frame_path = os.path.join(out_dir, f"{prefix}_{frame_idx:02d}.png")
            canvas.save(frame_path)
            sliced_frames.append(canvas)
            frame_idx += 1
            
    # Build consolidated Texture Atlas
    atlas_w = cols * target_size[0]
    atlas_h = rows * target_size[1]
    atlas = Image.new("RGBA", (atlas_w, atlas_h), (0, 0, 0, 0))
    for i, fr in enumerate(sliced_frames):
        r = i // cols
        c = i % cols
        atlas.paste(fr, (c * target_size[0], r * target_size[1]))
        
    atlas_path = os.path.join("assets/atlas", f"{prefix}_atlas.png")
    atlas.save(atlas_path)
    print(f"Generated {len(sliced_frames)} frames and atlas: {atlas_path}")
    return sliced_frames

# 1. Process Player (image.png: 4 cols x 2 rows = 8 frames)
slice_grid(
    "assets/new_asset/image.png",
    rows=2, cols=4,
    out_dir="assets/textures/player",
    prefix="player",
    target_size=(128, 128),
    align_bottom=True
)

# 2. Process Enemies (image copy.png: 4 cols x 2 rows = 8 frames)
# Row 0: Skeleton 1-4, Row 1: Bat 1-4
slice_grid(
    "assets/new_asset/image copy.png",
    rows=2, cols=4,
    out_dir="assets/textures/enemies",
    prefix="enemy",
    target_size=(128, 128),
    align_bottom=True
)

# 3. Process Boss & Crystal (image copy 2.png: 3 cols x 2 rows = 6 frames)
slice_grid(
    "assets/new_asset/image copy 2.png",
    rows=2, cols=3,
    out_dir="assets/textures/boss",
    prefix="boss",
    target_size=(256, 256),
    align_bottom=True
)

# 4. Process Draft Cards (image copy 3.png: 3 cols x 2 rows = 6 cards)
slice_grid(
    "assets/new_asset/image copy 3.png",
    rows=2, cols=3,
    out_dir="assets/textures/cards",
    prefix="card",
    target_size=(340, 500),
    align_bottom=False
)

# 5. Process Projectiles & HUD (image copy 4.png: 4 cols x 2 rows = 8 items)
slice_grid(
    "assets/new_asset/image copy 4.png",
    rows=2, cols=4,
    out_dir="assets/textures/projectiles",
    prefix="prop",
    target_size=(96, 96),
    align_bottom=False
)

print("All new textures sliced and consolidated into Atlases successfully!")
