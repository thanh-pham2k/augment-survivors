# Prompt 01 — Player Movement & Idle (8 Sub-images)

> **Mục tiêu**: Tạo spritesheet độ nét cao cho hoạt họa Thở (Idle) và Di chuyển (Run) của Nhân vật chính (Anime Flame Mage), tối ưu độ phân giải cao bằng cách giới hạn **chính xác 8 sub-images**.

---

## 1. Thông Số Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không bóng đổ xuống nền).
- **Góc nhìn**: Isometric 2.5D Top-Down (nghiêng 45-60 độ, nhân vật hướng nghiêng góc dưới bên phải 3/4).
- **Bố cục lưới**: **8 sub-images** xếp thành 2 hàng × 4 cột (2 rows × 4 columns).
- **Độ phân giải tổng thể**: `2048 × 1024 px` (mỗi ô đạt kích thước ~512 × 512 px siêu sắc nét).

---

## 2. Đặc Tả Nhân Vật (Visual Identity)

- Nam pháp sư anime trẻ tuổi, khuôn mặt cương nghị, mắt xanh lam sắc sảo.
- Mái tóc màu bạc/trắng vuốt nhọn (spiky silver-white hair) phong cách anime hành động.
- Áo choàng đỏ thẫm (crimson red hooded cloak) viền đen và hoa văn ngọn lửa vàng, tà áo bay bồng bềnh theo chuyển động.
- Trang phục chiến đấu màu xanh đen (dark navy combat tunic) có đai lưng và khóa vàng kim.
- Bàn tay trái nâng quả cầu lửa ma thuật màu cam vàng rực sáng (glowing orange fire orb) tỏa ánh sáng ấm.

---

## 3. Danh Sách 8 Khung Hình Trong Lưới

### Hàng 1 — Idle Breathing Loop (4 Frames):
1. **Frame 1 (Idle Relaxed)**: Đứng thế chiến đấu 3/4, hai chân vững chãi, quả cầu lửa rực sáng trên tay trái, vạt áo rũ tự nhiên.
2. **Frame 2 (Idle Inhale)**: Ngực nâng nhẹ lên, quả cầu lửa bốc hơi ấm, vạt áo lay động khẽ.
3. **Frame 3 (Idle Peak)**: Ngọn lửa trên tay bùng to hơn một chút, tóc mái lay nhẹ.
4. **Frame 4 (Idle Exhale)**: Hạ ngực trở về thế ban đầu, chu kỳ thở hoàn tất lặp lại mượt mà.

### Hàng 2 — 8-Way Run Cycle (4 Frames):
5. **Frame 5 (Run Contact Left)**: Chân trái sải mạnh về phía trước chạm đất, áo choàng đỏ bay cuộn về sau.
6. **Frame 6 (Run Passing Left)**: Chân trái chịu lực, chân phải nhấc lên chuẩn bị lướt tới, quả cầu lửa kéo vệt tàn than hồng nhỏ.
7. **Frame 7 (Run Contact Right)**: Chân phải bước dài chạm đất dứt khoát, trọng tâm hạ thấp lướt nhanh phong cách roguelite.
8. **Frame 8 (Run Passing Right)**: Chân phải đẩy lực, chân trái chuẩn bị vươn tới, hoàn tất chu kỳ chạy lặp.

---

## 4. Prompt Tiếng Anh (Copy dùng trực tiếp cho AI Generator)

```text
A professional 2D isometric pixel-art animation spritesheet of a dark fantasy anime battle mage on a solid flat bright green #00FF00 background, neatly organized in an 8-frame grid (4 columns by 2 rows).
Character appearance strictly consistent: handsome young anime sorcerer with spiky silver-white hair, intense blue eyes, flowing crimson-red cloak with dark trim, dark navy battle tunic with golden buckles, holding a radiant glowing yellow-orange fire orb in his left hand.
Row 1 (4 Idle Breathing Frames): Frame 1 neutral 3/4 isometric combat stance; Frame 2 chest gently inhaling with pulsing fire orb; Frame 3 peak breath with glowing flame embers; Frame 4 smooth exhale returning to stance.
Row 2 (4 Running Cycle Frames): Frame 5 left foot contact forward with billowing cape; Frame 6 passing stride; Frame 7 right foot contact stride forward with dynamic cloth physics; Frame 8 passing stride pushing off ground.
Clean sharp outlines, no ground shadows on green background, feet aligned horizontally across each row, high resolution 2.5D game spritesheet.
```
