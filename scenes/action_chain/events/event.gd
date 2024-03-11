class_name Event

extends ActionNode


func _ready() -> void:
	actionType = ActionType.EVENT


# PROTECTED. MUST BE OVERRIDEN. What defines an event's actual behavior.
func _do_event_action(state : ActionState) -> ActionState:
	push_error("UNIMPLEMENTED ERROR: Event._do_event_action()")
	return null


func _run(state : ActionState) -> void:
	state = _do_event_action(state)
	run_next(state)



