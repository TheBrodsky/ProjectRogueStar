extends Node


func _ready() -> void:
	var state: ActionState = ActionState.new()
	state.damage.damage_base += 1
	
	var dup_state: ActionState = state.clone()
	print(dup_state.damage.damage_base)
