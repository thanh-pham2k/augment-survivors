# Combat & Synergy Harness — Augment Survivors

Tài liệu thiết kế và hướng dẫn sử dụng Test Harness cho **Augment Survivors**, được cải tiến và chuyển giao từ kinh nghiệm harness của dự án `couple-chaos`.

---

## 1. Mục Đích & Khác Biệt So Với Couple-Chaos

Trong `couple-chaos`, harness phục vụ kiểm tra điểm tiếp xúc nhân vật (anchor, marker2d, pose, anim frame).  
Đối với **Augment Survivors (Action Roguelite / Synergy)**, harness được nâng cấp để giải quyết 3 bài toán sống còn:
1. **Kiểm tra tương tác Synergy (Synergy Chain Verification)**: Mô phỏng chuỗi kích hoạt hiệu ứng (ví dụ: *Arc Bolt → Chain Lightning → Burning Chain → Steam Burst*) mà không cần chơi thủ công 10 phút.
2. **Kiểm soát Proc Budget & Stress-Test**: Bắn hàng trăm projectile vào bầy quái 300+ con, đo lường frame time và đảm bảo proc loop bị chặn an toàn, duy trì **60 FPS**.
3. **Deterministic Replay & RNG Streams**: Chạy cùng một seed với các kịch bản build khác nhau để đo lường tính cân bằng và build diversity.

---

## 2. Cấu Trúc File & Dữ Liệu Harness

```
augment-survivors/
├── scenes/
│   └── harness/
│       └── combat_harness.tscn       # Scene visual kiểm tra F6
├── scripts/
│   └── harness/
│       ├── combat_harness.gd         # UI điều khiển, slow-mo, frame stepping, spawn
│       └── combat_runner.gd          # Executor kịch bản headless & runtime
├── data/
│   └── harness/
│       ├── synergy_fire_ice.json     # Preset test combo Burning + Chill (Steam Burst)
│       ├── stress_swarm_300.json     # Preset kiểm tra 300 Swarm Chasers
│       └── flanker_telegraph.json    # Preset kiểm tra né đòn và telegraph của Flanker
└── tests/
    ├── combat_harness_test.gd        # Headless automated test suite
    └── synergy_reaction_test.gd      # Test phản ứng dây chuyền & proc budget
```

---

## 3. Quy Cách Kịch Bản Preset (Harness JSON Schema)

File preset JSON đặt tại `data/harness/*.json`:

```json
{
  "name": "Synergy Chain: Fire & Arc",
  "seed": 1337,
  "arena": "res://scenes/arena/static_arena.tscn",
  "player": {
    "pos": [0, 0],
    "augments": ["Ember Shot", "Arc Bolt", "Wildfire"]
  },
  "spawns": [
    { "type": "swarm_chaser", "count": 10, "pos": [150, 0] },
    { "type": "flanker", "count": 2, "pos": [-200, 100] }
  ],
  "steps": [
    { "type": "fire_weapon", "angle_deg": 0, "bullets": 1 },
    { "type": "wait", "seconds": 0.5 },
    { "type": "assert_status", "enemy_type": "swarm_chaser", "status": "burning", "min_count": 5 },
    { "type": "assert_proc_count", "max_allowed": 50 },
    { "type": "assert_fps", "min_fps": 60 }
  ]
}
```

---

## 4. Các Loại Bước Trong Preset (Harness Steps)

| Bước | Dữ liệu | Tác dụng |
| :--- | :--- | :--- |
| `spawn` | `enemy_type`, `count`, `pos_pattern` | Spawn quái thử nghiệm tại vị trí định sẵn. |
| `fire_weapon` | `angle_deg`, `bullets`, `override_augment` | Kích hoạt vũ khí kiểm tra đường bay và trúng đích. |
| `player_move` | `vector`, `dash` | Giả lập input di chuyển / dash của người chơi. |
| `wait` | `seconds` | Chờ frame/thời gian thực hiện hiệu ứng DoT. |
| `assert_status` | `status_name`, `min_count` | Xác nhận kẻ địch đã dính trạng thái tương ứng. |
| `assert_proc_count` | `max_allowed` | Kiểm tra **Proc Budget** không bị nổ vòng lặp vô tận. |
| `assert_fps` | `min_fps` | Đảm bảo hiệu năng không sụt giảm dưới ngưỡng (60 FPS). |

---

## 5. Hướng Dẫn Chạy Kiểm Thử Tự Động (Headless CLI)

Chạy headless không cần mở editor Godot:

```sh
# Đường dẫn Godot trên macOS
GODOT="/Applications/Godot.app/Contents/MacOS/Godot"

# 1. Chạy test harness tương tác cơ bản
$GODOT --headless --path . --script tests/combat_harness_test.gd

# 2. Chạy test kiểm chứng phản ứng dây chuyền nguyên tố
$GODOT --headless --path . --script tests/synergy_reaction_test.gd
```

---

## 6. Visual Inspection (F6 Trong Godot Editor)

1. Mở `scenes/harness/combat_harness.tscn` và nhấn **F6**.
2. **Speed Controls**:
   - `Tạm dừng (Pause)`
   - `Chậm 0.25x`
   - `+1 Frame (Stepping 1/60s)`: Dễ dàng soi từng frame khi đạn nảy và phát tán tia sét.
3. **Overlays**:
   - Bật **Hitbox / Hurtbox Overlay**
   - Bật **Telegraph Trajectory** (đường đỏ dự báo đòn đánh của Flanker/Boss)
   - Bật **Proc Counter & FPS Monitor** ở góc màn hình.
