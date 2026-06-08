extends Node
class_name Rack


func reload(rack_container: Node, nodules: Array[Script]) -> void:
	var rack := HBoxContainer.new()
	for nodule in nodules:
		var panel := VBoxContainer.new()
		panel.custom_minimum_size = Vector2i(200, 0)
		var rows: Array = get_nodule_panel(nodule)
		for row in rows:
			panel.add_child(row)
		rack.add_child(panel)
	for child in rack_container.get_children():
		child.queue_free()
	rack_container.add_child(rack)

func get_nodule_panel(nodule: Script) -> Array:
	return nodule.ui()
