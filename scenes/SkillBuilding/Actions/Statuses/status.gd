extends Node
class_name Status
signal expire(status: Status, state: ActionState)
signal proc(status: Status, state: ActionState)


const tracker_packed: PackedScene = preload("res://scenes/SkillBuilding/Actions/Statuses/StackTracker.tscn")

enum StatusType {
	SHARED_STACK, ## Stacks share timers and their expiration timer is reset when adding a new stack 
	SHARED_STACK_NON_RESET, ## Stacks share timers but their expiration timer is not reset when adding a new stack
	SEPARATE_STACK ## Stacks proc and expire individually
}

@export_group(Globals.INSPECTOR_CATEGORY)
@export var base_stats: StatusState = StatusState.get_state()
@export var stack_scaling: ActionStateStats = ActionStateStats.get_state()
@export var status_type: StatusType
@export var has_stack_limit: bool = true ## Be careful about no limit or high limits for SEPARATE_STACK type

@export var trigger_hook: SupportedTriggers
@export var effect: Effect


var state: ActionState
var _tracker: StackTracker ## Not used for StatusType.SEPARATE_STACK
var _total_stacks: int = 0:
	set(value):
		_total_stacks = value
var _scaled_state: ActionState ## the last calculated state scaled to stacks
var _last_scaled_stacks: int = 0 ## the number of stacks _scaled_state was scaled at


#region public methods
func initialize(state: ActionState, effect: Effect) -> void:
	self.effect = effect
	self.state = state.duplicate()
	_modify_action_state()
	_modify_from_action_state()


func do_effect(body: Node2D) -> void:
	effect.modify_from_action_state(_get_scaled_state())
	effect.do_effect(body, _get_scaled_state())


func add_stacks(num_stacks: int = 1) -> void:
	if has_stack_limit:
		num_stacks -= max(0, _total_stacks + num_stacks - round(state.stats.status.max_stacks.val())) # make sure not to add more than max stacks
	_total_stacks += num_stacks
	match status_type:
		StatusType.SHARED_STACK, StatusType.SHARED_STACK_NON_RESET:
			if _tracker == null:
				_tracker = _build_new_tracker(num_stacks)
			else:
				var reset_stacks: bool = status_type == StatusType.SHARED_STACK
				_tracker.add_stacks(num_stacks, reset_stacks)
		StatusType.SEPARATE_STACK:
			_build_new_tracker(num_stacks)
#endregion

#region common action methods
func _modify_from_action_state() -> void:
	pass


func _modify_action_state() -> void:
	state.stats.status.merge(base_stats)
#endregion


func _build_new_tracker(num_stacks: int) -> StackTracker:
	var tracker: StackTracker = tracker_packed.instantiate()
	add_child(tracker)
	tracker.proc_time = state.stats.status.proc_time.val()
	tracker.expiration_time = state.stats.status.duration.val()
	tracker.add_stacks(num_stacks)
	tracker.stack_proc.connect(_on_proc)
	tracker.stack_expire.connect(_on_expiration)
	return tracker


func _get_scaled_state() -> ActionState:
	if _scaled_state == null or _total_stacks != _last_scaled_stacks:
		var unscaled_stats: ActionStateStats = stack_scaling.duplicate(true)
		_scaled_state = state.clone().merge(unscaled_stats.scale(_total_stacks))
	return _scaled_state


#region signal handlers
func _on_proc(tracker: StackTracker) -> void:
	proc.emit(self, state)
	do_effect(state.source)


func _on_expiration(tracker: StackTracker) -> void:
	_total_stacks -= tracker.stacks
	tracker.queue_free()
	_tracker = null
	
	if _total_stacks <= 0:
		expire.emit(self, state)
#endregion
