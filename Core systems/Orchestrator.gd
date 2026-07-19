extends RefCounted
class_name Orchestrator


var wire_data: Dictionary = {}
var nodule_internal_wires: Dictionary = {}


class SmartPacket:
	var _packet: Packet
	var _packet_address: PacketAddress
	
	func _init(
		packet: Packet,
		packet_address: PacketAddress
	) -> void:
		_packet = packet
		_packet_address = packet_address
	
class PacketAddress:
	var _nodule_id: int
	var _composition: Composition
	
	func _init(
		nodule_id: int,
		composition: Composition
	) -> void:
		_nodule_id = nodule_id
		_composition = composition
	
	func get_nodule() ->  Script:
		return _composition.nodules.get(_nodule_id)
	



func initialize_composition(composition: Composition, drawer: Node):
	var index := 0
	for nodule_script in composition.nodules:
		var ports := Ports.new()
		var widget := Widget.new()
		nodule_script.setup(ports, widget)
		Drawer.add_widget(drawer, widget)
		
		for wire in ports._ui_emitters_wires:
			var packet_address := PacketAddress.new(index, composition)
			signal_connector(packet_address, wire._port_id, wire._ui_address._object_reference, wire._ui_address._signal_name)
		nodule_internal_wires.set(nodule_script, ports)
		index += 1


static func signal_connector(packet_address: PacketAddress, ingest_port: int, object_reference: Node, signal_name: StringName):
	object_reference.connect(signal_name, handle_ui_data.bind(packet_address, ingest_port))

static func handle_ui_data(values: Array, _address: PacketAddress, _ingest_port: int) -> void:
	print("Values received: ", values)

func handle_packet(smart_packet: SmartPacket) -> void:
	var packet := smart_packet._packet
	var source_nodule := smart_packet._packet_address._nodule_id
	var composition := smart_packet._packet_address._composition
	
	var port_index := 0
	for data in packet._outputs.values():
		var target_addresses: Array[Address] = []
		for wire in composition.wires:
			var source_address := Address.new(source_nodule, port_index)
			if wire.source == source_address:
				target_addresses.append(wire.target)
		for target_address in target_addresses:
			wire_data.set(target_address, data)
			check_ready_packet(PacketAddress.new(target_address._nodule, composition))
		port_index += 1

func check_ready_packet(packet_address: PacketAddress) -> void:
	var nodule_script: Script = packet_address.get_nodule()
	var ports: Ports = nodule_internal_wires.get(nodule_script)
	var port_index := 0
	var inputs: Array[Variant] = []
	for input in ports._inputs:
		inputs.append(wire_data.get(Address.new(packet_address.nodule_id, port_index)))
		port_index += 1
	if not inputs.has(null):
		assemble_packet(packet_address)

func assemble_packet(packet_address: PacketAddress):
	var packet := Packet.new()
	var ports: Ports = nodule_internal_wires.get(packet_address.get_nodule())
	var port_index := 0
	for input in ports._inputs:
		var data: Variant = wire_data.get(Address.new(packet_address._nodule_id, port_index)) 
		packet._inputs.set(input._label, data)
		port_index += 1
	for output in ports._outputs:
		packet._outputs.set(output._label, null)
	run(SmartPacket.new(packet, packet_address))

func run(smart_packet: SmartPacket) -> void:
	var packet = smart_packet._packet
	var nodule = smart_packet._packet_address.get_nodule()
	nodule.function(packet)
	handle_packet(smart_packet)
