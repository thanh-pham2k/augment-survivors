# Batch 04 — Cảm Giác Đánh Đấm & Hiệu Ứng Phản Hồi (Combat Feedback & VFX)

> **Mã hạng mục trong Inventory**: `AS-146` ➔ `AS-165`  
> **Độ ưu tiên**: **P0 (Tuyệt đối quan trọng cho Combat Juice)**  
> **Tên file khi lưu để thả vào incoming**: `batch_04_combat_vfx.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Kích thước Cell**: 128×128 pixel per VFX state.
* **Phong cách**: Retro/Modern Arcade VFX (như trong *Dead Cells*, *Hades*, *Vampire Survivors*), màu sắc rực rỡ (vibrant additive colors), ánh sáng phát quang cao (High bloom contrast).
* **Quy cách nền**: Nền đen tuyền **`#000000`** hoặc Nền xanh lá cây thuần **`#00FF00`** (Nền đen đặc biệt lý tưởng cho các hiệu ứng phát sáng tia sét/lửa để shader additive hòa trộn tự nhiên).

---

## 📝 Prompt 4A: Tia Lửa Va Chạm, Chí Mạng & Trạng Thái Nguyên Tố (Impacts & Status Overlays)

Dành cho phản hồi va chạm (Hit sparks), Sát thương chí mạng (Critical burst) và 3 hiệu ứng trạng thái gắn trên đầu quái (Cháy 🔥, Đóng băng ❄️, Tê liệt ⚡):

```text
Game sprite sheet, combat impact feedback and elemental status effects, 2D action game VFX. Row 1: 4 frames bright white-yellow impact sparks and directional slash sparks. Row 2: 4 frames golden-orange critical hit radial burst with expanding shockwave ring. Row 3: 4 frames looping Burning status effect (flickering orange flame embers rising). Row 4: 4 frames looping Chilled/Frozen status effect (sharp crystalline blue frost needles and cold mist aura). Row 5: 4 frames looping Electrocuted/Shock status effect (crackling yellow-blue plasma electrical sparks jumping). Pure solid black background #000000, isolated glowing sprites, crisp edges, high dynamic range colors, perfectly aligned rows and columns --ar 16:9
```

* **Negative Prompt**:
  `characters, monsters, weapons, ground textures, text, numbers, blurry low-res haze, realistic photography, messy borders`

---

## 📝 Prompt 4B: Phản Ứng Nguyên Tố, Vệt Lướt Dash & Hào Quang (Synergies, Dash & Bursts)

Dành cho vụ nổ hơi nước Steam Burst, Tia sét bốc hỏa Burning Chain, Vệt tàn lửa khi Dash và Vòng vỡ khiên:

```text
Game sprite sheet, elemental reaction explosions and dash visual effects for 2D roguelite. Row 1: 6 frames Steam Burst elemental reaction (violent expanding white-hot boiling steam cloud explosion with water droplets and thermal embers). Row 2: 6 frames Burning Chain lightning arc (crackling orange-red fiery lightning bolt whipping outward). Row 3: 6 frames player Dash trail (afterimage ghost silhouette with dissipating red-orange flame smoke streak). Row 4: 6 frames Shield Break radial kinetic shockwave (expanding cyan diamond barrier shattering into crystalline shards). Pure solid black background #000000, luminous additive glow, pixel art / 2D hand-drawn game FX, sharp contrast --ar 16:9
```

* **Negative Prompt**:
  `human figures, faces, text, watermark, solid gray floor, uneven grid, muddy dark colors, low contrast`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_04_impacts_and_status.png`
   - `batch_04_synergies_and_dash.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ bóc tách và tích hợp vào `CombatEventBus`, tự động kích hoạt mỗi khi quái bị bắn trúng, dính chí mạng hoặc dính hiệu ứng nguyên tố!
