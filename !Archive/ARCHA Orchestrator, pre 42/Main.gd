extends Node

@export var drawer_container: Node
@export var composition: Composition
var drawer := Drawer.new()
var graph: GraphManager

func temporary_hotglue():
	get_window().content_scale_factor = 1.0 # 2.5

func _ready() -> void:
	temporary_hotglue()
	drawer.create(drawer_container)
	var orchestrator = Orchestrator.new()
	graph = GraphManager.new(get_node("VBoxContainer/Content area/VBoxContainer/GraphEdit"))
	orchestrator.initialize_composition(composition, drawer, graph)
