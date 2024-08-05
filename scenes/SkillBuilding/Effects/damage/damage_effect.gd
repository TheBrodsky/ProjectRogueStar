extends Effect
class_name DamageEffect


var damage: float = 0


func do_effect(effect_body: Node2D, state: ActionState) -> void:
	if effect_body.has_method("take_damage"):
		modify_from_action_state(state)
		@warning_ignore("unsafe_method_access")
		effect_body.take_damage(damage)


func modify_from_action_state(state: ActionState) -> void:
	damage = state.get_damage()
	damage *= state.get_stacks()

