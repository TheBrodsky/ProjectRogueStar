extends Node2D
class_name EventContainer


## If Events are the blueprint for a cause-and-event pattern, EventContainers are the implementation of that blueprint.
## EventContainers are created at the beginning of an event and persist until some termination condition is met.
## Usually this is when all the entities it *contains* are terminated, at which point the container serves no further purpose.
## It may be possible to have other termination conditions, such as a time limit.
##
## When an EventContainer is created and kicked off, it builds "actions" (also referred to as "entities") and gives them an effect.
## Additionally, it attaches any relevant triggers to those actions/entities to continue the chain.


#region properties
# fundamental event objects
var action_entity_packed: PackedScene
var effect: Effect
var state: ActionState
var triggers: Array[Trigger]

# follower properties
enum ContainerPosition {FROM_SOURCE, FROM_TARGET}
var container_position: ContainerPosition = ContainerPosition.FROM_SOURCE
var action_follower: PackedScene = null
var container_follower: PackedScene = null

# entity quantity properties
var max_entities: int
var entity_group_name: String
var num_actions: int = 1

# modifier properties
var modifiers: Array[QualitativeModifier]
var container_modifiers: Array[ContainerModifier] = []
var action_modifiers: Array[ActionModifier] = []

const _ACTION_ENTITY_KEY: String = "action_entity"
const _ACTION_INTERFACE_KEY: String = "i_action"
const _FOLLOWER_KEY: String = "follower"
const _REACHED_ENTITY_LIMIT_KEY: String = "reached_entity_limit" 
#endregion


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func initialize(action_entity_packed: PackedScene, effect: Effect, max_entities: int, entity_group_name: String, 
	state: ActionState, modifiers: Array[QualitativeModifier], triggers: Array[Trigger]) -> void:
	self.action_entity_packed = action_entity_packed
	self.effect = effect
	self.max_entities = max_entities
	self.entity_group_name = entity_group_name
	self.state = state
	self.modifiers = modifiers
	self.triggers = triggers
	_parse_modifiers()
	_modify_initialization()


func build() -> void:
	_add_follower_to_container()
	for i: int in num_actions:
		# get action and follower
		var action_dict: Dictionary = _build_action()
		if action_dict[_REACHED_ENTITY_LIMIT_KEY] == true:
			break
		
		var action_entity: Node2D = action_dict[_ACTION_ENTITY_KEY]
		var action_interface: ActionInterface = action_dict[_ACTION_INTERFACE_KEY]
		var follower: Follower = action_dict[_FOLLOWER_KEY]
		add_child(follower)
		
		# perform per-action modifications
		_modify_action_from_container_mods(action_entity, follower, i)
		_modify_action_from_action_mods(action_entity)
		action_interface.post_tree_initialize(triggers)
	_modify_build()


func _build_action() -> Dictionary:
	var return_dict: Dictionary = {
		_REACHED_ENTITY_LIMIT_KEY : false, 
		_ACTION_ENTITY_KEY : null, 
		_ACTION_INTERFACE_KEY : null, 
		_FOLLOWER_KEY : null}
	
	# check if max entities hit
	if max_entities > -1 and get_tree().get_nodes_in_group(entity_group_name).size() >= max_entities: # check 
		Logger.log_debug("Event hit maximum entities")
		return_dict[_REACHED_ENTITY_LIMIT_KEY] = true
	else:
		# create action entity
		var action_entity: Node2D = action_entity_packed.instantiate()
		action_entity.add_to_group(entity_group_name)
		return_dict[_ACTION_ENTITY_KEY] = action_entity
		
		# do action initialization
		var action_component: ActionInterface = ActionInterface.get_action_interface(action_entity)
		action_component.pre_tree_initialize(state.clone(), effect)
		return_dict[_ACTION_INTERFACE_KEY] = action_component
		
		# do follower initialization
		var new_follower: Follower = action_component.set_follower(action_follower, state, action_entity)
		new_follower.rotation = (state.stats.follower.target.get_target(get_tree()) - state.source.global_position).angle()
		return_dict[_FOLLOWER_KEY] = new_follower

	return return_dict


#region position, rotation, followers
func _add_follower_to_container() -> void:
	var container_pos: Vector2 = _get_container_pos()
	if container_follower != null:
		var follower: Follower = container_follower.instantiate()
		follower.modify_from_state(state)
		
		var parent: Node = get_parent() # store parent first because we have to reparent the container FIRST because _ready() calls in Follower
		reparent(follower)
		parent.add_child(follower)
		follower.global_position = container_pos
		
		tree_exited.connect(follower.queue_free) # makes sure follower gets cleaned up when event is freed
	else:
		global_position = container_pos


func _get_container_pos() -> Vector2:
	if container_position == ContainerPosition.FROM_SOURCE:
		return state.source.global_position
	else:
		return state.stats.follower.target.get_target(get_tree())
#endregion


#region modifier methods
## Separates the modifiers passed in by Event into more specific groups
func _parse_modifiers() -> void:
	for modifier: QualitativeModifier in modifiers:
		if modifier is ActionModifier:
			action_modifiers.append(modifier)
		elif modifier is ContainerModifier:
			container_modifiers.append(modifier)


## Allows any ContainerModifiers to apply any initialization modifications they have
func _modify_initialization() -> void:
	for modifier: ContainerModifier in container_modifiers:
		modifier.modify_initialization(state, self)


## Allows any ContainerModifiers to modify Actions within the Container as it's relevant to the Container itself.
func _modify_action_from_container_mods(action_entity: Node2D, follower: Follower, action_index: int) -> void:
	for modifier: ContainerModifier in container_modifiers:
		modifier.modify_action(state, self, action_entity, follower, action_index)


## Allows any ActionModifiers to modify Actions
func _modify_action_from_action_mods(action_entity: Node2D) -> void:
	for modifier: ActionModifier in action_modifiers:
		modifier.attach(action_entity, state)


func _modify_build() -> void:
	for modifier: ContainerModifier in container_modifiers:
		modifier.modify_build(state, self)
#endregion


func _should_exist() -> bool:
	return get_child_count() == 0
