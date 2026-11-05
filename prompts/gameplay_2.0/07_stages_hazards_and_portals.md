# Batch 07 — Đạo Cụ Bản Đồ, Cạm Bẫy & Cổng Dịch Chuyển (Stages, Hazards & Portals)

> **Mã hạng mục trong Inventory**: `AS-123` ➔ `AS-145`  
> **Độ ưu tiên**: **P1 (Tạo chiều sâu môi trường và lựa chọn qua màn)**  
> **Tên file khi lưu để thả vào incoming**: `batch_07_stages_props_and_portals.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Góc nhìn**: Isometric 2.5D Top-Down, góc xiên $45^\circ$, phối cảnh đồng bộ với nhân vật và quái.
* **Quy cách vật thể**: Tất cả vật thể (cột trụ, bẫy dung nham, cổng, bàn rèn) là **Sprite độc lập**, không vẽ dính vào nền sàn để Godot thực hiện Y-sort sắp xếp chiều sâu thứ tự đứng trước/sau.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen).

---

## 📝 Prompt 7A: Đạo Cụ 3 Vùng Đất & Cạm Bẫy Môi Trường (3 Biomes Environmental Props)

Bao gồm cột trụ đá, đuốc than cháy, hố dung nham sôi sùng sục, cọc băng nứt và bàn thờ Rune cổ:

```text
Game sprite sheet, environmental props and hazard obstacles for 2D isometric dark fantasy roguelite. Row 1: Cathedral props - (1) broken gothic stone pillar, (2) ornate metal fire brazier with 4 frames animated flickering flame, (3) tattered crimson wall banner with golden lion crest, (4) ancient stone rune altar with glowing blue glyphs. Row 2: Infernal props - (5) bubbling molten lava pit hazard with magma splatter, (6) jagged volcanic obsidian rock formation, (7) active steam vent cracking open with fiery glow. Row 3: Frozen Sanctum props - (8) sharp translucent ice crystal pillar, (9) dangerous cracked slippery ice sheet hazard, (10) frozen ancient skeleton trapped inside ice block. Solid green background #00FF00, isometric 2.5D angle, clean outlines, sharp pixel art textures, separated grid cells --ar 16:9
```

* **Negative Prompt**:
  `photo, 3D render, flat top-down 90-degree, text, modern architecture, blurry haze, messy edges, objects touching each other`

---

## 📝 Prompt 7B: Cặp Cổng Qua Màn & Trạm Lò Rèn Hắc Thiết (Safe/Corrupted Portals & Forge)

Bao gồm Cổng An Toàn (Safe Portal), Cổng Tha Hóa (Corrupted Portal) và Bàn Thợ Rèn (Blacksmith Forge):

```text
Game sprite sheet, fantasy portals and blacksmith station for 2D roguelite stage transitions. Section 1: Safe Portal (soothing ethereal cyan and sapphire swirling vortex portal, floating celestial rune stones rotating in a circle, gentle glowing particles). Section 2: Corrupted Portal (chaotic crimson-red and violet void vortex portal, jagged barbed thorns, dark purple mist, aggressive pulsing fiery energy). Section 3: Blacksmith Forge Station (heavy dark iron anvil, roaring stone furnace glowing with molten gold metal, glowing runic smithing hammer resting on table, ornate tools). Solid green background #00FF00, aligned grid rows, rich saturated fantasy colors, crisp 2.5D isometric perspective --ar 16:9
```

* **Negative Prompt**:
  `characters, monsters, text, labels, watermark, photographic, uneven spacing, blurry borders`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_07_biome_props_hazards.png`
   - `batch_07_portals_and_forge.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ bóc tách và tích hợp `SafePortal` và `CorruptedPortal` vào màn chơi, giúp người chơi tự do chọn đường an toàn hoặc đường mạo hiểm săn đồ hiếm!
