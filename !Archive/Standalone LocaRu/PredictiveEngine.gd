class_name PredictiveEngine
extends RefCounted

# The width of Layer 3 (Abstract Latent Feature Space)
# 4 dimensions are excellent for a small, nuanced prototype setup.
const LATENT_DIM: int = 4

# Hyperparameters for training stability
const LEARNING_RATE: float = 0.15
const REGULARIZATION: float = 0.02 # Prevents vectors from expanding to infinity

# Layer 2/3 Data Storage
# image_registry: Dictionary[String, Array[float]] -> Maps file paths to latent coordinates
var image_registry: Dictionary = {}

# tag_registry: Dictionary[String, Array[float]] -> Maps user tags to latent weights
var tag_registry: Dictionary = {}

# --- Initialization & Registration ---

## Registers a new image into the engine with a small randomized latent profile
func register_image(image_path: String) -> void:
	if not image_registry.has(image_path):
		var latent_vector: Array[float] = []
		for i in range(LATENT_DIM):
			# Small random distribution around 0 (-0.2 to 0.2)
			latent_vector.append(randf_range(-0.2, 0.2))
		image_registry[image_path] = latent_vector

## Registers a new user-defined tag with a randomized weight profile
func register_tag(tag_name: String) -> void:
	if not tag_registry.has(tag_name):
		var weight_vector: Array[float] = []
		for i in range(LATENT_DIM):
			weight_vector.append(randf_range(-0.2, 0.2))
		tag_registry[tag_name] = weight_vector

# --- Predictive Inference (Top-Down Pass) ---

## Computes the continuous score of a single image along a specific tag axis (Dot Product)
func get_predicted_score(image_path: String, tag_name: String) -> float:
	if not image_registry.has(image_path) or not tag_registry.has(tag_name):
		return 0.0
		
	var img_vec: Array = image_registry[image_path]
	var tag_vec: Array = tag_registry[tag_name]
	
	var score: float = 0.0
	for i in range(LATENT_DIM):
		score += img_vec[i] * tag_vec[i]
	return score

## Predicts the probability that Image A will win over Image B on a given tag
## Uses a standard logistic sigmoid function
func predict_pairwise(image_a: String, image_b: String, tag_name: String) -> float:
	var score_a: float = get_predicted_score(image_a, tag_name)
	var score_b: float = get_predicted_score(image_b, tag_name)
	
	var delta: float = score_a - score_b
	# Logistic function: P(A > B) = 1 / (1 + e^-delta)
	return 1.0 / (1.0 + exp(-delta))

# --- Learning Loop (Bottom-Up Error Minimization) ---

## Updates the latent layers using the residual error of a user choice
func update_ranking(image_a: String, image_b: String, tag_name: String, chosen_image: String) -> float:
	if not image_registry.has(image_a) or not image_registry.has(image_b) or not tag_registry.has(tag_name):
		return 0.0
		
	# 1. Get bottom-up observation reality
	var target_outcome: float = 1.0 if chosen_image == image_a else 0.0
	
	# 2. Compute top-down prediction
	var predicted_outcome: float = predict_pairwise(image_a, image_b, tag_name)
	
	# 3. Compute Layer 1 Residual Error (Surprise)
	var residual_error: float = target_outcome - predicted_outcome
	
	# Cache reference arrays
	var vec_a: Array = image_registry[image_a]
	var vec_b: Array = image_registry[image_b]
	var vec_tag: Array = tag_registry[tag_name]
	
	# Temporary containers to prevent updating values mid-calculation
	var new_vec_a: Array[float] = []
	var new_vec_b: Array[float] = []
	var new_vec_tag: Array[float] = []
	
	# 4. Local Optimization Pass (Gradient updates across shared dimensions)
	for i in range(LATENT_DIM):
		# Calculate gradients derived from the prediction error
		var d_tag: float = residual_error * (vec_a[i] - vec_b[i])
		var d_a: float = residual_error * vec_tag[i]
		var d_b: float = -residual_error * vec_tag[i]
		
		# Apply updates using learning rate and basic L2 regularization to prevent drift
		new_vec_tag.append(vec_tag[i] + LEARNING_RATE * d_tag - REGULARIZATION * vec_tag[i])
		new_vec_a.append(vec_a[i] + LEARNING_RATE * d_a - REGULARIZATION * vec_a[i])
		new_vec_b.append(vec_b[i] + LEARNING_RATE * d_b - REGULARIZATION * vec_b[i])
		
	# Write modified local updates back to registries
	image_registry[image_a] = new_vec_a
	image_registry[image_b] = new_vec_b
	tag_registry[tag_name] = new_vec_tag
	
	# Return the absolute error for performance tracking/logging
	return abs(residual_error)

# --- Utility Functions ---

## Returns a list of all registered images sorted dynamically from highest to lowest score
func get_sorted_images_for_tag(tag_name: String) -> Array:
	var list: Array = image_registry.keys()
	
	# Inline custom sorting logic using the predictive scores
	list.sort_custom(func(a, b):
		return get_predicted_score(a, tag_name) > get_predicted_score(b, tag_name)
	)
	return list
