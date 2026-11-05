# Batch 01 — Player Character Animation Spritesheet

> **Mục tiêu**: Tạo spritesheet hoạt họa nhân vật chính (Anime Flame Mage) theo góc nhìn Isometric 2.5D, đúng 100% hình mẫu từ ảnh tham khảo `references/game_ui_flow_reference.jpg` (Panel 1, 2, 4, 6).

---

## 1. Thông Tin Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không đổ bóng xuống nền, không gradient để phục vụ chroma key tách alpha).
- **Góc nhìn**: Isometric 2.5D Top-Down (khoảng 45–60 độ).
- **Quy cách bố cục**: 1 ảnh duy nhất chứa **8 khung hình (sub-images)** chia thành lưới 4 cột × 2 hàng (4 columns × 2 rows).
- **Độ phân giải tổng thể**: 2048 × 1024 px hoặc 1024 × 512 px.

---

## 2. Đặc Tả Ngoại Hình Nhân Vật (Visual Contract)

- **Khuôn mặt & Tóc**: Nam pháp sư anime trẻ tuổi, khuôn mặt cương nghị, mắt xanh lam sắc bén, mái tóc màu bạc/trắng ánh kim vuốt nhọn (spiky silver/white anime hair) với phần tóc mái rũ nhẹ.
- **Trang phục**:
  - Áo choàng dài màu đỏ thẫm/crimson red bồng bềnh, viền đen và cổ áo dựng cao, có hoa văn ngọn lửa vàng cam sau lưng.
  - Áo giáp bó sát/tunic chiến đấu màu xanh đen (dark navy/leather) có thắt lưng và khóa kim loại màu vàng kim.
  - Găng tay chiến đấu màu xám đậm.
  - Quần tối màu và bốt da đen cao cổ.
- **Vũ khí / Hiệu ứng**: Quả cầu lửa ma thuật (bright glowing orange-yellow fire orb) lơ lửng trên bàn tay trái, tỏa ánh sáng rực rỡ và các tàn lửa nhỏ bay xung quanh.

---

## 3. Danh Sách 8 Sub-Images Trong Lưới (Grid Layout)

### Hàng 1 (Top Row — 4 Frames):
1. **Frame 01 (Idle Stance A)**: Tư thế đứng nghiêng 3/4 (isometric facing bottom-right), chân hơi chùng, áo choàng rũ tự nhiên, tay trái nâng quả cầu lửa sáng rực.
2. **Frame 02 (Idle Stance B / Breathe)**: Ngực hơi nâng lên, quả cầu lửa bốc khói nhẹ, vạt áo choàng khẽ lay động.
3. **Frame 03 (Walk Cycle 1)**: Chân trái bước về phía trước, áo choàng đỏ bay bồng bềnh về phía sau, ngọn lửa nghiêng theo quán tính.
4. **Frame 04 (Walk Cycle 2)**: Chân phải sải bước dứt khoát, trọng tâm cơ thể hạ thấp, bước chạy lướt nhanh phong cách roguelite.

### Hàng 2 (Bottom Row — 4 Frames):
5. **Frame 05 (Cast Attack Anticipation)**: Người hơi lùi về sau, tay trái đưa cầu lửa về sau tích năng lượng.
6. **Frame 06 (Cast Attack Release)**: Đẩy mạnh tay về phía trước, bắn phóng ra chùm tia lửa hình quạt rực sáng.
7. **Frame 07 (Dash / Dodge Slide)**: Cơ thể nghiêng sát mặt đất lướt nhanh về phía trước, áo choàng kéo dài vệt tàn lửa đỏ cam phía sau.
8. **Frame 08 (Hurt / Impact)**: Tư thế khựng lại khi trúng đòn, tay chắn trước mặt, áo choàng co lại.

---

## 4. Prompt Tiếng Anh (Dùng Trực Tiếp Cho AI Generator)

```text
A 2D isometric pixel-art animation spritesheet of an anime battle mage on a solid flat bright green #00FF00 background, arranged in a neat grid of 8 sub-images (4 columns by 2 rows). 
Character design strictly matching dark fantasy roguelite: young handsome anime male sorcerer with spiky silver-white hair, intense blue eyes, flowing crimson-red hooded cape with dark trim and flame motif, dark navy combat tunic with golden buckles, holding a radiant glowing orange-yellow fire flame orb in his left hand. 
Row 1: Frame 1 Idle combat stance facing 3/4 isometric bottom-right; Frame 2 breathing idle with pulsing flame; Frame 3 running walk cycle left foot forward with billowing cape; Frame 4 running walk cycle right foot forward. 
Row 2: Frame 5 spell cast charge pulling flame orb back; Frame 6 casting blast thrusting fire orb forward; Frame 7 fast dash dodge slide leaving ember trails; Frame 8 hit reaction stagger. 
Clean distinct outlines, no shadows on the green background, uniform character proportions across all 8 frames, professional 2.5D game spritesheet style.
```
