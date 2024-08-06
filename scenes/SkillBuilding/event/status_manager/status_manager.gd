extends Node
class_name StatusManager


# get_class() doesnt return custom classes so this is the only option
# Each script key maps to a dictionary of that Status
# That dictionary maps each event's group ID to its Status
var statuses: Dictionary = {} ## Script : {event_id : Status}


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func initialize() -> void:
	pass


func add_status(status: Status, effect: Effect, state: ActionState, event_group: String, 
modifiers: Array[QualitativeModifier], triggers: Array[Trigger]) -> void:
	status = _get_or_add_status(status, effect, state, event_group, modifiers, triggers)
	status.add_stacks()


## Gets an existing status from the statuses dict or, if it doesn't exist, adds the passed in one
func _get_or_add_status(status: Status, effect: Effect, state: ActionState, event_group: String, 
modifiers: Array[QualitativeModifier], triggers: Array[Trigger]) -> Status:
	if status.get_script() in statuses:
		var event_status_dict: Dictionary = statuses[status.get_script()]
		if event_group in event_status_dict:
			return event_status_dict[event_group] # status from this event already exists
		else:
			# status exists but not from this event, make new one for this event
			event_status_dict[event_group] = status
			_add_new_status(status, effect, state, event_group, modifiers, triggers)
			return status
	else:
		# status doesn't exist at all on this entity
		statuses[status.get_script()] = {event_group : status}
		_add_new_status(status, effect, state, event_group, modifiers, triggers)
		return status


func _add_new_status(status: Status, effect: Effect, state: ActionState, event_group: String,
modifiers: Array[QualitativeModifier], triggers: Array[Trigger]) -> void:
	add_child(status)
	status.add_to_group(event_group)
	status.initialize(state, effect)
	status.expire.connect(_remove_status)
	_apply_modifiers()
	_add_triggers(status, state, triggers)


func _apply_modifiers() -> void: # TODO
	pass


func _add_triggers(status: Status, state: ActionState, triggers: Array[Trigger]) -> void:
	if triggers.size() > 0 and "trigger_hook" in status:
		@warning_ignore("unsafe_property_access")
		var trigger_hook: SupportedTriggers = status.trigger_hook
		for trigger: Trigger in triggers:
			trigger_hook.set_trigger(trigger, state)


func _remove_status(status: Status) -> void:
	statuses.erase(status.get_script())
	status.queue_free()


func _should_exist() -> bool:
	return get_child_count() == 0
