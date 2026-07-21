extends Node
class_name Ranking


var thread = HyperThreading.new()


# I should add GPU compute shaders later





var previous_iteration_sorted_ranking:Array = []


signal RankingIterated(ranking:Array, iteration_number:int)
signal AllProcessingComplete
signal UpdatePreviousRankingMemory(previous_ranking:Array[ScoredItem])
func dummy(): pass
func _ready() -> void:
	RankingIterated.connect(dummy)
	AllProcessingComplete.connect(dummy)

class ScoredItem:
	var id:String # Replace with proper global ID system later, for now just file name
	var score:float
	var original_order:int
	func _init(
		_id:String, _score:float, _original_order:int) -> void:
		id = _id
		score = _score
		original_order = _original_order




func comparisons_list_to_matrix() -> Array[Array]: # To complete later
	var result_matrix: Array[Array] = []
	return result_matrix
func comparisons_list_to_dictionary(comparisons:Array, items:Array[String]) -> Dictionary:
	var results_dict: Dictionary = {}
	for item in items:
		results_dict.get_or_add(item, {})
	for comparison in comparisons:
		var winner = comparison[0]
		var loser = comparison[1]
		results_dict.get_or_add(winner, {})
		results_dict[winner].get_or_add(loser, 0.0)
		results_dict[winner][loser] += 1.0
	return results_dict





func no_ranking_passthrough(unique_items:Array[String]) -> void:
	var returned_items:Array[ScoredItem] = []
	var index:int = 0
	for item in unique_items:
		returned_items.append(ScoredItem.new(item, 0.0, index))
		index += 1
	call_deferred("emit_signal", "RankingIterated", returned_items, -1)
	call_deferred("emit_signal", "IterationsComplete")

func bradley_terry(
	iteration_breaker:Breaker,
	comparisons_list:Array, # Can't make this Array[Array] because the JSON reader doesn't know that the Array is an Array[Array] so it blocks when trying to assign its output to this variable since types are a mismatch
	unique_items:Array[String],
	iteration_limit:int,
	unrated_item_default_strength:float = 0.0,
	sort_ascending:bool = false,
	previous_strengths:Dictionary[String,float] = {},
	comparisons_mode:String = "Dictionary" # Maybe remove the choice and auto select depending on which would be most performant depending on database size and sparsity of comparison data
) -> void: # And with all of that I still haven't actually tweaked this algorithm to work by pushing down losers. Zamn. This accursed threading desynchronisation. Tomorrow I'm gonna hate all of the hacks I took.
	
	##Grok stuff
		#var new_log_strengths = previous_log_strengths.duplicate(true)
		#for winner in range(previous_log_strengths.size()):
			#var gradient = 0.0
			#for loser in range(previous_log_strengths.size()):
				#if winner != loser and comparisons[winner][loser] > 0:
					#var probability = 1.0 / (1.0 + exp(previous_log_strengths[loser] - previous_log_strengths[winner]))
					#gradient += comparisons[winner][loser] * (1.0 - probability) - comparisons[loser][winner] * probability
			#new_log_strengths[winner] += learning_rate * gradient
		#call_deferred("emit_signal", "ResultsReady", new_log_strengths)
	## Some stuff I wrote to try to understand logarithmic version stuff, from that video on the ELO chess algorithm by J3M
		#var strength_0 = 1
		#var odds_of_x_beats_0
		#var rating_x = 1
		#var rating_y = 2
		#var strength_x = pow(exp(1), rating_x)
		#var odds_of_x_beats_y = pow(exp(1), (log(strength_x) - log(strength_y)))
		#var probability_of_x_beats_y = 1 / (1 + odds_of_x_beats_y)
	
	var ranking:Array[ScoredItem] = []
	
	var strength_of:Dictionary[String,float] = {}
	for item in unique_items:
		strength_of[item] = previous_strengths.get(item, 1.0)
	
	match comparisons_mode:
		#"Matrix":
			#var _comparisons:Array[Array] = comparisons_list_to_matrix()
		"Dictionary":
			var wins_count:Dictionary = comparisons_list_to_dictionary(comparisons_list, unique_items)
			
			var wins_sum_of:Dictionary[String,float]
			for winner in wins_count:
				wins_sum_of[winner] = 0
				for loser in wins_count[winner]:
					wins_sum_of[winner] += wins_count[winner][loser]
			
			for iteration in range(iteration_limit):
				if iteration_breaker.check_for_break_request(): break
				
				
				var opponent_difficulty_sum_for:Dictionary[String,float] = {}
				for winner in unique_items:
					opponent_difficulty_sum_for[winner] = 0.0
					for loser in wins_count[winner]:
						var sum_of_comparisons_between_both_items = wins_count[winner][loser] + wins_count.get(loser).get(winner,0)
						if winner != loser: opponent_difficulty_sum_for[winner] += sum_of_comparisons_between_both_items / (strength_of[winner] + strength_of[loser])
			
				for item in unique_items:
					if opponent_difficulty_sum_for[item] > 0:  # Avoid division by zero
						strength_of[item] = wins_sum_of[item] / opponent_difficulty_sum_for[item]
					else:
						strength_of[item] = unrated_item_default_strength  # Handle case where item i has no wins or comparisons
				
				presize_and_fill_array(unique_items, ranking, strength_of)
				thread.launch(sort_ranking, false, [ranking.duplicate(true), sort_ascending, iteration, iteration_limit])

