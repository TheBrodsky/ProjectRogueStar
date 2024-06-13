class_name IActionable
extends Node2D


## An interface for types of nodes that can be used by an event to do an action.
## do_action() is the main method.


@onready var scaling_tags: ScalingTags = $ScalingTags

@export var effect: PackedScene # must be type Effect

var is_blueprint: bool = true # blueprints live in the action chain and serve as a blueprint to copy


func _ready() -> void:
	add_to_group("taggable")
	if scaling_tags == null:
		scaling_tags = ScalingTags.get_empty_tags()


## MUST BE OVERRIDEN. What defines an event's actual behavior.
func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable.do_action()")


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
