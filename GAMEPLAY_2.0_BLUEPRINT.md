# Augment Survivors — Gameplay 2.0 Canonical Blueprint & Architecture Guide

> **Mục tiêu**: Định hình lại trải nghiệm chơi game theo triết lý **Elemental Build-Crafting Roguelite**: Tập trung vào vòng lặp phần thưởng (Reward Loop), danh tính vũ khí (Weapon Identity), tiến hóa có điều kiện (Branching Evolution) và kiến trúc sạch trên Godot 4.

---

## 1. Triết Lý Cốt Lõi (Core Philosophy)

1. **Thay đổi Về Chất thay vì Về Lượng (Qualitative over Quantitative)**:
   - Một nâng cấp vũ khí hay Augment tốt phải thay đổi hình thái đạn, quỹ đạo, cự ly và hành vi chiến đấu của người chơi, không chỉ tăng +10% flat damage đơn điệu.
2. **Triệt tiêu "Chạy Vòng Tròn" (Positioning & Spatial Depth)**:
   - Mỗi vũ khí đòi hỏi vị trí đứng khác nhau (ví dụ: *Inferno Staff* tối ưu sát thương khi bắn cự ly gần để trúng cả chùm tia; *Glacial Spear* đòi hỏi căn thẳng hàng để đâm xuyên).
   - Quái vật và môi trường tạo áp lực ép người chơi phải Dash và đổi hướng di chuyển.
3. **Vòng Lặp Phần Thưởng Rõ Ràng (Reward Loop)**:
   $$\text{Combat} \rightarrow \text{Kill Elite/Boss} \rightarrow \text{Drop Loot Chest} \rightarrow \text{Equip/Replace/Salvage (3 Slots)} \rightarrow \text{Build Transformation}$$
4. **Không Thêm Nút Bấm Chủ Động (Passive-Trigger Only)**:
   - Giữ vững thao tác thư giãn: **WASD di chuyển + Space Dash**.
   - Mọi hiệu ứng của Weapon, Armor, Relic đều là Passive Trigger (On-Hit, On-Dash, On-Kill, Low-HP) để không làm rối tay người chơi.

---

## 2. Hệ Thống Vũ Khí & Tiến Hóa Cành Nhánh (Weapon Evolution)

### 2.1. Ba Vũ Khí Khởi Đầu
1. **Inferno Staff (Hỏa Trượng)**: Phóng chùm đạn quạt lửa (Spread Shot), sát thương cực lớn ở cự ly gần.
2. **Storm Gauntlet (Lôi Thủ)**: Bắn tia điện tự động nhảy xích qua nhiều mục tiêu gần nhau (Chain Damage).
3. **Glacial Spear (Băng Thương)**: Phóng ngọn giáo băng đâm xuyên thấu hàng dọc (Pierce) và làm chậm kẻ địch (Chill).

### 2.2. Công Thức Tiến Hóa (Evolution Formula)
Vũ khí đạt **Lv.3** sẽ mở khóa khả năng tiến hóa dựa trên điều kiện xúc tác:

| Vũ khí Lv.3 | Điều kiện Xúc tác (Augment Catalyst) | Nhánh Tiến Hóa (Evolution Branch) | Cơ chế & Hình thái mới |
| :--- | :--- | :--- | :--- |
| **Inferno Staff** | Có `Ember Shot` (hoặc Fire Augment) | **Meteor Rain** | Triệu hồi mưa thiên thạch rơi ngẫu nhiên vùng lớn, sát thương diện rộng (AoE control). |
| **Inferno Staff** | Có `Multi-Shot` (hoặc Projectile Augment) | **Hellfire Barrage** | Xả liên hoàn 7 hỏa tiễn dồn về mục tiêu đơn lẻ với tốc độ cực cao (Boss killer). |
| **Inferno Staff** | *Không có Augment kết hợp (Xui rủi)* | **Inferno Mastery** | Nhánh cứu cánh: Tăng mạnh kích thước tia lửa, góc quạt rộng và sát thương cơ bản để không bị "phế". |

---

## 3. Hệ Thống Trang Bị & Hòm Báu (Equipment & Loot)

- **3 Slot Trang Bị Tinh Gọn**:
  1. `Weapon Slot`: Vũ khí chính quyết định hình thức tấn công.
  2. `Armor Slot`: Phòng thủ hoặc trao đổi rủi ro (ví dụ: *Frost Armor* — Đóng băng quái xung quanh khi nhận sát thương; *Berserker Cloak* — Càng thấp máu sát thương càng cao).
  3. `Relic Slot`: Hiệu ứng thay đổi toàn bộ lối chơi (ví dụ: *Ember Crown* — Hiệu ứng Cháy lây lan sang quái xung quanh khi quái chết).
