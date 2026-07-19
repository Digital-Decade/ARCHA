extends RefCounted
class_name Orchestrator


var wire_data: Dictionary = {}
var nodule_ports_and_internal_wires: Dictionary = {}
var hacky_scope_enforcer := []


func initialize_composition(composition: Composition, drawer: Drawer):
	var index := 0
	for nodule_script in composition.nodules:
		var ports := Ports.new()
		var widget := Widget.new()
		nodule_script.setup(ports, widget)
		drawer.add_widget(widget, index)
		
		for wire in ports._ui_emitters_wires:
			var nodule_address := NoduleAddress.new(composition, index)
			create_ui_bridge(nodule_address, wire)
		nodule_ports_and_internal_wires.set(nodule_script, ports)
		index += 1



func create_ui_bridge(nodule_address: NoduleAddress, wire: Ports.InternalWire) -> void:
	var ingest_port: int = wire._port_id
	var object_reference: Node = wire._ui_address._object_reference
	var signal_name: StringName = wire._ui_address._signal_name
	var data_source: Variant  = wire._ui_address._data_source
	
	if not object_reference or not object_reference.has_signal(signal_name):
		push_error("Orchestrator: Attempted to connect to an invalid signal or null object reference.")
		return
		
	var bridge = UISignalBridge.new(nodule_address, ingest_port, object_reference, data_source, self)
	object_reference.connect(signal_name, Callable(bridge, &"handle_ui_signal"))
	hacky_scope_enforcer.append(bridge)

class UISignalBridge:
	extends RefCounted

	var _nodule_address: NoduleAddress
	var _ingest_port: int
	var _object_reference: Node
	var _data_source: Variant
	var _orchestrator: Object
	
	func _init(nodule_address: NoduleAddress, ingest_port: int, object_reference: Node, data_source: Variant, orchestrator: Orchestrator) -> void: _nodule_address = nodule_address; _ingest_port = ingest_port; _object_reference = object_reference; _data_source = data_source; _orchestrator = orchestrator
	
	func handle_ui_signal(a0=null, a1=null, a2=null, a3=null):
		print("[Debug] Starting UI signal handling.")
		if not is_instance_valid(_object_reference):
			return
		var final_value: Variant
		if _data_source is StringName:
			final_value = _object_reference.get(_data_source)
		elif _data_source is int:
			var args = [a0, a1, a2, a3]
			var target_index: int = _data_source
			if target_index >= 0 and target_index < args.size():
				final_value = args[target_index]
			else:
				push_error("Orchestrator Bridge: Signal argument index %d out of bounds." % target_index)
				return
		else:
			push_error("No data source declared.")
		
		_orchestrator.receive_ui_change(final_value, _nodule_address, _ingest_port)


func receive_ui_change(value: Variant, origin_nodule_address: NoduleAddress, ingest_port: int) -> void:
	var composition = origin_nodule_address._composition
	var origin_port_address := PortAddress.new(origin_nodule_address._nodule_id, ingest_port)
	for target_port_address in composition.find_connected_ports(origin_port_address):
		wire_data.set(target_port_address.key(), value)
		print("[Debug] Target address: %s | Data: %s" % [target_port_address.key(), wire_data.get(target_port_address.key())])
		var target_nodule_address := NoduleAddress.new(origin_nodule_address._composition, target_port_address._nodule)
		check_ready_packet(target_nodule_address)


func handle_shipment(shipment: Shipment) -> void:
	var packet := shipment._package
	var composition: Composition = shipment._destination._composition
	var source_nodule := shipment._destination._nodule_id
	
	var output_port_index := 0
	for data in packet._outputs.values():
		var target_port_addresses: Array[PortAddress] = []
		for wire in composition.wires:
			var source_port_address := PortAddress.new(source_nodule, output_port_index)
			var ports_map: Ports = nodule_ports_and_internal_wires.values()[source_nodule]
			var ui_addresses: Array = []
			for internal_wire in ports_map._ui_receiver_wires:
				if internal_wire._port_id == output_port_index:
					ui_addresses.append(internal_wire._ui_address)
			for ui_address: Ports.UIReceiver in ui_addresses:
				ui_address._object_reference.set(ui_address._property_name, data)
			if wire.origin.equals(source_port_address):
				target_port_addresses.append(wire.target)
		for target_port_address in target_port_addresses:
			wire_data.set(target_port_address.key(), data)
			print("[Debug] Target address: %s | Data: %s" % [target_port_address.key(), wire_data.get(target_port_address.key())])
			check_ready_packet(NoduleAddress.new(composition, target_port_address._nodule))
		output_port_index += 1

func check_ready_packet(nodule_address: NoduleAddress) -> void:
	print("[Debug] Starting packet values readiness check.")
	var nodule_script: Script = nodule_address.get_nodule_script()
	var ports: Ports = nodule_ports_and_internal_wires.get(nodule_script)
	var port_index := 0
	var inputs: Array[Variant] = []
	for input in ports._inputs:
		inputs.append(wire_data.get(PortAddress.new(nodule_address._nodule_id, port_index).key()))
		port_index += 1
	print("[Debug] Packet values ready so far: ", inputs)
	if not inputs.has(null):
		assemble_packet(nodule_address)

func assemble_packet(nodule_address: NoduleAddress):
	print("[Debug] Starting packet assembly.")
	var packet := Packet.new()
	var ports: Ports = nodule_ports_and_internal_wires.get(nodule_address.get_nodule_script())
	var port_index := 0
	for input in ports._inputs:
		var data: Variant = wire_data.get(PortAddress.new(nodule_address._nodule_id, port_index).key()) 
		packet._inputs.set(input._label, data)
		port_index += 1
	for output in ports._outputs:
		packet._outputs.set(output._label, null)
	print("[Debug] Packet inputs: ", packet._inputs)
	dispatch(Shipment.new(packet, nodule_address))

func dispatch(shipment: Shipment) -> void:
	print("[Debug] Starting shipment dispatch.")
	var packet = shipment._package
	var nodule = shipment._destination.get_nodule_script()
	print("[Debug] Packet outputs pre-dispatch: ", packet._outputs)
	nodule.function(packet)
	print("[Debug] Packet outputs post-dispatch: ", packet._outputs)
	handle_shipment(shipment)
