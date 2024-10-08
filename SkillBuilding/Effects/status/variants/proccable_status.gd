extends Status
class_name ProccableStatus


func build_new_tracker(state: ActionState, affected_entity: Node2D) -> StackTracker:
	var tracker: StackTracker = super(state, affected_entity)
	tracker.proc.connect(_on_proc)
	return tracker


func _on_proc(tracker: StackTracker) -> void:
	if effect != null:
		do_effect(effect, tracker)
