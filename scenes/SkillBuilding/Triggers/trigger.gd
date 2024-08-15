@icon("res://assets/editor_icons/trigger.png")
class_name Trigger
extends Node


## Triggers represent the "cause" part of the "cause and effect" loop of the ActionChain
## Triggers listen for something or track a process, the outcome of which is a call to do_trigger()
## Triggers are stateless; ie they do not store states. They rely on whatever trips the trigger to pass
## a state in via a signal. The exact nature of that signal contract is different for each Trigger type.
##
## Triggers can operate as the root of a chain. In this case, it must be specified that it's a root.


## Determines whether the connecting node meets the requirements to be able to trigger this Trigger
static func is_compatible(connecting_node: Node) -> bool:
	return true


@export_group(Globals.INSPECTOR_CATEGORY)
@export_subgroup("Base Trigger Properties")
# coupled with supported_triggers.gd
@export_flags("Cyclical", "Hit", "HitReceived", "Kill", "Death", "Creation", "Expiration", "Proc") var trigger_type: int = 0
@export var preserves_state: bool = false ## if true, the ActionState is not reset as it passes to the Trigger. Be careful with this, it can be very powerful.

@export_subgroup("Root Trigger Properties")
@export var is_root: bool = false ## If this is the highest trigger node in the chain, this should be true
@export var source_node: Node2D ## The node that acts as both the chain owner and the source of the chain

var _next_events: Array[Event] = []


func _ready() -> void:
	_find_next_events()
	if is_root:
		if source_node == null:
			assert(get_parent() is Node2D)
			source_node = get_parent()
		preserves_state = true # no sense duplicating the state if this is the root
		engage(null)


## Performs any necessary setup for the trigger to do its function
func engage(connecting_node: Node) -> void:
	if is_root:
		_engage_as_root(_build_new_state_for_root())
	else:
		_engage_as_link(connecting_node)


func do_trigger(state: ActionState) -> void:
	for event: Event in _next_events:
		var new_state: ActionState = state.clone() # Trigger -> Event state duplication
		event.do_event(new_state)


func _engage_as_root(state: ActionState) -> void:
	pass


func _engage_as_link(connecting_node: Node) -> void:
	pass


func _find_next_events() -> void:
	for child in get_children():
		if child is Event:
			_next_events.append(child)


func _build_new_state_for_root() -> ActionState:
	assert(source_node != null)
	var new_state: ActionState = ActionState.get_state()
	new_state.set_owner_type_from_node(source_node)
	new_state.source = source_node
	return new_state


func _build_state_for_trigger(state: ActionState) -> ActionState:
	if not preserves_state:
		state = ActionState.get_state(state) # get a clean state with owner and source from passed-in state
	return state
