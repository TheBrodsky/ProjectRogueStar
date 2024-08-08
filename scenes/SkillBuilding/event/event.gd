@icon("res://assets/editor_icons/event.png")
extends ActionNode
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

@export var action: PackedScene ## Determines what the event does/how it behaves. ie "cause"
@export var effect: Effect = DebugEffect.new() ## Determines how the action interacts with other things
@export var target: Target = AtReticle.new()
@export var max_entities: int = -1 ## -1 is no max

@onready var GroupIdGen: GroupIdGenerator = $GroupIdGenerator

# these are supposed to be private but export makes them get duplicated correctly, so /shrug
@export_group(Globals.PRIVATE_CATEGORY)
@export var _event_group_name: String = "" ## Group added to all entities produced by this event. Allows to check existing entities
@export var _is_status_action: bool


func _enter_tree() -> void:
	action_type = ActionType.EVENT


func _ready() -> void:
	find_next_action_nodes([ActionType.TRIGGER])
	_determine_action_type()
	if _event_group_name.is_empty():
		_event_group_name = GroupIdGen.make_group_name()


func _run(state: ActionState) -> void:
	super._run(state)
	state.target = target
	if _is_status_action:
		_build_status_manager(state)
	else:
		_build_event_container(state)


# really just exists to log the connection and cast the type (.assign)
func _get_next_triggers() -> Array[Trigger]:
	for trigger: Trigger in _next:
		Logger.log_trace("%s: connecting to node %s" % [get_action_name(), trigger.get_action_name()])
	var next_as_triggers: Array[Trigger]
	next_as_triggers.assign(_next)
	return next_as_triggers


func _get_qualt_modifiers() -> Array[QualitativeModifier]:
	var qualt_mods: Array[QualitativeModifier] = []
	for child in get_children():
		if child is QualitativeModifier:
			qualt_mods.append(child)
	return qualt_mods


func _build_event_container(state: ActionState) -> void:
	var container: EventContainer = EventContainer.new()
	get_tree().get_root().add_child(container)
	container.initialize(action, effect, max_entities, _event_group_name, state, _get_qualt_modifiers(), _get_next_triggers())
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
	
	status_manager.add_status(action.instantiate() as Status, effect, state, _event_group_name, _get_qualt_modifiers(), _get_next_triggers())


func _determine_action_type() -> void:
	var action_type_name: String = action.get_state().get_node_type(0)
	_is_status_action = action_type_name == "Node"


func copy_from(other: ActionNode) -> void:
	super(other)
	_event_group_name = (other as Event)._event_group_name
	effect = (other as Event).effect
