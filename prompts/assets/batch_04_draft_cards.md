# Batch 04 — Augment Draft Cards & Synergy Popups

> **Mục tiêu**: Tạo bộ thẻ bài chọn kỹ năng (Draft Cards) viền neon phát sáng và icon nguyên tố đúng 100% theo Panel 3 và Panel 4 từ ảnh gốc `references/game_ui_flow_reference.jpg`.

---

## 1. Thông Tin Kỹ Thuật

- **Background bắt buộc**: Pure solid bright green `#00FF00` (đồng nhất 100% để dễ cắt tách từng thẻ card hoàn chỉnh).
- **Hình thức**: Thẻ bài dọc UI (Vertical Tarot-style Cards) viền kim loại chạm khắc hoa văn cổ và neon dạ quang.
- **Bố cục**: 1 ảnh duy nhất gồm **6 sub-images** (lưới 3 cột × 2 hàng):
  - Hàng trên: 3 Thẻ bài Draft chính (Ember Shot, Frostbite, Arc Bolt).
  - Hàng dưới: 3 Thẻ bài kết hợp Synergy / Thẻ phụ.
- **Độ phân giải tổng thể**: 2048 × 1365 px hoặc 1024 × 682 px.

---

## 2. Đặc Tả Chi Tiết Từng Thẻ Bài (Sub-Images)

### Hàng 1 — 3 Thẻ Draft Kinh Điển (Panel 3):
1. **Card 01: EMBER SHOT (RARE)**:
   - Viền thẻ: Kim loại bạc chạm khắc hoa văn fantasy, viền trong phát sáng neon xanh lam dịu.
   - Huy hiệu đỉnh thẻ: Khung banner nhỏ chữ `RARE` phát sáng.
   - Icon trung tâm: Quả cầu lửa đỏ cam rực rỡ với các tia lửa lốc xoáy bốc lên.
   - Text nhãn: Tiêu đề `EMBER SHOT`, dòng mô tả *"Attacks apply Burning."*
   - Huy hiệu đáy thẻ: Huy hiệu tròn nhỏ chứa icon ngọn lửa 🔥.

2. **Card 02: FROSTBITE (RARE)**:
   - Viền thẻ: Kim loại chạm khắc hoa văn băng giá, viền neon xanh lam phát quang.
   - Huy hiệu đỉnh thẻ: Khung chữ `RARE`.
   - Icon trung tâm: Bông tuyết băng 6 cánh hình học ma thuật phát ánh sáng xanh ngọc tuyết trắng.
   - Text nhãn: Tiêu đề `FROSTBITE`, dòng mô tả *"Attacks slow enemies."*
   - Huy hiệu đáy thẻ: Huy hiệu tròn nhỏ chứa icon bông tuyết ❄️.

3. **Card 03: ARC BOLT (LEGENDARY)**:
   - Viền thẻ: Viền vàng kim hoàng gia (Royal Gold) tỏa hào quang vàng chói lọi, hoa văn chạm khắc tinh xảo.
   - Huy hiệu đỉnh thẻ: Khung rực lửa vàng chữ `LEGENDARY`.
   - Icon trung tâm: Tia sét vàng kim sắc nhọn đánh thẳng xuống tỏa tia điện phân nhánh.
   - Text nhãn: Tiêu đề `ARC BOLT`, dòng mô tả *"Every fourth shot chains to nearby enemies."*
   - Huy hiệu đáy thẻ: Huy hiệu tròn nhỏ chứa biểu tượng tia chớp ⚡.

### Hàng 2 — 3 Thẻ Bài / Synergy Evolution (Panel 4 & Mở Rộng):
4. **Card 04: BURNING CHAIN (SYNERGY)**:
   - Viền kết hợp đôi: Lửa vàng cam hòa trộn tia điện vàng kim.
   - Icon trung tâm: Dây xích bốc lửa phát tán tia sét ma thuật.
   - Text nhãn: Tiêu đề `BURNING CHAIN`, mô tả *"Burning enemies can chain lightning to 2 nearby enemies."*
   - Huy hiệu đáy: Biểu tượng kép `🔥 + ⚡`.

5. **Card 05: FROST CONDUIT (SYNERGY)**:
   - Viền thẻ: Tinh thể băng xanh lam kết hợp viền điện tím/vàng.
   - Icon trung tâm: Tinh thể băng dẫn truyền dòng điện cao thế.
   - Text nhãn: Tiêu đề `FROST CONDUIT`, mô tả *"Chilled enemies struck by chain lightning discharge freezing shockwave."*
   - Huy hiệu đáy: Biểu tượng kép `❄️ + ⚡`.

6. **Card 06: WILDFIRE (COMMON)**:
   - Viền đồng cổ điển (Bronze frame).
   - Icon trung tâm: Ngọn lửa lây lan bùng nổ sang nhiều hướng.
   - Text nhãn: Tiêu đề `WILDFIRE`, mô tả *"Burning spreads to nearby enemies on death."*

---

## 3. Prompt Tiếng Anh (Dùng Trực Tiếp Cho AI Generator)

```text
A UI graphic asset sheet featuring 6 collectible fantasy roguelite tarot-style skill cards on a flat solid bright green #00FF00 background, arranged in a neat grid (3 columns by 2 rows). 
Each card has a dark slate interior, intricate metallic fantasy borders with glowing neon runes, an elemental icon, crisp typography, and bottom icon badge.
Row 1 (3 iconic cards from reference):
Card 1: 'EMBER SHOT' (RARE) - silver-blue neon border, flaming fireball icon swirling with embers, labeled 'Attacks apply Burning.', flame badge at bottom.
Card 2: 'FROSTBITE' (RARE) - crystalline cyan neon border, intricate geometric ice snowflake icon, labeled 'Attacks slow enemies.', frost badge at bottom.
Card 3: 'ARC BOLT' (LEGENDARY) - glowing radiant golden filigree border, crackling golden lightning bolt icon, labeled 'Every fourth shot chains to nearby enemies.', thunder badge at bottom.
Row 2 (3 synergy cards):
Card 4: 'BURNING CHAIN' (SYNERGY) - fiery electric dual-element aura border, flaming lightning chain icon, labeled 'Burning enemies chain lightning.', fire+lightning badge.
Card 5: 'FROST CONDUIT' (SYNERGY) - frozen electrified crystal border, ice shockwave icon.
Card 6: 'WILDFIRE' - bronze runic border, spreading fire inferno icon.
Crisp high-resolution vector game UI quality, perfectly vertical rectangular cards, clean edges for cropping.
```
