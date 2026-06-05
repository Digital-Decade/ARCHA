extends RefCounted

const INPUTS = ["text_in"]
const OUTPUTS = ["text_out"]

func execute(inputs: Dictionary) -> Dictionary:
	return {
		"text_out": inputs["text_in"].to_upper()
	}
