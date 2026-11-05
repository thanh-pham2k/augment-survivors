# Batch 09 — Giao Diện & Màn Hình Tính Năng (HUD, Modals & Meta Screens)

> **Mã hạng mục trong Inventory**: `AS-166` ➔ `AS-195`  
> **Độ ưu tiên**: **P1 (Modal Gameplay) & P2 (Meta-Progression Screens)**  
> **Tên file khi lưu để thả vào incoming**: `batch_09_ui_modals_screens.png`

---

## 🎨 Thông Số Kỹ Thuật (Production Contract)
* **Phong cách UI**: Dark Fantasy Gothic RPG (tương tự *Diablo*, *Hades*, *Brotato*), viền đá đen chạm khắc vàng kim, ngọc hồng ngọc và ngọc lam đính góc.
* **Tách rời Text**: Toàn bộ khung modal, thẻ bài, nút bấm phải **hoàn toàn sạch chữ (No text baked in)** để Godot render Label động.
* **Quy cách nền**: Nền xanh lá cây thuần **`#00FF00`** (Pure Green Screen) hoặc Nền trong suốt PNG.

---

## 📝 Prompt 9A: 3 Hộp Thoại Quyết Định Gameplay (Comparison, Evolution & Portal Modals)

Bao gồm 3 giao diện quyết định quan trọng nhất trong run chơi:
1. **Loot Comparison Modal**: So sánh món đồ đang đeo vs món đồ mới nhặt từ rương.
2. **Evolution Choice Modal**: Chọn 1 trong 2 nhánh Tiến hóa vũ khí.
3. **Stage Portal Choice Modal**: Chọn Cổng An Toàn hay Cổng Tha Hóa.

```text
Game UI sprite sheet, 3 dark fantasy decision modal dialog frames for 2D roguelite. Panel 1: Loot Item Comparison Panel (ornate gothic stone double-window frame with gold filigree, left slot labeled for current gear and right slot for new gear, completely blank inside, bottom area for 3 action buttons). Panel 2: Weapon Evolution Selection Panel (majestic dual-card pedestal frame with glowing runic header ribbon reading "WEAPON ASCENSION", two ornate empty card display slots side-by-side). Panel 3: Stage Portal Selection Panel (stone archway frame with two portal viewports, one with glowing blue trim and one with ominous red spike trim). Pure solid green background #00FF00, razor-sharp vector/pixel UI borders, modular layout without text baked in --ar 16:9
```

* **Negative Prompt**:
  `photo, messy illustrations, pre-baked long text, watermark, blurry textures, character portraits baked into slots`

---

## 📝 Prompt 9B: Màn Hình Mở Khóa, Bách Khoa Toàn Thư & Độ Khó (Codex, Armory & Ascension)

Dành cho hệ thống lưu giữ tiến trình chơi lâu dài (Meta-Progression):

```text
Game UI sprite sheet, meta-progression screens and collection assets. Panel 1: Codex Collection Grid (ornate dark parchment background with 12 square item inventory slots with locked mystery padlock silhouettes). Panel 2: Permanent Armory Loadout Frame (character display pedestal in center with 3 empty equipment slots: Weapon, Armor, Relic, framed in antique brass). Panel 3: Ascension Difficulty selector dial (gothic circular wheel with 5 skull threat levels from novice to torment). Pure solid green background #00FF00, crisp clean UI layout, 2D game interface, symmetrical design --ar 16:9
```

* **Negative Prompt**:
  `realistic photo, 3D room, blurry buttons, words, text, unaligned elements`

---

## 🛠️ Hướng Dẫn Tích Hợp
1. Tạo ảnh từ 1 trong 2 prompt trên (hoặc cả hai).
2. Lưu file với tên:
   - `batch_09_decision_modals.png`
   - `batch_09_meta_codex_screens.png`
3. Thả vào thư mục: [`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)
4. Hệ thống sẽ bóc tách và tích hợp vào các scene UI (`armory_shop_ui.tscn`, `loot_choice_modal.tscn`, `evolution_modal.tscn`).
