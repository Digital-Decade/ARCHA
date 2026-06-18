extends Node

@export var drawer_container: Node
@export var widgets: Array[Script]
var drawer: Node

func temporary_hotglue():
	get_window().content_scale_factor = TestData.content_scale

func _ready() -> void:
	temporary_hotglue()
	drawer = Drawer.create(drawer_container)
	Drawer.refresh(drawer, widgets)
