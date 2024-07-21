extends Modifier


@export_range(.01,100) var speed_mult: float = 1
@export var speed_addend: float = 0 


func modify_state(state: ActionState) -> void:
	state.speed_base += speed_addend
	state.speed_mult *= speed_mult
	
