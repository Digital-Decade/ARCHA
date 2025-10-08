extends Node
class_name Curves

static func exponent_flipped(normalized_input:float, exponent:float) -> float:
	return 1.0-pow((1.0-normalized_input), 1.0/exponent)

static func exponent_flipped_clipped(normalized_input:float, exponent:float, clipping_point:float) -> float:
	var y_compensation = exponent_flipped(clipping_point, exponent)
	var scaled_input = normalized_input * clipping_point
	return exponent_flipped(scaled_input, exponent) * (1.0/y_compensation)

static func sigmoid(input:float) -> float:
	return 1/(1+exp(input))
