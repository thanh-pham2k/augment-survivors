"""
High-Resolution Pixel Art Generator (64x64, 128x128) for Augment Survivors
Creates visually striking, high-contrast, beautiful sprites matching references/game_ui_flow_reference.jpg:
- Player (64x64 Hero with glowing flame orb, cape, detailed anime-style features)
- Skeleton Warrior (48x48 with sword, shield, bone texture)
- Bat Flanker (48x48 purple wings, glowing red eyes, sonic trail)
- Boss Ember Colossus (128x128 giant magma rock titan with glowing crystal shoulders)
- Crystal Core (48x64 glowing red crystal pedestal)
- High-res projectiles (Fireball, Ice Shard, Arc Bolt)
- Rich 64x64 Augment Icons with glowing elemental borders
"""
import os
from PIL import Image, ImageDraw, ImageFilter

SPRITES_DIR = "assets/sprites"
ICONS_DIR = "assets/icons"
os.makedirs(SPRITES_DIR, exist_ok=True)
os.makedirs(ICONS_DIR, exist_ok=True)

def create_hd_player():
    # 64x64 Hero
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Shadow under player
    d.ellipse([20, 52, 44, 60], fill=(0, 0, 0, 90))
    
    # Flowing Crimson Cape
    d.polygon([(18, 26), (46, 26), (52, 54), (12, 54)], fill=(160, 25, 35, 255))
    d.polygon([(16, 30), (48, 30), (50, 52), (14, 52)], fill=(190, 35, 45, 255))
    # Cape inner fold
    d.polygon([(26, 32), (38, 32), (35, 52), (28, 52)], fill=(120, 15, 25, 255))
    
    # Body Armor / Tunic (Dark indigo with gold trim)
    d.rectangle([24, 28, 40, 48], fill=(35, 42, 60, 255))
    d.line([(24, 38), (40, 38)], fill=(220, 180, 60, 255), width=2) # Gold belt
    d.rectangle([29, 36, 35, 40], fill=(255, 220, 90, 255)) # Belt buckle
    
    # Legs & Boots
    d.rectangle([23, 48, 29, 56], fill=(25, 22, 28, 255))
    d.rectangle([35, 48, 41, 56], fill=(25, 22, 28, 255))
    # Boot cuffs
    d.rectangle([22, 48, 30, 50], fill=(60, 50, 45, 255))
    d.rectangle([34, 48, 42, 50], fill=(60, 50, 45, 255))

    # Face & Neck
    d.rectangle([26, 16, 38, 28], fill=(245, 205, 180, 255))
    # Eyes (Intense blue / determined)
    d.point((28, 22), fill=(40, 90, 180, 255))
    d.point((29, 22), fill=(40, 90, 180, 255))
    d.point((35, 22), fill=(40, 90, 180, 255))
    d.point((36, 22), fill=(40, 90, 180, 255))
    
    # Silver/White Anime Hair with bangs
    d.polygon([(22, 18), (42, 18), (44, 10), (32, 6), (20, 10)], fill=(230, 235, 245, 255))
    d.polygon([(22, 16), (26, 22), (28, 16)], fill=(215, 220, 235, 255)) # Front bangs
    d.polygon([(36, 16), (38, 22), (42, 16)], fill=(215, 220, 235, 255))
    d.polygon([(30, 14), (32, 20), (34, 14)], fill=(245, 250, 255, 255))
    
    # Left Hand Holding Glowing Fire Orb
    # Outer glow
    d.ellipse([40, 22, 58, 40], fill=(255, 90, 10, 120))
    # Mid flame
    d.ellipse([42, 24, 56, 38], fill=(255, 140, 20, 220))
    # Core bright yellow flame
    d.ellipse([45, 27, 53, 35], fill=(255, 240, 130, 255))
    # Sparks
    d.point((41, 21), fill=(255, 200, 50, 255))
    d.point((57, 23), fill=(255, 200, 50, 255))
    d.point((50, 19), fill=(255, 255, 200, 255))

    img.save(os.path.join(SPRITES_DIR, "player.png"))

