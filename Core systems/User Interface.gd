extends Node
class_name UI

const wip_ui = preload("res://Scenes/Workspace/Workspace.tscn")

static func run(host: Node):
	var wip_ui_instance = wip_ui.instantiate()
	host.find_child("UI box").add_child(wip_ui_instance)
	
	print(wip_ui)
