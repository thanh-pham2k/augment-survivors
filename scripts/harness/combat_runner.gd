class_name CombatHarnessRunner
extends Node2D

signal harness_finished(success: bool, telemetry: Dictionary)

@export var is_headless: bool = false
@export var speed_scale: float = 4.0

var scenario_data: Dictionary = {}
var event_bus: CombatEventBus
var stage: GameplayStage
var step_index: int = 0
var elapsed_step_time: float = 0.0

var captured_frames: int = 0
var total_fps: float = 0.0

func load_scenario(preset_path: String) -> bool:
	if not FileAccess.file_exists(preset_path):
		printerr("Preset not found: ", preset_path)
		return false
	var file = FileAccess.open(preset_path, FileAccess.READ)
	var json_str = file.get_as_text()
	var json = JSON.new()
	if json.parse(json_str) != OK:
		printerr("Failed to parse JSON preset")
		return false
	scenario_data = json.data
	return true

func start_scenario() -> void:
	step_index = 0
	elapsed_step_time = 0.0
	stage = load("res://scenes/combat/gameplay_stage.tscn").instantiate() as GameplayStage
	add_child(stage)
	event_bus = stage.event_bus

func _physics_process(delta: float) -> void:
	if scenario_data.is_empty() or not stage:
		return
		
	var scaled_delta = delta * speed_scale
	elapsed_step_time += scaled_delta
	captured_frames += 1
	total_fps += Engine.get_frames_per_second()
	
	var steps = scenario_data.get("steps", [])
	if step_index >= steps.size():
		_finish(true)
		return
		
	var step = steps[step_index]
	var s_type = step.get("type", "")
	
	match s_type:
		"wait":
			if elapsed_step_time >= step.get("seconds", 1.0):
				_next_step()
		"player_dash":
			stage.player.try_dash()
			_next_step()
		"spawn_stress":
			var count = step.get("count", 100)
			for i in range(count):
				var skel = stage.skeleton_scene.instantiate() as BaseEnemy
				skel.global_position = Vector2(randf_range(-400, 400), randf_range(-400, 400))
				skel.event_bus = stage.event_bus
				stage.add_child(skel)
			_next_step()
		"assert_fps":
			var min_fps = step.get("min_fps", 30)
			var current_fps = Engine.get_frames_per_second()
			if is_headless:
				# In headless mode FPS measurement is virtual, so skip strict check
				pass
			elif current_fps < min_fps:
				printerr("FPS dropped below threshold: ", current_fps)
				_finish(false)
				return
			_next_step()
		_:
			_next_step()

func _next_step() -> void:
	step_index += 1
	elapsed_step_time = 0.0

func _finish(success: bool) -> void:
	var avg_fps = (total_fps / captured_frames) if captured_frames > 0 else 60.0
	var telemetry = {
		"avg_fps": avg_fps,
		"enemies_defeated": event_bus.enemies_defeated if event_bus else 0,
		"synergies": event_bus.discovered_synergies.keys() if event_bus else []
	}
	harness_finished.emit(success, telemetry)
	set_physics_process(false)
