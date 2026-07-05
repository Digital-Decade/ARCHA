extends RefCounted
class_name Orchestrator

var wire_data := WireData.new()
var nodule_internal_wires: Dictionary = {}


func initialize_composition(composition: Composition, drawer: Node):
	for nodule in composition.nodules:
		var ports := Ports.new()
		var widget := Widget.new()
		nodule.interface(ports, widget)
		Drawer.add_widget(drawer, widget)
		nodule_internal_wires.set(nodule, ports)

func build_packet():
	var packet := Packet.new()
	packet

static func handle_ui_data() -> void:
	print("Handling ui data")

func handle_packet(packet: Packet) -> void:
	pass
	check_ready_packets()

func check_ready_packets() -> void:
	pass

func run(nodule: Nodule, packet: Packet) -> void:
	pass
