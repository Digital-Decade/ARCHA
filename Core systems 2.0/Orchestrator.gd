extends RefCounted
class_name Orchestrator

var packet_bay: Array[Packet]

static func poke():
	print("Orchestrator poked")

func build_packet():
	pass

func handle_packet(packet: Packet):
	pass
	check_ready_packets()

func check_ready_packets() -> void:
	pass


static func run(composition: Composition) -> void:
	pass
