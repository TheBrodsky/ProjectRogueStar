extends StackTracker
class_name QueueStackTracker


## Uses a timeline/queue to mark when individual stacks expire, allowing independent stack expiration.
## To simplify the logic, this tracker DOES NOT RESPECT STACK LIMITS.
## This tracker does not have an Expiration timer. It expires when it reaches 0 stacks.


var _timeline: Array[Vector2] = [] ## x = timestamp for expiration, y = number of stacks
var _cur_time: float = 0
var _last_expired_stacks: int = 0


func _process(delta: float) -> void:
	_cur_time += delta
	
	# check for expired stacks
	while _timeline.size() > 0 and _timeline[0].x < _cur_time:
		var expiring_stacks: Vector2 = _timeline.pop_front()
		stacks -= expiring_stacks.y
		_last_expired_stacks = expiring_stacks.y
	
	if _timeline.size() == 0:
		queue_free()
		expire.emit(self)


func update(new_state: ActionState, num_stacks: int, reset_expiration: bool) -> void:
	_update_properties_from_state(new_state)
	_add_stacks(num_stacks)
	_weighted_average_state(new_state, num_stacks)


## Adds stacks to the tracker, respecting stack limit. Returns the amount of stacks added, after limit considerations.
func _add_stacks(num_stacks: int) -> void:
	stacks += num_stacks
	var expiration_time: float = _cur_time + state.stats.status.duration.val()
	_timeline.append(Vector2(expiration_time, num_stacks))


func _update_properties_from_state(state: ActionState) -> void:
	var stats: StatusState = state.stats.status
	_proc_time = stats.proc_time.val()


func _on_proc_timer_timeout() -> void:
	if stacks == 0: # the last proc can be 0 stacks if it happens right as the tracker expires; this fixes that
		stacks = _last_expired_stacks
	proc.emit(self)
