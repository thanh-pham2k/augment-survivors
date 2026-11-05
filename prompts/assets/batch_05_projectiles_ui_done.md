# Batch 05 — Projectiles, FX & Core UI Icons

> **Mục tiêu**: Tạo bảng đạn ma thuật (Projectiles), hiệu ứng va chạm (Impact VFX) và bộ icon giao diện (HUD Icons) theo đúng Panel 2, 4, 5 từ ảnh gốc `references/game_ui_flow_reference.jpg`.

---

## 1. Thông Tin Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không đổ bóng).
- **Góc nhìn**: 2D Sprite / Top-Down FX.
- **Bố cục**: 1 ảnh duy nhất gồm **8 sub-images** (lưới 4 cột × 2 hàng):
  - Hàng trên: 4 loại đạn & tia phép (Projectiles & VFX).
  - Hàng dưới: 4 Icon HUD & Kỹ năng (HUD & Action Icons).
- **Độ phân giải tổng thể**: 2048 × 1024 px hoặc 1024 × 512 px.

---

## 2. Đặc Tả Chi Tiết 8 Sub-Images (Grid Layout)

### Hàng 1 — Đạn & Hiệu Ứng Ma Thuật (Projectiles & VFX):
1. **Sub-image 01 (Fire Fan Projectile / Đạn Hỏa 3 Tia)**: Quả cầu lửa hình giọt nước rực sáng bốc khói cam vàng, có đuôi lửa dài kéo theo tàn than hồng (chính là đạn bắn ra từ tay nhân vật trong ảnh).
2. **Sub-image 02 (Frost Shard / Tinh Thể Băng)**: Mũi tên băng sắc nhọn 6 cạnh màu xanh ngọc băng tuyết, có vệt sương lạnh mờ ảo.
3. **Sub-image 03 (Chain Lightning Arc / Tia Sét Nối Quái)**: Tia điện zíc-zắc màu vàng kim phân nhánh rực rỡ, nối giữa các mục tiêu bị giật điện.
4. **Sub-image 04 (Steam Burst / Vụ Nổ Hơi Nước)**: Hiệu ứng vòng tròn khói nổ nhiệt hơi nước trắng đục hòa lẫn tàn lửa và mảnh băng vỡ (phản ứng Hỏa + Băng).

### Hàng 2 — Icons Giao Diện & Kỹ Năng (HUD Elements):
5. **Sub-image 05 (Dash Action Button Icon)**: Nút tròn góc phải dưới từ Panel 2: Icon người chạy dũng mãnh màu xanh neon phát sáng bên trong vòng tròn năng lượng màu xanh lam đậm.
6. **Sub-image 06 (Hero Status Avatar Portrait)**: Chân dung nhỏ bán thân của nhân vật chính góc nhìn nghiêng (anime nam tóc bạc, áo choàng đỏ) viền kim loại tối.
7. **Sub-image 07 (Boss Shield Barrier)**: Vòm khiên năng lượng lục giác màu xanh lam dạ quang bao bọc Boss.
8. **Sub-image 08 (Timeline Skull Milestone Icon)**: Biểu tượng đầu lâu màu bạc kim loại nhỏ trên thanh timeline tiến trình trận đấu.

---

## 3. Prompt Tiếng Anh (Dùng Trực Tiếp Cho AI Generator)

```text
A 2D game asset spritesheet of magical projectiles, visual effects, and HUD UI icons on a flat solid bright green #00FF00 background, neatly arranged in an 8-item grid (4 columns by 2 rows). 
Row 1 (Projectiles & VFX):
Item 1: Burning Fireball Projectile - teardrop-shaped radiant fireball blazing with bright yellow-orange molten core and swirling ember trail.
Item 2: Frost Ice Shard - sharp crystalline cyan-blue icicle projectile emitting frosty mist.
Item 3: Chain Lightning Spark - sharp jagged crackling golden-yellow electric arc bolt branching with high voltage energy.
Item 4: Steam Burst AoE explosion - circular shockwave cloud of scalding white steam mixing glowing orange embers and shattered cyan ice fragments.
Row 2 (HUD & Action Icons):
Item 5: Dash Button Icon - circular UI action badge with a glowing cyan neon silhouette of a sprinting athlete inside a dark sci-fi/fantasy ring.
Item 6: Hero Avatar Icon - round metallic framed portrait of the anime battle mage with silver hair and crimson cloak.
Item 7: Blue Hexagonal Energy Shield - glowing translucent cyan-blue hexagonal forcefield barrier.
Item 8: Timeline Skull Marker - stylized silver skull icon used as a battle milestone progress tracker.
Clean sharp alpha-ready outlines, vibrant fantasy colors, perfect for top-down action roguelite survivor game.
```
