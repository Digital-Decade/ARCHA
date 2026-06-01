extends GraphEdit

# Tracks active fingers: { touch_index: screen_position }
var touch_points: Dictionary = {}
var initial_pinch_distance: float = 0.0
var initial_zoom: float = 1.0

func _gui_input(event: InputEvent) -> void:
	# 1. Track Finger Press / Release
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
			if touch_points.size() < 2:
				initial_pinch_distance = 0.0

	# 2. Track Finger Movement
	if event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		# TWO FINGER GESTURES (Pinch to Zoom & Pan)
		if touch_points.size() == 2:
			var keys = touch_points.keys()
			var p1: Vector2 = touch_points[keys[0]]
			var p2: Vector2 = touch_points[keys[1]]
			var current_distance = p1.distance_to(p2)
			
			# A. Handle Panning (Move canvas based on the midpoint drag of both fingers)
			# Godot's ScreenDrag gives a relative movement vector
			scroll_offset -= event.relative * 0.5 / zoom
			
			# B. Handle Pinch-to-Zoom
			if initial_pinch_distance == 0.0:
				initial_pinch_distance = current_distance
				initial_zoom = zoom
			else:
				# Calculate zoom factor change percentage
				var zoom_factor = current_distance / initial_pinch_distance
				# Apply clamped zoom boundary matching your GraphEdit inspector settings
				zoom = clamp(initial_zoom * zoom_factor, zoom_min, zoom_max)
