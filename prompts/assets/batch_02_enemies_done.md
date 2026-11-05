# Batch 02 — Common Enemies Animation Spritesheet

> **Mục tiêu**: Tạo spritesheet hoạt họa cho 2 kẻ địch thường gặp đầu game theo đúng Panel 2 và 4 từ ảnh gốc `references/game_ui_flow_reference.jpg`:
> 1. **Skeleton Warrior** (Swarm Chaser): Bộ xương lính cầm kiếm sắt.
> 2. **Shadow Bat** (Flanker): Dơi tím mắt đỏ bay lượn.

---

## 1. Thông Tin Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100%, không đổ bóng xuống nền để dễ tách chroma key).
- **Góc nhìn**: Isometric 2.5D Top-Down (nhìn nghiêng hướng về phía người chơi).
- **Bố cục**: 1 ảnh duy nhất gồm **8 khung hình (sub-images)** chia lưới 4 cột × 2 hàng (4 columns × 2 rows).
  - Hàng trên (Hàng 1): 4 frames bước đi của Skeleton Warrior.
  - Hàng dưới (Hàng 2): 4 frames đập cánh bay của Shadow Bat.
- **Độ phân giải tổng thể**: 2048 × 1024 px hoặc 1024 × 512 px.

---

## 2. Đặc Tả Thiết Kế

### Kẻ địch 1: Skeleton Warrior (Swarm Chaser)
- Bộ xương chiến binh cổ đại, xương màu trắng xám cũ kỹ.
- Mũ giáp sắt rỉ sét có sừng nhỏ hoặc rạn nứt, hốc mắt tối đen có **đốm sáng đỏ rực bên trong**.
- Tay phải cầm thanh kiếm ngắn bằng sắt rỉ (rusted iron shortsword) sắc bén.
- Tay trái hoặc để tự do vung vẩy, dáng đi lảo đảo nhưng hung hãn tiến tới.

### Kẻ địch 2: Shadow Bat (Flanker)
- Dơi quỷ nhỏ bay lơ lửng, thân mình lông xù màu tím đen/dark violet.
- Đôi cánh màng da màu tím dạ quang (purple leathery wings) vươn rộng.
- Hai mắt màu đỏ rực phát sáng (glowing crimson eyes), hai tai nhọn vểnh cao, có nanh nhỏ.

---

## 3. Danh Sách 8 Sub-Images Trong Lưới (Grid Layout)

### Hàng 1 — Skeleton Warrior Walk Cycle (4 Frames):
1. **Frame 01 (Skel Contact Left)**: Chân trái bước tới trước, tay cầm kiếm hạ thấp.
2. **Frame 02 (Skel Pass)**: Hai chân giao nhau, thân hơi nhấp nhô, kiếm hơi giơ lên.
3. **Frame 03 (Skel Contact Right)**: Chân phải bước dứt khoát về trước, kiếm vung ngang ngực.
4. **Frame 04 (Skel Attack Slash)**: Chém mạnh kiếm về phía góc dưới trái, hốc mắt đỏ rực.

### Hàng 2 — Shadow Bat Flight Cycle (4 Frames):
5. **Frame 05 (Bat Wings High)**: Hai cánh giương cao hướng lên trên, cơ thể hơi chìm xuống.
6. **Frame 06 (Bat Wings Downstroke)**: Cánh vỗ mạnh xuống dưới, tạo lực nâng.
7. **Frame 07 (Bat Wings Flat / Glide)**: Cánh mở rộng nằm ngang lướt nhanh về phía trước.
8. **Frame 08 (Bat Dive Dash)**: Cánh khép sát thân mình, đầu chúc về trước trong tư thế lao bổ nhào (flank attack).

---

## 4. Prompt Tiếng Anh (Dùng Trực Tiếp Cho AI Generator)

```text
A 2D isometric pixel-art enemy spritesheet on a flat solid bright green #00FF00 background, neatly arranged in an 8-frame grid (4 columns by 2 rows). 
Row 1 features a Skeleton Warrior: ancient undead skeleton warrior wearing a rusted iron horned skull cap, glowing ominous red dots in dark eye sockets, holding a jagged iron short sword in hand. 4 walk and attack animation frames: Frame 1 left foot forward, Frame 2 passing step, Frame 3 right foot forward sword raised, Frame 4 diagonal slashing strike.
Row 2 features a Shadow Bat: dark violet purple vampiric fantasy bat with glowing bright red eyes, pointed ears, and large leathery purple wings. 4 flying animation frames: Frame 5 wings raised high, Frame 6 downstroke flap, Frame 7 wings flat glide, Frame 8 aerodynamic diving charge pose.
Clean sharp silhouettes, no shadows or gradients on the green background, exact 2.5D isometric perspective matching dark fantasy survivor roguelite style.
```
