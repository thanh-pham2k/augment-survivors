class_name RngManager
extends RefCounted

var spawn_rng: RandomNumberGenerator
var draft_rng: RandomNumberGenerator
var encounter_rng: RandomNumberGenerator

var current_seed: int = 1337

func initialize_seed(base_seed: int) -> void:
	current_seed = base_seed
	
	spawn_rng = RandomNumberGenerator.new()
	spawn_rng.seed = base_seed
	
	draft_rng = RandomNumberGenerator.new()
	draft_rng.seed = base_seed + 10007
	
	encounter_rng = RandomNumberGenerator.new()
	encounter_rng.seed = base_seed + 20011

func roll_draft(pool: Array[AugmentData], count: int = 3) -> Array[AugmentData]:
	var result: Array[AugmentData] = []
	var available = pool.duplicate()
	
	for i in range(count):
		if available.is_empty():
			break
		var idx = draft_rng.randi_range(0, available.size() - 1)
		result.append(available[idx])
		available.remove_at(idx)
		
	return result
