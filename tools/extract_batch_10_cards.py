from PIL import Image
import numpy as np

def remove_chroma(img, green_thresh=130, ratio=1.20):
    img = img.convert("RGBA")
    arr = np.array(img, dtype=float)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    is_green = (g > green_thresh) & (g > r * ratio) & (g > b * ratio)
    arr[:, :, 3] = np.where(is_green, 0, 255).astype(np.uint8)
    return Image.fromarray(arr.astype(np.uint8))

def crop_tight_alpha(img, pad=2):
    arr = np.array(img)
    alpha = arr[:, :, 3] > 10
    if not np.any(alpha):
        return img
    y_indices, x_indices = np.where(alpha)
    y_min, y_max = max(0, y_indices.min() - pad), min(img.height, y_indices.max() + pad + 1)
    x_min, x_max = max(0, x_indices.min() - pad), min(img.width, x_indices.max() + pad + 1)
    return img.crop((x_min, y_min, x_max, y_max))

print("=== Extracting Batch 10 Cards ===")
img = Image.open('assets/incoming/batch_10_weapon_and_catalyst_cards.png')
clean = remove_chroma(img)

cards_meta = [
    ("card_reaction_catalyst.png", (29, 8, 405, 620)),
    ("card_overload.png", (410, 10, 787, 620)),
    ("card_shatter.png", (792, 10, 1170, 620)),
    ("card_close_quarters.png", (28, 622, 405, 1244)),
    ("card_multishot.png", (411, 622, 788, 1243)),
    ("card_wide_arc.png", (794, 622, 1170, 1243))
]

for name, box in cards_meta:
    card = crop_tight_alpha(clean.crop(box))
    card.save(f"assets/sprites/{name}", format="PNG")
    print(f"Saved assets/sprites/{name}: {card.size}")

print("=== All 6 Cards Extracted Successfully ===")
