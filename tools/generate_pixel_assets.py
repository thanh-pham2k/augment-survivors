"""
Procedural Pixel Art Generator for Augment Survivors
Generates all essential sprites:
- Player (Hero with cape & fire orb)
- Skeleton Warrior (Swarm Chaser)
- Bat (Flanker)
- Boss (The Ember Colossus) & Crystal Cores
- Projectiles (Fireball, Frost shard, Lightning spark)
- Augment Icons (Ember Shot, Frostbite, Arc Bolt, Wildfire, Shatter, Overload, Catalyst, Close Quarters)
"""
import os
from PIL import Image, ImageDraw

SPRITES_DIR = "assets/sprites"
ICONS_DIR = "assets/icons"
os.makedirs(SPRITES_DIR, exist_ok=True)
os.makedirs(ICONS_DIR, exist_ok=True)

def create_player():
    # 32x32 Hero Sprite
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Cape (Dark Red / Crimson)
    d.rectangle([9, 12, 23, 27], fill=(160, 30, 40, 255))
    d.rectangle([8, 14, 24, 28], fill=(130, 20, 30, 255))
    # Body / Armor (Dark Blue / Leather)
    d.rectangle([12, 14, 20, 24], fill=(45, 55, 80, 255))
    # Head & Skin
    d.rectangle([13, 7, 19, 13], fill=(235, 190, 160, 255))
    # Hair (Silver / White anime style)
    d.polygon([(11, 7), (21, 7), (20, 4), (16, 3), (12, 4)], fill=(220, 225, 235, 255))
    d.rectangle([11, 6, 13, 9], fill=(200, 205, 220, 255))
    # Eyes
    d.point((14, 9), fill=(30, 40, 70, 255))
    d.point((18, 9), fill=(30, 40, 70, 255))
    # Fire Orb in hand
    d.ellipse([21, 14, 27, 20], fill=(255, 120, 20, 255))
    d.ellipse([23, 16, 25, 18], fill=(255, 230, 100, 255))
    # Boots
    d.rectangle([11, 25, 14, 29], fill=(30, 25, 30, 255))
    d.rectangle([18, 25, 21, 29], fill=(30, 25, 30, 255))
    img.save(os.path.join(SPRITES_DIR, "player.png"))

def create_skeleton():
    # 28x28 Skeleton Warrior
    img = Image.new("RGBA", (28, 28), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Skull
    d.rectangle([10, 5, 18, 12], fill=(225, 225, 215, 255))
    # Eyes (glowing dark/red)
    d.point((12, 8), fill=(40, 10, 10, 255))
    d.point((16, 8), fill=(40, 10, 10, 255))
    # Ribcage
    d.line([(14, 13), (14, 19)], fill=(200, 200, 190, 255), width=2)
    d.line([(10, 14), (18, 14)], fill=(210, 210, 200, 255), width=1)
    d.line([(11, 16), (17, 16)], fill=(210, 210, 200, 255), width=1)
    d.line([(12, 18), (16, 18)], fill=(210, 210, 200, 255), width=1)
    # Legs
    d.line([(12, 20), (11, 26)], fill=(210, 210, 200, 255), width=1)
    d.line([(16, 20), (17, 26)], fill=(210, 210, 200, 255), width=1)
    # Sword
    d.line([(20, 11), (20, 23)], fill=(180, 190, 200, 255), width=2)
    d.line([(18, 19), (22, 19)], fill=(120, 90, 40, 255), width=1)
    img.save(os.path.join(SPRITES_DIR, "skeleton.png"))

def create_bat():
    # 24x24 Purple Bat (Flanker)
    img = Image.new("RGBA", (24, 24), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Wings
    d.polygon([(2, 7), (8, 4), (11, 11), (5, 14)], fill=(140, 60, 190, 255))
    d.polygon([(22, 7), (16, 4), (13, 11), (19, 14)], fill=(140, 60, 190, 255))
    # Body
    d.ellipse([9, 8, 15, 16], fill=(70, 25, 110, 255))
    # Glowing Red Eyes
    d.point((10, 10), fill=(255, 60, 80, 255))
    d.point((14, 10), fill=(255, 60, 80, 255))
    # Ears
    d.polygon([(9, 8), (8, 5), (10, 6)], fill=(90, 30, 130, 255))
    d.polygon([(15, 8), (16, 5), (14, 6)], fill=(90, 30, 130, 255))
    img.save(os.path.join(SPRITES_DIR, "bat.png"))

def create_boss():
    # 64x64 The Ember Colossus
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Magma Rock Body (Dark obsidian / lava cracks)
    d.rectangle([16, 18, 48, 50], fill=(45, 38, 42, 255))
    # Magma Core & Cracks
    d.ellipse([24, 24, 40, 40], fill=(255, 100, 20, 255))
    d.ellipse([27, 27, 37, 37], fill=(255, 220, 70, 255))
    # Lava cracks
    d.line([(20, 22), (26, 26)], fill=(255, 80, 10, 255), width=2)
    d.line([(44, 22), (38, 26)], fill=(255, 80, 10, 255), width=2)
    d.line([(32, 40), (32, 48)], fill=(255, 90, 20, 255), width=3)
    # Crystal Cores on Shoulders
    d.polygon([(10, 14), (16, 8), (22, 14), (16, 22)], fill=(255, 60, 40, 255))
    d.polygon([(12, 14), (16, 10), (20, 14), (16, 20)], fill=(255, 200, 120, 255))
    d.polygon([(42, 14), (48, 8), (54, 14), (48, 22)], fill=(255, 60, 40, 255))
    d.polygon([(44, 14), (48, 10), (52, 14), (48, 20)], fill=(255, 200, 120, 255))
    # Head & Horns
    d.polygon([(26, 16), (38, 16), (32, 8)], fill=(30, 25, 30, 255))
    # Eyes
    d.point((29, 13), fill=(255, 240, 100, 255))
    d.point((35, 13), fill=(255, 240, 100, 255))
    # Giant Fist Fists
    d.rectangle([6, 32, 16, 48], fill=(38, 32, 35, 255))
    d.rectangle([48, 32, 58, 48], fill=(38, 32, 35, 255))
    img.save(os.path.join(SPRITES_DIR, "boss_colossus.png"))

def create_crystal():
    # 24x32 Breakable Crystal Core
    img = Image.new("RGBA", (24, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Base Pedestal
    d.ellipse([4, 24, 20, 30], fill=(60, 55, 65, 255))
    # Crystal Body
    d.polygon([(12, 2), (20, 14), (16, 26), (8, 26), (4, 14)], fill=(255, 50, 40, 255))
    d.polygon([(12, 6), (17, 14), (14, 24), (10, 24), (7, 14)], fill=(255, 160, 100, 255))
    d.polygon([(12, 8), (14, 14), (13, 22)], fill=(255, 240, 200, 255))
    img.save(os.path.join(SPRITES_DIR, "crystal_core.png"))

def create_projectiles():
    # Fireball 16x16
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([1, 1, 14, 14], fill=(255, 80, 20, 255))
    d.ellipse([3, 3, 12, 12], fill=(255, 180, 40, 255))
    d.ellipse([5, 5, 10, 10], fill=(255, 240, 180, 255))
    img.save(os.path.join(SPRITES_DIR, "proj_fire.png"))

    # Frost Shard 16x16
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(8, 1), (13, 8), (8, 15), (3, 8)], fill=(60, 180, 255, 255))
    d.polygon([(8, 3), (11, 8), (8, 13), (5, 8)], fill=(200, 240, 255, 255))
    img.save(os.path.join(SPRITES_DIR, "proj_ice.png"))

    # Lightning Bolt / Spark 16x16
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(9, 1), (14, 6), (9, 7), (12, 15), (4, 8), (8, 7), (4, 1)], fill=(255, 220, 40, 255))
    d.polygon([(8, 3), (11, 6), (8, 7), (10, 12), (6, 8), (8, 7)], fill=(255, 255, 200, 255))
    img.save(os.path.join(SPRITES_DIR, "proj_lightning.png"))

