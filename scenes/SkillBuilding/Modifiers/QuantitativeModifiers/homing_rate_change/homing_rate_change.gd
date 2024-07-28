extends QuantitativeModifier


@export var homing_rate_add: float = 0
@export var homing_rate_multi: float = 1


func modify_state(state: ActionState) -> void:
	state.homing_rate_base += homing_rate_add
	state.homing_rate_multi *= homing_rate_multi
