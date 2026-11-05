# Batch 03 — Kho 3 Vũ Khí Khởi Đầu (Starter Weapons Arsenal)

> **Mã hạng mục trong Inventory**: `AS-060` ➔ `AS-068`  
> **Độ ưu tiên**: **P0 (Tuyệt đối quan trọng cho Vertical Slice)**  
> **Tên file khi lưu để thả vào incoming**: `batch_03_starter_weapons.png`

---

## 🎯 Ý Nghĩa Gameplay Lõi
3 vũ khí cơ sở định hình 3 phong cách chiến đấu hoàn toàn khác biệt ngay từ giây đầu tiên:
1. **Inferno Staff (Hỏa Trượng)**: Sát thương quạt lửa hình nón, cực mạnh khi áp sát cự ly gần.
2. **Storm Gauntlet (Lôi Thủ)**: Phóng tia điện nhảy xích tự động giữa các mục tiêu túm tụm đông đúc.
3. **Glacial Spear (Băng Thương)**: Phóng ngọn giáo băng đâm xuyên thẳng hàng và làm chậm tốc độ quái.

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Kích thước Icon trang bị**: Khung vuông tỷ lệ 1:1, viền kim loại chạm khắc cổ điển (Gothic metallic frame).
* **Kích thước Đạn & VFX**: 128×128 pixel per frame, hướng bắn chuẩn quay sang phải (Right-facing $0^\circ$).
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen) hoặc nền đen tuyền (dành cho tia điện phát sáng cộng hưởng).

---

## 📝 Prompt 3: Trọn Bộ 3 Vũ Khí Cơ Sở (Icons, Projectiles & Impacts)

Tất cả 3 vũ khí cơ sở (Icon, Tia đạn bay, Vệt chém/bắn, Vụ nổ va chạm) nằm trong 1 Spritesheet tổng hợp:

```text
Game sprite sheet, 3 fantasy starter weapons collection for 2D roguelite action game. Row 1: 3 detailed weapon inventory icons inside square ornate bronze frames - (1) Inferno Staff with glowing ruby crystal head and spiraling flames, (2) Storm Gauntlet armored brass knuckle pulsing with blue electrical plasma, (3) Glacial Spear carved from sharp crystalline ice with frosty mist aura. Row 2: Inferno Staff combat VFX - 4 frames 3-way spreading fan fireballs projectile flying right, and 4 frames fiery ember impact burst. Row 3: Storm Gauntlet combat VFX - 4 frames jagged chain lightning electrical arcs connecting targets with blue-white plasma sparks, and 4 frames electric shock burst. Row 4: Glacial Spear combat VFX - 4 frames piercing elongated ice spear projectile with frost trail flying right, and 4 frames ice shattering impact spikes. Solid green background #00FF00, aligned grid spacing, crisp pixel art edges, vibrant glowing colors, high contrast --ar 16:9
```

* **Negative Prompt**:
  `realistic photograph, 3D CGI plastic render, modern guns, firearms, text, words, watermark, blurry glow bleeding across grid cells, uneven spacing`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ prompt trên.
2. Lưu file với tên: `batch_03_starter_weapons.png`.
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống tự động bóc tách thành:
   - `assets/sprites/weapons/icon_inferno_staff.png`
   - `assets/sprites/weapons/icon_storm_gauntlet.png`
   - `assets/sprites/weapons/icon_glacial_spear.png`
   - Kèm các scene đạn `projectile_fire_fan.tscn`, `projectile_chain_lightning.tscn`, `projectile_ice_spear.tscn` tích hợp thẳng vào `WeaponController`!
