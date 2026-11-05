# Batch 05 — Rương Báu & Trang Bị Cổ Vật (Loot, Relics & Chests)

> **Mã hạng mục trong Inventory**: `AS-082` ➔ `AS-101`  
> **Độ ưu tiên**: **P1 (Cực kỳ quan trọng cho vòng lặp Loot & Trang Bị)**  
> **Tên file khi lưu để thả vào incoming**: `batch_05_loot_and_equipment.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Kích thước Icon trang bị / Cổ vật**: Khung vuông tỷ lệ 1:1 (khuyến nghị 256×256 master downscale 128×128 hoặc 64×64).
* **Rương báu**: Isometric 2.5D, góc nhìn từ trên xuống, kích thước ~128×128 pixel.
* **Phong cách**: Fantasy RPG Loot Art (tương tự *Hades*, *Diablo*, *Brotato*), họa tiết chạm khắc viền vàng/bạc/đá quý, ánh sáng nội tại lung linh.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen).

---

## 📝 Prompt 5A: Bộ 6 Cổ Vật Relic & 3 Bộ Áo Giáp Armor (Relic & Armor Icons)

Bao gồm trọn bộ 6 Relics thay đổi lối chơi và 3 Áo giáp phòng ngự:

```text
Game UI sprite sheet, 9 fantasy RPG equipment item icons inside ornate square gothic borders, 2D game assets. Row 1: 3 Relics - (1) Ember Crown (radiant golden circlet set with burning flame rubies and rising fire embers), (2) Vampire Ring (antique silver skull band set with glowing blood-red gem teardrop), (3) Frost Armor Amulet (chiseled sapphire snowflake talisman encased in solid ice). Row 2: 3 Relics - (4) Berserker Gloves (spiked black iron gauntlets wrapped in crimson rage chains), (5) Arc Capacitor (steampunk lightning coil battery sparking with blue electricity), (6) Cursed Hourglass (twisted obsidian hourglass filled with glowing purple spectral sand). Row 3: 3 Armors - (7) Ember Mantle (heavy crimson battle cuirass with glowing magma seams), (8) Glacial Plate (crystallized translucent ice breastplate with sharp frost pauldrons), (9) Shadowguard Armor (deep purple velvet and dark iron assassin mail). Pure solid green background #00FF00, aligned grid spacing, high resolution pixel art, rich vibrant textures --ar 1:1
```

* **Negative Prompt**:
  `photo, 3D render, modern items, sci-fi guns, text, words, watermark, blurry details, uneven icon borders`

---

## 📝 Prompt 5B: Rương Báu, Đồng Vàng Xoay & Cột Sáng Phẩm Cấp (Chests, Coins & Loot Beams)

Bao gồm Rương Tinh Anh (Elite Chest), Rương Boss Vàng Kim, Chuỗi frame xoay tiền vàng 🪙, Bình máu và 4 Cột sáng phẩm cấp (Common Trắng, Rare Lam, Epic Tím, Legendary Vàng):

```text
Game sprite sheet, fantasy loot and chest assets for 2D roguelite. Row 1: Elite Wooden & Iron Chest (closed state, creaking open state, wide open state revealing glowing purple interior treasure). Row 2: Boss Ornate Golden Chest (luxurious gilded chest with lion crest, closed, glowing open with erupting golden light rays). Row 3: 6 frames spinning 3D gold coin animation loop and 1 crimson red potion health flask. Row 4: 4 vertical light beams of item rarity (Common pure white beam, Rare bright cyan beam, Epic royal violet beam, Legendary dazzling golden pillar of light with floating stars). Solid green background #00FF00, clear spacing, crisp outlines, high visual polish --ar 16:9
```

* **Negative Prompt**:
  `realistic photo, blurry glow, text, numbers, watermark, floor textures, characters, monsters`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_05_relics_and_armors.png`
   - `batch_05_chests_and_coins.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ tự động bóc tách thành các icon trang bị, đăng ký vào `data/relics/` và `data/armors/`, đồng thời nối rương rơi từ quái Elite vào `gameplay_stage.gd`!
