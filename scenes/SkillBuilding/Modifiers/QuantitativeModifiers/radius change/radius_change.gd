extends QuantitativeModifier


@export var radius_add: float = 100
@export var radius_mult: float = 1


func modify_state(state: ActionState) -> void:
	state.aoe_radius_base = radius_add
	state.aoe_radius_multi = radius_mult
