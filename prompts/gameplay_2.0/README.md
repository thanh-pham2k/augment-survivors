# Augment Survivors — Complete Prompt Suite & Asset Generation Guide

> **Mục tiêu**: Bộ prompt hoàn chỉnh bao phủ toàn bộ **222 hạng mục** trong file [`Augment_Survivors_Complete_Asset_Inventory.xlsx`](file:///Users/thanhpv/Documents/Work/augment-survivors/Augment_Survivors_Complete_Asset_Inventory.xlsx), phục vụ lộ trình **Gameplay 2.0 (Vertical Slice ➔ Expansion ➔ Polish)**.

---

## 🚀 Thư Mục Nhận Asset Tự Động (Single Drop-in Folder)

Bạn chỉ cần tạo ảnh từ các prompt bên dưới và thả trực tiếp file ảnh vào duy nhất một thư mục:

📂 **Đường dẫn thư mục nhận ảnh**:  
[`file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming`](file:///Users/thanhpv/Documents/Work/augment-survivors/assets/incoming)

> [!TIP]
> **Quy ước đặt tên file khi thả vào `assets/incoming/`**:  
> Bạn có thể đặt tên theo cú pháp `batch_XX_<tên_batch>.png` (ví dụ: `batch_01_player_turnaround.png`, `batch_03_starter_weapons.png`, `batch_05_relic_icons.png`). Hệ thống tự động quét, bóc tách Chroma Key `#00FF00` thành PNG trong suốt, căn chuẩn Ground Pivot và tích hợp vào Godot Engine!

---

## 📋 Danh Mục Các File Prompt Theo Nhóm (10 Batches)

| Batch | File Prompt Chi Tiết | Số Hạng Mục | Ưu Tiên | Nội Dung Chính |
| :---: | :--- | :---: | :---: | :--- |
| **00** | [`00_asset_qc_audit_manifest.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/00_asset_qc_audit_manifest.md) | **Audit 222 items** | P0 | Báo cáo kiểm định 16 sheet concept cũ vs 222 hạng mục mới (Tái sử dụng vs Vẽ bổ sung). |
| **01** | [`01_hero_core_animations.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/01_hero_core_animations.md) | **AS-001 ➔ AS-012** (12) | **P0 (Vertical Slice)** | Turnaround 4 hướng, Death tan biến, Victory, Shadow, Weapon hand sockets. |
| **02** | [`02_enemies_and_elites.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/02_enemies_and_elites.md) | **AS-013 ➔ AS-042** (30) | **P0 - P1** | Hurt/Death cho 4 quái thường + Ice Wraith + 2 Quái Tinh Anh (Bone Captain & Infernal Arcanist). |
| **03** | [`03_starter_weapons_arsenal.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/03_starter_weapons_arsenal.md) | **AS-060 ➔ AS-068** (9) | **P0 (Vertical Slice)** | 3 Vũ khí cơ sở (Inferno Staff, Storm Gauntlet, Glacial Spear): Icons, Projectiles, Attack VFX, Impacts. |
| **04** | [`04_combat_feedback_and_vfx.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/04_combat_feedback_and_vfx.md) | **AS-146 ➔ AS-165** (20) | **P0 (Vertical Slice)** | Hit flash, Impact sparks, Critical bursts, Status overlays (Burn/Freeze/Shock), Dash trails. |
| **05** | [`05_loot_equipment_and_chests.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/05_loot_equipment_and_chests.md) | **AS-082 ➔ AS-101** (20) | **P1 (Vertical Slice)** | 6 Relics (Ember Crown...), 3 Armors, Elite Chest, Boss Chest, Rarity beams, Đồng vàng xoay. |
| **06** | [`06_weapon_evolutions_and_synergies.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/06_weapon_evolutions_and_synergies.md) | **AS-069 ➔ AS-081 & AS-102 ➔ AS-122** (34) | **P1** | 6 Vũ khí tiến hóa (Meteor Rain, Hellfire Barrage...), Card frames tách chữ, Combo VFX. |
| **07** | [`07_stages_hazards_and_portals.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/07_stages_hazards_and_portals.md) | **AS-123 ➔ AS-145** (23) | **P1** | Props 3 Biome (Trụ đá, Đuốc than, Hồ dung nham, Cọc băng), Cổng An Toàn vs Cổng Tha Hóa, Lò Rèn. |
| **08** | [`08_boss_colossus_phases_and_crystals.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/08_boss_colossus_phases_and_crystals.md) | **AS-043 ➔ AS-059** (17) | **P1** | Colossus Enraged phase, Ground slam shockwave, 3 Trụ tinh thể (Intact/Damaged/Destroyed), Khiên hộ thể. |
| **09** | [`09_meta_hud_and_screens.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/09_meta_hud_and_screens.md) | **AS-166 ➔ AS-195** (30) | **P1 - P2** | UI So sánh trang bị, Bảng chọn Tiến hóa, Bảng chọn Cổng qua màn, Codex bộ sưu tập, Permanent Armory. |
| **10** | [`10_audio_sfx_and_technical_specs.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/gameplay_2.0/10_audio_sfx_and_technical_specs.md) | **AS-196 ➔ AS-222** (27) | **P0 - P2** | Bảng mô tả 5 bản nhạc BGM, toàn bộ Sound Effects (SFX) chiến đấu/loot/UI, Shaders và thông số kỹ thuật. |

---

## 🎯 Thứ Tự Ưu Tiên Triển Khai (Vertical Slice First!)

Nếu bạn muốn tạo asset theo lộ trình nhanh nhất để chơi thử ngay, hãy tạo theo thứ tự **Vertical Slice**:
1. **Batch 03**: `03_starter_weapons_arsenal.md` (Inferno Staff, Storm Gauntlet, Glacial Spear).
2. **Batch 05**: `05_loot_equipment_and_chests.md` (Loot Chest, Đồng vàng, Relic Ember Crown).
3. **Batch 06**: `06_weapon_evolutions_and_synergies.md` (Meteor Rain & Hellfire Barrage).
4. **Batch 04**: `04_combat_feedback_and_vfx.md` (Hit flash, Impact sparks, Critical bursts).
5. **Batch 01 & 02**: Hoàn thiện hoạt họa Hurt/Death cho Player và Quái vật.
