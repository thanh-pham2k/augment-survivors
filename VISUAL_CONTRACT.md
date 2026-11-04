# Visual Contract & UI Flow Reference — Augment Survivors

Tài liệu quy định chuẩn hình ảnh, UI layout và flow màn hình dựa trên Concept Board chính thức của **Augment Survivors** (`references/game_ui_flow_reference.jpg`). Mọi subagent (`combat-engineer`, `synergy-architect`, `qa-benchmarker`) phải tuân theo cấu trúc visual và dữ liệu này khi thực hiện các task.

---

## 1. Bản Đồ 6 Màn Hình Chính (Screen Flow)

Tham chiếu ảnh gốc: `references/game_ui_flow_reference.jpg`

```
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  1. MAIN MENU   │ ──> │ 2. EARLY COMBAT  │ ──> │ 3. AUGMENT DRAFT │
└─────────────────┘     └──────────────────┘     └──────────────────┘
                                 │                        │
                                 ▼                        ▼
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  6. RUN RESULTS │ <── │  5. BOSS FIGHT   │ <── │ 4. SYNERGY COMBAT│
└─────────────────┘     └──────────────────┘     └──────────────────┘
```

---

## 2. Chi Tiết Từng Màn Hình & Yêu Cầu Kỹ Thuật

### 1. Main Menu
- **Visual Style**: Dark fantasy, rực lửa, lâu đài đổ nát với mặt trăng máu.
- **Hero Pose**: Pháp sư áo choàng đỏ/đen với quả cầu lửa trên tay trái.
- **Buttons**:
  - `START RUN` (Nút chính, hiệu ứng vàng kim sáng)
  - `CONTINUE`
  - `AUGMENT CODEX` (Xem danh mục các lõi và công thức synergy đã khám phá)
  - `SETTINGS`

### 2. Early Gameplay (Combat Pacing ~00:45)
- **Top HUD**:
  - Avatar nhân vật + Level (`Lv. 3`)
  - HP Bar (`120 / 120`)
  - Timer chính giữa (`00:45`) kèm Timeline Milestone Bar (thanh tiến trình có icon Skull/Milestones)
  - Kill count (`72`) + Nút Pause `||`
- **Bottom HUD**:
  - Augment Slots (6 ô vuông hiển thị lõi hiện có, ô 1: `Ember Shot Lv. 1`)
  - Dash Cooldown Button góc phải (`4.2s` cooldown)
- **Combat Field**:
  - Hero bắn đạn lửa 3 tia (Fan pattern / Spread shots)
  - Quái: Skeleton Warriors (Swarm Chasers) cầm kiếm + Dơi tím (Flankers)
  - Đấu trường hình tròn lát đá tối màu, có cột đuốc rực lửa 4 góc.

### 3. Augment Draft (Chọn 1 trong 3)
- **Header**: "CHOOSE YOUR AUGMENT"
- **3 Thẻ bài Draft**:
  1. **Ember Shot** (RARE / Viền xanh lam neon): *"Attacks apply Burning."* (Icon cầu lửa đỏ)
  2. **Frostbite** (RARE / Viền xanh lam neon): *"Attacks slow enemies."* (Icon bông tuyết băng)
  3. **Arc Bolt** (LEGENDARY / Viền vàng kim hào quang): *"Every fourth shot chains to nearby enemies."* (Icon tia chớp vàng)
- **Bottom Draft Bar**:
  - `Current Build`: 6 ô hiển thị các Augment đang sở hữu
  - `REROLL (2)`: Nút xúc xắc quay lại thẻ draft (tối đa 2 lần/run).

### 4. Synergy Combat (Combat Pacing ~06:42)
- **Synergy Popup Banner (Giữa màn hình khi kích hoạt)**:
  - Banner: `🔥 + ⚡ BURNING CHAIN`
  - Mô tả: *"Burning enemies can chain lightning to 2 nearby enemies."*
- **Visual Effects**:
  - Quái bị cháy (Burning effect): Toàn thân bốc lửa vàng cam.
  - Quái bị đóng băng (Chilled effect): Tinh thể băng xanh bao quanh.
  - Tia sét (Chain lightning): Nối tia vàng giữa các kẻ địch đang cháy.
- **HUD Update**: Đầy 5 ô Augment, Dash Cooldown giảm còn `2.8s`, Kill count `2,846`.

### 5. Boss Fight (Pacing ~11:50)
- **Boss**: **The Ember Colossus** (Khổng lồ đá dung nham, pha lê đỏ trên vai).
- **Boss Mechanics**:
  - HP Bar dài màu đỏ rực.
  - **SHIELD PHASE (0/3)**: *"Break the 3 core crystals to expose its weak point!"* (Có 3 trụ pha lê xuất hiện quanh sân đấu).
  - Vòm khiên năng lượng xanh bao bọc Boss.
- **Telegraph Indicators**:
  - Vòng tròn đỏ hình quạt và vòng đồng tâm trên mặt đất (Warning AoE Areas) báo trước đòn dậm/chém của Boss.
  - Player phải dùng Dash (`2.4s`) và định vị né đòn.

### 6. Run Results (Bảng tổng kết Run)
- **Header**: `VICTORY` kèm vòng nguyệt quế vàng.
- **Bảng Thống Kê**:
  - `Survival Time`: 11:50
  - `Defeated Enemies`: 5,973
  - `Personal Best`: 11:50 (NEW)
- **Acquired Augments (6 slots)**: Hiển thị 6 icon lõi và số sao/cấp độ của từng lõi.
- **Discovered Synergies (3 combos)**:
  - `🔥 + ⚡ Burning Chain`
  - `❄️ + ⚡ Frost Conduit`
  - `🔥 + ❄️ Scorching Frost`
- **Build Summary**: Mô tả tóm tắt lối chơi đã xây dựng (*"A potent Fire-Lightning build that spreads Burning and chains damage, with Frost for control."*).
- **Damage Contribution Chart (Biểu đồ thanh)**:
  - `Burning (DoT)`: 42%
  - `Chain Lightning`: 29%
  - `Fire Shot`: 18%
  - `Frostbite (Slow)`: 11%
- **Action Button**: `PLAY AGAIN` (Khuyến khích Voluntary Replay ngay lập tức).

---

## 3. Chỉ Dẫn Dành Cho Multi-Agent Khi Chạy `/goal`

1. **`combat-engineer`**:
   - Sử dụng layout HUD đúng chuẩn: Top bar (Level, HP 120, Timer, Timeline, Kills, Pause), Bottom bar (6 Augment Slots, Dash Cooldown góc phải).
   - Code đòn đánh Boss "The Ember Colossus" có telegraph đỏ quạt/vòng tròn và phase đập vỡ 3 trụ pha lê.
2. **`synergy-architect`**:
   - Tên và cơ chế chính thức khớp với hình:
     - `Ember Shot` (Fire/Burning)
     - `Frostbite` (Ice/Chill/Slow)
     - `Arc Bolt` (Lightning/Chain)
   - Tên Synergy kết hợp:
     - `Burning Chain` (Fire + Lightning)
     - `Frost Conduit` (Ice + Lightning)
     - `Scorching Frost` (Fire + Ice)
   - Thiết kế banner popup thông báo synergy khi combo lần đầu kích hoạt.
3. **`qa-benchmarker`**:
   - Thu thập telemetry data phục vụ chính xác màn hình **Run Results**: Defeated enemies, survival time, discovered synergies, % Damage Contribution breakdown.
