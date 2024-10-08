@icon("res://assets/editor_icons/event.png")
extends Node
class_name Event


## Events are one of the two fundamental building blocks to the action chain.
## Events are responsible for describing a cause-and-effect pattern.
## Criticall, they only *describe* this behavior. The actual cause and effect behavior
## is handled by other classes, Action for "cause", Effect for "effect", 
## and "EventContainer" for some of the nitty-gritty internal details.
##
## A bullet-point list of what Event is responsible for:
## - operating within the action chain according to the ActionNode interface
## - gathering any subsequent triggers in the chain and passing them to whatever object may need them (see EventContainer)
## - using a unique group name to keep track of all entities which originated from this event

@export_group(Globals.MODIFIABLE_CATEGORY)
@export var max_entities: int = -1 ## -1 is no max

@export_group(Globals.INSPECTOR_CATEGORY)
@export var action_entity_packed: PackedScene ## Determines what the event does/how it behaves. ie "cause"
@export var effect: Effect = DebugEffect.new() ## Determines how the action interacts with other things
@export var target: Target = AtReticle.new()

var _event_group_name: String = "" ## Group added to all entities produced by this event. Allows to check existing entities
var _next_triggers: Array[Trigger] = []
var _state_transform: ActionStateStats = null
var _has_setup: bool = false


func do_event(state: ActionState) -> void:
	_do_one_time_setup()
	
	state.merge(_state_transform)
	_build_event_container(state)


func _build_event_container(state: ActionState) -> void:
	var container: EventContainer = EventContainer.new()
	get_tree().get_root().add_child(container)
	container.initialize(action_entity_packed, effect, max_entities, _event_group_name, state, _get_qualt_modifiers(), _next_triggers)
	container.build()


func _get_qualt_modifiers() -> Array[QualitativeModifier]:
	var qualt_mods: Array[QualitativeModifier] = []
	for child in get_children():
		if child is QualitativeModifier:
			qualt_mods.append(child)
	return qualt_mods


func _find_next_triggers() -> void:
	for child in get_children():
		if child is Trigger:
			_next_triggers.append(child)


func _build_state_transform() -> void:
	_state_transform = ActionStateStats.get_state()
	_state_transform.populate_substats()
	_state_transform.follower.target = target
	_apply_quant_modifiers(_state_transform)


func _apply_quant_modifiers(stats: ActionStateStats) -> void:
	for child: Node in get_children():
		if child is QuantitativeModifier:
			(child as QuantitativeModifier).modify_state(stats)


## Why isn't this in ready()? See AnyNode.
func _do_one_time_setup() -> void:
	if not _has_setup:
		_has_setup = true
		if _next_triggers.is_empty():
			_find_next_triggers()
		
		if _state_transform == null:
			_build_state_transform()
		
		if _event_group_name.is_empty():
			_event_group_name = GroupRegistry.get_group_id("event")
