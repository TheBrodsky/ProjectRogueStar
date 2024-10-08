extends Node
class_name StackTracker
signal proc(tracker: StackTracker)
signal expire(tracker: StackTracker)


## StackTrackers have all the instance-related logic for handling statuses.
## A StackTracker is status-agnotistic, since the exact behavior of a status effect
## is largely unrelated to the logic of tracking the duration, stacks, and proccing of a status.


@export var proc_timer: Timer
@export var expiration_timer: Timer

var stacks: int = 0
var state: ActionState
var affected_entity: Node2D
var triggers: Array[Trigger] = [] # statuses pass triggers on to their effect

var _max_stacks: int
var _ignore_stack_limit: bool

var _proc_time: float = 1: ## Time in seconds between procs
	set(value):
		_proc_time = value
		if proc_timer != null:
			proc_timer.wait_time = _proc_time

var _expiration_time: float = 1: ## Time in seconds before stacks expire
	set(value):
		_expiration_time = value
		if expiration_timer != null:
			expiration_timer.wait_time = _expiration_time


func _ready() -> void:
	if proc_timer != null:
		proc_timer.timeout.connect(_on_proc_timer_timeout)
	
	if expiration_timer != null:
		expiration_timer.timeout.connect(_on_expiration_timer_timeout)


func _process(delta: float) -> void:
	if stacks == 0:
		queue_free()
		expire.emit(self)


func initialize(state: ActionState, num_stacks: int, affected_entity: Node2D) -> void:
	self.state = state
	self.state.source = affected_entity
	self.affected_entity = affected_entity
	_update_properties_from_state(state)
	_add_stacks(num_stacks)


func update(new_state: ActionState, num_stacks: int, reset_expiration: bool) -> void:
	_update_properties_from_state(new_state)
	if reset_expiration:
		expiration_timer.start()
	_add_stacks(num_stacks)
	_weighted_average_state(new_state, num_stacks)


func force_expire() -> void:
	queue_free()
	expire.emit(self)


func add_triggers(triggers: Array[Trigger]) -> void:
	for trigger in triggers:
		trigger.engage(self)
	self.triggers.append_array(triggers)


## Adds stacks to the tracker, respecting stack limit. Returns the amount of stacks added, after limit considerations.
func _add_stacks(num_stacks: int) -> void:
	stacks += num_stacks
	if not _ignore_stack_limit and stacks > _max_stacks:
		stacks = _max_stacks


func _update_properties_from_state(state: ActionState) -> void:
	var stats: StatusState = state.stats.status
	_max_stacks = floor(stats.max_stacks.val())
	_ignore_stack_limit = stats.ignore_stack_limit
	_expiration_time = stats.duration.val()
	_proc_time = stats.proc_time.val()


## Calculates a weighted average based on number of stacks between the old state and the new one
func _weighted_average_state(new_state: ActionState, new_stacks: int) -> void:
	var new_state_factor: float = new_stacks / stacks
	var old_state_factor: float = 1 - new_state_factor
	state.scale(old_state_factor)
	new_state.scale(new_state_factor)
	state.merge(new_state.stats)


func _on_proc_timer_timeout() -> void:
	proc.emit(self)


func _on_expiration_timer_timeout() -> void:
	if proc_timer.time_left <= .01: # sometimes expire and proc tie, which is a problem if expire gets called first
		proc.emit(self)
	queue_free()
	expire.emit(self)
