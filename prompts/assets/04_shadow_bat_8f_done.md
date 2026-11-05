# Prompt 04 — Shadow Bat Aerial Flanker (8 Sub-images)

> **Mục tiêu**: Tạo spritesheet hoạt họa cho quái bay: **Shadow Bat** (Dơi quỷ bóng đêm). Chia rõ ràng 4 frames đập cánh bay lượn (Flight loop) và 4 frames cụp cánh lao bổ nhào tốc độ cao (Dive flank attack). Giới hạn **chính xác 8 sub-images**.

---

## 1. Thông Số Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không bóng đổ).
- **Góc nhìn**: Isometric 2.5D Top-Down nhìn từ trên cao xuống.
- **Bố cục lưới**: **8 sub-images** xếp thành 2 hàng × 4 cột (2 rows × 4 columns).
- **Độ phân giải tổng thể**: `2048 × 1024 px`.

---

## 2. Đặc Tả Quái Vật (Visual Identity)

- Dơi quỷ bóng đêm, thân hình lông xù màu tím sẫm (dark violet/purple).
- Đôi cánh màng da lớn màu tím dạ quang (vibrant purple leathery bat wings).
- Hai mắt màu đỏ rực phát sáng (glowing crimson eyes), hai tai nhọn vểnh cao, có nanh nhỏ.

---

## 3. Danh Sách 8 Khung Hình Trong Lưới

### Hàng 1 — Flight Flap Cycle (4 Frames):
1. **Frame 1 (Wings High Up)**: Hai cánh giương cao hướng lên trên, thân mình hơi chìm xuống lấy đà.
2. **Frame 2 (Wings Downstroke)**: Cánh vỗ mạnh xuống dưới, đẩy thân bay nhô lên cao.
3. **Frame 3 (Wings Full Spread / Flat)**: Đôi cánh mở rộng nằm ngang đón gió lướt nhanh về phía trước.
4. **Frame 4 (Wings Mid Recovery)**: Cánh hơi gập lại nhấc lên chuẩn bị cho nhịp vỗ tiếp theo.

### Hàng 2 — Dive Attack & Flank Charge (4 Frames):
5. **Frame 5 (Dive Anticipation)**: Đầu chúc xuống, hai mắt đỏ rực khóa mục tiêu.
6. **Frame 6 (Wings Tucked In Dive)**: Cụp sát hai cánh vào thân mình thành hình giọt nước khí động học lao vun vút.
7. **Frame 7 (Dive Strike)**: Lao thẳng tới trước với vệt gió mờ tím phía sau (purple air streak).
8. **Frame 8 (Dive Pull-up)**: Xòe cánh hãm phanh vút ngược lên cao.

---

## 4. Prompt Tiếng Anh (Copy dùng trực tiếp cho AI Generator)

```text
A 2D isometric pixel-art animation spritesheet of a dark fantasy shadow bat enemy on a solid flat bright green #00FF00 background, neatly arranged in an 8-frame grid (4 columns by 2 rows).
Creature design: dark violet-purple fantasy bat with glowing bright red eyes, pointed ears, small fangs, and vibrant purple leathery wings.
Row 1 (4 Flight Flap Frames): Frame 1 wings raised high above body; Frame 2 powerful downward wing flap creating lift; Frame 3 wings fully spread horizontal gliding forward; Frame 4 wings folding slightly recovering upward.
Row 2 (4 Dive Attack Frames): Frame 5 angling head downward aiming red glowing eyes at target; Frame 6 wings tucked tightly against body in aerodynamic dive torpedo pose; Frame 7 high speed dive strike with subtle purple motion trail; Frame 8 wings spreading out braking upward.
Clean sharp silhouettes, zero background shadows, consistent proportions, 2.5D survivor roguelite game art.
```
