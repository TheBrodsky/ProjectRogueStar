extends QuantitativeModifier


@export var aim_deviation_addend: float = 0 
@export_range(.01,100) var aim_deviation_mult: float = 1
#TODO
#@export var group_deviation_addend: float = 0
#@export_range(.01,100) var group_deviation_mult: float = 1


func modify_state(state: ActionState) -> void:
	state.aim_deviation_base += aim_deviation_addend
	state.aim_deviation_mult *= aim_deviation_mult
	#TODO
	#state.group_deviation_base += aim_deviation_addend
	#state.group_deviation_mult *= aim_deviation_mult

