class_name CombatEventBus
extends Node

# Signal declarations
signal event_emitted(event_type: String, payload: Dictionary)
signal synergy_unlocked(synergy_id: String, synergy_name: String, description: String)
signal proc_budget_exhausted(event_type: String)
signal damage_dealt(source: String, target: Node, amount: float, is_crit: bool, element: GlobalEnums.ElementType)

# Proc budget configuration
const MAX_PROCS_PER_TICK: int = 150
const MAX_CHAIN_DEPTH: int = 4

var _current_tick_procs: int = 0
var _event_queue: Array[Dictionary] = []
var _is_processing: bool = false

# Telemetry data
var damage_contribution: Dictionary = {
	"Fire": 0.0,
	"Ice": 0.0,
	"Lightning": 0.0,
	"Physical": 0.0
}
var enemies_defeated: int = 0
var discovered_synergies: Dictionary = {}

func _process(_delta: float) -> void:
	_current_tick_procs = 0
	_flush_event_queue()

func emit_combat_event(event_type: String, payload: Dictionary, depth: int = 0) -> bool:
	if depth > MAX_CHAIN_DEPTH:
		return false
	if _current_tick_procs >= MAX_PROCS_PER_TICK:
		proc_budget_exhausted.emit(event_type)
		return false
		
	_current_tick_procs += 1
	payload["depth"] = depth
	payload["type"] = event_type
	_event_queue.append(payload)
	
	if not _is_processing:
		_flush_event_queue()
	return true

func _flush_event_queue() -> void:
	if _is_processing:
		return
	_is_processing = true
	while _event_queue.size() > 0:
		var event = _event_queue.pop_front()
		event_emitted.emit(event["type"], event)
	_is_processing = false

func record_damage(category: String, amount: float) -> void:
	if not damage_contribution.has(category):
		damage_contribution[category] = 0.0
	damage_contribution[category] += amount

func register_synergy(id: String, name: String, desc: String) -> void:
	if not discovered_synergies.has(id):
		discovered_synergies[id] = {"name": name, "desc": desc}
		synergy_unlocked.emit(id, name, desc)

func reset_run_data() -> void:
	damage_contribution = {"Fire": 0.0, "Ice": 0.0, "Lightning": 0.0, "Physical": 0.0}
	enemies_defeated = 0
	discovered_synergies.clear()
	_current_tick_procs = 0
	_event_queue.clear()