- **Cơ chế Nhặt Đồ (Loot Loop)**:
  - Quái Tinh Anh (Elite Champion) hoặc Boss bị tiêu diệt rớt **Loot Chest**.
  - Người chơi bước vào mở ra UI so sánh trực tiếp: Món mới vs Món đang mang trong Slot -> Lựa chọn: **Trang bị (Equip)** / **Thay thế (Replace)** / **Phân tách lấy Vàng (Salvage)**.

---

## 4. Kiểm Soát Xác Suất Ngẫu Nhiên (Weighted Draft & Build Direction)

- **Weighted Draft (Xác suất có định hướng)**:
  - Khi người chơi chọn *Inferno Staff*, các thẻ Augment hệ Hỏa (Fire) sẽ được tăng trọng số xuất hiện (Weight multiplier = 1.6x).
  - Người chơi dễ dàng định hình phong cách chơi mong muốn nhưng vẫn giữ yếu tố bất ngờ của Roguelite.
- **Reroll Từng Thẻ Riêng Biệt**:
  - Giữ nguyên cơ chế Reroll từng slot thẻ trong bảng chọn Augment bằng tài nguyên xúc xắc mua tại Lò Rèn hoặc thưởng khi lên cấp.

---

## 5. Quy Chuẩn Kiến Trúc Kỹ Thuật (Godot 4 Architecture Standards)

### 5.1. Tách Biệt Data (`Resource`) vs Runtime (`Controller/Node`)
> [!CAUTION]
> **Tuyệt đối không lưu runtime state (current level, cooldown, dynamic buffs) trực tiếp vào file `.tres`!** Godot Engine chia sẻ bộ nhớ cache giữa các instance Resource, gây lỗi dirty data nhiễm chéo giữa các Run.

- **Data Definition (`Resource`)**:
  - `WeaponData.gd` (`res://scripts/weapons/weapon_data.gd`): Chứa base stats, projectile scene, sprite texture, sound fx, evolution tree.
  - `EquipmentData.gd` (`res://scripts/equipment/equipment_data.gd`): Chứa icon, slot type (Weapon/Armor/Relic), base modifiers.
- **Runtime Behavior (`Node`)**:
  - `WeaponController.gd` (`res://scripts/weapons/weapon_controller.gd`): Gắn trực tiếp lên `Player`. Quản lý `current_level`, `cooldown_timer`, `fire_rate`, bắn đạn thực tế.
  - `EquipmentController.gd` (`res://scripts/equipment/equipment_controller.gd`): Gắn trên `Player`. Quản lý 3 slot trang bị đang đeo, lắng nghe tín hiệu từ `CombatEventBus`.

### 5.2. Chống Đệ Quy Vô Hạn Trên Event Bus (Anti-Recursion Trigger Guards)
- Bổ sung `event_depth: int` và `source_tag: String` trong mọi sự kiện kích hoạt nguyên tố:
  - Nếu `Lửa` kích hoạt `Sét`, event depth = 1.
  - Nếu `Sét` kích hoạt lan `Lửa`, event depth = 2.
  - Khi `event_depth >= 2`, ngăn không cho kích hoạt chu kỳ lặp tiếp theo, giữ vững giới hạn **Proc Budget (tối đa 150 procs/tick)** và bảo vệ FPS không bao giờ bị tụt.

---

## 6. Lộ Trình Triển Khai (Roadmap) & Kế Hoạch "Vertical Slice"

### Giai Đoạn 1: Lát Cắt Dọc Chuẩn Mực (Vertical Slice)
Không triển khai dàn hàng ngang. Hoàn thiện và nghiệm thu 1 chu trình hoàn chỉnh từ đầu đến cuối:
1. **Inferno Staff** (Chùm đạn lửa, cảm giác cự ly gần xa).
2. **1 Quái Elite** rớt **Loot Chest**.
3. **1 Relic** (`Ember Crown` lây lan cháy).
4. **1 Công thức Tiến hóa**: Staff Lv.3 + Ember Shot $\rightarrow$ *Meteor Rain* / *Hellfire Barrage* / *Inferno Mastery*.
5. **Playtest nghiệm thu**: Đạt 60 FPS, cảm giác bắn "đã tay", lựa chọn có sức nặng.

### Giai Đoạn 2: Mở Rộng Nội Dung Ngang (Horizontal Expansion)
- Thêm **Storm Gauntlet** và **Glacial Spear** cùng cây tiến hóa tương ứng.
- Bổ sung các trang bị Armor và Relic cho hệ Băng và Lôi.
- Thêm cơ chế **Cổng An Toàn (Safe) vs Cổng Tha Hóa (Corrupted)** với modifier độ khó và tỉ lệ rớt rương báu hiếm.
- Hoàn thiện 3 Phase của Boss Ancient Colossus.
