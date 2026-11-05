# Quy Chuẩn Tạo Asset Theo Batch — HOÀN TẤT 100%

> **Trạng thái**: Tất cả các Batch Asset (Bản đồ Đấu trường, Hoạt họa Nhân vật, Kẻ địch, Boss, VFX, Màn hình Menu Chính và toàn bộ 12 Thẻ bài Nâng cấp Tarot) đã được tạo, bóc tách Chroma Key, chuẩn hóa Ground Pivot Lock và tích hợp thành công vào Game Engine Godot 4!

---

## 1. Bảng Tổng Kết Trạng Thái Toàn Bộ Batch

| Mã Batch | File Prompt (Đã hoàn thành) | Số Sub-images | Nội dung chính | Trạng thái |
| :---: | :--- | :---: | :--- | :---: |
| **00** | [`arena_map_background_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/arena_map_background_done.md) | **1 ảnh (16:9)** | Bản đồ Đấu trường đá cổ 1920×1080, 4 cột trụ đuốc than rực lửa, vòng ma pháp rune. | ✅ **ĐÃ XONG** |
| **01** | [`01_player_movement_8f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/01_player_movement_8f_done.md) | **8 frames** (4x2) | Hoạt họa thở (Idle 4f) & Chạy (Run 4f) Anime Flame Mage độ nét cao. | ✅ **ĐÃ XONG** |
| **02** | [`02_player_combat_8f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/02_player_combat_8f_done.md) | **8 frames** (4x2) | Chưởng phóng cầu lửa (Cast 4f) + Lướt tàn lửa (Dash 2f) + Trúng đòn (Hurt 2f). | ✅ **ĐÃ XONG** |
| **03** | [`03_skeleton_warrior_8f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/03_skeleton_warrior_8f_done.md) | **8 frames** (4x2) | Lính xương Skeleton: Bước đi (Walk 4f) + Chém kiếm vệt sáng (Slash 4f). | ✅ **ĐÃ XONG** |
| **04** | [`04_shadow_bat_8f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/04_shadow_bat_8f_done.md) | **8 frames** (4x2) | Dơi quỷ tím Shadow Bat: Vỗ cánh bay (Fly 4f) + Lao bổ nhào (Dive 4f). | ✅ **ĐÃ XONG** |
| **05** | [`05_boss_colossus_6f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/05_boss_colossus_6f_done.md) | **6 frames lớn** (3x2) | Boss Khổng lồ Nham thạch: Thở nham thạch (2f) + Đập sàn (2f) + Quét quạt (2f). | ✅ **ĐÃ XONG** |
| **06** | [`06_elemental_vfx_8f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/06_elemental_vfx_8f_done.md) | **8 items** (4x2) | Cầu lửa bay & nổ tung + Tia sét Arc Bolt + Vụ nổ hơi nước Steam Burst. | ✅ **ĐÃ XONG** |
| **07** | [`07_augment_draft_cards_6f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/07_augment_draft_cards_6f_done.md) | **6 cards** (3x2) | Bộ 6 thẻ bài Tarot Ultra HD: Ember Shot, Frostbite, Arc Bolt & Synergies. | ✅ **ĐÃ XONG** |
| **08** | [`08_main_menu_background_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/08_main_menu_background_done.md) | **1 ảnh (16:9)** | Bức tranh nền Main Menu sạch 100% không text (Pháp sư góc trái, lâu đài gothic trăng máu). | ✅ **ĐÃ XONG** |
| **09** | [`09_menu_ui_buttons_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/09_menu_ui_buttons_done.md) | **5 items** (1x5) | Logo 3D "AUGMENT SURVIVORS" vàng kim hoàng gia & Bộ nút bấm chạm khắc kim loại. | ✅ **ĐÃ XONG** |
| **10** | [`10_weapon_and_catalyst_cards_6f_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/10_weapon_and_catalyst_cards_6f_done.md) | **6 cards** (3x2) | Bộ 6 thẻ bài Tarot còn lại: Reaction Catalyst, Overload, Shatter, Close Quarters, Multi-Shot, Wide Arc. | ✅ **ĐÃ XONG** |
| **11** | [`11_endless_dungeon_floor_tiles_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/11_endless_dungeon_floor_tiles_done.md) | **1 ảnh (1:1)** | Texture nền gạch đá cổ Gothic vô tận (Seamless Tiling Ground 1024x1024). | ✅ **ĐÃ XONG** |
| **12** | [`12_dark_mage_cultist_spritesheet_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/12_dark_mage_cultist_spritesheet_done.md) | **8 frames** (4x2) | Quái Pháp sư Bắn xa Dark Mage: Di chuyển lơ lửng (4f) + Tụ cầu hắc ám & Bắn (4f). | ✅ **ĐÃ XONG** |
| **13** | [`13_kamikaze_exploder_spritesheet_done.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/prompts/assets/13_kamikaze_exploder_spritesheet_done.md) | **8 frames** (4x2) | Quái Tự sát Kamikaze Ghoul: Chạy nước rút cuồng bạo (4f) + Nạp xung nổ lửa (4f). | ✅ **ĐÃ XONG** |

---

## 2. Quy Chuẩn Kỹ Thuật Đã Áp Dụng
1. **Chroma Key `#00FF00`**: Toàn bộ viền xanh lá được xử lý trong suốt tuyệt đối không lem màu.
2. **Ground Pivot Lock**: Chân của nhân vật và quái được neo cố định tại cùng tọa độ Y trên canvas 128×128 (và 256×256 cho Boss), triệt tiêu hoàn toàn hiện tượng trượt chân hoặc giật nhấp nhô.
3. **Loại Bỏ Hoàn Toàn Chồng Chữ**: Màn hình Run Results và Main Menu sử dụng 100% nền tranh thuần không chữ và render các nút bấm / Logo độc lập bằng Godot UI.
4. **100% Thẻ Bài Đạt Chuẩn Tarot Ultra HD**: Toàn bộ 12 lõi nâng cấp đều có thẻ bài mỹ thuật riêng biệt, không còn bất kỳ ô thẻ tạm (fallback) nào!
