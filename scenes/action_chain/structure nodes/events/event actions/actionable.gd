class_name IActionable
extends Node2D


## This is just an interface for types of nodes that can be used by an event to do an action.


@onready var inclusive_tags: Tags = $AddTags
@onready var exclusive_tags: Tags = $SubTags


# MUST BE OVERRIDEN. What defines an event's actual behavior.
func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable.do_action()")
