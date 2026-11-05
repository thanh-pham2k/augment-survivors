# Batch 11 — Màn Hình Bản Đồ, Trang Bị & Lò Rèn (Map Selection, Armory & Blacksmith)

> **Mã hạng mục trong Inventory**: `AS-166` ➔ `AS-195` (Bổ sung mở rộng)  
> **Độ ưu tiên**: **P0 (UX/UI Out-of-run) & P1 (Map Cards)**  
> **Mục tiêu**: Cung cấp prompt hoàn chỉnh để tạo thêm asset concept art cho 3 bản đồ, NPC Lò rèn và khung trang bị ngoài trận.

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Phong cách**: Dark Fantasy Anime Pixel Art & Gothic UI (*Hades II*, *Vampire Survivors*, *Elden Ring*).
* **Bảng màu**: 
  - Cathedral: Tím thẫm đá hoa cương, Vàng kim hoàng gia (`#C6A655`).
  - Magma: Đỏ nham thạch rực lửa (`#F05028`), khói tro đen.
  - Glacial: Xanh băng tuyết huyền bí (`#3CC8FF`), sương giá ánh bạc.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** hoặc PNG trong suốt để slicing tự động.

---

## 📝 Prompt 11A: 3 Thẻ Trực Quan Chọn Bản Đồ (Map Selection Tarot Cards)

Dành cho màn hình **MapSelectUI**: 3 thẻ tranh minh họa dọc tỉ lệ 3:4 miêu tả chi tiết bối cảnh, kiến trúc và hiểm họa của 3 vùng đất.

```text
Game UI sprite sheet, 3 vertical fantasy biome selection tarot cards for 2D roguelite action game. 
Card 1: "Cathedral of Ash" (interior of a shattered gothic cathedral, ruined marble pillars, glowing brass braziers, floating ash particles, regal gold ornate frame). 
Card 2: "Magma Caldera" (underground volcanic cavern, bubbling river of orange molten lava, jagged obsidian basalt rocks, heat distortion, molten crimson metal frame with skull crest). 
Card 3: "Glacial Hollow" (frozen crystal cavern, massive translucent blue ice spires, blizzard wind swirl, frozen skeleton trapped inside wall, frosted runic silver-cyan frame). 
Vertical card aspect ratio 3:4, pixel art high detail, dramatic lighting, empty space at the bottom for dynamic stats, pure solid green background #00FF00 --ar 16:9
```

* **Negative Prompt**:
  `photo, 3d render, blurry, modern buildings, cartoonish childish doodle, pre-baked long text, watermark`

---

## 📝 Prompt 11B: Chân Dung NPC Thợ Rèn & Khung Ô Trang Bị (Blacksmith & Armory Slots)

Dành cho màn hình **EquipmentUI** và **MetaShopUI**:

```text
Game UI sprite sheet, dark fantasy blacksmith NPC and modular equipment slot frames. 
Item 1: Veteran Runesmith Dwarf Portrait (grizzled beard with ember sparks, wearing leather apron with runic engravings, carrying a glowing hot forging hammer, determined gaze, 256x256 circular frame). 
Item 2: Weapon Equipment Frame (heavy forged iron pedestal frame with ruby socket, empty inside for weapon icon). 
Item 3: Armor Equipment Frame (engraved steel shield crest frame with sapphire socket, empty inside). 
Item 4: Relic Trinket Frame (ornate gold filigree diamond slot with amethyst crystal trim, empty inside). 
Item 5: Meta Upgrade Badges (5 small circular badge icons: Golden Heart for Max HP, Swift Wing for Move Speed, Ghost Dash for Dash Cooldown, Golden Horseshoe for Magnet Radius, Mystic D20 Dice for Augment Reroll). 
Pixel art aesthetic, pure solid green background #00FF00, sharp crisp borders --ar 16:9
```

* **Negative Prompt**:
  `low resolution, jpeg artifacts, blurry edges, words written on slots, white halo, realistic photo`

---

## 📁 Thao Tác Thả File
Khi bạn tạo xong hình ảnh từ AI:
1. Đặt tên file là `batch_11_map_cards.png` hoặc `batch_11_blacksmith_armory.png`.
2. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
3. Script tự động sẽ xử lý bóc tách trong 1 lệnh duy nhất!