func negative_bradley_terry(
	breaker:Breaker,
	comparisons_list:Array,
	unique_items:Array[String], 
	iteration_limit:int,
	starting_strength:float = 1.0
) -> void:
	
	var strength_of: Dictionary[String, float] = {}
	for item in unique_items:
		strength_of[item] = starting_strength

	# Learning rate for loser penalty
	var alpha: float = 0.1  # Controls penalty size; adjust as needed

	# Process each comparison to penalize losers
	for iteration in range(iteration_limit):
		if breaker.check_for_break_request(): break
		for comparison in comparisons_list:
			var winner: String = comparison[0]
			var loser: String = comparison[1]
			if winner == loser or not strength_of.has(winner) or not strength_of.has(loser):
				continue  # Skip invalid comparisons
			# Penalize loser's score
			var penalty: float = alpha * (strength_of[winner] / (strength_of[winner] + strength_of[loser]))
			strength_of[loser] *= (1.0 - penalty)  # Reduce loser's score
			# Winner's score remains unchanged

		# Emit signal with current ranking (sorted by strength)
		var ranking:Array[ScoredItem] = []
		presize_and_fill_array(unique_items, ranking, strength_of)
		thread.launch(sort_ranking, false, [ranking.duplicate(true), false, iteration, iteration_limit])

func iterative_elo_rating_model_attempt(
	breaker:Breaker,
	unique_items:Array[String],
	comparisons_list:Array,
	iteration_limit:int,
	previous_scores:Dictionary[String,float] = {},
	starting_score:float = 0.0
) -> void:
	
	#var ratings:Array[ScoredItem] = [] # this thing ?
	var new_score:Dictionary = {} # And that ?

	# What about this section ?
	var wins_count:Dictionary = comparisons_list_to_dictionary(comparisons_list, unique_items)
	
	var wins_sum_of:Dictionary[String,float]
	for winner in wins_count:
		wins_sum_of[winner] = 0
		for loser in wins_count[winner]:
			wins_sum_of[winner] += wins_count[winner][loser]
			
	# Since the ratings in elo are updated per match, you don't iterate to converge, you just add the miscalculation with a factor of confidence.
	for iteration in range(iteration_limit):
		if breaker.check_for_break_request(): break
	
	var score:Dictionary[String,float] = previous_scores
	for item in unique_items:
		score.get_or_add(item, starting_score)
	
	var denominator:Dictionary[String,float] = {} # This thing ?
	for winner in unique_items:
		denominator[winner] = 0.0 # Continued here ? Basically they are remnants of pure Bradley Terry but they won't apply to Elo since Elo using unbounded ratings instead of the principle of transitivity of odds.
		
		for loser in unique_items:
		#for loser in wins_count[winner]: # Iterate less, and then fill out the rest with the default starting score directly, although, that would mean using a separate for loop which is not smart actually.
			if winner == loser: continue
			var score_difference = log(score[winner]) - log(score[loser])
			var actual_score = wins_count[winner][loser]
			var learning_factor:float = rating_deviation()
			new_score[winner] = score[winner] + learning_factor*(actual_score - predicted_score(score_difference))
	
	
			#var sum_of_comparisons_between_both_items = wins_count[winner][loser] + wins_count.get(loser).get(winner,0)
			denominator[winner] += wins_count[winner][loser] + wins_count.get(loser).get(winner,0) / (score[winner] + score[loser])
