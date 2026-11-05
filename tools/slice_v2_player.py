"""
Process and slice the new v2 Anime Mage Spritesheet into clean, transparent animation frames
"""
from PIL import Image
import numpy as np

def remove_green_screen(img):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    # Pure green #00FF00
    is_green = (g > 110) & (g > r * 1.25) & (g > b * 1.25)
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    return Image.fromarray(arr.astype(np.uint8))

p_path = '/Users/thanhpv/.gemini/antigravity/brain/7223f6ad-dfcf-45f5-8120-52441d5cf9e1/mage_spritesheet_isometric_1793890528006.jpg'
p_img = Image.open(p_path)
p_trans = remove_green_screen(p_img)

w, h = p_trans.size
cols = 4
fw = w // cols

names = ["idle", "walk_1", "walk_2", "cast"]
for i in range(cols):
    cell = p_trans.crop((i * fw, 0, (i + 1) * fw, h))
    bbox = cell.getchannel('A').getbbox()
    if bbox:
        sprite = cell.crop(bbox)
        # Normalize height to 76px
        scale = 76.0 / sprite.height
        nw = max(1, int(sprite.width * scale))
        sprite = sprite.resize((nw, 76), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (84, 84), (0, 0, 0, 0))
        canvas.paste(sprite, ((84 - nw) // 2, 84 - 76))
        canvas.save(f'assets/player_anim/player_frame_{i}.png')
        if i == 0:
            canvas.save('assets/sprites/player.png')

print("New v2 high-res anime mage animation frames saved!")
