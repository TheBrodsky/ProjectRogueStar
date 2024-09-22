extends Node
class_name StatusManager


var statuses: Dictionary = {}
var affected_entity: Node2D


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func add_status(status: Status, state: ActionState, num_stacks: int = 1) -> void:
	if status in statuses:
		var tracker: StackTracker = statuses[status]
		status.update_tracker(tracker, state, num_stacks)
	else:
		var tracker: StackTracker = status.build_new_tracker(state, num_stacks, affected_entity)
		statuses[status] = tracker
		add_child(tracker)


func _should_exist() -> bool:
	return get_child_count() == 0