#
	for item in unique_items:
		if denominator[item] > 0:  # Avoid division by zero
			score[item] = wins_sum_of[item] / denominator[item]
		else:
			score[item] = starting_score  # Handle case where item i has no wins or comparisons
			
	#presize_and_fill_array(unique_items, ranking, strength_of)
	thread.launch(sort_ranking, false) #, [ranking.duplicate(true), sort_descending, iteration, iteration_limit])

func the_fabled_glicko_2_model() -> void:
	pass



func predicted_score(rating_difference:float) -> float:
	return Curves.sigmoid(rating_difference)

func update_rating(previous_score:float, scaling_factor:float, actual_score, score_difference) -> float:
	var difference_from_prediction = actual_score - predicted_score(score_difference)
	return previous_score + scaling_factor*(difference_from_prediction)

func rating_deviation() -> float:
	return 1.0





func presize_and_fill_array(unique_items:Array[String], ranking:Array[ScoredItem], strength_of:Dictionary[String,float] = {}) -> void: 
	ranking.resize(unique_items.size()) # Performance improvement suggested by Grok, preallocates memory
	var index = 0
	for item in unique_items:
		ranking[index] = ScoredItem.new(item, strength_of[item], index) # Assigning to the existing indices of the pre-sized array rather than appending.
		index += 1

func sort_ranking(ranking:Array[ScoredItem], sort_ascending:bool = false, iteration_number:int = -1, _iteration_limit:int = -1) -> void:
	ranking.sort_custom(
		func(a, b): 
			if a.score == b.score: # Suggested addition by Grok to sort by ID if the strengths are equal, to ensure consistent ordering.
				return a.original_order < b.original_order
			return a.score < b.score if sort_ascending else a.score > b.score
	)
	#var index:int = 0
	#var identical:bool = true
	#if previous_iteration_sorted_ranking.is_empty():
		#identical = false
	#else:
		#for i in previous_iteration_sorted_ranking:
			#if previous_iteration_sorted_ranking[index].id != ranking[index].id:
				#identical = false
				#break
	
	#if !UpdatePreviousRankingMemory.is_connected(update_previous_ranking_memory): UpdatePreviousRankingMemory.connect(update_previous_ranking_memory)
	
	#if stopped_at_iteration == -1:
		#if identical && iteration_number+1 < iteration_limit: # Terribly fucking awful and I guess I'm too tired to bugfix it rn. Should really sleep.
			#if ranking_thread_breaker == false:
				#call_deferred("ranking_thread_interrupter", iteration_number, true)
				#call_deferred("emit_signal", "AllProcessingComplete")
				#call_deferred("emit_signal", "UpdatePreviousRankingMemory", []) 
		#elif iteration_number+1 == iteration_limit:
			#call_deferred("emit_signal", "RankingIterated", ranking, iteration_number)
			#call_deferred("emit_signal", "AllProcessingComplete")
			#call_deferred("emit_signal", "UpdatePreviousRankingMemory", [])
		#elif !identical:
	call_deferred("emit_signal", "RankingIterated", ranking, iteration_number) 

			#call_deferred("emit_signal", "UpdatePreviousRankingMemory", ranking.duplicate(true))
	




func update_previous_ranking_memory(previous_ranking:Array) -> void: previous_iteration_sorted_ranking = previous_ranking





































		#if loaded_page["Sorting"] == 1: # Bradley Terry
			#var names
			#for item in loaded_items:
				#names = item.file_name
			#var ranked_file_names = rank.ranking_relational_bradley_terry(rank.comparisons, names, 10, true)	
			#thumbnail = read_image(loaded_folder + file_names[ranked_file_names[i][2]]) # For now loading thumbnails from cache in other sorting modes is broken. Fix this later. Need an elegand bradley terry to normal sorting dictionary or something.
			#
			##if loaded_directory["Thumbnails"][i] == null:
				##thumbnail = read_image(folder_path + file_names[ranked_file_names[i][2]])
				##loaded_directory["Thumbnails"][i] = thumbnail
			##else:
				##thumbnail = loaded_directory["Thumbnails"][i]	
