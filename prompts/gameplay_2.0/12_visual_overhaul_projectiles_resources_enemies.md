# Batch 12 — Đại Tu Đồ Họa: Đạn, Tài Nguyên & Kỹ Năng / Quái Vật (Visual Overhaul Suite)

> **Mục tiêu**: Nâng cấp toàn diện chất lượng đồ họa gameplay theo phản hồi thực tế từ màn chơi sinh tồn vô tận:
> 1. **Đạn**: Thiết kế chuyển động mượt mà, lõi năng lượng phát sáng, vệt tàn lửa/băng/sét và vụ nổ va chạm (Impact burst).
> 2. **Tài nguyên**: Ngọc XP đa phân cấp phát quang lơ lửng, đồng vàng cổ khắc cổ tự, hiệu ứng vệt hút chân không và tia sáng bùng nổ khi nhân vật hấp thụ (Absorption burst).
> 3. **Kỹ năng & Quái vật**: Vùng chiêu AoE, vòng cảnh báo nguy hiểm (Telegraph), và dàn quái vật Dark Fantasy tương phản cao, hình khối sắc nét, mắt rực lửa ma thuật.

---

## 🎨 Quy Chuẩn Mỹ Thuật (Art Direction & Production Standards)

* **Phong cách chủ đạo**: *Dark Fantasy Anime Pixel Art & Modern 2D Arcade* (tương đồng đẳng cấp với *Hades*, *Dead Cells*, *Vampire Survivors HD*, *Blasphemous*).
* **Độ tương phản**: Cực cao (High Dynamic Range), đổ bóng viền sắc nét (crisp silhouette) để nổi bật hoàn hảo trên nền gạch đá tối màu của Thánh Đường Vô Tận.
* **Quy cách nền**: 
  - Với **Đạn & Hiệu ứng phát sáng (VFX)**: Nền đen tuyền **`#000000`** (giúp AI render ánh sáng phát quang chân thực, shader Godot Additive blend tự nhiên).
  - Với **Quái vật & Tài nguyên (Sprite/Entities)**: Nền xanh lá cây thuần **`#00FF00`** (để công cụ tự động bóc tách alpha trong 1 click).
* **Cách bố trí**: Xếp theo hàng ngang (Row) và cột (Column) thẳng thớm, khoảng cách đều nhau để công cụ `tools/slice_all_incoming_batches.py` cắt tự động.

---

## 📦 PHẦN 1: ĐẠN VŨ KHÍ & VỤ NỔ VA CHẠM (PROJECTILES & IMPACT BURSTS)

