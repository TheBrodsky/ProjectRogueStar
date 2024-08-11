extends Resource
class_name StatusState


static func get_state() -> StatusState:
	var state: StatusState = StatusState.new()
	state.resource_local_to_scene = true
	return state


func merge(other: StatusState) -> void:
	stacks += other.stacks


@export var stacks: int = 0 # used by actions that can "stack", multiplying Effect by the number of stacks
func get_stacks() -> int: return stacks if stacks > 0 else 1
