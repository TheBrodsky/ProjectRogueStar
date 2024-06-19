extends IActionable


## Overridable. Performs setup before calling _main_action()
func _pre_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	super(new_action, new_state, next_triggers)


## Overridable. Main component of the action
func _main_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable._main_action()")


## Overridable. Performs any kind of cleanup or additional setup that may be required for the action or action outcome to continue functioning.
func _post_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	super(new_action, new_state, next_triggers)


## Overridable
func _set_trigger(trigger: Trigger) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable._set_trigger()")
