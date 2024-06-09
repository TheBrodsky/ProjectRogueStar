class_name IActionable
extends Node2D


## This is just an interface for types of nodes that can be used by an event to do an action.


@onready var scaling_tags: ScalingTags = $ScalingTags


func _ready() -> void:
	add_to_group("taggable")
	if scaling_tags == null:
		scaling_tags = ScalingTags.get_empty_tags()


func merge_child_tags() -> ScalingTags:
	var cumulative_scaling_tags: ScalingTags = scaling_tags
	for child in get_children():
		if child.is_in_group("taggable"):
			@warning_ignore("unsafe_method_access")
			var child_tags: ScalingTags = child.merge_child_tags()
			cumulative_scaling_tags = cumulative_scaling_tags.add(child_tags)
	return cumulative_scaling_tags


# MUST BE OVERRIDEN. What defines an event's actual behavior.
func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable.do_action()")
