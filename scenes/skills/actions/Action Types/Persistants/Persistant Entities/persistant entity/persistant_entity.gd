extends Node2D
class_name PersistantEntity



func set_trigger(trigger: Trigger, state: ActionState) -> void:
	var trigger_copy: Trigger = trigger.clone()
	add_child(trigger_copy)
	var state_copy: ActionState = state.duplicate()
	state_copy.source = self
	trigger_copy._run(state_copy)
