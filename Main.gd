extends Node

@export var drawer_container: Node
@export var composition: Composition
var drawer: Node

func temporary_hotglue():
	get_window().content_scale_factor = TestData.content_scale

func _ready() -> void:
	temporary_hotglue()
	var widgets = composition.nodes
	drawer = Drawer.create(drawer_container)
	Drawer.refresh(drawer, widgets)
