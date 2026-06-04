extends RefCounted

const INPUTS = ["text_to_print"]
const OUTPUTS = []

func execute(inputs: Dictionary) -> Dictionary:
	print("--- PROTOTYPE SUCCESS ---")
	print(inputs["text_to_print"])
	return {}