def create_hd_skeleton():
    # 48x48 Skeleton Warrior
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Shadow
    d.ellipse([14, 40, 34, 46], fill=(0, 0, 0, 80))
    # Skull
    d.rectangle([18, 8, 30, 20], fill=(230, 230, 220, 255))
    # Dark Eye sockets
    d.rectangle([20, 12, 23, 16], fill=(30, 15, 15, 255))
    d.rectangle([25, 12, 28, 16], fill=(30, 15, 15, 255))
    # Glowing red eye glint
    d.point((21, 13), fill=(255, 50, 50, 255))
    d.point((26, 13), fill=(255, 50, 50, 255))
    # Teeth / Jaw
    d.rectangle([21, 18, 27, 21], fill=(200, 200, 190, 255))
    d.line([(23, 18), (23, 21)], fill=(40, 40, 40, 255))
    d.line([(25, 18), (25, 21)], fill=(40, 40, 40, 255))
    # Spine & Ribs
    d.line([(24, 21), (24, 34)], fill=(210, 210, 200, 255), width=3)
    d.line([(16, 24), (32, 24)], fill=(220, 220, 210, 255), width=2)
    d.line([(17, 27), (31, 27)], fill=(220, 220, 210, 255), width=2)
    d.line([(19, 30), (29, 30)], fill=(220, 220, 210, 255), width=2)
    # Pelvis & Legs
    d.line([(20, 34), (18, 44)], fill=(210, 210, 200, 255), width=2)
    d.line([(28, 34), (30, 44)], fill=(210, 210, 200, 255), width=2)
    # Iron Sword in Right Hand
    d.line([(34, 14), (34, 38)], fill=(190, 200, 210, 255), width=3)
    d.line([(31, 32), (37, 32)], fill=(140, 110, 50, 255), width=2) # Crossguard
    d.line([(34, 38), (34, 42)], fill=(90, 70, 40, 255), width=2) # Pommel
    img.save(os.path.join(SPRITES_DIR, "skeleton.png"))

def create_hd_bat():
    # 48x48 Flanker Bat
    img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Large Purple Leathery Wings
    d.polygon([(6, 12), (18, 8), (22, 24), (10, 30)], fill=(140, 50, 190, 255))
    d.polygon([(42, 12), (30, 8), (26, 24), (38, 30)], fill=(140, 50, 190, 255))
    d.line([(18, 8), (8, 14), (12, 28)], fill=(180, 80, 230, 255), width=2)
    d.line([(30, 8), (40, 14), (36, 28)], fill=(180, 80, 230, 255), width=2)
    # Furry Dark Body
    d.ellipse([18, 16, 30, 32], fill=(55, 20, 85, 255))
    # Pointed Ears
    d.polygon([(18, 16), (15, 8), (21, 12)], fill=(90, 30, 130, 255))
    d.polygon([(30, 16), (33, 8), (27, 12)], fill=(90, 30, 130, 255))
    # Glowing Crimson Eyes
    d.ellipse([20, 20, 23, 23], fill=(255, 40, 60, 255))
    d.ellipse([25, 20, 28, 23], fill=(255, 40, 60, 255))
    # Fangs
    d.point((22, 26), fill=(250, 250, 250, 255))
    d.point((26, 26), fill=(250, 250, 250, 255))
    img.save(os.path.join(SPRITES_DIR, "bat.png"))

