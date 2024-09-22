extends Effect
class_name DebugEffect


func do_effect(effect_body: Node2D, state: ActionState) -> void:
	Logger.log_debug("Debug Effect with body %s" % effect_body)
