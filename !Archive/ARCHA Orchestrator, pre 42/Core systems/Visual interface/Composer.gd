extends GraphEdit
class_name GraphManager

var _graph: GraphEdit
var graph_nodes_db: Dictionary

func _init(graph: GraphEdit) -> void:
	_graph = graph

func add_nodule(label: String, ports: Ports, index: int):
	var graph_node := GraphNode.new()
	graph_node.title = label
	graph_nodes_db[index] = graph_node
	_graph.add_child(graph_node)

func read_composition(composition: Composition):
	var index := 0
	for nodule in composition.nodules:
		graph_nodes_db[index].position_offset = nodule.position
		index += 1

func write_composition():
	pass
