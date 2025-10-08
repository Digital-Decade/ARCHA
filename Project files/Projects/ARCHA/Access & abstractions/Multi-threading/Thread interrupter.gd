extends Node
class_name Breaker

var should_break:bool


func _init() -> void: reset()

func reset() -> void: should_break = false

func request_break() -> void: should_break = true

func check_for_break_request() -> bool:
	if should_break: reset(); return true
	else: return false 



#var additional_information

#enum Iterations {RANKING, SORTING}
#func should_iterations_continue(iterations_of:Iterations) -> bool:
	#return true # Temp
	
#var final_ranking_iteration:int = 0
#var final_sorting_iteration:int = 0
	
## Something something about synchronizing the threads that may not be at the same iteration levels.
## The last one in the chain before the results are displayed, it should not update the displayed results if it receives stuff from the chain after the iterration number it concluded was the last.
