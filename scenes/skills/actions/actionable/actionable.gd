class_name IActionable
extends Node2D


## An interface for types of nodes that can be used by an event to do an action.


@onready var scaling_tags: ScalingTags = $ScalingTags

@export var effect: PackedScene # must be type Effect. This is the end result of an action.

var is_blueprint: bool = true # blueprints live in the action chain and serve as a blueprint to copy


func _ready() -> void:
	add_to_group("taggable")
	if scaling_tags == null:
		scaling_tags = ScalingTags.get_empty_tags()


## Overridable. Performs setup before calling _main_action()
func _pre_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	get_tree().get_root().add_child(new_action)
	new_action.position = new_state.source.global_position

## Overridable. Main component of the action
func _main_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable._main_action()")


## Overridable. Performs any kind of cleanup or additional setup that may be required for the action or action outcome to continue functioning.
func _post_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	new_action.set_triggers(next_triggers)


## Overridable
func _set_trigger(trigger: Trigger) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable._set_trigger()")


func set_triggers(next_triggers: Array[Trigger]) -> void:
	for trigger: Trigger in next_triggers:
		_set_trigger(trigger)


func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	var new_actionable: IActionable = clone()
	_pre_action(new_actionable, new_state, next_triggers)
	_main_action(new_actionable, new_state, next_triggers)
	_post_action(new_actionable, new_state, next_triggers)




func merge_child_tags() -> ScalingTags:
	var cumulative_scaling_tags: ScalingTags = scaling_tags
	for child in get_children():
		if child.is_in_group("taggable"):
			@warning_ignore("unsafe_method_access")
			var child_tags: ScalingTags = child.merge_child_tags()
			cumulative_scaling_tags = cumulative_scaling_tags.add(child_tags)
	return cumulative_scaling_tags


func build_effect() -> Effect:
	return effect.instantiate()


func clone(flags: int = 15) -> IActionable:
	var new_actionable: IActionable = self.duplicate(flags)
	new_actionable._copy_from(self)
	return new_actionable


func _copy_from(other: IActionable) -> void:
	is_blueprint = false # is_blueprint is NEVER passed on
	effect = other.effect
