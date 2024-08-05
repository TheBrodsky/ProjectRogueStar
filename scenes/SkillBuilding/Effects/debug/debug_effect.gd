extends Effect
class_name DebugEffect


func do_effect(effect_body: Node2D, state: ActionState) -> void:
	Logger.log_debug("Debug Effect with body %s" % effect_body)


func modify_from_action_state(state: ActionState) -> void:
	pass
