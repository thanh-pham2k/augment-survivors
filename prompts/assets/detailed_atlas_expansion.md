# Cẩm Nang Atlas Hoạt Họa 60 FPS (Đã Tối Ưu Tối Đa 8 Frames/Prompt)

Tài liệu này lưu ý kỹ thuật khi ghép các frame từ các batch 8-frame vào hệ thống Animation trong Godot 4:

1. **Chuẩn hóa Tọa độ Chân (Foot Pivot Alignment)**:
   - Tất cả các frame trong cùng một hành động (như Walk hoặc Idle) được căn chỉnh sao cho điểm tiếp đất của bàn chân luôn nằm trên một đường thẳng ngang. Tránh tình trạng nhân vật bị giật lên xuống khi đổi frame.
2. **Tốc độ Animation (FPS)**:
   - `idle`: 4-6 FPS (thở êm dịu).
   - `walk` / `run`: 8-10 FPS (bước chạy dứt khoát).
   - `cast`: 10-12 FPS (xuất chiêu nhanh, dứt khoát).
   - `dash`: 12-14 FPS (lướt thần tốc).
   - `attack_slash`: 10-12 FPS (chém kiếm nhanh và có độ dừng ở điểm kết thúc).
3. **Phân bổ theo Batch 8-Frames**:
   - Sử dụng các file prompt từ `prompts/assets/01_player_movement_8f.md` đến `07_augment_draft_cards_6f.md`.
