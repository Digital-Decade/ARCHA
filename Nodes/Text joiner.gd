extends RefCounted

const INPUTS = ["text_a", "text_b"]
const OUTPUTS = ["joined_text"]

static func execute(inputs: Dictionary) -> Dictionary:
	var a = inputs.get("text_a", "")
	var b = inputs.get("text_b", "")
	
	return {
		"joined_text": str(a) + str(b)
	}
