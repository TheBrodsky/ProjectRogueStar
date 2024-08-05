extends Node


var effect: Effect
var state: ActionState


func modify_from_action_state(state: ActionState) -> void:
	self.state = state


func do_effect(body: Node2D) -> void:
	effect.modify_from_action_state(state)
	effect.do_effect(body, state)


## OPTIONAL
func modify_action_state(state: ActionState) -> ActionState:
	return state
