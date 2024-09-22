extends Resource
class_name StatusState


static func get_state() -> StatusState:
	var state: StatusState = StatusState.new()
	state.resource_local_to_scene = true
	return state


@export var ignore_stack_limit: bool = false
@export var max_stacks: FloatStat = FloatStat.get_stat()
@export var proc_time: FloatStat = FloatStat.get_stat()
@export var duration: FloatStat = FloatStat.get_stat()


func merge(other: StatusState) -> void:
	ignore_stack_limit = ignore_stack_limit or other.ignore_stack_limit
	max_stacks.merge(other.max_stacks)
	proc_time.merge(other.proc_time)
	duration.merge(other.duration)


func scale(scalar: float) -> void:
	max_stacks.scale(scalar)
	proc_time.scale(scalar)
	duration.scale(scalar)
