extends RefCounted
class_name GraphRunContext

var _state: Dictionary = {}
var _lock: Mutex = Mutex.new()

func setup_node(node_id: String) -> void:
	_lock.lock()
	if not _state.has(node_id):
		_state[node_id] = {}
	_lock.unlock()

func write_input(node_id: String, socket_name: String, value: Variant
) -> void:
	_lock.lock()
	if not _state.has(node_id):
		_state[node_id] = {}
	_state[node_id][socket_name] = value
	_lock.unlock()

func read_inputs_for(node_id: String, input_names: Array) -> Dictionary:
	var flat_inputs: Dictionary = {}
	_lock.lock()
	var node_inputs: Dictionary = _state.get(node_id, {})
	for name in input_names:
		flat_inputs[name] = node_inputs.get(name, null)
	_lock.unlock()
	return flat_inputs

func is_node_ready(node_id: String, input_names: Array) -> bool:
	_lock.lock()
	var node_inputs: Dictionary = _state.get(node_id, {})
	for name in input_names:
		if not node_inputs.has(name) or node_inputs[name] == null:
			_lock.unlock()
			return false
	_lock.unlock()
	return true
	
	
	
	
