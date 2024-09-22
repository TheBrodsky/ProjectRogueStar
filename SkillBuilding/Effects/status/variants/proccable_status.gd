extends Status
class_name ProccableStatus


func build_new_tracker(state: ActionState, num_stacks: int, affected_entity: Node2D) -> StackTracker:
	var tracker: StackTracker = super(state, num_stacks, affected_entity)
	tracker.proc.connect(_on_proc)
	return tracker


func _on_proc(tracker: StackTracker) -> void:
	if effect != null:
		effect.do_effect(tracker.affected_entity, _get_scaled_tracker_state(tracker))
