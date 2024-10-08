extends Effect
class_name DamageEffect


func do_effect(effect_body: Node2D, state: ActionState, triggers: Array[Trigger] = []) -> void:
	if effect_body.has_method("take_damage"):
		var damage: float = state.stats.damage.damage.val()
		@warning_ignore("unsafe_method_access")
		effect_body.take_damage(damage)



