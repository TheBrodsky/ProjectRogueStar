extends QuantitativeModifier


@export var snaking_frequency_add: float = 0
@export var snaking_frequency_multi: float = 1
@export var snaking_amplitude_add: float = 0
@export var snaking_amplitude_multi: float = 1


func modify_state(state: ActionState) -> void:
	state.snaking_frequency_base = snaking_frequency_add
	state.snaking_frequency_multi = snaking_frequency_multi
	state.snaking_amplitude_base = snaking_amplitude_add
	state.snaking_amplitude_multi = snaking_amplitude_multi
