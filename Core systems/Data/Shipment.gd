extends Resource
class_name Shipment

@export var _package: Packet
@export var _destination: NoduleAddress

func _init(
	package: Packet,
	destination: NoduleAddress
) -> void:
	_package = package
	_destination = destination
