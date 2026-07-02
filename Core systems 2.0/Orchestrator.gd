extends RefCounted
class_name Orchestrator

var wire_data := WireData.new()

func initialize_composition(composition: Composition, drawer: Node):
	for nodule in composition.nodules:
		var ports := Ports.new()
		var widget := Widget.new()
		nodule.interface(ports, widget)
		Drawer.add_widget(drawer, widget)
		something_to_intercept_ports_declared()

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
