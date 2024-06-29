extends Effect
class_name DamageEffect


@export var damage: int = 1


func modify_from_action_state(state: ActionState) -> void:
	pass


func do_effect(effect_body: Node2D) -> void:
	if effect_body.has_method("take_damage"):
		@warning_ignore("unsafe_method_access")
		effect_body.take_damage(damage)

