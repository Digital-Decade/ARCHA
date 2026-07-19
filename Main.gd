extends Node

@export var drawer_container: Node
@export var composition: Composition
var drawer := Drawer.new()

func temporary_hotglue():
	get_window().content_scale_factor = 1.0 # 2.5

func _ready() -> void:
	temporary_hotglue()
	drawer.create(drawer_container)
	var orchestrator = Orchestrator.new()
	orchestrator.initialize_composition(composition, drawer)
