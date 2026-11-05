import shutil

# Player:
# idle: 4 frames
for i in range(4):
    shutil.copy2(f"assets/final_sprites/player/idle_{i:02d}.png", f"assets/final_sprites/player/player_frame_{i:02d}.png")
shutil.copy2(f"assets/final_sprites/player/idle_03.png", "assets/final_sprites/player/player_frame_04.png")

# walk: 4 frames
for i in range(4):
    shutil.copy2(f"assets/final_sprites/player/run_{i:02d}.png", f"assets/final_sprites/player/player_frame_{5+i:02d}.png")
shutil.copy2(f"assets/final_sprites/player/run_03.png", "assets/final_sprites/player/player_frame_09.png")

# cast: 4 frames
for i in range(4):
    shutil.copy2(f"assets/final_sprites/player/cast_{i:02d}.png", f"assets/final_sprites/player/player_frame_{10+i:02d}.png")

# dash: 2 frames
shutil.copy2("assets/final_sprites/player/dash_00.png", "assets/final_sprites/player/player_frame_14.png")
shutil.copy2("assets/final_sprites/player/dash_01.png", "assets/final_sprites/player/player_frame_15.png")
shutil.copy2("assets/final_sprites/player/dash_01.png", "assets/final_sprites/player/player_frame_16.png")

# hurt: 2 frames
shutil.copy2("assets/final_sprites/player/hurt_00.png", "assets/final_sprites/player/player_frame_17.png")
shutil.copy2("assets/final_sprites/player/hurt_01.png", "assets/final_sprites/player/player_frame_18.png")
shutil.copy2("assets/final_sprites/player/hurt_01.png", "assets/final_sprites/player/player_frame_19.png")

# Skeleton:
for i in range(4):
    shutil.copy2(f"assets/final_sprites/skeleton/walk_{i:02d}.png", f"assets/final_sprites/skeleton/skel_frame_{i:02d}.png")
shutil.copy2("assets/final_sprites/skeleton/walk_02.png", "assets/final_sprites/skeleton/skel_frame_04.png")
shutil.copy2("assets/final_sprites/skeleton/walk_03.png", "assets/final_sprites/skeleton/skel_frame_05.png")

for i in range(4):
    shutil.copy2(f"assets/final_sprites/skeleton/slash_{i:02d}.png", f"assets/final_sprites/skeleton/skel_frame_{6+i:02d}.png")
shutil.copy2("assets/final_sprites/skeleton/slash_02.png", "assets/final_sprites/skeleton/skel_frame_10.png")
shutil.copy2("assets/final_sprites/skeleton/slash_03.png", "assets/final_sprites/skeleton/skel_frame_11.png")

# Bat:
for i in range(4):
    shutil.copy2(f"assets/final_sprites/bat/fly_{i:02d}.png", f"assets/final_sprites/bat/bat_frame_{i:02d}.png")
for i in range(2):
    shutil.copy2(f"assets/final_sprites/bat/dive_{i:02d}.png", f"assets/final_sprites/bat/bat_frame_{4+i:02d}.png")

# Boss:
for i in range(6):
    shutil.copy2(f"assets/final_sprites/boss/boss_{i:02d}.png", f"assets/final_sprites/boss/boss_frame_{i:02d}.png")

print("All active sprite frames updated with high-definition assets!")