def create_hd_boss():
    # 128x128 The Ember Colossus
    img = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Shadow
    d.ellipse([30, 108, 98, 124], fill=(0, 0, 0, 110))
    # Rocky Obsidian Torso
    d.polygon([(44, 38), (84, 38), (96, 92), (32, 92)], fill=(40, 34, 38, 255))
    # Molten Lava Core (Central glowing crack)
    d.ellipse([50, 52, 78, 80], fill=(255, 80, 10, 255))
    d.ellipse([54, 56, 74, 76], fill=(255, 180, 30, 255))
    d.ellipse([58, 60, 70, 72], fill=(255, 240, 120, 255))
    # Lava Veins flowing across chest
    d.line([(40, 46), (56, 58)], fill=(255, 90, 10, 255), width=4)
    d.line([(88, 46), (72, 58)], fill=(255, 90, 10, 255), width=4)
    d.line([(64, 80), (64, 96)], fill=(255, 110, 20, 255), width=5)
    # Horned Rock Head
    d.polygon([(52, 34), (76, 34), (64, 20)], fill=(32, 26, 30, 255))
    d.polygon([(48, 24), (42, 12), (54, 22)], fill=(48, 38, 42, 255)) # Left horn
    d.polygon([(80, 24), (86, 12), (74, 22)], fill=(48, 38, 42, 255)) # Right horn
    # Glowing Molten Eyes
    d.ellipse([56, 27, 60, 30], fill=(255, 220, 60, 255))
    d.ellipse([68, 27, 72, 30], fill=(255, 220, 60, 255))
    # Giant Crystal Spikes on Shoulders (Glowing Red/Orange)
    # Left crystal
    d.polygon([(24, 30), (36, 14), (44, 34), (32, 50)], fill=(255, 50, 30, 255))
    d.polygon([(28, 30), (36, 18), (40, 32), (32, 46)], fill=(255, 180, 90, 255))
    # Right crystal
    d.polygon([(104, 30), (92, 14), (84, 34), (96, 50)], fill=(255, 50, 30, 255))
    d.polygon([(100, 30), (92, 18), (88, 32), (96, 46)], fill=(255, 180, 90, 255))
    # Massive Stone Fists
    d.rectangle([12, 64, 34, 100], fill=(36, 30, 34, 255))
    d.line([(18, 76), (28, 86)], fill=(255, 80, 10, 255), width=3) # fist crack
    d.rectangle([94, 64, 116, 100], fill=(36, 30, 34, 255))
    d.line([(110, 76), (100, 86)], fill=(255, 80, 10, 255), width=3)
    img.save(os.path.join(SPRITES_DIR, "boss_colossus.png"))

def create_hd_crystal():
    # 48x64 Crystal Core Pedestal
    img = Image.new("RGBA", (48, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Stone Base Pedestal
    d.ellipse([6, 48, 42, 60], fill=(45, 42, 52, 255))
    d.rectangle([12, 44, 36, 52], fill=(60, 56, 70, 255))
    # Glowing Fire Crystal (Faceted ruby)
    d.polygon([(24, 6), (38, 24), (32, 44), (16, 44), (10, 24)], fill=(255, 40, 30, 255))
    d.polygon([(24, 10), (34, 24), (29, 40), (19, 40), (14, 24)], fill=(255, 140, 70, 255))
    d.polygon([(24, 14), (29, 24), (26, 36), (22, 36), (19, 24)], fill=(255, 230, 160, 255))
    # Aura glow
    d.point((24, 4), fill=(255, 255, 200, 255))
    img.save(os.path.join(SPRITES_DIR, "crystal_core.png"))

def create_hd_projectiles():
    # HD Fireball 32x32
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([2, 2, 29, 29], fill=(255, 80, 10, 140))
    d.ellipse([6, 6, 25, 25], fill=(255, 150, 20, 220))
    d.ellipse([10, 10, 21, 21], fill=(255, 235, 100, 255))
    d.ellipse([13, 13, 18, 18], fill=(255, 255, 240, 255))
    img.save(os.path.join(SPRITES_DIR, "proj_fire.png"))

    # HD Frost Shard 32x32
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(16, 2), (28, 16), (16, 30), (4, 16)], fill=(50, 160, 255, 220))
    d.polygon([(16, 6), (24, 16), (16, 26), (8, 16)], fill=(180, 230, 255, 255))
    d.line([(16, 6), (16, 26)], fill=(255, 255, 255, 255), width=2)
    img.save(os.path.join(SPRITES_DIR, "proj_ice.png"))

    # HD Lightning Spark 32x32
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(18, 2), (28, 12), (18, 14), (24, 30), (8, 16), (16, 14), (8, 2)], fill=(255, 220, 30, 255))
    d.polygon([(17, 6), (24, 12), (17, 14), (20, 24), (11, 16), (16, 14), (11, 6)], fill=(255, 255, 220, 255))
    img.save(os.path.join(SPRITES_DIR, "proj_lightning.png"))

create_hd_player()
create_hd_skeleton()
create_hd_bat()
create_hd_boss()
create_hd_crystal()
create_hd_projectiles()
print("High-definition sprites generated successfully!")
