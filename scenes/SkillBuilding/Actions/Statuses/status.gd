extends Node
class_name Status
signal expire(status: Status)
signal proc(status: Status)


const tracker_packed: PackedScene = preload("res://scenes/SkillBuilding/Actions/Statuses/StackTracker.tscn")

enum StatusType {
	SHARED_STACK, ## Stacks share timers and their expiration timer is reset when adding a new stack 
	SHARED_STACK_NON_RESET, ## Stacks share timers but their expiration timer is not reset when adding a new stack
	SEPARATE_STACK ## Stacks proc and expire individually
}
@export var status_type: StatusType
@export var max_stacks: int = -1 ## -1 is no limit. Be careful about no limit or high limits for SEPARATE_STACK type
@export var proc_time: float = 1 ## Number of seconds between each proc
@export var duration: float = 1 ## Time (in seconds) before stack(s) expire
@export var effect: Effect
@export var affected_entity: Node2D
@export var stack_efficiency: float = 1 ## How effective stacks are, as a multiplier 

var state: ActionState
var _tracker: StackTracker
var _total_stacks: int = 0:
	set(value):
		_total_stacks = value
		_update_stack_count()


func _ready() -> void:
	if max_stacks == -1:
		max_stacks = Globals.INT64_MAX


func initialize(state: ActionState, effect: Effect) -> void:
	self.effect = effect
	modify_from_action_state(state)


func modify_from_action_state(state: ActionState) -> void:
	self.state = modify_action_state(state)


func modify_action_state(state: ActionState) -> ActionState:
	return state


func do_effect(body: Node2D) -> void:
	effect.modify_from_action_state(state)
	effect.do_effect(body, state)


func add_stacks(num_stacks: int = 1) -> void:
	num_stacks -= max(0, _total_stacks + num_stacks - max_stacks) # make sure not to add more than max stacks
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
	

func _build_new_tracker(num_stacks: int) -> StackTracker:
	var tracker: StackTracker = tracker_packed.instantiate()
	add_child(tracker)
	tracker.proc_time = proc_time
	tracker.expiration_time = duration
	tracker.add_stacks(num_stacks)
	tracker.stack_proc.connect(_on_proc)
	tracker.stack_expire.connect(_on_expiration)
	return tracker


func _update_stack_count() -> void:
	state.stacks = _total_stacks * stack_efficiency


func _on_proc(tracker: StackTracker) -> void:
	proc.emit(self)
	do_effect(affected_entity)


func _on_expiration(tracker: StackTracker) -> void:
	_total_stacks -= tracker.stacks
	tracker.queue_free()
	_tracker = null
	
	if _total_stacks <= 0:
		expire.emit(self)
