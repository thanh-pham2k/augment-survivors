# Batch 08 — Đại Chiến Trùm & 3 Trụ Tinh Thể (Boss Colossus & Crystals)

> **Mã hạng mục trong Inventory**: `AS-043` ➔ `AS-059`  
> **Độ ưu tiên**: **P1 (Đỉnh cao cao trào trận đấu Boss)**  
> **Tên file khi lưu để thả vào incoming**: `batch_08_boss_phases_crystals.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Quy mô Boss**: To gấp 3-4 lần nhân vật thường (canvas đề xuất 384×384 hoặc 512×512 pixel per frame).
* **Tên gọi thống nhất**: **The Ember Colossus (Chúa Tể Nham Thạch)**.
* **3 Trụ Tinh Thể**: Chiều cao khoảng 120px, hiệu ứng pha lê Băng Lam (Cyan Sapphire) lơ lửng, tạo tia liên kết phát sáng nối vào thân Trùm.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen).

---

## 📝 Prompt 8A: Boss Enrage Cuồng Bạo, Bắn Hỏa Cầu & Gục Ngã (Boss Phases & Death)

Bao gồm trạng thái Nộ (Enrage), Phóng cầu lửa tầm xa và Hoạt họa tử trận sụp đổ thành đống đá nham thạch nguội lạnh:

```text
Game sprite sheet, The Ember Colossus giant lava boss combat phases and death animation, 2D dark fantasy pixel art. Row 1: 4 frames Enrage phase transition (eyes blazing fiery yellow, magma body cracks surging with boiling orange energy, roaring upward with fire erupting from shoulders). Row 2: 4 frames Ranged magma boulder cast (rearing back and hurling massive burning molten rock forward). Row 3: 6 frames Death collapse sequence (colossus staggering backward, glowing magma veins extinguishing to dull grey stone, giant crumbling into pile of cracked obsidian rubble with lingering smoke). Pure solid green background #00FF00, aligned grid rows, monumental scale, crisp outlines, high resolution --ar 16:9
```

* **Negative Prompt**:
  `photo, 3D polygon render, small human size, text, labels, watermark, floor tiles, blurry motion blur across cells`

---

## 📝 Prompt 8B: 3 Trụ Tinh Thể, Khiên Năng Lượng & Sóng Chấn Động (Crystals & Boss Shield)

Bao gồm 3 trạng thái của Trụ Tinh Thể (Nguyên vẹn, Rạn nứt, Nổ tung), Vòm khiên lục giác bảo vệ Trùm và Sóng xung kích nứt đất:

```text
Game sprite sheet, boss mechanics and crystal shield cores for 2D roguelite. Row 1: Floating Crystal Cores in 3 states - (1) Intact hovering cyan crystal shard wrapped in revolving runic rings, (2) Damaged cracked crystal with leaking glowing plasma fissures, (3) 4 frames crystal shattering explosion into sharp frozen shards. Row 2: Boss Invulnerability Shield (radiant hexagonal energy barrier dome shimmering with blue crystalline refraction). Row 3: 4 frames Ground Slam shockwave (cracking circular earth fissure with bursting magma geysers). Row 4: 4 frames sweeping flame arc slash wave. Pure solid green background #00FF00, crisp separated grid elements, vibrant fantasy contrast --ar 16:9
```

* **Negative Prompt**:
  `realistic photograph, blurry textures, text, watermark, character sprites, solid floor textures`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_08_boss_enrage_death.png`
   - `batch_08_crystals_and_shield.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ bóc tách và tích hợp vào `boss_colossus.gd` và `crystal_core.gd`, kích hoạt đầy đủ 3 Phase chiến đấu có chiều sâu!
