# Batch 01 — Nhân Vật Chính Flame Mage (Player Core Animations)

> **Mã hạng mục trong Inventory**: `AS-001` ➔ `AS-012`  
> **Độ ưu tiên**: **P0 (Cốt lõi cho Vertical Slice)**  
> **Tên file khi lưu để thả vào incoming**: `batch_01_hero_animations.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Phong cách**: 2D Anime Dark Fantasy Pixel Art / High-res 2.5D Isometric Sprite, viền đen sắc nét (Crisp black outlines), đổ bóng cel-shading tương phản cao.
* **Tỷ lệ nhân vật**: Chiều cao khoảng 96-128 pixel, chân chạm cùng đường chân trời cố định (Ground Pivot Lock) tại đáy mỗi ô.
* **Màu sắc chủ đạo**: Áo choàng đỏ thẫm (Crimson Cape), giáp da thắt lưng nâu vàng, tóc trắng bạc vuốt nhọn (Spiky silver hair), găng tay phát sáng tàn lửa.
* **Quy cách nền**: Nền xanh lá cây chuẩn thuần sắc **`#00FF00`** (Pure Green Screen) để bóc tách Chroma Key tự động không bị lem màu.
* **Bố cục lưới**: Lưới đều đặn không cắt mép, khoảng cách giữa các ô tối thiểu 16px.

---

## 📝 Prompt 1A: Bảng Xoay 4 Hướng & Tử Trận (Turnaround & Death Sheet)

Dùng để hoàn thiện các góc nhìn chưa có và hoạt họa chết gục ngã tan biến:

```text
Game sprite sheet, anime flame mage character turnaround and death animation, high quality 2D game asset. Top row: 4 directional turnaround master poses (front facing, back facing, left profile, right 3/4 profile) wearing crimson hooded cape, silver hair, leather battle tunic with gold trims. Bottom row: 6 sequential death animation frames, collapsing to knees, dropping weapon, dissolving into glowing ember particles and dark ashes, fading away. Isolated on pure green background #00FF00, equal grid spacing, no shadows baked into floor, pixel art crisp edges, cel-shaded, 4k resolution --ar 16:9
```

* **Negative Prompt**:
  `text, typography, watermark, blurry, photographic, realistic skin, 3D CGI render, floor tiles, background scenery, uneven spacing, cropped limbs`

---

## 📝 Prompt 1B: Chiến Thắng, Nhặt Đồ & Khung Chân Dung (Victory, Interact & Portrait)

Bao gồm hoạt họa chiến thắng, cúi người nhặt bảo vật và Avatar chân dung cho HUD:

```text
Game sprite sheet, anime flame mage action states. Row 1: 4 frames victory celebration pose, raising staff high with erupting small flame sparks, heroic stance. Row 2: 4 frames interact and pickup loot pose, bending down reaching toward ground with hand, collecting item. Row 3: 2 detailed hero status portraits inside ornate circular golden frames (1 normal confident expression, 1 hurt wounded grimace expression with sweat drop). Pure solid green background #00FF00, clean distinct grid cells, high resolution pixel art, consistent character proportions --ar 16:9
```

* **Negative Prompt**:
  `realistic face, photorealistic, 3D polygon, messy lines, text, watermark, bad anatomy, deformed hands, background wallpaper`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_01_hero_turnaround_death.png`
   - `batch_01_hero_actions_portrait.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ tự động bóc tách nền, gắn socket tay cầm vũ khí và đồng bộ vào `scenes/entities/player.tscn`!
