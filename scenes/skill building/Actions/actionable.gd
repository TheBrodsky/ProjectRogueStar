@icon("res://assets/editor_icons/actionable.png")
class_name Actionable
extends Node2D


## An interface for types of nodes that can be used by an event to do an action.

@export var action_shape: PackedScene ## Determines how the action behaves/what it does. ie "cause"
@export var effect: Effect ## Determines how the action interacts with other things
@export var max_entities: int = -1 ## -1 is no max

var state: ActionState ## usually null if is_blueprint is true
var is_blueprint: bool = true ## blueprints live in the action chain and serve as a blueprint to copy

# Ids are used to generate unique group names to keep track of emitted entities
static var _id_counter: int = 0
var _id: int
var _group_name: String


func _ready() -> void:
	if effect == null:
		_find_effect()
	
	if is_blueprint:
		_make_entity_group_name()
		set_process(false)
	else:
		set_process(true)
		state = state.duplicate()


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


#region action methods
## Overridable
func _pre_action(next_triggers: Array[Trigger]) -> void:
	position = state.source.global_position


## Overridable
func _main_action(next_triggers: Array[Trigger]) -> void:
	add_entity(_build_entity())


## Overridable
func _post_action(next_triggers: Array[Trigger]) -> void:
	_set_triggers(next_triggers)
	_apply_state_attachers()


func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	if max_entities > -1 and get_tree().get_nodes_in_group(_group_name).size() >= max_entities:
		Logger.log_debug("Actionable hit maximum entities")
	else:
		if is_blueprint: # if this is the blueprint, it needs to be cloned and added to the tree as a non-blueprint
			var new_actionable: Actionable = clone()
			new_actionable.state = new_state
			get_tree().get_root().add_child(new_actionable)
			new_actionable.do_action(null, next_triggers) # recursive call on non-blueprint actionable will go to else case
		else:
			_pre_action(next_triggers)
			_main_action(next_triggers)
			_post_action(next_triggers)

#endregion

#region public methods
func add_entity(new_entity: Node2D) -> void:
	new_entity.add_to_group(_group_name)
	add_child(new_entity)
	if "modify_from_action_state" in new_entity:
		@warning_ignore("unsafe_method_access")
		new_entity.modify_from_action_state(state)


func clone(flags: int = 15) -> Actionable:
	var new_actionable: Actionable = self.duplicate(flags)
	new_actionable._copy_from(self)
	return new_actionable

#endregion

#region private methods
func _copy_from(other: Actionable) -> void:
	is_blueprint = false # is_blueprint is NEVER passed on
	effect = other.effect
	_id = other._id
	_group_name = other._group_name


func _build_entity() -> Node2D:
	var new_entity: Node2D = action_shape.instantiate()
	if "effect" in new_entity:
		@warning_ignore("unsafe_property_access")
		new_entity.effect = effect
	return new_entity


func _set_trigger(trigger: Trigger) -> void:
	for entity: Node in get_children():
		for entity_child in entity.get_children():
			if entity_child is TriggerHook:
				(entity_child as TriggerHook).set_trigger(trigger, state)


func _set_triggers(next_triggers: Array[Trigger]) -> void:
	for trigger: Trigger in next_triggers:
		_set_trigger(trigger)


func _should_exist() -> bool:
	return get_child_count() == 0


func _apply_state_attachers() -> void:
	for attacher: Attacher in state.attachers:
		for child in get_children():
			attacher.attach(child as Node2D)


func _make_entity_group_name() -> void:
	if max_entities > -1:
		_id = _id_counter
		_id_counter += 1
		_group_name = "emission %s" % _id


func _find_effect() -> void:
	for node in get_children():
		if node is Effect:
			effect = node

#endregion
