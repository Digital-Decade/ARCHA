class_name LogicNode
extends RefCounted

var node_id: String

func set_input(port: int, value: Variant, trace_id: String, hop_count: int) -> void:
	# Receive data from the orchestrator, run the custom logic, then output
	var result = execute(port, value)
	
	# Pass the trace metadata onward so the orchestrator can track the lifecycle
	emit_output(0, result, trace_id, hop_count)

func execute(port, value):
	pass

func emit_output(port: int, value: Variant, trace_id: String, hop_count: int) -> void:
	var packet = Packet.new()
	packet.sender_id = node_id
	packet.output_port = port
	packet.payload = value
	packet.trace_id = trace_id
	
	Orchestrator.dispatch(packet)
