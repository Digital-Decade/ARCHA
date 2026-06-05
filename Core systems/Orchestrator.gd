extends Node
# Global Orchestrator Singleton

var routing_table: Dictionary = {}

func dispatch(packet: Packet) -> void:
	var target_id = 0
	var target_port = 0
	_deliver_locally(target_id, target_port, packet)

func _deliver_locally(target_id: String, target_port: int, packet: Packet) -> void:
	var target_node = find_local_node(target_id)
	if target_node:
		target_node.set_input(target_port, packet.payload, packet.trace_id, packet.hop_count)

func find_local_node(target_id):
	return target_id
