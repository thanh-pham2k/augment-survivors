# Batch 00 — Báo Cáo Kiểm Định Asset (Asset QC & Audit Manifest)

> **Mục tiêu**: Đối chiếu 16 Concept Batches đã có trong project với danh mục 222 hạng mục của Gameplay 2.0 để xác định chính xác: **Cái gì tái sử dụng 100%**, **Cái gì cần vẽ bổ sung trạng thái**, và **Cái gì cần tạo mới hoàn toàn**.

---

## 1. Bảng Đối Chiếu 16 Concept Sheet Hiện Có

| Concept Sheet Cũ | Tình Trạng Hiện Tại Trong Godot | Hạng Mục Inventory Tương Ứng | Kết Luận QC & Hướng Xử Lý |
| :--- | :--- | :--- | :--- |
| **Batch 01: Player Movement** | Đã cắt 8 frames (Idle 4f + Run 4f) tại `assets/final_sprites/player/` | AS-002, AS-003 | ✅ **TÁI SỬ DỤNG**: Hoạt họa hướng phải đã hoạt động mượt mà. Cần tạo thêm Turnaround 4 hướng (AS-001) và Death (AS-007). |
| **Batch 02: Player Combat** | Đã cắt Cast 4f, Dash 2f, Hurt 2f tại `assets/final_sprites/player/` | AS-004, AS-005, AS-006 | ✅ **TÁI SỬ DỤNG**: Đã tích hợp vào `player.tscn`. Cần thêm VFX vệt tàn lửa Dash (AS-158) và Death tan biến (AS-007). |
| **Batch 03: Skeleton Warrior** | Đã cắt Walk 4f + Attack 4f tại `assets/final_sprites/skeleton/` | AS-013, AS-014, AS-015 | ✅ **TÁI SỬ DỤNG**: Đang chạy làm quái cơ bản. Cần bổ sung Hurt (AS-016) và Death vụn xương (AS-017). |
| **Batch 04: Shadow Bat** | Đã cắt Fly 4f + Dive 4f tại `assets/final_sprites/bat/` | AS-018, AS-019, AS-020 | ✅ **TÁI SỬ DỤNG**: Đang bay lượn mượt mà. Cần bổ sung Hurt (AS-021) và Death tan biến bóng đêm (AS-022). |
| **Batch 05: Boss Colossus** | Đã cắt 6 frames tại `assets/final_sprites/boss_colossus/` | AS-043, AS-044, AS-045, AS-046, AS-048 | ✅ **TÁI SỬ DỤNG**: Đang dùng cho Trùm Colossus. Cần bổ sung Enrage Phase (AS-049) và Death sụp đổ dung nham (AS-050). |
| **Batch 06: Elemental VFX** | Đã cắt Cầu lửa, Sét, Nổ hơi nước tại `assets/sprites/` | AS-146, AS-154, AS-155 | ⚠️ **CẦN MỞ RỘNG**: Đủ cho prototype cơ bản nhưng thiếu Impact Sparks, Critical Burst và Status overlays (AS-147 -> AS-153). |
| **Batch 07 & 10: 12 Tarot Cards** | Đã cắt đủ 12 thẻ tại `assets/sprites/card_*.png` | AS-102 -> AS-113 | ✅ **TÁI SỬ DỤNG**: Đã tích hợp vào `AugmentDraftUI`. Về lâu dài nên tạo Card Frame trống (AS-114 -> AS-117) để hiển thị chữ động. |
| **Batch 08: Main Menu BG** | Đã tích hợp tại `assets/sprites/menu_background.png` | AS-166 | ✅ **TÁI SỬ DỤNG 100%**: Nền sạch không chữ, chuẩn 1920×1080. |
| **Batch 09: Menu UI Buttons** | Đã cắt 5 nút kim loại + Logo 3D tại `assets/sprites/` | AS-167, AS-168 | ✅ **TÁI SỬ DỤNG**: Đã chạy trên màn hình Main Menu. |
| **Batch 11: Cathedral Floor** | Đã blend torus zero-seam tại `assets/sprites/endless_floor_tile.png` | AS-123 | ✅ **TÁI SỬ DỤNG 100%**: Ghép vô tận không vết lằn gạch. |
| **Batch 12: Dark Mage Cultist** | Đã cắt 8 frames tại `assets/final_sprites/dark_mage/` | AS-023, AS-024, AS-025 | ✅ **TÁI SỬ DỤNG**: Quái bắn phép bay lượn mượt mà. Cần bổ sung Hurt (AS-026) và Death (AS-027). |
| **Batch 13: Kamikaze Exploder** | Đã cắt 8 frames tại `assets/final_sprites/exploder/` | AS-028, AS-029, AS-030 | ✅ **TÁI SỬ DỤNG**: Quái phát nổ tự sát mượt mà. Cần bổ sung Death vụ nổ lớn (AS-032). |
| **Batch 14: Magma Biome Tile** | Đã blend torus zero-seam tại `assets/sprites/biome_magma_tile.png` | AS-129 | ✅ **TÁI SỬ DỤNG 100%**: Dùng làm nền Màn 2. |
| **Batch 15: Frost Biome Tile** | Đã blend torus zero-seam tại `assets/sprites/biome_frost_tile.png` | AS-135 | ✅ **TÁI SỬ DỤNG 100%**: Đã khử sạch vệt nứt dọc, dùng cho Màn 3. |
| **Batch 16: Boss HP Bar Frame** | Đã tích hợp tại `assets/sprites/boss_hp_bar_frame.png` | AS-184 | ✅ **TÁI SỬ DỤNG 100%**: Đang hiển thị thanh máu Trùm trên đầu màn hình. |

