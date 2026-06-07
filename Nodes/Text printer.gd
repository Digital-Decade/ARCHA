extends Nodule

static func ui() -> Array:
	var rows: Array = []
	
	var text_label := RichTextLabel.new()
	text_label.text = "test"
	text_label.fit_content = true
	rows.append(text_label)
	
	return rows

static func run(text: String) -> String:
	print("--- Prototype success ---")
	print(text)
	return text
	
