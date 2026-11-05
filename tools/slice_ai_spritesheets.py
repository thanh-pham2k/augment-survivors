"""
Slice AI-generated green-screen spritesheets into clean, transparent PNG animation frames:
- Player (idle, walk, cast)
- Skeleton Warrior (walk 4 frames)
- Bat (fly 4 frames)
"""
from PIL import Image
import numpy as np

def remove_green_screen(img, green_hue_range=(45, 140), min_saturation=40, min_val=40):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    
    # Calculate green dominance
    # Pure green #00FF00 has g >> r and g >> b
    is_green = (g > 110) & (g > r * 1.25) & (g > b * 1.25)
    
    # Set alpha to 0 where green is detected
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    return Image.fromarray(arr.astype(np.uint8))

# 1. Process Player Spritesheet
p_path = '/Users/thanhpv/.gemini/antigravity/brain/7223f6ad-dfcf-45f5-8120-52441d5cf9e1/player_mage_isometric_spritesheet_1793889812280.jpg'
p_img = Image.open(p_path)
p_trans = remove_green_screen(p_img)

# Divide into 4 columns (frames)
w, h = p_trans.size
cols = 4
frame_w = w // cols

for i in range(cols):
    cell = p_trans.crop((i * frame_w, 0, (i + 1) * frame_w, h))
    bbox = cell.getchannel('A').getbbox()
    if bbox:
        sprite = cell.crop(bbox)
        # Resize to standard height 72px
        scale = 72.0 / sprite.height
        new_w = max(1, int(sprite.width * scale))
        sprite = sprite.resize((new_w, 72), Image.Resampling.LANCZOS)
        # Put on centered 80x80 canvas
        canvas = Image.new('RGBA', (80, 80), (0, 0, 0, 0))
        canvas.paste(sprite, ((80 - new_w) // 2, 80 - 72))
        canvas.save(f'assets/player_anim/player_frame_{i}.png')
        if i == 0:
            canvas.save('assets/sprites/player.png') # default idle

print("Player animation frames sliced successfully!")

# 2. Process Enemy Spritesheet
e_path = '/Users/thanhpv/.gemini/antigravity/brain/7223f6ad-dfcf-45f5-8120-52441d5cf9e1/enemy_spritesheet_1793889800225.jpg'
e_img = Image.open(e_path)
e_trans = remove_green_screen(e_img)

ew, eh = e_trans.size
# Top half: Skeleton, Bottom half: Bat
skel_row = e_trans.crop((0, 0, ew, eh // 2))
bat_row = e_trans.crop((0, eh // 2, ew, eh))

# Skeletons (4 frames)
skel_fw = ew // 4
for i in range(4):
    cell = skel_row.crop((i * skel_fw, 0, (i + 1) * skel_fw, eh // 2))
    bbox = cell.getchannel('A').getbbox()
    if bbox:
        sprite = cell.crop(bbox)
        scale = 56.0 / sprite.height
        new_w = max(1, int(sprite.width * scale))
        sprite = sprite.resize((new_w, 56), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
        canvas.paste(sprite, ((64 - new_w) // 2, 64 - 56))
        canvas.save(f'assets/enemy_anim/skel_frame_{i}.png')
        if i == 0:
            canvas.save('assets/sprites/skeleton.png')

# Bats (4 frames)
bat_fw = ew // 4
for i in range(4):
    cell = bat_row.crop((i * bat_fw, 0, (i + 1) * bat_fw, eh // 2))
    bbox = cell.getchannel('A').getbbox()
    if bbox:
        sprite = cell.crop(bbox)
        scale = 48.0 / sprite.height
        new_w = max(1, int(sprite.width * scale))
        sprite = sprite.resize((new_w, 48), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
        canvas.paste(sprite, ((64 - new_w) // 2, (64 - 48) // 2))
        canvas.save(f'assets/enemy_anim/bat_frame_{i}.png')
        if i == 0:
            canvas.save('assets/sprites/bat.png')

print("Enemy animation frames sliced successfully!")
