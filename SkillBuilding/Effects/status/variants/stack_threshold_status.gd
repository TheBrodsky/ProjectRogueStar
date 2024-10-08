extends ProccableStatus
class_name StackThresholdStatus


@export var stack_threshold: int
@export var threshold_effect: Effect
@export var threshold_effect_stats: ActionStateStats
@export var expire_on_proc: bool = true


func build_new_tracker(state: ActionState, affected_entity: Node2D) -> StackTracker:
	var tracker: StackTracker = super(state, affected_entity)
	_on_stack_added(tracker)
	return tracker


func update_tracker(tracker: StackTracker, state: ActionState) -> void:
	super(tracker, state)
	_on_stack_added(tracker)


func _on_stack_added(tracker: StackTracker) -> void:
	if tracker.stacks >= stack_threshold:
		tracker.stacks = stack_threshold
		do_effect(threshold_effect, tracker)
		tracker.force_expire()


func _get_scaled_tracker_state(tracker: StackTracker) -> ActionState:
	var cloned_state: ActionState = tracker.state.clone()
	cloned_state.stats.merge(threshold_effect_stats)
	return cloned_state
