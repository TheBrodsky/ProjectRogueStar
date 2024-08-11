@icon("res://assets/editor_icons/trigger.png")
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

@export_group("Base Trigger Properties")
# coupled with supported_triggers.gd
@export_flags("Cyclical", "Hit", "HitReceived", "Kill", "Death", "Creation", "Expiration", "Proc") var trigger_type: int = 0
@export var is_one_shot: bool = false ## one shot triggers will pause after triggering once. Once paused, they will not run until resumed.

@export_group("Root Trigger Properties")
@export var is_root: bool = false ## If this is the highest trigger node in the chain, this should be true
@export var source_node: Node2D ## The node that acts as both the chain owner and the source of the chain

var state: ActionState
var _is_paused: bool = true # all triggers begin disengaged. Either a ChainRoot or preceding Event must engage it.


func _enter_tree() -> void:
	action_type = ActionType.TRIGGER


func _ready() -> void:
	find_next_action_nodes([ActionType.EVENT])
	if is_root:
		assert(source_node != null)
		var new_state: ActionState = ActionState.new()
		new_state.set_owner_type_from_node(source_node)
		new_state.source = source_node
		_run(new_state)
	else:
		pause() # non-root triggers go into standby until a parent calls them


func resume() -> void:
	_is_paused = false


func pause() -> void:
	_is_paused = true


func _run_next() -> void:
	for child: ActionNode in _next:
		Logger.log_trace("%s: connecting to node %s" % [get_action_name(), child.get_action_name()])
		var new_state: ActionState = state.clone() # Trigger -> Event state duplication
		child._run(new_state)
	

func _do_trigger() -> void:
	if !_is_paused:
		if is_one_shot:
			pause()
		triggered.emit(self)
		_run_next()


func _run(state: ActionState) -> void:
	super._run(state)
	self.state = state
	resume()
