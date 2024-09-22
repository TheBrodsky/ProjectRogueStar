extends Resource
class_name Status


const atomic_tracker_packed: PackedScene = preload("res://SkillBuilding/Effects/status/stack_tracker/AtomicTracker.tscn")
const tracker_packed: PackedScene = preload("res://SkillBuilding/Effects/status/stack_tracker/StackTracker.tscn")
const queue_tracker_packed: PackedScene = preload("res://SkillBuilding/Effects/status/stack_tracker/QueueStackTracker.tscn")

enum StackingType {
	ATOMIC_STACK, ## An atomic status does not stack. Put differently, it always has 1 stack.
	SHARED_STACK, ## Stacks share timers and their expiration timer is reset when adding a new stack 
	SHARED_STACK_NON_RESET, ## Stacks share timers but their expiration timer is not reset when adding a new stack
	SEPARATE_STACK ## Stacks proc and expire individually
}

@export var base_stats: StatusState
@export var effect: Effect
@export var stack_type: StackingType
@export var stack_scaling: ActionStateStats = ActionStateStats.get_state()


func build_new_tracker(state: ActionState, num_stacks: int, affected_entity: Node2D) -> StackTracker:
	var merged_state: ActionState = _get_modified_base_stats(state)
	var tracker: StackTracker = _get_tracker_type()
	tracker.initialize(merged_state, num_stacks, affected_entity)
	tracker.expire.connect(_on_expiration)
	return tracker


func update_tracker(tracker: StackTracker, state: ActionState, num_stacks: int) -> void:
	var merged_state: ActionState = _get_modified_base_stats(state)
	var reset_expiration_timer: bool = stack_type == StackingType.SHARED_STACK
	tracker.update(merged_state, num_stacks, reset_expiration_timer)


func _get_modified_base_stats(state: ActionState) -> ActionState:
	var modified_state: ActionState = state.clone()
	modified_state.stats.status.merge(base_stats)
	return modified_state


func _get_scaled_tracker_state(tracker: StackTracker) -> ActionState:
	var cloned_scaling: ActionStateStats = stack_scaling.duplicate(true)
	cloned_scaling.scale(tracker.stacks)
	var cloned_state: ActionState = tracker.state.clone()
	cloned_state.stats.merge(cloned_scaling)
	return cloned_state


func _get_tracker_type() -> StackTracker:
	match stack_type:
		StackingType.ATOMIC_STACK:
			return atomic_tracker_packed.instantiate()
		StackingType.SHARED_STACK or StackingType.SHARED_STACK_NON_RESET:
			return tracker_packed.instantiate()
		StackingType.SEPARATE_STACK:
			return queue_tracker_packed.instantiate()
		_:
			return tracker_packed.instantiate()


func _on_expiration(tracker: StackTracker) -> void:
	pass









