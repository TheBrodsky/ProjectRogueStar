extends Modifier


@export var speed_mult: float = 1


func modify_state(state: ActionState) -> void:
	state.speed_mult *= speed_mult