### 📝 Prompt 12A: Đạn Nguyên Tố Cơ Bản & Nâng Cấp (Elemental Weapon Projectiles Sheet)
> **Tên file khi lưu**: `batch_12a_projectiles.png`  
> **Quy cách nền**: Solid Black `#000000` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, high-energy elemental weapon projectiles and impact bursts for 2D top-down roguelite action game. 
Row 1: 6 frames looping Fireball projectile, molten white-hot plasma core with roaring swirling orange-crimson flame corona and trailing fire embers, pointing right. 
Row 2: 6 frames looping Frost Javelin projectile, spinning sharp cyan crystalline ice lance with shimmering diamond specular highlights and frosty cold mist trail, pointing right. 
Row 3: 6 frames looping Lightning Plasma Orb, volatile crackling violet-electric energy sphere with erratic golden arcing spark tendrils, pointing right. 
Row 4: 4 frames Fireball Impact explosion burst, expanding fireball mushroom shockwave with flying molten embers. 
Row 5: 4 frames Frost Impact burst, shattering glacial crystal fragments and frosted frostbite flash. 
Row 6: 4 frames Lightning Impact burst, radial electric discharge flash with branching yellow plasma arcs. 
Pure solid black background #000000, luminous additive glow, vibrant saturated colors, crisp edges, neatly arranged grid rows and columns --ar 16:9
```
* **Negative Prompt**:
  `characters, monsters, weapons, hands, ground floor, text, UI elements, low resolution, blurry hazy smoke, messy overlapping sprites`

---

### 📝 Prompt 12B: Đạn Vũ Khí Tiến Hóa & Tuyệt Kỹ (Evolved Weapon Projectiles & Beams)
> **Tên file khi lưu**: `batch_12b_evolved_projectiles.png`  
> **Quy cách nền**: Solid Black `#000000` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, evolved ultimate weapon projectiles for 2D fantasy survivors game. 
Row 1: 6 frames Inferno Dragon Breath wave, massive roaring crescent flame wave infused with draconic magma fire and black smoke curls, pointing right. 
Row 2: 6 frames Glacial Blizzard Shard, massive spinning snowflake razor blade of eternal ice with radiating sub-zero aura, pointing right. 
Row 3: 6 frames Tempest Judgement Railgun Bolt, blinding hyper-dense beam of violet and cyan thunder with rotating magnetic energy rings, pointing right. 
Row 4: 6 frames Cataclysmic Detonation burst, giant apocalyptic supernova burst combining fire, ice crystals, and lightning arcs. 
Pure solid black background #000000, intense neon glow, pixel art / 2D hand-drawn arcade style, perfectly spaced alignment --ar 16:9
```
* **Negative Prompt**:
  `human figures, realistic photo, watermarks, UI, messy borders, gray background, dark dull colors`

---

## 💎 PHẦN 2: TÀI NGUYÊN RƠI, NGỌC XP & RƯƠNG BÁU (COLLECTIBLES & RESOURCE BURSTS)

### 📝 Prompt 12C: Ngọc Linh Hồn XP, Tiền Vàng Cổ & Hiệu Ứng Hút Nhặt (XP Soul Gems & Coins)
> **Tên file khi lưu**: `batch_12c_gems_and_coins.png`  
> **Quy cách nền**: Solid Green `#00FF00` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, fantasy currency, soul gems, and pickup absorption visual effects for 2D roguelite. 
Row 1: 4 frames rotating/pulsing Small Soul Gem (rhombus shaped luminescent cyan crystal with gentle floating bob and diamond gleam shine). 
Row 2: 4 frames rotating/pulsing Medium Mana Shard (glowing royal sapphire prism with internal magical mist and sharp facet sparkles). 
Row 3: 4 frames rotating/pulsing Large Arcane Cluster (amethyst violet crystal cluster surrounded by faint floating runic dust). 
Row 4: 4 frames spinning Ancient Dragon Coin (ornate circular gold medallion engraved with draconic crest, shimmering metallic specular reflections). 
Row 5: 4 frames Coin Pouch / Treasure Stash (embroidered velvet red pouch overflowing with sparkling gold coins and gems). 
Row 6: 4 frames Player Absorption Sparkle Burst (bright starburst flash with floating sparkles and rising energy rings when resource is collected). 
Pure solid green background #00FF00, sharp pixel art contours, vibrant saturated gems, clean separate items, perfectly aligned --ar 16:9
```
* **Negative Prompt**:
  `characters, monsters, swords, armor, ground tiles, text, words, blurry glow spilling outside, jpeg artifacts`

---

### 📝 Prompt 12D: Trụ Nâng Cấp Huyền Bí & Rương Chiến Lợi Phẩm (World Cache Obelisk & Chests)
> **Tên file khi lưu**: `batch_12d_cache_and_chests.png`  
> **Quy cách nền**: Solid Green `#00FF00` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, interactive world shrines and loot treasure chests for 2D action roguelite. 
Row 1: 6 frames World Upgrade Monolith (mystic floating dark stone obelisk with glowing turquoise arcane runes carved along its spine, two levitating orbit crystal shards, and a pulsing magical glyph ring on the floor). 
Row 2: 3 states Wooden Scavenger Chest (State 1: Closed with iron bands; State 2: Unlocking glow; State 3: Open popping with silver coins). 
Row 3: 3 states Royal Gilded Chest (State 1: Closed ornate gold chest with ruby crest; State 2: Unlocking light beam; State 3: Open with golden pillar of light and jewels). 
Row 4: 3 states Boss Reliquary Vault (State 1: Colossal demonic obsidian coffer wrapped in glowing purple chains; State 2: Chains shattering; State 3: Open overflowing with legendary celestial relics). 
Pure solid green background #00FF00, isometric 2.5D perspective, crisp pixel art outlines, high contrast shading --ar 16:9
```
* **Negative Prompt**:
  `photo, 3d render, characters, floor tile patterns, UI menus, text, watermark`

---

## ⚔️ PHẦN 3: KỸ NĂNG, VÙNG CẢNH BÁO & QUÁI VẬT THẾ HỆ MỚI (SKILLS & REVAMPED MONSTERS)

### 📝 Prompt 12E: Vùng Chiêu Kỹ Năng & Vòng Cảnh Báo Nguy Hiểm (AoE Spells & Telegraphs)
> **Tên file khi lưu**: `batch_12e_spells_and_telegraphs.png`  
> **Quy cách nền**: Solid Black `#000000` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, top-down magical area-of-effect spells and combat threat telegraphs. 
Row 1: 6 frames Inferno Ring AoE (circular ground magic seal with rising pillars of fire and molten cracks). 
Row 2: 6 frames Glacial Frost Nova AoE (expanding circle of freezing ground frost with sharp ice stalagmites erupting upward). 
Row 3: 6 frames Lightning Storm AoE (crackle ground circle with three simultaneous vertical lightning strikes). 
Row 4: 4 frames Ominous Threat Circle (glowing crimson danger zone ring with pulsing inner warning fill and hazard runes). 
Row 5: 4 frames Boss Slam Cone Telegraph (fan-shaped red warning cone with expanding shockwave arrow indicators). 
Pure solid black background #000000, intense emissive lighting, clean geometric runes, additive blending FX, perfectly spaced rows --ar 16:9
```
* **Negative Prompt**:
  `monsters, human characters, health bars, text, labels, numbers, blurry edges, gray haze`

---

### 📝 Prompt 12F: Quái Vật Cận Chiến & Quái Bay Thế Hệ Mới (Revamped Skeleton & Dread Bat)
> **Tên file khi lưu**: `batch_12f_skeleton_and_bat.png`  
> **Quy cách nền**: Solid Green `#00FF00` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, dark fantasy monsters with high visual contrast for 2D action game. 
Character 1: "Crypt Bone Reaver" (tall menacing skeleton warrior clad in weathered dark gothic plate armor, glowing cyan spectral flames burning inside skull eye sockets, wielding a chipped heavy broadsword. Row 1: 4 frames Walk animation; Row 2: 4 frames Attack overhead cleave; Row 3: 4 frames Death bone collapse into dust). 
Character 2: "Voidwing Dread Bat" (monstrous demonic bat with razor-sharp silhouette, translucent dark purple wings with glowing neon-violet veins, glowing red multi-eyes, fanged maw. Row 4: 4 frames Flying flap animation; Row 5: 4 frames Screech sonic attack; Row 6: 4 frames Death disintegration). 
Pure solid green background #00FF00, crisp clean pixel art sprite borders, side-top down perspective, uniform sizing, isolated sprites --ar 16:9
```
* **Negative Prompt**:
  `photo, 3d render, shadows on green screen, cut-off limbs, text, watermark, human face, cartoonish cute chibi style`

---

### 📝 Prompt 12G: Quái Cảm Tử Nham Thạch & Pháp Sư Bóng Tối (Magma Exploder & Dark Sorcerer)
> **Tên file khi lưu**: `batch_12g_exploder_and_mage.png`  
> **Quy cách nền**: Solid Green `#00FF00` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, specialized dark fantasy enemies for top-down action roguelite. 
Character 1: "Volatile Cinderspark" (Kamikaze creature made of jagged obsidian stone with glowing fiery magma fissures pulsating across its body, swollen glowing lava core on back that shines with blinding heat. Row 1: 4 frames fast hunched Run; Row 2: 3 frames pre-detonation expand and flare; Row 3: 5 frames violent explosive fireball detonation). 
Character 2: "Obsidian Cultist Sorcerer" (sinister robed necromancer hovering slightly above ground, tattered black-purple robes with gold arcane trim, skeletal hands holding a floating cursed tome and a staff topped with a void crystal eye. Row 4: 4 frames hovering Idle/Walk; Row 5: 4 frames spellcasting projectile release; Row 6: 4 frames shadow death vanishing). 
Pure solid green background #00FF00, sharp edges, distinct silhouettes, dramatic lighting, no overlapping frames --ar 16:9
```
* **Negative Prompt**:
  `real photo, 3D model, blurry gradients, background floor, text, UI elements, low resolution, messy colors`

---

### 📝 Prompt 12H: Quái Tinh Anh & Đại Ma Thần Boss (Dread Knight Elite & Boss Colossus)
> **Tên file khi lưu**: `batch_12h_elite_and_boss.png`  
> **Quy cách nền**: Solid Green `#00FF00` | Tỉ lệ: `--ar 16:9`

