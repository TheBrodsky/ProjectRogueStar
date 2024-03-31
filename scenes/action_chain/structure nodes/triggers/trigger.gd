class_name Trigger
extends ActionNode
signal triggered(origin: Trigger)


## Triggers specify when the current "place" in the ActionChain advances to the next node (usually an Event)
##
## Together with Events, Triggers are the two fundamental building blocks of the ActionChain. See ActionNode for more information.
## Triggers listen for something or track a process, the outcome of which is a call to _do_trigger(). This also emits triggered.
##
## Triggers keep a persistent reference to an action_state at all times, because they may be "active" for more than a single frame.
## Because Triggers keep a persistent reference of the ActionState, triggers clone the ActionState when running the next node,
## which prevents nodes later in the chain from making unexpected modifications that propagate up the chain.


@export var is_one_shot: bool = false # one shot triggers will pause after triggering once. Once paused, they will not run until resumed.

var action_state: ActionState
var _is_paused: bool = true # all triggers being disengaged. Either a ChainRoot or preceding Event must engage it.


func _enter_tree() -> void:
	actionType = ActionType.TRIGGER


func _ready() -> void:
	_next = get_next_action_node([ActionType.EVENT, ActionType.BRANCH])
	pause()


func resume() -> void:
	_is_paused = false


func pause() -> void:
	_is_paused = true
	

func _do_trigger() -> void:
	if !_is_paused:
		if is_one_shot:
			pause()
		triggered.emit(self)
		run_next()


func _run(state: ActionState) -> void:
	super._run(state)
	action_state = state
	resume()


func run_next() -> void:
	var next: ActionNode = _get_next()
	if next != null:
		Logger.log_debug("%s: connecting to node %s" % [get_action_name(), next.get_action_name()])
		next._run(action_state.clone())
