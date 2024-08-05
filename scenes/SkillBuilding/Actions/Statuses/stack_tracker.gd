extends Node
class_name StackTracker
signal stack_proc(tracker: StackTracker)
signal stack_expire(tracker: StackTracker)


@export var proc_timer: Timer
@export var expiration_timer: Timer

var proc_time: float = 1: ## Time in seconds between procs
	set(value):
		proc_time = value
		if proc_timer != null:
			proc_timer.wait_time = proc_time
			proc_timer.start()

var expiration_time: float = 1: ## Time in seconds before stacks expire
	set(value):
		expiration_time = value
		if expiration_timer != null:
			expiration_timer.wait_time = expiration_time
			expiration_timer.start()

var stacks: int = 0


func add_stacks(num_stacks: int, reset_expiration: bool = true) -> void:
	stacks += num_stacks
	if reset_expiration:
		expiration_timer.start()


func _on_proc_timer_timeout() -> void:
	stack_proc.emit(self)


func _on_expiration_timer_timeout() -> void:
	# sometimes when timers tie, this one happens first, preventing the other from happening
	if proc_timer.time_left <= .01:
		stack_proc.emit(self)
	stack_expire.emit(self)
