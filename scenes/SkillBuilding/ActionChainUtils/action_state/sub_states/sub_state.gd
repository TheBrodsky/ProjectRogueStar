extends Resource
class_name SubState


static func get_state() -> SubState:
	var state: SubState = SubState.new()
	state.resource_local_to_scene = true
	return state
