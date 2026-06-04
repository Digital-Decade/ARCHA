extends RefCounted

const INPUTS = ["text_a", "text_b"]
const OUTPUTS = ["joined_text"]

func execute(inputs: Dictionary) -> Dictionary:
	return {
		"joined_text": inputs["text_a"] + inputs["text_b"]
	}