def create_augment_icons():
    # 8 Augment icons (48x48)
    icons = {
        "ember_shot": {"bg": (120, 30, 20), "symbol": "fire"},
        "wildfire": {"bg": (160, 40, 10), "symbol": "spread_fire"},
        "frostbite": {"bg": (20, 70, 140), "symbol": "ice"},
        "shatter": {"bg": (30, 100, 160), "symbol": "ice_break"},
        "arc_bolt": {"bg": (140, 120, 10), "symbol": "lightning"},
        "overload": {"bg": (160, 140, 20), "symbol": "electric_burst"},
        "reaction_catalyst": {"bg": (90, 40, 130), "symbol": "catalyst"},
        "close_quarters": {"bg": (120, 50, 50), "symbol": "daggers"}
    }
    
    for name, spec in icons.items():
        img = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
        d = ImageDraw.Draw(img)
        # Rounded background border
        d.rounded_rectangle([2, 2, 45, 45], radius=6, fill=spec["bg"], outline=(220, 200, 150), width=2)
        sym = spec["symbol"]
        if "fire" in sym:
            d.ellipse([14, 14, 34, 34], fill=(255, 100, 20, 255))
            d.ellipse([18, 18, 30, 30], fill=(255, 220, 60, 255))
        elif "ice" in sym:
            d.polygon([(24, 10), (34, 24), (24, 38), (14, 24)], fill=(120, 220, 255, 255))
            d.polygon([(24, 14), (30, 24), (24, 34), (18, 24)], fill=(230, 250, 255, 255))
        elif "lightning" in sym or "electric" in sym:
            d.polygon([(26, 8), (38, 20), (27, 22), (32, 40), (14, 24), (24, 22)], fill=(255, 230, 50, 255))
        elif sym == "catalyst":
            d.ellipse([16, 16, 32, 32], fill=(220, 90, 255, 255))
            d.ellipse([20, 20, 28, 28], fill=(255, 255, 255, 255))
        else: # daggers
            d.polygon([(12, 12), (36, 36)], outline=(240, 230, 200), width=4)
            d.polygon([(36, 12), (12, 36)], outline=(240, 230, 200), width=4)
        img.save(os.path.join(ICONS_DIR, f"{name}.png"))

create_player()
create_skeleton()
create_bat()
create_boss()
create_crystal()
create_projectiles()
create_augment_icons()
print("All pixel assets generated successfully!")
