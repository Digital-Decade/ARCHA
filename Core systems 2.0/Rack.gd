extends Node
class_name Rack

var module_ids := ["print output", "file picker", "list view"]


var module_contents: Dictionary = {
	"print output": output_printer,
	"file picker": [],
	"list view": []
}

func output_printer() -> Array:
	var rows: Array = []
	
	var text_label := RichTextLabel.new()
	text_label.text = "test"
	text_label.fit_content = true
	rows.append(text_label)
	
	return rows

func reload(rack_container: Node) -> void:
	var rack := HBoxContainer.new()
	for module_id in module_ids:
		var module := VBoxContainer.new()
		module.custom_minimum_size = Vector2i(200, 0)
		var rows: Array = retrieve_module_contents(module_id)
		for row in rows:
			module.add_child(row)
		rack.add_child(module)
	for child in rack_container.get_children():
		child.queue_free()
	rack_container.add_child(rack)

func retrieve_module_contents(module_id: String) -> Array:
	var result: Array
	if typeof(module_contents[module_id]) == TYPE_CALLABLE:
		result = module_contents[module_id].call()
	else:
		result = [] 
	return result
