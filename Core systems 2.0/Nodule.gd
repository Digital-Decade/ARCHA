extends Resource
class_name Nodule

signal data_updated(new_value: Variant)

var uid: String
var type: String

func _init(id: String = "default") -> void:
	uid = id

static func ui() -> Array:
	var result: Array[Node] = []
	return result

func function(input_data: Variant) -> void:
	data_updated.emit(input_data)
