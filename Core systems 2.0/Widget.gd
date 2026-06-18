extends RefCounted
class_name Widget

var _element_layout: Array = []

func fetch() -> VBoxContainer:
	if _element_layout.size() > 0:
		var widget := VBoxContainer.new()
		for element_stripe in _element_layout:
			var stripe := HBoxContainer.new()
			if typeof(element_stripe) == TYPE_ARRAY:
				for element in element_stripe:
					stripe.add_child(element)
			elif typeof(element_stripe) == TYPE_NODE_PATH:
				stripe.add_child(element_stripe)
			widget.add_child(stripe)
		return widget
	else:
		return null

func add_custom_stripe(...elements: Array) -> void:
	for element in elements:
		if typeof(element) == TYPE_NODE_PATH:
			pass
		elif typeof(element) == TYPE_STRING:
			pass

func add_button(label: String) -> void:
	var button := Button.new()
	button.text = label
	_element_layout.append(button)
