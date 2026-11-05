# Augment Survivors — Game Design Blueprint v1.0

> **North Star**: Every run should create a new strategic possibility, not just a different damage number.  
> **Status**: 48/48 quyết định đã chốt. Bước tiếp theo: **BUILD PROTOTYPE** (Chưa vào full production).

---

## TL;DR — Kết luận thiết kế

Augment Survivors là một **Systemic Synergy Roguelite**: Ít lõi, nhiều tương tác, mỗi run buộc người chơi xây dựng chiến thuật khác nhau.

1. **Core Fun**: Di chuyển, né tránh, định vị và tự động tấn công phải hấp dẫn ngay cả khi chưa có Augment.
2. **Unique Hook**: Augments thay đổi hành vi chiến đấu, tạo những phản ứng dây chuyền mạnh và bất ngờ.
3. **Player Agency**: Người chơi không kiểm soát hoàn toàn RNG, nhưng có công cụ thích nghi và tránh lựa chọn vô dụng.
4. **Evergreen Strategy**: Skill mastery + build diversity + systemic interactions, thay vì liên tục thêm content.
5. **MVP**: 1 nhân vật, 1 vũ khí, 6–8 lõi, 3 nguyên tố, 2 loại địch và 1 boss.
6. **Ưu tiên lớn nhất**: Chứng minh rằng người chơi tự nguyện chơi lại để khám phá một build khác.

---

## I. Decisions — Tổng hợp 48 quyết định đã chốt

*Tất cả lựa chọn dưới đây là Confirmed Decisions, không tự động thay bằng recommendation mới.*

| Nhóm | Quyết định đã chốt |
| :--- | :--- |
| **A. Core Fun** | Midcore; Build Architect + Overpowered Hero; Spatial Control + Offensive Positioning; Final Boss; mở đầu bằng Weapon + Enemy Encounters; Combat Feedback + Progress Comparison |
| **B. First Principles** | Giữ Focus, không thêm Starting Augment; thất bại dựa trên kỹ năng + chiến thuật; đa dạng đội hình địch đầu trận; 3 nguyên tố; ưu tiên loại bỏ nhiều môi trường và Codex UI hoàn chỉnh khỏi prototype; Telegraph + Danger Highlight |
| **C. Emergence** | Hybrid Tag-Based + Explicit Recipes; cho phép combo cực mạnh với cái giá tương ứng; Opportunity Cost + Activation Conditions; Behavioral + Spatial Counterplay; arena tĩnh; boss kiểm tra kỹ năng + khả năng thích nghi |
| **D. RNG** | Rarity theo milestone; limited stacking; adaptive bad-luck protection; công bố xác suất qua Codex + thông tin theo ngữ cảnh; synergy có thể suy luận; không bổ sung nguồn random reward cho MVP |
| **E. Evergreen** | Mechanical + Strategic Mastery; build phải khác cách chơi và có khả năng chiến thắng; Personal Best; Horizontal Expansion; counterplay để xử lý meta thống trị; Systemic Depth + Procedural Encounter Variation |
| **F. Market** | PC/Steam; Free Demo → Premium; Death Must Die làm benchmark chính; Minimalist 2D cho prototype; hook Crazy Synergy + Build Transformation; thử nghiệm qua itch.io và cộng đồng roguelite |
| **G. Validation** | Micro Prototype; Voluntary Replay Rate là metric chính; mixed blind testers; so sánh gameplay có/không có Augments và cùng seed với các build khác nhau; Combined Success Gate; mục tiêu 60 FPS |
| **H. Blueprint** | North Star: Emergent Synergy; 6–8 Augments đầu tiên; Data-Driven + Events; Proc Budget + Deferred Processing; Atomic Draft State Transition; quyết định dựa trên quantitative + qualitative evidence |

*Các cơ chế chốt khác*: Free movement, auto-fire, dash, draft chọn 1 trong 3, 2 reroll/run, optional Focus, rarity system, tối đa 2 strategic evolutions/run, deterministic seeds, version-locked runs, rolling autosave và persistent draft.

---

## II. Insights — Những nguyên tắc rút ra

1. **Synergy chính là sản phẩm, không phải tính năng phụ**: Người chơi mong một lựa chọn làm thay đổi cách những hiệu ứng đã sở hữu hoạt động.
2. **RNG phải tạo vấn đề thú vị để giải quyết**: Một draft tốt cần những lựa chọn có trade-off khác nhau nhưng đều hợp lệ.
3. **Combo cực mạnh là phần thưởng cho khám phá**: Cho phép build áp đảo kẻ địch nhưng vẫn có giới hạn kỹ thuật an toàn (proc budget).
4. **Replayability phải đến từ hành vi mới**: Hai build có sát thương khác nhau nhưng chơi giống nhau không phải hai chiến thuật khác biệt.

