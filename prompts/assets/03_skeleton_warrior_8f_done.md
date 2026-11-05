# Prompt 03 — Skeleton Warrior Swarm (8 Sub-images)

> **Mục tiêu**: Tạo spritesheet hoạt họa cho quái vật phổ biến nhất game: **Skeleton Warrior** (Lính xương cầm kiếm). Chia rõ ràng 4 frames bước đi (Walk) và 4 frames vung kiếm chém kèm vệt sáng cong (Slash attack). Giới hạn **chính xác 8 sub-images**.

---

## 1. Thông Số Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không đổ bóng).
- **Góc nhìn**: Isometric 2.5D Top-Down (hướng về phía nhân vật, nhìn nghiêng 3/4).
- **Bố cục lưới**: **8 sub-images** xếp thành 2 hàng × 4 cột (2 rows × 4 columns).
- **Độ phân giải tổng thể**: `2048 × 1024 px`.

---

## 2. Đặc Tả Quái Vật (Visual Identity)

- Bộ xương chiến binh cổ đại, xương màu trắng xám rạn nứt.
- Đầu lâu đội mũ sắt rỉ sét có sừng cong (horned rusted iron skull cap).
- Hốc mắt tối đen có **đốm lửa đỏ ma mị rực sáng bên trong (glowing crimson eyes)**.
- Tay phải cầm một thanh đoản kiếm sắt rỉ (rusted iron shortsword) sắc bén.

---

## 3. Danh Sách 8 Khung Hình Trong Lưới

### Hàng 1 — Walk Cycle (4 Frames):
1. **Frame 1 (Walk Contact Left)**: Chân trái bước dứt khoát về phía trước chạm đất, tay cầm kiếm chúc xuống đất.
2. **Frame 2 (Walk Passing Step)**: Hai chân giao nhau, thân hình nhấp nhô nhẹ, hốc mắt đỏ rực.
3. **Frame 3 (Walk Contact Right)**: Chân phải sải bước chạm đất, thanh kiếm hơi nhấc lên ngang hông.
4. **Frame 4 (Walk Passing Step 2)**: Chân trái bắt đầu nhấc lên, tiến bước hung hãn lặp chu kỳ.

### Hàng 2 — Attack Sword Slash (4 Frames):
5. **Frame 5 (Slash Windup)**: Giơ thanh kiếm ngắn lên cao qua vai, chuẩn bị chém mạnh xuống.
6. **Frame 6 (Slash Strike Initiation)**: Vung mạnh thanh kiếm chém chéo xuống góc dưới, tạo vệt sáng bạc (white-silver arc).
7. **Frame 7 (Slash Full Arc Follow-Through)**: Lưỡi kiếm chém hết đà, tạo vệt chém bán nguyệt sắc lẹm phát sáng (glowing crescent slash effect).
8. **Frame 8 (Slash Recovery)**: Kiếm thu về vị trí sẵn sàng chiến đấu, cơ thể ổn định lại.

---

## 4. Prompt Tiếng Anh (Copy dùng trực tiếp cho AI Generator)

```text
A 2D isometric pixel-art animation spritesheet of an undead skeleton warrior enemy on a solid flat bright green #00FF00 background, neatly laid out in an 8-frame grid (4 columns by 2 rows).
Character design: ancient undead skeleton warrior wearing a battered horned iron helmet, menacing glowing red dots in dark eye sockets, holding a jagged iron short sword.
Row 1 (4 Walk Cycle Frames): Frame 1 left foot forward step with sword lowered; Frame 2 passing step with rhythmic gait; Frame 3 right foot forward step; Frame 4 passing step thrusting body forward.
Row 2 (4 Attack Slash Frames): Frame 5 raising sword over shoulder preparing a slash; Frame 6 downward diagonal sword strike; Frame 7 full impact slash leaving a brilliant white-silver glowing crescent slash trail arc; Frame 8 recovery to combat stance.
Crisp distinct edges, zero background shadows, consistent proportions, dark fantasy survivor roguelite style.
```
