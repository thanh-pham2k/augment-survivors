# Batch 03 — Boss "The Ember Colossus" & Crystal Core Spritesheet

> **Mục tiêu**: Tạo spritesheet hoạt họa cho Boss chính **The Ember Colossus** (Người đá dung nham khổng lồ) và **Crystal Core** (Trụ pha lê khiên bảo vệ) đúng 100% theo Panel 5 từ ảnh gốc `references/game_ui_flow_reference.jpg`.

---

## 1. Thông Tin Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không bóng đổ để tách chroma key).
- **Góc nhìn**: Isometric 2.5D Top-Down nhìn từ trên xuống nghiêng 45 độ.
- **Bố cục**: 1 ảnh duy nhất gồm **6 sub-images** lớn (lưới 3 cột × 2 hàng).
  - Kích thước Boss to gấp 3 lần nhân vật thường.
- **Độ phân giải tổng thể**: 2048 × 1365 px hoặc 1024 × 682 px.

---

## 2. Đặc Tả Thiết Kế

### Boss: The Ember Colossus (Khổng lồ Dung Nham)
- Cơ thể khổng lồ cấu tạo từ đá magma obsidian màu xám đen gồ ghề, với các đường nứt dung nham màu cam/vàng rực phát sáng trên ngực, lưng và cánh tay.
- Hai bờ vai mọc ra **khối tinh thể dung nham màu đỏ cam phát quang (Ember Crystals)** cực lớn, góc cạnh như đá quý ruby thô.
- Đầu đá có sừng nham thạch nhô ra, hai mắt là hai khe nứt sáng rực màu vàng dung nham.
- Hai nắm đấm đá khổng lồ, nặng nề, toát ra sức mạnh áp đảo.

### Trụ Tinh Thể: Crystal Core (Vật thể phá vỡ Shield)
- Bệ đá phong ấn cổ tròn ở chân, đỡ lấy một khối pha lê lửa màu đỏ ruby rực sáng vút cao lên trời, có hào quang lửa bao quanh.

---

## 3. Danh Sách 6 Sub-Images Trong Lưới (Grid Layout)

### Hàng 1 — Boss Actions (3 Frames):
1. **Frame 01 (Boss Idle / Breathing Magma)**: Đứng sừng sững, hai tay buông thõng, dung nham trong lồng ngực đập phập phồng tỏa nhiệt.
2. **Frame 02 (Boss Ground Slam Anticipation)**: Nâng cao hai cánh tay đá khổng lồ lên trời, ngửa người tích luỹ sức mạnh đập sàn.
3. **Frame 03 (Boss Ground Slam Impact)**: Dộng mạnh hai nắm đấm xuống đất, các tia nứt dung nham tóe ra xung quanh.

### Hàng 2 — Boss & Crystal Variants (3 Frames):
4. **Frame 04 (Boss Swipe Attack)**: Vung nắm đấm phải quét ngang một đường vòng cung lớn (tạo đòn telegraph hình quạt).
5. **Frame 05 (Crystal Core Intact)**: Trụ pha lê đá nguyên vẹn, tỏa hào quang đỏ ruby rực rỡ và tia sáng xung quanh.
6. **Frame 06 (Crystal Core Shattering / Destroyed)**: Khối tinh thể vỡ vụn nứt toác, các mảnh pha lê bắn tung tóe thành tàn lửa.

---

## 4. Prompt Tiếng Anh (Dùng Trực Tiếp Cho AI Generator)

```text
A 2D isometric pixel-art boss spritesheet on a flat solid bright green #00FF00 background, neatly laid out in a grid of 6 large sub-images (3 columns by 2 rows). 
Features the giant raid boss 'The Ember Colossus' and its 'Crystal Core' from a dark fantasy roguelite game:
The Ember Colossus is a massive obsidian magma stone titan with glowing molten lava cracks pulsing through its rocky chest, jagged volcanic horns, blazing yellow molten eyes, and gigantic sharp radiant red fire crystals sprouting from both massive stone shoulders. 
Row 1: Frame 1 Boss idle breathing stance with glowing lava veins; Frame 2 Boss rearing up raising massive stone fists overhead preparing an earthquake slam; Frame 3 Boss slamming fists into ground with molten impact sparks.
Row 2: Frame 4 Boss sweeping right arm in a wide crushing arc strike; Frame 5 Crystal Core: a pristine glowing red ruby crystal pillar mounted on an ancient stone pedestal emitting fiery aura; Frame 6 Crystal Core shattering into fractured glowing shards and fading embers.
Clean contours, no background shadows, consistent massive proportions, high-end 2.5D isometric game art.
```
