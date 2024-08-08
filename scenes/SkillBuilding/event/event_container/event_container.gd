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
var action: PackedScene
var effect: Effect
var state: ActionState
var triggers: Array[Trigger]

# follower properties
enum ContainerPosition {FROM_SOURCE, FROM_TARGET}
var container_position: ContainerPosition = ContainerPosition.FROM_SOURCE
var action_follower: PackedScene = preload("res://scenes/BehaviorComponents/Targets and Followers/NewFollowers/StaticFollower.tscn")
var container_follower: PackedScene = null # has no default because it's uncommon to use this

# entity quantity properties
var max_entities: int
var entity_group_name: String
var num_actions: int = 1
var remaining_actions: int

# modifier properties
var modifiers: Array[QualitativeModifier]
var container_modifiers: Array[ContainerModifier] = []
var action_modifiers: Array[ActionModifier] = []
#endregion


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func initialize(action: PackedScene, effect: Effect, max_entities: int, entity_group_name: String, 
	state: ActionState, modifiers: Array[QualitativeModifier], triggers: Array[Trigger]) -> void:
	self.action = action
	self.effect = effect
	self.max_entities = max_entities
	self.entity_group_name = entity_group_name
	self.state = state # state is not duplicated here becaused we dont want to reset the quantative modifiers from Event
	self.modifiers = modifiers
	self.triggers = triggers
	_parse_modifiers()
	_modify_initialization()


func build() -> void:
	_add_follower_to_container()
	for i: int in num_actions:
		var new_action: Node2D = _build_action()
		if new_action == null: # null new_action means we're at entity limit, so we break
			break
		var follower: Follower = _add_follower_to_action(new_action)
		new_action.tree_exited.connect(_on_action_exited_tree) # this must be set AFTER the followers, because followers reparent actions (reparent triggers tree_exit)
		_set_triggers(new_action, triggers)
		_modify_action_from_container_mods(new_action, follower, i)
		_modify_action_from_action_mods(new_action)
	_modify_build()


#region position, rotation, followers
func _add_follower_to_action(new_action: Node2D) -> Follower:
	var follower: Follower = action_follower.instantiate()
	follower.modify_from_state(state)
	follower.add_child(new_action)
	add_child(follower)
	follower.rotation = (state.target.get_target(get_tree()) - state.source.global_position).angle()
	return follower


func _add_follower_to_container() -> void:
	var container_pos: Vector2 = _get_container_pos()
	if container_follower != null:
		var follower: Follower = container_follower.instantiate()
		follower.modify_from_state(state)
		
		var parent: Node = get_parent() # store parent first because we have to reparent the container FIRST because _ready() calls in Follower
		reparent(follower)
		parent.add_child(follower)
		follower.global_position = container_pos
		
		tree_exited.connect(Callable(follower, "queue_free")) # makes sure follower gets cleaned up when event is freed
	else:
		global_position = container_pos


func _get_container_pos() -> Vector2:
	if container_position == ContainerPosition.FROM_SOURCE:
		return state.source.global_position
	else:
		return state.target.get_target(get_tree())
#endregion


#region action methods
func _build_action() -> Node2D:
	var new_action: Node2D = null
	
	# check if max entities hit
	if max_entities > -1 and get_tree().get_nodes_in_group(entity_group_name).size() >= max_entities: # check 
		Logger.log_debug("Event hit maximum entities")
	else:
		# create action
		new_action = action.instantiate()
		new_action.add_to_group(entity_group_name)
		remaining_actions += 1
	
	if new_action != null:
		if "effect" in new_action:
				@warning_ignore("unsafe_property_access")
				new_action.effect = effect
		
		if "modify_from_action_state" in new_action:
			@warning_ignore("unsafe_method_access")
			new_action.modify_from_action_state(state.duplicate()) # Event -> Action state duplication

	return new_action


func _set_triggers(action_entity: Node2D, next_triggers: Array[Trigger]) -> void:
	if triggers.size() > 0 and "trigger_hook" in action_entity:
		@warning_ignore("unsafe_property_access")
		var trigger_hook: SupportedTriggers = action_entity.trigger_hook
		for trigger: Trigger in triggers:
			trigger_hook.set_trigger(trigger, state)
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


func _on_action_exited_tree() -> void:
	remaining_actions -= 1


func _should_exist() -> bool:
	return remaining_actions <= 0
