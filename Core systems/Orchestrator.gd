extends Node


# Todo:
# Graph Reset Pass: Clearing out old text values back to null after execution so a composition can be triggered multiple times without getting clogged by stale data.
# Performance Logger: Benchmarking the workers to see exactly how many microseconds they take to execute on their background threads.


const TYPE_REGISTRY : Dictionary = {
	"text_input": preload("res://Nodes/Text input.gd"),
	"string_uppercase": preload("res://Nodes/String uppercase.gd"),
	"console_print": preload("res://Nodes/Console print.gd"),
	"text_join": preload("res://Nodes/Text joiner.gd")
}

var graph_data: Dictionary = {}
var task_queue: Array[String] = []
var queue_mutex: Mutex = Mutex.new()

func _ready() -> void:
	graph_data = _load_composition_file("res://Compositions/Branching composition.json")
	if graph_data.is_empty():
		return
	
	_inflate_graph_schemas()
	
	var root_nodes: Array[String] = _find_root_nodes()
	
	queue_mutex.lock()
	for root_id in root_nodes:
		task_queue.append(root_id)
	queue_mutex.unlock()
	for i in range(root_nodes.size()):
		WorkerThreadPool.add_task(_thread_worker)


func _load_composition_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		push_error("Composition file not found at: " + file_path)
		return {}
	var file := FileAccess.open(file_path, FileAccess.READ)
	var json_string := file.get_as_text()
	file.close()
	
	var parsed_data = JSON.parse_string(json_string)
	if parsed_data == null:
		push_error("Failed to parse JSON file: " + file_path)
		return {}
	
	return parsed_data

func _inflate_graph_schemas() -> void:
	for node_id in graph_data["nodes"]:
		var node: Dictionary = graph_data["nodes"][node_id]
		var worker_type: String = node["worker_type"]
		
		var worker_script: Script = TYPE_REGISTRY[worker_type]
		
		node["inputs"] = {}
		if "INPUTS" in worker_script:
			for input_name in worker_script.INPUTS:
				node["inputs"][input_name] = { "type": "string", "value": null }
				
		node["outputs"] = {}
		if "OUTPUTS" in worker_script:
			for socket_name in worker_script.OUTPUTS:
				var initial_value = null
				if node.has("values") and node["values"].has(socket_name):
					initial_value = node["values"][socket_name]
				node["outputs"][socket_name] = { "type": "string", "value": initial_value }

func _find_root_nodes() -> Array[String]:
	var all_node_ids: Array = graph_data["nodes"].keys()
	var dependent_node_ids: Array[String] = []
	
	for connections in graph_data["connections"]:
		var to_node: String = connections["to_node"]
		if not dependent_node_ids.has(to_node):
			dependent_node_ids.append(to_node)
			
	var root_nodes: Array[String] = []
	for node_id in all_node_ids:
		if not dependent_node_ids.has(node_id):
			root_nodes.append(node_id)
			
	return root_nodes

func _thread_worker() -> void:
	queue_mutex.lock()
	var next_node_id: String = ""
	if task_queue.size() > 0:
		next_node_id = task_queue.pop_front()
	queue_mutex.unlock()
	
	if next_node_id != "":
		_execute_node(next_node_id)


func _execute_node(node_id: String) -> void:
	var node: Dictionary = graph_data["nodes"][node_id]
	var worker_type: String = node["worker_type"]
	if worker_type == "text_input":
		pass
	else:
		var worker_script: Script = TYPE_REGISTRY[worker_type]
		var worker = worker_script.new()
		
		var flat_inputs: Dictionary = {}
		if "INPUTS" in worker_script:
			for input_name in worker_script.INPUTS:
				flat_inputs[input_name] = node["inputs"][input_name]["value"]
		
		var results: Dictionary = worker.execute(flat_inputs)
		if "OUTPUTS" in worker_script:
			for socket_name in worker_script.OUTPUTS:
				if results.has(socket_name):
					node["outputs"][socket_name]["value"] = results[socket_name]
			
	for connection in graph_data["connections"]:
		if connection["from_node"] == node_id:
			var from_port: int = connection["from_port"]
			var to_node: String = connection["to_node"]
			var to_port: int = connection["to_port"]
			
			var target_node: Dictionary = graph_data["nodes"][to_node]
			
			var source_script: Script = TYPE_REGISTRY[node["worker_type"]]
			var target_script: Script = TYPE_REGISTRY[target_node["worker_type"]]
			
			var from_socket_name: String = source_script.OUTPUTS[from_port]
			var to_socket_name: String = target_script.INPUTS[to_port]
			
			var output_data: Dictionary = node["outputs"][from_socket_name]
			var target_input_data: Dictionary = graph_data["nodes"][to_node]["inputs"][to_socket_name]
			
			if output_data["type"] == target_input_data["type"]:
				queue_mutex.lock()
				target_input_data["value"] = output_data["value"]
				if _is_node_ready(to_node):
					task_queue.append(to_node)
					queue_mutex.unlock()
					WorkerThreadPool.add_task(_thread_worker)
				else:
					queue_mutex.unlock()
				

func _is_node_ready(node_id: String) -> bool:
	var node: Dictionary = graph_data["nodes"][node_id]
	if not node.has("inputs"):
		return true
	var inputs: Dictionary = node["inputs"]
	for input_name in inputs:
		if inputs[input_name]["value"] == null:
			return false
	return true
	
