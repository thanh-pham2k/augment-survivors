# Đặc Tả Các Texture Atlas Mở Rộng — Cho Hoạt Họa 60 FPS Siêu Mượt

Tài liệu này tổng hợp **danh sách các Texture Atlas chuyên biệt** cần tạo để đưa trải nghiệm game từ mức Prototype cơ bản lên mức **Game thương mại siêu mượt (Fluid 60 FPS Animation)**.

---

## 1. Nguyên Tắc Cốt Lõi Khi Tạo Atlas Cho Game 2D Roguelite

1. **Chuẩn Hóa Kích Thước Ô (Cell Dimensions)**: Tất cả các khung hình trong cùng 1 atlas phải nằm trong các ô vuông kích thước bằng nhau (ví dụ: `128x128` cho nhân vật, `256x256` cho Boss).
2. **Khóa Tọa Độ Điểm Chân (Ground Pivot Lock)**: Bàn chân của nhân vật khi chạm đất luôn phải nằm tại cùng một tọa độ Y cố định (ví dụ: cách mép dưới 10px). Điều này loại bỏ 100% hiện tượng trượt chân (foot-sliding) và giật nhấp nhô (vertical jitter).
3. **Tách Biệt Các Luồng Trạng Thái (Action State Separation)**: Thay vì dồn mọi thứ vào 1 ảnh, chia thành các dải hoạt họa 6-8 frame cho từng hành động để chu kỳ lặp (loop) mượt mà không bị ngắt nhịp.

---

## 2. Danh Sách 4 Atlas Chuyên Biệt Cần Tạo

### 🎯 Atlas 01: Player Complete Action Matrix (128 × 128 px / frame)
- **Quy cách**: Lưới 6 cột × 4 hàng = **24 frames** (Kích thước ảnh tổng: `768 × 512 px` trên nền `#00FF00`).
- **Nội dung 4 dải hoạt họa**:
  - **Hàng 1 — Idle Breath (6 frames)**: Dáng đứng chiến đấu 3/4, ngực nhấp nhô nhẹ, ngọn lửa trên tay bập bùng chuyển sắc từ vàng sang cam.
  - **Hàng 2 — 8-Way Run Cycle (6 frames)**: Chu kỳ chạy hoàn chỉnh (Contact Left $\rightarrow$ Down $\rightarrow$ Pass $\rightarrow$ Contact Right $\rightarrow$ Down $\rightarrow$ Pass), áo choàng đỏ cuộn sóng theo từng bước chân.
  - **Hàng 3 — Fire Spell Blast (6 frames)**: Giơ cao tay $\rightarrow$ quả cầu lửa tích tụ năng lượng $\rightarrow$ chưởng phóng chùm đạn lửa 3 tia ra phía trước $\rightarrow$ giật lùi phục hồi thế đứng.
  - **Hàng 4 — Phantom Dash & Hurt (6 frames)**: 4 frames lướt nhanh nghiêng người để lại tàn lửa đỏ + 2 frames giật lùi khựng lại khi nhận sát thương.

---

### 🎯 Atlas 02: Enemy Swarm & Flanker Combat Matrix (128 × 128 px / frame)
- **Quy cách**: Lưới 6 cột × 3 hàng = **18 frames** (Kích thước ảnh tổng: `768 × 384 px` trên nền `#00FF00`).
- **Nội dung 3 dải hoạt họa**:
  - **Hàng 1 — Skeleton Relentless March (6 frames)**: Bộ xương lính vác kiếm sắt bước đi dứt khoát, đầu gối nhấc cao, đầu sọ lắc nhẹ, hốc mắt đỏ rực.
  - **Hàng 2 — Skeleton Sword Slash (6 frames)**: Chu kỳ vung kiếm chém chéo từ trên xuống dưới, tia kiếm vung để lại vệt sáng bạc (slash trail).
  - **Hàng 3 — Shadow Bat Aerial Flap & Dive (6 frames)**: 3 frames đập cánh bay lượn nhịp nhàng (Up $\rightarrow$ Flat $\rightarrow$ Down) + 3 frames cụp cánh lao bổ nhào tấn công thần tốc.

---

