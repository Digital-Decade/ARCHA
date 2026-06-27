extends RefCounted
class_name Orchestrator

var wire_data

func build_packet():
	var packet := Packet.new()
	packet

func handle_ui_data() -> void:
	pass

func handle_packet(packet: Packet) -> void:
	pass
	check_ready_packets()

func check_ready_packets() -> void:
	pass

func run(nodule: Nodule, packet: Packet) -> void:
	pass
