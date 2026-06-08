extends Nodule

static func ui() -> Array:
	var rows: Array = []
	
	var text_field := TextEdit.new()
	text_field.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var button := Button.new()
	button.text = "Send"
	rows.append_array([text_field, button])
	
	return rows

static func run(text: String) -> String:
	return text