```text
Game sprite sheet, formidable elite champion and colossal titan boss for 2D dark fantasy roguelite. 
Character 1: "Dread Knight Champion" (imposing twice-player-sized knight in jagged black obsidian plate armor with curved demonic horns, glowing crimson aura ring hovering above head, wielding a massive runic war halberd dripping with dark energy. Row 1: 4 frames menacing Walk; Row 2: 4 frames heavy Ground-shattering Strike; Row 3: 4 frames Stunned / Death roar). 
Character 2: "Gothic Colossus Titan" (gigantic ancient construct of gothic cathedral stonework, wrought iron spires, and a blinding molten arcane core pulsing in its chest, iron-fisted gauntlets with runic engravings. Row 4: 4 frames Idle breathing steam; Row 5: 4 frames devastating Two-handed Ground Smash; Row 6: 4 frames Core Overload laser discharge). 
Pure solid green background #00FF00, high contrast, dramatic rim lighting, epic scale, pixel art master quality --ar 16:9
```
* **Negative Prompt**:
  `blurry, noisy, modern city, weapons cutting out of frame, green color bleeding into characters, text, watermark`

---

## 🚀 QUY TRÌNH THỰC HIỆN DÀNH CHO BẠN / SUBAGENT

1. **Copy từng Prompt** ở trên dán vào công cụ tạo ảnh của bạn (Midjourney, DALL-E 3, SDXL, Flux, hoặc Agent Image Generator).
2. **Lưu file ảnh** với đúng tên đã gợi ý:
   - `batch_12a_projectiles.png`
   - `batch_12b_evolved_projectiles.png`
   - `batch_12c_gems_and_coins.png`
   - `batch_12d_cache_and_chests.png`
   - `batch_12e_spells_and_telegraphs.png`
   - `batch_12f_skeleton_and_bat.png`
   - `batch_12g_exploder_and_mage.png`
   - `batch_12h_elite_and_boss.png`
3. **Thả ảnh vào thư mục incoming**:
   [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Báo cho Antigravity Orchestrator: *"Tôi đã thêm ảnh"*, hệ thống sẽ chạy script cắt ghép tự động, đưa ngay vào engine Godot và cập nhật tức thì vào game!
