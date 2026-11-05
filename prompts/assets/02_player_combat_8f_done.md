# Prompt 02 — Player Combat & Dash Actions (8 Sub-images)

> **Mục tiêu**: Tạo spritesheet cho các hành động chiến đấu đặc trưng của Nhân vật chính: Bắn phép chùm tia (Cast Blast), Lướt né chiêu kèm tàn lửa (Phantom Dash), và Giật lùi khi dính đòn (Hurt reaction). Giới hạn **chính xác 8 sub-images**.

---

## 1. Thông Số Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không đổ bóng).
- **Góc nhìn**: Isometric 2.5D Top-Down (hướng sang phải 3/4).
- **Bố cục lưới**: **8 sub-images** xếp thành 2 hàng × 4 cột (2 rows × 4 columns).
- **Độ phân giải tổng thể**: `2048 × 1024 px`.

---

## 2. Đặc Tả Nhân Vật

- Anime Flame Mage: Tóc bạc vuốt nhọn, áo choàng đỏ thẫm bồng bềnh viền đen, chiến phục navy, quả cầu lửa rực sáng trên tay.

---

## 3. Danh Sách 8 Khung Hình Trong Lưới

### Hàng 1 — Spellcasting Blast Sequence (4 Frames):
1. **Frame 1 (Cast Anticipation)**: Người hơi lùi về sau, tay trái co lại tích tụ luồng nhiệt lượng lớn, quả cầu lửa bốc khói dữ dội.
2. **Frame 2 (Cast Thrust)**: Đẩy mạnh lòng bàn tay về phía trước, năng lượng lửa bùng sáng chói lọi.
3. **Frame 3 (Cast Release Blast)**: Bắn phóng ra chùm đạn lửa 3 tia (triple fireballs fan) xé gió lao đi, tàn lửa bay mù mịt.
4. **Frame 4 (Cast Recoil)**: Tay giật nhẹ theo độ giật ma thuật, áo choàng cuộn lại rồi hạ xuống.

### Hàng 2 — Dash Dodge & Hurt Reaction (4 Frames):
5. **Frame 5 (Dash Initiation)**: Trọng tâm hạ sát mặt đất, người ngả về phía trước chuẩn bị lướt tốc độ cao.
6. **Frame 6 (Dash Slide Full)**: Lướt nhanh vun vút về phía trước, cơ thể mờ ảo để lại vệt tàn lửa đỏ cam dài phía sau (ember trail).
7. **Frame 7 (Hurt Impact)**: Cơ thể bị giật khựng lại khi trúng đòn, một tay giơ lên chắn, vạt áo choàng dạt sang bên.
8. **Frame 8 (Hurt Recovery)**: Trọng tâm lùi lại chống chân vững xuống đất, chuẩn bị phản kích.

---

## 4. Prompt Tiếng Anh (Copy dùng trực tiếp cho AI Generator)

```text
A high-resolution 2D isometric pixel-art animation spritesheet of an anime flame mage combat actions on a pure solid green #00FF00 background, formatted in an 8-frame grid (4 columns by 2 rows).
Character: handsome young battle sorcerer with spiky silver-white hair, flowing crimson-red cape with dark flame trim, dark navy tunic with gold belt buckle.
Row 1 (4 Spellcast Frames): Frame 1 casting charge pulling flame orb back; Frame 2 forward palm thrust with blazing magical flare; Frame 3 launching fan of glowing orange-yellow fireballs with fiery blast sparks; Frame 4 casting recoil recovery.
Row 2 (4 Dash & Hurt Frames): Frame 5 low crouching dash launch; Frame 6 fast phantom dash slide horizontally leaving dynamic glowing orange flame ember trail behind; Frame 7 stagger hit impact reaction flinching back; Frame 8 recovery step anchoring feet.
Clean alpha-ready contours, zero background shadows, consistent proportions matching roguelite survivor anime art style.
```
