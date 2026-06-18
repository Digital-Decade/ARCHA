extends Resource
class_name Nodule

static func interface(ports: Ports):
	pass

static func function(packet: Packet) -> Packet:
	return packet
