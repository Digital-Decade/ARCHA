extends Node

# Perceptual Baseline Anchors
const BASELINE_DPI: float = 96.0
const BASELINE_DISTANCE_CM: float = 60.0 # Typical desktop monitor distance

func _ready() -> void:
	calculate_perceptual_scale()

func calculate_perceptual_scale() -> void:
	print("--- Calculating perceptual scale ---")
	
	var raw_dpi: float = DisplayServer.screen_get_dpi()
	var current_os = OS.get_name()
	print("OS: ", current_os, " | Display DPI: ", raw_dpi)
	
	# Fallback guardrail: If a desktop driver reports 0 DPI, default to standard desktop density
	if raw_dpi <= 0:
		raw_dpi = 96.0
		
	# 2. Step One: Normalize by physical density (DPI Ratio)
	var density_ratio: float = raw_dpi / BASELINE_DPI
	
	# 3. Step Two: Apply Perceptual Distance Placeholders (Eye-to-Screen)
	var estimated_distance_cm: float = BASELINE_DISTANCE_CM
	
	match current_os:
		"Android", "iOS":
			estimated_distance_cm = 35.0 # Typical close-up phone distance
		"Web", "macOS", "Windows", "Linux":
			estimated_distance_cm = 60.0 # Standard desktop distance
			
	var distance_ratio: float = estimated_distance_cm / BASELINE_DISTANCE_CM
	
	# 4. Combine for final Content Scale Factor
	# Formula: (Density Normalization) * (Distance Adjustment)
	var final_perceptual_scale: float = density_ratio * distance_ratio
	
	# Guardrail clamp to prevent extreme outlier hardware from breaking the UI
	final_perceptual_scale = clamp(final_perceptual_scale, 0.75, 4.0)
	
	# Apply directly to Godot's vector canvas engine
	Hooks.new().set_content_scale(self, final_perceptual_scale)
	
	print("Estimated Distance: ", estimated_distance_cm, "cm")
	print("Applied Window Scale Factor: ", final_perceptual_scale)
