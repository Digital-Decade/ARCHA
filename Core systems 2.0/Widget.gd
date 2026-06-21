extends RefCounted
class_name Widget

var _layout: VBoxContainer
var adresses: Array[PropertyAddress] = []

func create(minimum_size: int = 200) -> void:
	if _layout == null:
		_layout = VBoxContainer.new()
		_layout.custom_minimum_size = Vector2i(minimum_size, 0)

func append_custom_controls(node: Node, size: int = 1) -> void:
	if _layout == null:
		push_error("Trying to append controls on widget that wasn't created with \"widget.create()\"")
		return
	if is_instance_of(node, HBoxContainer):
		_layout.add_child(node)
	else:
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size = Vector2i(0, 50*size)
		hbox.add_child(node)
		_layout.add_child(hbox)
	

func register_ui_property(object_reference: Node, property_name: StringName, change_signal: StringName) -> PropertyAddress:
	var address := PropertyAddress.new(object_reference, property_name)
	adresses.append(address)
	object_reference.connect(change_signal, call_orchestrator)
	return address

func call_orchestrator():
	pass

class PropertyAddress:
	var _object_reference: Node
	var _property_name: StringName
	func _init(
		object_reference: Node, 
		property_name: StringName
	) -> void:
		_object_reference = object_reference
		_property_name = property_name
	
	func bind_to(port: Ports.Port) -> void:
		pass
