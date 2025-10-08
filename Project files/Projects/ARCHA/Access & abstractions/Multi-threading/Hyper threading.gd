extends Node
class_name HyperThreading

var thread0:MultiThreading = MultiThreading.new()
var thread1:MultiThreading = MultiThreading.new()
var thread2:MultiThreading = MultiThreading.new()
var thread3:MultiThreading = MultiThreading.new()
var thread4:MultiThreading = MultiThreading.new()
var thread5:MultiThreading = MultiThreading.new()
var thread6:MultiThreading = MultiThreading.new()
var thread7:MultiThreading = MultiThreading.new()
var thread8:MultiThreading = MultiThreading.new()
var thread9:MultiThreading = MultiThreading.new()

func launch(function_to_run:Callable, breaker_logic_included:bool = false, arguments:Array = [], max_parallel_threads:int = 1) -> Variant:
	var previous_thread_results:Variant
	if 		!thread0.thread.is_alive() && max_parallel_threads > 0: 	previous_thread_results = thread0.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread1.thread.is_alive() && max_parallel_threads > 1: 	previous_thread_results = thread1.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread2.thread.is_alive() && max_parallel_threads > 2: 	previous_thread_results = thread2.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread3.thread.is_alive() && max_parallel_threads > 3: 	previous_thread_results = thread3.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread4.thread.is_alive() && max_parallel_threads > 4: 	previous_thread_results = thread4.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread5.thread.is_alive() && max_parallel_threads > 5: 	previous_thread_results = thread5.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread6.thread.is_alive() && max_parallel_threads > 6: 	previous_thread_results = thread6.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread7.thread.is_alive() && max_parallel_threads > 7: 	previous_thread_results = thread7.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread8.thread.is_alive() && max_parallel_threads > 8: 	previous_thread_results = thread8.launch(function_to_run, breaker_logic_included, arguments)
	elif 	!thread9.thread.is_alive() && max_parallel_threads > 9: 	previous_thread_results = thread9.launch(function_to_run, breaker_logic_included, arguments)
	else: 																previous_thread_results = thread0.launch(function_to_run, breaker_logic_included, arguments) # Fallback, if user set thread to 0, or if all threads are busy, just use thread 0. Probably not the best design descision.
	return previous_thread_results
