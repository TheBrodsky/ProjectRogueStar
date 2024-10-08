extends Node
class_name StatusManager


## Status manager manage the instanced statuses on an entity.
## Statuses managers are the interface for other things to add statuses to an entity.
## This also handles the cleanup of statuses when all their stacks have expired,
## courtesy of StackTracker emitting "expire"


var statuses: Dictionary = {}
var affected_entity: Node2D


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func add_status(status: Status, state: ActionState, triggers: Array[Trigger]) -> void:
	if status in statuses:
		var tracker: StackTracker = statuses[status]
		status.update_tracker(tracker, state)
	else:
		var tracker: StackTracker = status.build_new_tracker(state, affected_entity)
		statuses[status] = tracker
		tracker.add_triggers(triggers)
		add_child(tracker)


func _should_exist() -> bool:
	return get_child_count() == 0