> **Nguyên tắc review Augment**: Một Augment tốt phải tạo ra một quyết định thú vị hoặc một tương tác mới có thể quan sát được. Nếu chỉ tăng 10% damage đơn thuần thì không ưu tiên đưa vào bộ lõi đầu tiên.

---

## III. Critique — Phản biện và Rủi ro

| Vấn đề | Mức độ | Phân tích |
| :--- | :---: | :--- |
| 6–8 lõi quá ít cho 10–15 phút | **Cao** | Pool có thể nhanh cạn; limited stacking hoặc nâng cấp hành vi cần đủ hấp dẫn |
| Auto-fire thiếu combat depth | **Cao** | Nếu địch chỉ đuổi thẳng, positioning dễ thành chạy vòng tròn |
| Synergy dễ biến thành proc explosion | **Cao** | Chain lightning + burning spread có thể bùng nổ event cấp số nhân |
| Bad-luck protection bóp méo RNG | Trung bình | Quá ưu tiên lõi hợp build khiến người chơi lặp lại 1 công thức |
| Combo mạnh nhưng ít counterplay | Trung bình | Screen-wipe làm mất ý nghĩa né đòn / di chuyển |
| Minimalist 2D thiếu truyền đạt | Trung bình | Hỏa, Băng, Sét phải nhận diện rõ dù trên hàng trăm quái |
| Evergreen phụ thuộc vào ít content | Trung bình | Cần systemic depth vững chắc |

### 3 mâu thuẫn giải quyết bằng triển khai
1. **Small Augment Pool vs Build Diversity**: Thiết kế lõi có tác dụng độc lập, nhiều hướng kết hợp và nâng cấp hành vi (6–8 lõi là giới hạn prototype, không phải bản full).
2. **Adaptive RNG vs Deterministic Seed**: Quản lý và lưu tách biệt các random stream (`Spawn RNG`, `Draft RNG`, `Encounter RNG`).
3. **Allow Broken Builds vs Performance/Fairness**: Giữ cảm giác visual/damage cực đã, nhưng áp đặt proc budget / event rate limit an toàn.

---

## IV. Improvements — Cải tiến có tác động lớn

| Ưu tiên | Cải tiến | Lợi ích | Chi phí |
| :---: | :--- | :--- | :---: |
| **1** | Thiết kế 6–8 lõi theo synergy graph trước khi code | Ít lõi nhưng nhiều cách kết hợp | Trung bình |
| **2** | Thiết kế enemy AI buộc người chơi đổi vị trí (Flanker, Swarm) | Combat thú vị ngay cả khi chưa có lõi | Trung bình |
| **3** | Tạo same-seed replay và telemetry từ prototype | Đo được hiệu quả build và RNG | Thấp–Trung bình |

---

## V. Open Questions — Giả định làm việc cho Prototype

- **Thời lượng run**: Thiết kế baseline 12 phút (khoảng 10–15 phút).
- **6–8 lõi đủ diversity?**: Đủ cho thử nghiệm hệ thống, so sánh 2 build cùng seed.
- **Rarity & weighted RNG**: Cấu hình đơn giản, cố định giữa các test draft logs.
- **Proc budget**: Đặt giới hạn cấu hình được, stress test 60 FPS.
- **Overpowered**: Quét quái đông được, nhưng không được bỏ qua mechanic boss.
- **Cấu hình baseline**: Máy PC phổ thông tiêu chuẩn.

---

## VI. Game Design Blueprint Chi Tiết

### 1. Executive Summary & Specification
- **Title**: AUGMENT SURVIVORS (*Build the impossible. Survive the chaos.*)
- **Genre**: Action Roguelite · Auto-Shooter · Synergy Builder
- **Platform**: PC / Steam (Free Demo → Premium)
- **Engine**: Godot 4
- **Target Performance**: 60 FPS

### 2. Core Gameplay Loop & Pacing
- **Mỗi 10s**: Positioning, né tránh, điều hướng auto-fire.
- **Mỗi 45–120s**: Tình huống địch mới hoặc quyết định build.
- **Mỗi 2 phút**: Draft Augment (Draft milestones dự kiến: ~0:50, 2:50, 4:50, 6:50, 8:50, 10:50).
- **Phút ~12**: Boss Fight.

