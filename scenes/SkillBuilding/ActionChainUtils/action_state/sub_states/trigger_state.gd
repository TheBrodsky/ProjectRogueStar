extends Resource
class_name TriggerState


static func get_state() -> TriggerState:
	var state: TriggerState = TriggerState.new()
	state.resource_local_to_scene = true
	return state


func merge(other: TriggerState) -> void:
	pass
