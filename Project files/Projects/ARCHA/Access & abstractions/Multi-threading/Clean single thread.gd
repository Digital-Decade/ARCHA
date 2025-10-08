extends Node
class_name MultiThreading

var thread:Thread = Thread.new()
var breaker:Breaker = Breaker.new()

func launch(function_to_run:Callable, breaker_logic_included:bool = false, arguments:Array = []) -> Variant:
	var previous_thread_results:Variant
	if breaker_logic_included && thread.is_alive():
		breaker.request_break()
	if thread.is_started():
		previous_thread_results = thread.wait_to_finish()
	thread = Thread.new()
	if breaker_logic_included: match arguments.size():
			0: thread.start(function_to_run.bind(breaker))
			1: thread.start(function_to_run.bind(breaker, arguments[0]))
			2: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1]))
			3: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2]))
			4: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3]))
			5: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]))
			6: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]))
			7: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]))
			8: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]))
			9: thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]))
			10:thread.start(function_to_run.bind(breaker, arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]))
			_: push_warning("Passed along too many arguments to the thread_launcher() function, please expand this function if needed.")
	else: match arguments.size():
			0: thread.start(function_to_run)
			1: thread.start(function_to_run.bind(arguments[0]))
			2: thread.start(function_to_run.bind(arguments[0], arguments[1]))
			3: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2]))
			4: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3]))
			5: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]))
			6: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]))
			7: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]))
			8: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]))
			9: thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]))
			10:thread.start(function_to_run.bind(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]))
			_: push_warning("Passed along too many arguments to the thread_launcher() function, please expand this function if needed.")
	return previous_thread_results
