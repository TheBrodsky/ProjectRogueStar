extends Node
class_name StatusManager


var statuses: Dictionary = {} ## Script : Status, get_class() doesnt return custom classes so this is the only option


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func add_status(status: Status, effect: Effect, state: ActionState) -> void:
	if status.get_script() in statuses:
		var existing_status: Status = statuses[status.get_script()]
		existing_status.add_stacks()
	else:
		add_child(status)
		status.affected_entity = state.source
		status.initialize(state, effect)
		statuses[status.get_script()] = status
		status.expire.connect(_remove_status)
		status.add_stacks()
		


func _remove_status(status: Status) -> void:
	statuses.erase(status.get_script())
	status.queue_free()


func _should_exist() -> bool:
	return get_child_count() == 0
