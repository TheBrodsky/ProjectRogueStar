extends Effect
class_name DebugEffect


func modify_from_action_state(state: ActionState) -> void:
	pass


func do_effect() -> void:
	Logger.log_debug("Debug Effect!")

