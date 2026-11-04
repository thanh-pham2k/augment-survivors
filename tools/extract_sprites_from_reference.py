"""
Extract transparent game sprites directly from reference image panels:
- player.png
- skeleton.png
- bat.png
- boss_colossus.png
- crystal_core.png
- proj_fire.png
"""
from PIL import Image, ImageDraw

def make_transparent(img, bg_color_sample, tolerance=35):
    img = img.convert("RGBA")
    data = img.getdata()
    new_data = []
    sr, sg, sb = bg_color_sample[:3]
    for item in data:
        r, g, b, a = item
        # Calculate color difference to floor background
        dist = ((r - sr)**2 + (g - sg)**2 + (b - sb)**2)**0.5
        if dist < tolerance:
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append((r, g, b, 255))
    img.putdata(new_data)
    return img

p2 = Image.open('assets/sprites/panel_2_early_gameplay.png')
# Floor color sample near center
floor_color = p2.getpixel((145, 145))

# 1. Player: crop from panel 2 (154, 134, 180, 168)
p_crop = p2.crop((153, 134, 178, 166))
p_clean = make_transparent(p_crop, floor_color, 45)
p_clean = p_clean.resize((50, 64), Image.Resampling.NEAREST)
p_clean.save('assets/sprites/player.png')

# 2. Skeleton: crop from panel 2 (180, 92, 202, 118)
skel_crop = p2.crop((180, 92, 202, 118))
skel_clean = make_transparent(skel_crop, floor_color, 45)
skel_clean = skel_clean.resize((44, 52), Image.Resampling.NEAREST)
skel_clean.save('assets/sprites/skeleton.png')

# 3. Bat: crop from panel 2 (135, 192, 155, 212)
bat_crop = p2.crop((135, 192, 155, 212))
bat_clean = make_transparent(bat_crop, floor_color, 40)
bat_clean = bat_clean.resize((48, 48), Image.Resampling.NEAREST)
bat_clean.save('assets/sprites/bat.png')

# 4. Boss Colossus: crop from panel 5 (174, 90, 298, 222)
p5 = Image.open('assets/sprites/panel_5_boss_fight.png')
boss_floor = p5.getpixel((200, 230))
boss_crop = p5.crop((174, 90, 298, 222))
boss_clean = make_transparent(boss_crop, boss_floor, 40)
boss_clean = boss_clean.resize((150, 160), Image.Resampling.NEAREST)
boss_clean.save('assets/sprites/boss_colossus.png')

# 5. Crystal Core: crop from panel 5 (142, 118, 164, 158)
c_crop = p5.crop((142, 118, 164, 158))
c_clean = make_transparent(c_crop, boss_floor, 40)
c_clean = c_clean.resize((44, 80), Image.Resampling.NEAREST)
c_clean.save('assets/sprites/crystal_core.png')

# 6. Fire Projectile: crop 3-way fan bullet from panel 2 (198, 140, 215, 155)
proj_crop = p2.crop((198, 140, 215, 155))
proj_clean = make_transparent(proj_crop, floor_color, 45)
proj_clean = proj_clean.resize((32, 28), Image.Resampling.NEAREST)
proj_clean.save('assets/sprites/proj_fire.png')

print("All reference entities extracted and converted to sprites with alpha!")
