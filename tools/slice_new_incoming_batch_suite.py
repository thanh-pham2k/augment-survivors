import os
import numpy as np
from PIL import Image

INCOMING_DIR = 'assets/incoming'
UI_DIR = 'assets/sprites/ui'
EQUIP_DIR = 'assets/sprites/equipment'
WEAPONS_DIR = 'assets/sprites/weapons'
CHESTS_DIR = 'assets/sprites/chests'

os.makedirs(UI_DIR, exist_ok=True)
os.makedirs(EQUIP_DIR, exist_ok=True)
os.makedirs(WEAPONS_DIR, exist_ok=True)
os.makedirs(CHESTS_DIR, exist_ok=True)

def remove_green_screen(img, green_thresh=160, rb_max=120):
    arr = np.array(img.convert('RGB'))
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    
    # Green screen detection
    # Strong green mask
    is_green = (g > green_thresh) & (r < rb_max) & (b < rb_max)
    # Spill reduction: where green is noticeably higher than avg(r, b)
    avg_rb = (r.astype(float) + b.astype(float)) / 2.0
    spill = np.clip((g.astype(float) - avg_rb) / 80.0, 0.0, 1.0)
    
    alpha = np.where(is_green, 0, 255).astype(np.uint8)
    # Despill: clamp green channel to avg_rb where spill occurs
    despilled_g = np.where(spill > 0, np.minimum(g, avg_rb + 15), g).astype(np.uint8)
    
    rgba = np.dstack([r, despilled_g, b, alpha])
    return Image.fromarray(rgba, 'RGBA')

def get_tight_bbox(img_rgba):
    arr = np.array(img_rgba)
    alpha = arr[:, :, 3]
    active_y, active_x = np.where(alpha > 10)
    if len(active_y) == 0:
        return (0, 0, img_rgba.width, img_rgba.height)
    return (int(active_x.min()), int(active_y.min()), int(active_x.max()), int(active_y.max()))

# 1. Process image.png -> 3 Map Tarot Cards
p0 = os.path.join(INCOMING_DIR, 'image.png')
if os.path.exists(p0):
    print('[PROCESSING] image.png -> Map Tarot Cards')
    raw0 = Image.open(p0)
    clean0 = remove_green_screen(raw0)
    
    # 3 columns:
    # Card 1: x=70..645, y=13..818
    # Card 2: x=671..1215, y=13..818
    # Card 3: x=1251..1815, y=13..818
    card_cathedral = clean0.crop((70, 13, 645, 818))
    card_magma = clean0.crop((671, 13, 1215, 818))
    card_frost = clean0.crop((1251, 13, 1815, 818))
    
    card_cathedral.save(os.path.join(UI_DIR, 'map_card_cathedral.png'))
    card_magma.save(os.path.join(UI_DIR, 'map_card_magma.png'))
    card_frost.save(os.path.join(UI_DIR, 'map_card_frost.png'))
    print('  ✓ Saved map_card_cathedral.png, map_card_magma.png, map_card_frost.png')

# 2. Process image copy.png -> Blacksmith, Armory Frames & Badges
p1 = os.path.join(INCOMING_DIR, 'image copy.png')
if os.path.exists(p1):
    print('[PROCESSING] image copy.png -> Blacksmith, Slot Frames & Meta Badges')
    raw1 = Image.open(p1)
    clean1 = remove_green_screen(raw1)
    
    # Row 0:
    # Item 0: Dwarf Blacksmith portrait x=10..537, y=31..550
    # Item 1: Weapon Frame x=551..915, y=31..550
    # Item 2: Armor Frame x=926..1274, y=31..550
    # Item 3: Relic Frame x=1291..1661, y=31..550
    dwarf = clean1.crop((10, 31, 537, 550))
    w_frame = clean1.crop((551, 31, 915, 550))
    a_frame = clean1.crop((926, 31, 1274, 550))
    r_frame = clean1.crop((1291, 31, 1661, 550))
    
    dwarf.save(os.path.join(UI_DIR, 'portrait_blacksmith.png'))
    w_frame.save(os.path.join(UI_DIR, 'frame_weapon_slot.png'))
    a_frame.save(os.path.join(UI_DIR, 'frame_armor_slot.png'))
    r_frame.save(os.path.join(UI_DIR, 'frame_relic_slot.png'))
    
    # Row 1: 5 Badges
    # y=580..904
    # Item 0: Max HP badge x=50..351
    # Item 1: Move Speed badge x=374..669
    # Item 2: Dash Cooldown badge x=685..980
    # Item 3: Magnet Radius badge x=999..1293
    # Item 4: Rerolls badge x=1315..1611
    b_hp = clean1.crop((50, 580, 351, 904))
    b_spd = clean1.crop((374, 580, 669, 904))
    b_dash = clean1.crop((685, 580, 980, 904))
    b_mag = clean1.crop((999, 580, 1293, 904))
    b_reroll = clean1.crop((1315, 580, 1611, 904))
    
    b_hp.save(os.path.join(UI_DIR, 'badge_max_hp.png'))
    b_spd.save(os.path.join(UI_DIR, 'badge_move_speed.png'))
    b_dash.save(os.path.join(UI_DIR, 'badge_dash_cooldown.png'))
    b_mag.save(os.path.join(UI_DIR, 'badge_magnet_radius.png'))
    b_reroll.save(os.path.join(UI_DIR, 'badge_rerolls.png'))
    print('  ✓ Saved portrait_blacksmith.png, 3 slot frames, and 5 meta badges')

# 3. Process image copy 4.png -> Chests & Loot
p4 = os.path.join(INCOMING_DIR, 'image copy 4.png')
if os.path.exists(p4):
    print('[PROCESSING] image copy 4.png -> Chests & Loot')
    raw4 = Image.open(p4)
    clean4 = remove_green_screen(raw4)
    # Row 0: 3 chests
    chest_wood = clean4.crop((246, 9, 572, 241))
    chest_silver = clean4.crop((673, 9, 985, 241))
    chest_gold = clean4.crop((1084, 9, 1397, 241))
    
    chest_wood.save(os.path.join(CHESTS_DIR, 'chest_wooden.png'))
    chest_silver.save(os.path.join(CHESTS_DIR, 'chest_silver.png'))
    chest_gold.save(os.path.join(CHESTS_DIR, 'chest_gold.png'))
    print('  ✓ Saved chest_wooden.png, chest_silver.png, chest_gold.png')

print('[COMPLETE] All new generated incoming assets cleanly sliced and deployed!')
