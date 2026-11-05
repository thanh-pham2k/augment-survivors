from PIL import Image
import numpy as np

def remove_chroma(img, green_thresh=130, ratio=1.20):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    return Image.fromarray(arr.astype(np.uint8))

def crop_tight_alpha(img, pad=3):
    arr = np.array(img)
    alpha = arr[:, :, 3] > 10
    if not np.any(alpha):
        return img
    y_indices, x_indices = np.where(alpha)
    y_min, y_max = max(0, y_indices.min() - pad), min(img.height, y_indices.max() + pad + 1)
    x_min, x_max = max(0, x_indices.min() - pad), min(img.width, x_indices.max() + pad + 1)
    return img.crop((x_min, y_min, x_max, y_max))

print("=== Processing Main Menu Assets ===")

# 1. Background
bg = Image.open('assets/incoming/batch_08_main_menu_background.png')
bg_1080 = bg.resize((1920, 1080), Image.Resampling.LANCZOS)
bg_1080.save('assets/sprites/menu_background.png', format='PNG')
print(f"Saved assets/sprites/menu_background.png: {bg_1080.size}")

# 2. Logo & Buttons
ui_img = Image.open('assets/incoming/batch_09_menu_ui_buttons.png')
ui_clean = remove_chroma(ui_img)

boxes = [
    ("menu_logo.png", (21, 10, 1176, 510)),
    ("btn_start_run.png", (134, 527, 1065, 721)),
    ("btn_continue.png", (144, 725, 1055, 901)),
    ("btn_codex.png", (144, 906, 1055, 1082)),
    ("btn_settings.png", (144, 1088, 1055, 1264))
]

for name, box in boxes:
    cropped = crop_tight_alpha(ui_clean.crop(box))
    cropped.save(f"assets/sprites/{name}", format="PNG")
    print(f"Saved assets/sprites/{name}: {cropped.size}")

print("=== Menu Assets Processed Successfully ===")
