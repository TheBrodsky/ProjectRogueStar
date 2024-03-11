extends Event


func _do_event_action(state : ActionState) -> ActionState:
	Logger.log_debug("Debug event run")
	return null
