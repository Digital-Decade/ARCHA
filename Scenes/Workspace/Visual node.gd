extends GraphNode
class_name VisualNode

# Every visual node mirrors a background logic node
var logic_node: LogicNode

func setup(node_name: String, inputs_count: int, outputs_count: int, logical: LogicNode) -> void:
	title = node_name
	logic_node = logical
	
	# Determine how many total slots we need to show
	var total_slots = max(inputs_count, outputs_count)
	
	for i in range(total_slots):
		# Create a dummy visual row for the ports to align to
		var row = HBoxContainer.new()
		add_child(row)
		
		# Set slot properties: set_slot(index, enable_left, type_left, color_left, enable_right, type_right, color_right)
		var has_input = i < inputs_count
		var has_output = i < outputs_count
		
		set_slot(i, 
			has_input, 0, Color.WHITE,   # Left port (Input)
			has_output, 0, Color.GREEN   # Right port (Output)
		)
