extends Resource
class_name Shipment

@export var _destination: Address
@export var _package: Packet

func _init(
	destination: Address,
	package: Packet
) -> void:
	_destination = destination
	_package = package
