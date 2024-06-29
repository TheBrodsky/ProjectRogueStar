extends Effect
class_name DebugEffect


func modify_from_action_state(state: ActionState) -> void:
	pass


func do_effect(effect_body: Node2D) -> void:
	Logger.log_debug("Debug Effect with body %s" % effect_body)

