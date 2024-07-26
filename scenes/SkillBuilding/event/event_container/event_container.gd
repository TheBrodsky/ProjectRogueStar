extends Node2D
class_name EventContainer


## If Events are the blueprint for a cause-and-event pattern, EventContainers are the implementation of that blueprint.
## EventContainers are created at the beginning of an event and persist until some termination condition is met.
## Usually this is when all the entities it *contains* are terminated, at which point the container serves no further purpose.
## It may be possible to have other termination conditions, such as a time limit.
##
## When an EventContainer is created and kicked off, it builds "actions" (also referred to as "entities") and gives them an effect.
## Additionally, it attaches any relevant triggers to those actions/entities to continue the chain.


# data/objects passed in via Event. See Event for more info.
var action: PackedScene
var effect: PackedScene
var max_entities: int
var entity_group_name: String
var state: ActionState
var modifiers: Array[QualitativeModifier]
var triggers: Array[Trigger]

var num_actions: int = 1
var container_modifiers: Array[ContainerModifier] = []
var action_modifiers: Array[ActionModifier] = []


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func initialize(action: PackedScene, effect: PackedScene, max_entities: int, entity_group_name: String, 
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
	position = state.source.global_position
	for i: int in num_actions:
		var new_action: Node2D = _build_action()
		if new_action == null: # null new_action means we're at entity limit, so we break
			break
		_add_action(new_action)
		#_set_triggers(new_action)
		_modify_action_from_container_mods(new_action, i)
		_modify_action_from_action_mods(new_action)


func _add_action(new_action: Node2D) -> void:
	if "modify_from_action_state" in new_action:
		@warning_ignore("unsafe_method_access")
		new_action.modify_from_action_state(state)
	add_child(new_action)


func _build_action() -> Node2D:
	var new_action: Node2D = null # most of the time this will be of type Action
	if max_entities > -1 and get_tree().get_nodes_in_group(entity_group_name).size() >= max_entities:
		Logger.log_debug("Actionable hit maximum entities")
	else:
		new_action = action.instantiate()
		new_action.add_to_group(entity_group_name)
		if "effect" in new_action:
			var new_effect: Effect = effect.instantiate()
			new_effect.modify_from_action_state(state)
			@warning_ignore("unsafe_property_access")
			new_action.effect = new_effect
	return new_action


## TODO THIS NEEDS TO BE LOOKED AT
func _set_single_trigger(trigger: Trigger) -> void:
	for entity: Node in get_children():
		for entity_child in entity.get_children():
			if entity_child is TriggerHook:
				(entity_child as TriggerHook).set_trigger(trigger, state)

## TODO THIS NEEDS TO BE LOOKED AT
func _set_triggers(next_triggers: Array[Trigger]) -> void:
	for trigger: Trigger in next_triggers:
		_set_single_trigger(trigger)


func _should_exist() -> bool:
	return get_child_count() == 0


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
func _modify_action_from_container_mods(action: Node2D, action_index: int) -> void:
	for modifier: ContainerModifier in container_modifiers:
		modifier.modify_action(state, self, action, action_index)


## Allows any ActionModifiers to modify Actions
func _modify_action_from_action_mods(action: Node2D) -> void:
	for modifier: ActionModifier in action_modifiers:
		modifier.attach(action, state)
#endregion
