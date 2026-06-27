extends RefCounted
class_name Widget

var _layout: VBoxContainer

func create(minimum_size: int = 200) -> void:
	if _layout == null:
		_layout = VBoxContainer.new()
		_layout.custom_minimum_size = Vector2i(minimum_size, 0)

func append_custom_controls(node: Node, size: int = 1) -> void:
	if _layout == null:
		create()
		print("[INFO] Auto created widget to append controls on, use \"widget.create()\" to create manually with custom aettings.")
	if is_instance_of(node, HBoxContainer):
		_layout.add_child(node)
	else:
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size = Vector2i(0, 50*size)
		hbox.add_child(node)
		_layout.add_child(hbox)

func add_button(text: String) -> Button:
	var button := Button.new()
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.text = text
	append_custom_controls(button)
	return button

func add_text_field(size: int) -> TextEdit:
	var text_field := TextEdit.new()
	text_field.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	append_custom_controls(text_field, size)
	return text_field

func add_text_label(default_text: String) -> RichTextLabel:
	var text_label := RichTextLabel.new()
	text_label.text = default_text
	text_label.fit_content = true
	text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	append_custom_controls(text_label)
	return text_label
