# Batch 06 — Tiến Hóa Vũ Khí & Khung Thẻ Lõi (Weapon Evolutions & Cards)

> **Mã hạng mục trong Inventory**: `AS-069` ➔ `AS-081` & `AS-102` ➔ `AS-122`  
> **Độ ưu tiên**: **P1 (Bước ngoặt tạo Build Identity độc nhất)**  
> **Tên file khi lưu để thả vào incoming**: `batch_06_weapon_evolutions.png`

---

## 🎯 Ý Nghĩa Gameplay Lõi
Khi vũ khí đạt **Lv.3**, người chơi được lựa chọn 1 trong 2 nhánh Tiến Hóa hoàn toàn mới:
* **Inferno Staff** $\rightarrow$ **Meteor Rain** (Mưa thiên thạch AoE dọn map) HOẶC **Hellfire Barrage** (Xả liên hoàn 7 hỏa tiễn dồn trùm).
* **Storm Gauntlet** $\rightarrow$ **Thunderstorm** (Bão sấm sét đánh từ trời) HOẶC **Voltaic Lance** (Tia lôi thương xuyên phá).
* **Glacial Spear** $\rightarrow$ **Frozen Tempest** (Cơn lốc tuyết giam giữ quái) HOẶC **Glacial Impaler** (Cọc băng gai khổng lồ trồi từ đất).

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Kích thước Icon tiến hóa**: Khung vuông tỷ lệ 1:1 viền vàng hoàng kim (Legendary Gold Frame).
* **Kích thước Khung thẻ bài**: Tỷ lệ chuẩn bài Tarot 2:3 (khuyên dùng 512×768 master), **hoàn toàn trống phần chữ** để Godot chèn text động đa ngôn ngữ.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen).

---

## 📝 Prompt 6A: 6 Biểu Tượng & Đạn Tiến Hóa Siêu Cấp (6 Weapon Evolutions Sheet)

Bao gồm trọn bộ 6 biểu tượng tiến hóa và hình thái đạn mới:

```text
Game sprite sheet, 6 advanced weapon evolution skills and ultimate projectiles for 2D roguelite action game. Row 1: 6 legendary skill icons inside ornate glowing diamond frames - (1) Meteor Rain (falling volcanic comet blazing across sky), (2) Hellfire Barrage (cluster of 7 fiery dragon missile heads), (3) Thunderstorm (dark storm vortex cloud with branching blue lightning strikes), (4) Voltaic Lance (hyper-dense plasma laser spear), (5) Frozen Tempest (spiral blizzard whirlwind with jagged ice shards), (6) Glacial Impaler (massive crystalline icicle stalagmite bursting from earth). Row 2: Combat projectile frames for Meteor Rain (comet impact explosion with magma splash) and Hellfire Barrage (rapid seeking flame jets). Row 3: Combat projectile frames for Thunderstorm (vertical lightning strikes) and Voltaic Lance (continuous piercing plasma beam). Row 4: Combat projectile frames for Frozen Tempest (spinning ice tornado) and Glacial Impaler (ground spike eruption). Solid green background #00FF00, aligned grid spacing, high dynamic range, crisp pixel art outlines --ar 16:9
```

* **Negative Prompt**:
  `photo, 3D render, modern weaponry, text, labels, watermark, blurry haze, unaligned grid cells`

---

## 📝 Prompt 6B: Khung Thẻ Bài Tarot Trống & Xúc Xắc Reroll (Blank Card Frames & Dice)

Bao gồm 4 Khung thẻ bài Tarot trống chữ phân theo phẩm cấp (Common Xám, Rare Lam, Legendary Vàng Kim, Synergy Đỏ Hỏa Ngục) kèm xúc xắc Reroll 3D:

```text
Game UI sprite sheet, 4 blank fantasy tarot card frames and dice icons for roguelite draft interface. Top row: 4 empty tarot card templates (aspect ratio 2:3, central art window and lower parchment text box completely blank without any text) - (1) Common bronze stone card frame, (2) Rare silver rune card frame with glowing cyan gems, (3) Legendary golden ornate card frame with majestic winged crest, (4) Synergy dual-element card frame wrapped in burning chains and crackling frost. Bottom row: 4 frames glowing golden D6 polyhedral dice rolling animation for per-card reroll mechanic, and 1 ornate ribbon banner reading "EVOLUTION AVAILABLE". Solid green background #00FF00, sharp borders, clean 2D game UI assets --ar 16:9
```

* **Negative Prompt**:
  `pre-written English words, pre-baked description text, messy layout, photographic, blurry borders, low resolution`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_06_weapon_evolutions.png`
   - `batch_06_blank_card_frames.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ cắt các biểu tượng tiến hóa gắn vào `WeaponData.gd`, đồng thời cập nhật `AugmentDraftUI` dùng khung thẻ động!
