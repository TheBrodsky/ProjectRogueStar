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
@export var action: PackedScene ## Determines what the event does/how it behaves. ie "cause"
@export var is_status_action: bool
@export var effect: Effect = DebugEffect.new() ## Determines how the action interacts with other things
@export var target: Target = AtReticle.new()

@onready var GroupIdGen: GroupIdGenerator = $GroupIdGenerator

var _event_group_name: String = "" ## Group added to all entities produced by this event. Allows to check existing entities
var _next_triggers: Array[Trigger] = []
var _state_transform: ActionStateStats = null



func do_event(state: ActionState) -> void:
	if _next_triggers.is_empty():
		_find_next_triggers()
	
	if _state_transform == null:
		_build_state_transform()
	
	if _event_group_name.is_empty():
		_event_group_name = GroupIdGen.make_group_name()
	
	state.merge(_state_transform)
	if is_status_action:
		_build_status_manager(state)
	else:
		_build_event_container(state)


func _build_event_container(state: ActionState) -> void:
	var container: EventContainer = EventContainer.new()
	get_tree().get_root().add_child(container)
	container.initialize(action, effect, max_entities, _event_group_name, state, _get_qualt_modifiers(), _next_triggers)
	container.build()


func _build_status_manager(state: ActionState) -> void:
	var affected_entity: Node2D = state.source
	var status_manager: StatusManager = null
	for child in affected_entity.get_children(): # check for existing manager
		if child is StatusManager:
			status_manager = child
			break
	
	if status_manager == null: # no existing manager, instantiate new one
		status_manager = StatusManager.new()
		affected_entity.add_child(status_manager)
	
	status_manager.add_status(action.instantiate() as Status, effect, state, _event_group_name, _get_qualt_modifiers(), _next_triggers)


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