---

## 2. Danh Sách Những Asset Mới BẮT BUỘC Phải Sản Xuất (Missing Gap)

Các nhóm sau **hoàn toàn chưa có trong game** và là trọng tâm sản xuất của Gameplay 2.0:

1. **Bộ Vũ Khí & Tiến Hóa (Weapons & Evolutions — AS-060 ➔ AS-081)**:
   - 3 Vũ khí cơ sở: *Inferno Staff, Storm Gauntlet, Glacial Spear* (Icon, đạn, vệt bắn, va chạm).
   - 6 Nhánh Tiến Hóa: *Meteor Rain, Hellfire Barrage, Thunderstorm, Voltaic Lance, Frozen Tempest, Glacial Impaler*.
2. **Hệ Thống Trang Bị & Hòm Báu (Loot & Equipment — AS-082 ➔ AS-101)**:
   - 6 Nhẫn/Vương miện/Găng tay Relic (Ember Crown, Vampire Ring, Frost Armor, Berserker Gloves...).
   - 3 Áo giáp Armor (Ember Mantle, Glacial Plate, Shadowguard).
   - Rương báu vật Elite Chest & Boss Chest (Trạng thái Đóng / Mở).
   - Đồng tiền vàng xoay 3D (Gold Coin spin) & Vệt nam châm hút vàng.
3. **Quái Vật Mới & Tinh Anh (Elites & Ice Wraith — AS-033 ➔ AS-042)**:
   - *Ice Wraith*: Bóng ma băng giá phóng mảnh băng làm chậm.
   - *Elite Bone Captain*: Đội trưởng xương giáp sắt khổng lồ cầm đại kiếm.
   - *Elite Infernal Arcanist*: Đại pháp sư hỏa ngục bay lơ lửng phóng hỏa cầu kép.
4. **Cổng Dịch Chuyển & Đạo Cụ Tương Tác (Portals & Props — AS-141 ➔ AS-145)**:
   - *Cổng An Toàn (Safe Portal - Màu Lam Huyền Ảo)*.
   - *Cổng Tha Hóa (Corrupted Portal - Màu Đỏ Hư Không)*.
   - *Bàn Lò Rèn Hắc Thiết (Blacksmith Forge Station)*.
5. **UI So Sánh & Mở Khóa (Gameplay 2.0 Modals — AS-176 ➔ AS-181)**:
   - Giao diện so sánh trang bị (Equip vs Replace vs Salvage).
   - Giao diện chọn 1 trong 2 nhánh Tiến Hóa Vũ Khí.
