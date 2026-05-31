extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

func _ready() -> void:
	graph_edit.connection_request.connect(_on_connection_request)
	graph_edit.disconnection_request.connect(_on_disconnection_request)
	
	spawn_test_graph()


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
	# TODO: Inform our logical graph manager about this connection

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	# TODO: Inform our logical graph manager about this disconnection



var node_scene = preload("res://Scenes/Workspace/Visual node.tscn")

func spawn_test_graph() -> void:
	# 1. Create a logical node
	var logic_a = LogicNode.new()
	# 2. Spawn its visual representation
	var visual_a = node_scene.instantiate()
	graph_edit.add_child(visual_a)
	visual_a.setup("Image Source", 0, 1, logic_a) # 0 Inputs, 1 Output
	visual_a.position_offset = Vector2(100, 100)
	
	# Create a second node
	var logic_b = LogicNode.new()
	var visual_b = node_scene.instantiate()
	graph_edit.add_child(visual_b)
	visual_b.setup("Head to Head View", 2, 1, logic_b) # 2 Inputs, 1 Output
	visual_b.position_offset = Vector2(400, 100)
