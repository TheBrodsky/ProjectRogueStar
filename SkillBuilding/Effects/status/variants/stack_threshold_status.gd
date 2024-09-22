extends ProccableStatus
class_name StackThresholdStatus


@export var stack_threshold: int
@export var threshold_effect: Effect
@export var threshold_effect_stats: ActionStateStats
@export var expire_on_proc: bool = true


func build_new_tracker(state: ActionState, num_stacks: int, affected_entity: Node2D) -> StackTracker:
	var tracker: StackTracker = super(state, num_stacks, affected_entity)
	_on_stack_added(tracker)
	return tracker


func update_tracker(tracker: StackTracker, state: ActionState, num_stacks: int) -> void:
	super(tracker, state, num_stacks)
	_on_stack_added(tracker)


func _on_stack_added(tracker: StackTracker) -> void:
	if tracker.stacks >= stack_threshold:
		tracker.stacks = stack_threshold
		threshold_effect.do_effect(tracker.affected_entity, _get_scaled_tracker_state(tracker))
		tracker.force_expire()


func _get_scaled_tracker_state(tracker: StackTracker) -> ActionState:
	var cloned_state: ActionState = tracker.state.clone()
	cloned_state.stats.merge(threshold_effect_stats)
	return cloned_state
