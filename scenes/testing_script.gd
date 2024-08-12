extends Node


func _ready() -> void:
	var state: ActionState = ActionState.get_state()
	state.stats.damage.damage.add += 1
	
	var dup_state: ActionState = state.clone()
	print(dup_state.stats.damage.damage.add)