### 3. Bộ 8 Augments Mẫu (Prototype)
1. **Ember Shot**: Đạn gây Burning theo thời gian.
2. **Wildfire**: Burning có thể lan khi mục tiêu chết.
3. **Frostbite**: Đạn gây Chill, làm chậm.
4. **Shatter**: Tấn công liên tiếp lên mục tiêu Chill kích hoạt sát thương phụ.
5. **Arc Bolt**: Đạn nảy sang nhiều mục tiêu (Chain).
6. **Overload**: Chain Lightning tương tác với trạng thái trên mục tiêu.
7. **Reaction Catalyst**: Tăng khả năng tạo phản ứng giữa các nguyên tố.
8. **Close Quarters**: Đứng gần quái tăng damage, đổi lại rủi ro cao.

```
Ví dụ chuỗi Emergent Synergy:
Arc Bolt hits Enemy A
      ↓
Apply Chain Lightning
      ↓
Enemy B has Burning
      ↓
Burning Chain triggered
      ↓
Burning spreads to Enemy C
      ↓
Enemy C is Chilled
      ↓
Steam Burst triggered
      ↓
Area Damage
```

### 4. Enemy Counterplay (MVP Scope)
- **Swarm Chaser**: Đuổi bầy đàn, ép giữ khoảng cách, tạo cơ hội cho đòn diện rộng.
- **Flanker**: Tìm góc tiếp cận, tấn công có telegraph rõ ràng, buộc né tránh/đổi vị trí.
- **Boss**: Đòn đánh vùng (AoE), cơ động đổi vị trí, triệu hồi thêm quái; kiểm tra kỹ năng di chuyển + build adaptation.

### 5. RNG Streams Separation
```
Run Seed
  ├── Spawn RNG
  ├── Draft RNG
  └── Encounter RNG
```

### 6. Kiến trúc Kỹ thuật (Godot 4)
```
          RUN CONTROLLER
                 │
    ┌────────────┼────────────┐
    │            │            │
 Combat       Augment       Run State
 System       Manager       Persistence
    │            │            │
    │       Draft / RNG       │
    │            │            │
    └───── EVENT QUEUE ───────┘
                 │
          SYNERGY ENGINE
                 │
      Tag & Reaction Rules
                 │
        Proc Budget / Depth
                 │
          Damage / Status
                 │
           Combat VFX
```
- **Resources (`.tres`)**: Khai báo Augment, triggers, tags, effects.
- **Event Queue / Dispatcher**: Decouple logic giữa các Augments và combat entity.
- **Proc Budget**: Giới hạn recursion depth / rate of procs per tick.
- **Atomic Run State**: Save seed, draft choices, recovery sau crash.

### 7. Lộ trình Triển khai (Prototype Roadmap)
- **P0 — Combat Sandbox**: Di chuyển, Dash, auto-fire, Swarm + Flanker, hit feedback, telegraph (60–90s combat vui chưa cần lõi).
- **P1 — Synergy Sandbox**: 3 nguyên tố (Hỏa, Băng, Sét), 6–8 lõi, Tag rules, Event Queue, Proc Budget.
- **P2 — Complete Run**: Draft UI, RNG streams, reroll, milestone pacing, Boss fight, Victory/Defeat screen.
- **P3 — Reliability & Telemetry**: Deterministic seed, logging, atomic draft state, stress test 60 FPS.
- **P4 — Blind Playtest**: Bản itch.io test 20–30 người (Metric chính: Voluntary Replay Rate ≥ 50%).

---

## IV. Gameplay 2.0 & Vertical Slice Evolution (Confirmed Standard)

> Chi tiết kỹ thuật, công thức tiến hóa vũ khí và tiêu chuẩn kiến trúc xem tại: [`GAMEPLAY_2.0_BLUEPRINT.md`](file:///Users/thanhpv/Documents/Work/augment-survivors/GAMEPLAY_2.0_BLUEPRINT.md)

1. **Vòng lặp phần thưởng (Reward Loop)**: Combat ➔ Kill Elite ➔ Loot Chest ➔ 3 Slot Equipment (Weapon, Armor, Relic) ➔ Build Transformation.
2. **Tiến hóa vũ khí (Weapon Evolution)**: Lv.3 + Augment xúc tác = Nhánh tiến hóa (AoE vs Single-target vs Fallback Mastery).
3. **Kiến trúc Godot 4**: Tách biệt `Resource` (Data tĩnh) và `Node/Controller` (Runtime state). Không lưu biến động vào `.tres`.
4. **Chiến lược phát triển**: Hoàn thiện **Vertical Slice** (Inferno Staff + 1 Elite + 1 Loot Chest + 1 Relic + 1 Evolution) trước khi mở rộng ngang.
