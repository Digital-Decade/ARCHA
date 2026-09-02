extends Resource
class_name DataSource

enum Source {SIGNAL, PROPERTY}

@export var trigger_node
@export var trigger_signal
@export var mode: Source
@export var data_signal_argument: int
@export var data_node
@export var data_property

static func from_signal(signal_argument_index: int) -> DataSource:
	pass
