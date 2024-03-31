extends Modifier


@export var accuracy_change: float = 0


func modify_state(state: ActionState) -> void:
	state.accuracy += accuracy_change

