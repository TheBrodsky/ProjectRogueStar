extends Modifier


@export var damage_addend: float = 0 ##value to add to damage_base
@export_range(.01,100) var damage_multiplier: float = 1 ##value to multiply by damage_multi


func modify_state(state: ActionState) -> void:
	state.damage_base += damage_addend
	state.damage_multi *= damage_multiplier
