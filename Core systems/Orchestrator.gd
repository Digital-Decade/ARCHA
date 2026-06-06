extends Node


# Todo:
# Performance Logger: Benchmarking the workers to see exactly how many microseconds they take to execute on their background threads.


const TYPE_REGISTRY : Dictionary = {
	"text_input": preload("res://Nodes/Text input.gd"),
	"string_uppercase": preload("res://Nodes/String uppercase.gd"),
	"console_print": preload("res://Nodes/Console print.gd"),
	"text_join": preload("res://Nodes/Text joiner.gd")
}

var _compiled_graph: Dictionary = {}
var task_queue: Array[Dictionary] = []
var queue_mutex: Mutex = Mutex.new()

func _ready() -> void:
	var raw_data := _load_composition_file("res://Compositions/Branching composition.json")
	if raw_data.is_empty():
		printerr("❌ ENGINE ERROR: Composition file was empty or not found!")
		return
	
	print("✅ STEP 1: JSON loaded successfully. Compiling...")
	_compile_graph(raw_data)
	
	var context := GraphRunContext.new()
	
	for node_id in _compiled_graph:
		context.setup_node(node_id)
		var blueprint: Dictionary = _compiled_graph[node_id]
		for input_name in blueprint["static_inputs"]:
			context.write_input(node_id, input_name, blueprint["static_inputs"][input_name])
	
	queue_mutex.lock()
	var spawn_count: int = 0
	for node_id in _compiled_graph:
		var blueprint: Dictionary = _compiled_graph[node_id]
		if blueprint["is_root"]:
			task_queue.append({
			"node_id": node_id,
			"context": context
			})
			spawn_count += 1
	queue_mutex.unlock()
	
	print("✅ STEP 2: Graph compiled. Found ", spawn_count, " root entry points.")
	
	for i in range(spawn_count):
		WorkerThreadPool.add_task(_thread_worker)


func _load_composition_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Composition file not found at: " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var test_json := JSON.new()
	if test_json.parse(file.get_as_text()) == OK:
		if typeof(test_json.data) == TYPE_DICTIONARY:
			return test_json.data
	return {}


func _compile_graph(raw_json: Dictionary) -> void:
	_compiled_graph.clear()
	
	for node_id in raw_json["nodes"]:
		var raw_node: Dictionary = raw_json["nodes"][node_id]
		var worker_script: Script = TYPE_REGISTRY[raw_node["worker_type"]]
		
		var input_names: Array = []
		if "INPUTS" in worker_script:
			input_names = worker_script.INPUTS
		
		var static_inputs: Dictionary = {}
		if raw_node.has("values"):
			for key in raw_node["values"]:
				static_inputs[key] = raw_node["values"][key]
		
		
		_compiled_graph[node_id] = {
			"script": worker_script,
			"input_names": input_names,
			"static_inputs": static_inputs,
			"downstream_routes": [],
			"is_root": true
		}
	
	for connection in raw_json["connections"]:
		var from_node_id: String = connection["from_node"]
		var from_port: int = connection["from_port"]
		var to_node_id: String = connection["to_node"]
		var to_port: int = connection["to_port"]
		
		var from_blueprint: Dictionary = _compiled_graph[from_node_id]
		var to_blueprint: Dictionary = _compiled_graph[to_node_id]
		
		var from_socket_name: String = from_blueprint["script"].OUTPUTS[from_port]
		var to_socket_name: String = to_blueprint["script"].INPUTS[to_port]
		
		from_blueprint["downstream_routes"].append({
			"from_socket": from_socket_name,
			"to_node": to_node_id,
			"to_socket": to_socket_name
		})
		
		to_blueprint["is_root"] = false

func _thread_worker() -> void:
	while true:
		var current_token: Dictionary = {}
		
		queue_mutex.lock()
		if not task_queue.is_empty():
			current_token = task_queue.pop_front()
		queue_mutex.unlock()
		
		if current_token.is_empty():
			break
			
		_execute_node(current_token["node_id"], current_token["context"])


func _execute_node(node_id: String, context: GraphRunContext) -> void:
	var blueprint: Dictionary = _compiled_graph[node_id]
	var inputs: Dictionary = context.read_inputs_for(node_id, blueprint["input_names"])
	var worker = blueprint["script"].new()
	var results: Dictionary = worker.execute(inputs)
	
	for route in blueprint["downstream_routes"]:
		var value = results.get(route["from_socket"], null)
		
		context.write_input(route["to_node"], route["to_socket"], value)
		
		var target_blueprint: Dictionary = _compiled_graph[route["to_node"]]
		if context.is_node_ready(route["to_node"], target_blueprint["input_names"]):
			queue_mutex.lock()
			task_queue.append({
				"node_id": route["to_node"],
				"context": context
			})
			queue_mutex.unlock()
			WorkerThreadPool.add_task(_thread_worker)
