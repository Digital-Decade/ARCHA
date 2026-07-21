extends Node

func _ready() -> void:
	var engine = PredictiveEngine.new()
	
	# 1. Register a tiny test environment
	var img_a: String = "res://assets/image_a.jpg"
	var img_b: String = "res://assets/image_b.jpg"
	var img_c: String = "res://assets/image_c.jpg"
	var tag: String = "Cinematic"
	
	engine.register_image(img_a)
	engine.register_image(img_b)
	engine.register_image(img_c)
	engine.register_tag(tag)
	
	print("--- BEGINNING SIMULATION ---")
	print("Initial Sorting: ", engine.get_sorted_images_for_tag(tag))
	
	# 2. Simulate user input establishing a strict hierarchy: A > B > C
	# We run it in a small training cycle to mimic repeated interactions
	for epoch in range(15):
		var err_1 = engine.update_ranking(img_a, img_b, tag, img_a) # User says A > B
		var err_2 = engine.update_ranking(img_b, img_c, tag, img_b) # User says B > C
		var err_3 = engine.update_ranking(img_a, img_c, tag, img_a) # User says A > C
		
		if epoch % 5 == 0:
			print("Epoch %d Avg Error: %.4f" % [epoch, (err_1 + err_2 + err_3) / 3.0])
			
	print("Trained Sorting (Expected A, B, C): ", engine.get_sorted_images_for_tag(tag))
	
	print("\n--- TEST: INTRODUCING CIRCULAR CONTRADICTION ---")
	print("Force feeding a system contradiction: User suddenly claims C > A")
	
	for epoch in range(10):
		engine.update_ranking(img_c, img_a, tag, img_c)
		
	print("Adjusted Sorting after conflict resolution: ", engine.get_sorted_images_for_tag(tag))