### 🎯 Atlas 03: Boss "The Ember Colossus" Titan Matrix (256 × 256 px / frame)
- **Quy cách**: Lưới 4 cột × 3 hàng = **12 frames** (Kích thước ảnh tổng: `1024 × 768 px` trên nền `#00FF00`).
- **Nội dung 3 dải hoạt họa**:
  - **Hàng 1 — Titan Idle & Magma Pulse (4 frames)**: Người đá khổng lồ đứng sừng sững, nham thạch trong lồng ngực phập phồng tỏa nhiệt và bốc khói đen.
  - **Hàng 2 — Earthquake Ground Slam (4 frames)**: Ngửa người giơ hai nắm đấm đá khổng lồ lên cao $\rightarrow$ dộng sấm sét xuống sàn đấu $\rightarrow$ nứt toác mặt đất.
  - **Hàng 3 — Magma Arc Sweep & Stagger (4 frames)**: Quét cánh tay phải một góc quạt rộng 90 độ + tư thế khựng lại khi khiên bảo vệ bị phá vỡ.

---

### 🎯 Atlas 04: Elemental FX & Impact Explosions (96 × 96 px / frame)
- **Quy cách**: Lưới 6 cột × 3 hàng = **18 frames** (Kích thước ảnh tổng: `576 × 288 px` trên nền `#00FF00`).
- **Nội dung 3 dải hoạt họa**:
  - **Hàng 1 — Fireball In-Flight & Burst (6 frames)**: 3 frames quả cầu lửa xoáy đuôi tia than hồng + 3 frames quả cầu phát nổ khi trúng mục tiêu.
  - **Hàng 2 — Lightning Chain Arc Discharge (6 frames)**: 6 frames tia điện vàng kim giật lan tỏa, phân nhánh zíc-zắc sinh động.
  - **Hàng 3 — Steam Burst Reaction AoE (6 frames)**: Vụ nổ hơi nước bốc lên cuồn cuộn với các mảnh băng vỡ tan và đốm lửa bốc hơi.

---

## 3. Các Prompt Tiếng Anh Dùng Cho AI Generator

### Prompt Atlas 01 (Player 24-Frame Matrix):
```text
A 2D isometric pixel-art character animation texture atlas on a solid flat green #00FF00 background, strictly formatted as a 6-column by 4-row grid (24 uniform 128x128px frames). 
Features the anime battle mage with spiky silver-white hair, flowing crimson cape with flame crest, dark navy combat tunic, and radiant orange fire flame orb in his left hand:
- Row 1: 6-frame smooth breathing idle loop with pulsing magical flame.
- Row 2: 6-frame full isometric running cycle with rhythmic footwork and flowing cape cloth physics.
- Row 3: 6-frame spellcasting sequence (charge, forward palm thrust, explosive fire emission, recoil).
- Row 4: 4-frame fast phantom dash slide with fiery motion blur, followed by 2-frame stagger hit reaction.
Zero background shadows, feet ground contact strictly aligned at the bottom of each frame.
```

### Prompt Atlas 02 (Enemies 18-Frame Matrix):
```text
A 2D isometric pixel-art enemy animation texture atlas on a flat bright green #00FF00 background, formatted as a 6-column by 3-row grid (18 uniform 128x128px frames):
- Row 1: Skeleton Warrior 6-frame smooth march cycle wearing horned iron cap, glowing red eye sockets, holding rusted iron shortsword.
- Row 2: Skeleton Warrior 6-frame sword slash combo with sweeping silver blade trail.
- Row 3: Shadow Bat 6-frame aerial sequence (3 frames of graceful flapping wings followed by 3 frames of aerodynamic dive-bomb flank charge).
Clean silhouettes, uniform proportions, no shadows on the green background.
```

### Prompt Atlas 03 (Boss Titan 12-Frame Matrix):
```text
A 2D isometric pixel-art raid boss texture atlas on a flat bright green #00FF00 background, formatted as a 4-column by 3-row grid (12 large uniform 256x256px frames).
Features 'The Ember Colossus' - a colossal obsidian stone titan with pulsing molten chest cracks, volcanic horns, blazing yellow eyes, and massive ruby crystals on both shoulders:
- Row 1: 4-frame idle stance with glowing breathing magma veins and rising volcanic smoke.
- Row 2: 4-frame ground slam animation (rearing up, raising fists overhead, devastating ground smash impact).
- Row 3: 4-frame sweeping arm horizontal arc strike and shield-break stagger reaction.
Crisp edges, consistent massive scale across all frames.
```

### Prompt Atlas 04 (VFX & Elemental Impacts 18-Frame Matrix):
```text
A 2D top-down game visual effects texture atlas on a solid flat green #00FF00 background, arranged in a 6-column by 3-row grid (18 uniform 96x96px frames):
- Row 1: 6-frame fireball flight and bursting explosion with trailing orange sparks.
- Row 2: 6-frame crackling golden chain lightning arc animation flashing and branching across targets.
- Row 3: 6-frame steam burst AoE cloud explosion mixing scalding white steam, shattered cyan ice shards, and glowing ember smoke.
High energy, vibrant elemental colors, alpha-ready borders.
```
