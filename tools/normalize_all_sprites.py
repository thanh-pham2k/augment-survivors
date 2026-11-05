import glob, os
from PIL import Image

def normalize_dir(pattern, target_w, target_h, fit_h, ground_y=None, center_y=False):
    files = sorted(glob.glob(pattern))
    for f in files:
        im = Image.open(f)
        w, h = im.size
        scale = fit_h / float(h)
        new_w = max(1, int(w * scale))
        new_h = fit_h
        resized = im.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
        canvas = Image.new('RGBA', (target_w, target_h), (0, 0, 0, 0))
        paste_x = (target_w - new_w) // 2
        if center_y:
            paste_y = (target_h - new_h) // 2
        else:
            paste_y = ground_y - new_h
        canvas.paste(resized, (paste_x, paste_y), resized)
        canvas.save(f, format="PNG")
        print(f"Normalized {f} -> {target_w}x{target_h}")

print("Normalizing Player...")
normalize_dir("assets/final_sprites/player/*.png", target_w=128, target_h=128, fit_h=74, ground_y=112)

print("Normalizing Skeleton...")
normalize_dir("assets/final_sprites/skeleton/*.png", target_w=128, target_h=128, fit_h=70, ground_y=112)

print("Normalizing Bat...")
normalize_dir("assets/final_sprites/bat/*.png", target_w=128, target_h=128, fit_h=52, center_y=True)

print("Normalizing Boss...")
normalize_dir("assets/final_sprites/boss/*.png", target_w=256, target_h=256, fit_h=160, ground_y=226)

print("ALL SPRITES NORMALIZED WITH GROUND PIVOT LOCK!")
