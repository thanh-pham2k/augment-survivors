# Batch 10 — Âm Thanh, Kỹ Thuật & Cấu Hình Engine (Audio & Technical Specs)

> **Mã hạng mục trong Inventory**: `AS-196` ➔ `AS-222`  
> **Độ ưu tiên**: **P0 (SFX va chạm & Nhạc nền) ➔ P2 (Shader & Texture Filters)**  
> **Hướng dẫn tạo**: Dành cho AI Audio Generators (như Suno, Udio, ElevenLabs, Soundraw) hoặc thư viện âm thanh bản quyền; kèm mã nguồn Shader Godot 4.

---

## 🎵 1. Đặc Tả Nhạc Nền (BGM Music Prompts & Loops)

Định dạng yêu cầu: **OGG Vorbis** (`.ogg`), Stereo 44.1kHz, thiết kế để Loop tuần hoàn không đứt quãng.

| Item ID | Tên Bài Nhạc | Prompt / Mô Tả Âm Nhạc (Suno / Udio / AI Audio) | Cảm Xúc & Nhịp Điệu |
| :---: | :--- | :--- | :--- |
| **AS-196** | **Main Menu Theme** | `Dark fantasy gothic orchestral ambient, melancholic cello solo, distant church choir chanting, soft harp, atmospheric, mysterious, 75 BPM, seamless loop` | U tối, bí ẩn, gợi mở hành trình |
| **AS-197** | **Màn 1: Cathedral Theme** | `Fast-paced dark gothic action roguelite soundtrack, driving acoustic drums, tense violin ostinato, pipe organ chords, rhythmic, heroic dark fantasy, 125 BPM, loop` | Hồi hộp, thúc giục di chuyển |
| **AS-198** | **Màn 2: Infernal Depths** | `Aggressive dark fantasy combat metal, pounding war drums, distorted bass synth, fiery electric guitar riffs, relentless swarm combat pace, 138 BPM, seamless loop` | Nóng bức, cuồng bạo, khẩn cấp |
| **AS-199** | **Màn 3: Frozen Sanctum** | `Chilling atmospheric blizzard battle music, crystalline glass marimba, soaring soprano choir, rapid orchestral strings, cold dread tension, 130 BPM, loop` | Lạnh lẽo, sắc nhọn, nguy hiểm |
| **AS-200** | **Boss: The Ember Colossus** | `Epic monumental boss battle theme, massive taiko thunder drums, roaring brass section, apocalyptic choir, aggressive heroic intensity, climactic finale, 142 BPM` | Hoành tráng, nghẹt thở, tối thượng |

---

## 🔊 2. Bảng Âm Thanh Hiệu Ứng (Sound Effects — SFX Table)

Định dạng yêu cầu: **WAV 16-bit** (cho âm ngắn tức thời không trễ) hoặc OGG.

| Item ID | Hành Động Gameplay | Mô Tả Âm Thanh (Foley / Synthesizer Prompt) | Yêu Cầu Kỹ Thuật |
| :---: | :--- | :--- | :--- |
| **AS-201** | Click nút UI | *Crisp metallic latch click, stone thud hover tick* | Độ dài < 0.15s, dứt khoát |
| **AS-202** | Nhặt đồng vàng | *Bright resonant high-pitch coin jingle, sparkling clink* | Vui tai, thỏa mãn (Dopamine hit) |
| **AS-203** | Hỏa trượng bắn lửa | *Deep whooshing flame roar, crackling fireball ignition* | Uy lực, vang ấm |
| **AS-203** | Lôi thủ phóng điện | *Sharp high-voltage electrical zap, buzzing plasma whip* | Sắc bén, dồn dập |
| **AS-203** | Băng thương đâm | *Piercing crystalline ice whistle, deep thud* | Thanh thoát, lạnh lùng |
| **AS-204** | Trúng đòn quái | *Punchy organic hit thud, bone crunch impact* | Có độ nặng va chạm (Weight) |
| **AS-204** | Sát thương chí mạng | *Heavy bass-boosted punch pop, glass shatter overtone* | Nổi bật gấp đôi đòn thường |
| **AS-205** | Lướt Dash | *Fast whipping wind whoosh with sizzling fire friction* | Phản hồi ngay lập tức (< 0.05s) |
| **AS-208** | Búa đập lò rèn | *Heavy blacksmith anvil hammer strike on glowing steel* | Vang tiếng kim loại cổ điển |
| **AS-209** | Tiến hóa vũ khí | *Ascendant holy choir chord with triumphant brass fanfare* | Cao trào, chúc mừng |
| **AS-210** | Trụ Tinh thể vỡ | *Massive frozen diamond shattering explosion, kinetic boom* | Chấn động cả màn hình |

---

## 💻 3. Cấu Hình Kỹ Thuật & Shader Godot 4 (Technical Assets)

### AS-214: Shader Hit Flash Trắng Khi Quái Trúng Đạn (`hit_flash.gdshader`)
Tạo cảm giác "chớp sáng trắng" tức thời mà không cần vẽ thêm sprite:

```gdshader
shader_type canvas_item;

uniform float hit_flash_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 hit_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 mixed_rgb = mix(tex_color.rgb, hit_flash_color.rgb, hit_flash_intensity);
    COLOR = vec4(mixed_rgb, tex_color.a);
}
```

### AS-222: Cấu Hình Import Texture Mặc Định Trong Godot
* **Texture Filter**: `Nearest` (để giữ nguyên điểm ảnh pixel art sắc nét, không bị nhòe mờ bilinear).
* **Roughness**: `Disabled`.
* **Compression**: `Lossless` hoặc `VRAM Compressed` tùy nền tảng.
