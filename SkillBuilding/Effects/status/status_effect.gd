extends Effect
class_name StatusEffect


@export var status: Status


func do_effect(effect_body: Node2D, state: ActionState, triggers: Array[Trigger] = []) -> void:
	var status_manager: StatusManager = null
	for child in effect_body.get_children(): # check for existing manager
		if child is StatusManager:
			status_manager = child
			break
	
	if status_manager == null: # no existing manager, instantiate new one
		status_manager = StatusManager.new()
		status_manager.affected_entity = effect_body
		effect_body.add_child(status_manager)
	
	status_manager.add_status(status, state, triggers)
