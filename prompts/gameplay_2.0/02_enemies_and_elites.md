# Batch 02 — Quái Vật Thường & Quái Tinh Anh (Enemies & Elites)

> **Mã hạng mục trong Inventory**: `AS-013` ➔ `AS-042`  
> **Độ ưu tiên**: **P0 (Hurt/Death quái thường) & P1 (Ice Wraith + 2 Quái Tinh Anh)**  
> **Tên file khi lưu để thả vào incoming**: `batch_02_enemies_and_elites.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Góc nhìn**: Isometric 2.5D Top-Down, hướng nhìn chếch góc 45 độ xuống sàn.
* **Quy cách kích thước**:
  * Quái thường: Chiều cao ~64-80px.
  * Quái Tinh Anh (Elite): To gấp 1.5 lần (~120-140px), có giáp trụ và vũ khí đặc trưng.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen) để bóc tách Chroma Key tự động.

---

## 📝 Prompt 2A: Quái Mới Ice Wraith & Hoạt Họa Tử Trận 4 Quái Cũ (Common Hurt/Death & Ice Wraith)

Bao gồm quái Băng giá mới và trọn bộ hoạt họa tan biến tử trận cho Skeleton, Dơi, Pháp Sư và Quái Nổ:

```text
Game sprite sheet, fantasy enemy death and ice monster animations, 2D pixel art game assets. Row 1: Ice Wraith monster (ethereal glowing cyan frost phantom, horned frozen skull, ragged icy shroud) with 4 frames hovering forward and 4 frames casting ice shard spell. Row 2: 4 frames Skeleton Warrior hurt and shattering into pile of scattered dry bones. Row 3: 4 frames Shadow Bat struck by hit and dissolving into purple shadow smoke puff. Row 4: 4 frames Dark Mage Cultist dying, collapsing into swirling black void robes. Row 5: 4 frames Flame Exploder exploding outward into expanding fiery blast debris. Pure solid green background #00FF00, clear grid rows and columns, crisp pixel borders, high resolution --ar 16:9
```

* **Negative Prompt**:
  `photorealistic, 3D render, text, labels, watermark, gradient floor, messy particles overlapping cells, blurry silhouettes`

---

## 📝 Prompt 2B: Hai Quái Tinh Anh & Hào Quang Thủ Lĩnh (Elite Champions Sheet)

Dành cho 2 thủ lĩnh Tinh Anh (Elite Bone Captain & Elite Infernal Arcanist) với bộ giáp hầm hố và cổng triệu hồi:

```text
Game sprite sheet, 2 elite champion mini-boss monsters and elite effects, dark fantasy 2D pixel art. Top section: Elite Bone Captain (heavy corrupted gothic plate armor, spiked horned helmet, carrying massive two-handed executioner broadsword with purple runic glow) - 4 frames menacing heavy walk, 4 frames wide arc overhead sword slam, 4 frames death collapse. Middle section: Elite Infernal Arcanist (floating demonic sorcerer in ornate burning obsidian robes, holding flaming horned skull staff) - 4 frames levitating forward, 4 frames twin fireball blast cast, 4 frames fiery ash death. Bottom section: 6 frames ominous violet-black elite spawn vortex portal and glowing golden champion skull aura rings. Pure solid green background #00FF00, aligned grid spacing, crisp cel-shaded outlines --ar 16:9
```

* **Negative Prompt**:
  `low resolution, modern soldier, sci-fi, blurry edges, cut off weapons, text, watermark, background terrain, drop shadow baked into ground`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_02_enemy_deaths_ice_wraith.png`
   - `batch_02_elite_champions.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ bóc tách nền, đăng ký script AI cho `IceWraith` và `EliteEnemy` tương ứng.
