extends RefCounted

const INPUTS = ["text"]
const OUTPUTS = ["text"]

func execute(inputs: Dictionary) -> Dictionary:
	var user_string = inputs.get("text", "")
	
	return {
		"text": user_string
	}
