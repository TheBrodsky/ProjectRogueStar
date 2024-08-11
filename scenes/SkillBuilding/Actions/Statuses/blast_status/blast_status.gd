extends Status
class_name BlastStatus


@export var supported_triggers: SupportedTriggers
@export var expiration_trigger: OnExpiration


func initialize(state: ActionState, effect: Effect) -> void:
	self.affected_entity = state.source
	modify_from_action_state(state)
	OnExpireHook.set_trigger(self, expiration_trigger, state)
	#supported_triggers.set_trigger(expiration_trigger, self.state)


func _update_stack_count() -> void:
	super()
	#radius_mod.radius_mult = 1 + (state.status.stacks * .05)
	#print(radius_mod.radius_mult)


func _on_expiration(tracker: StackTracker) -> void:
	expire.emit(self)
	_total_stacks -= tracker.stacks
	tracker.queue_free()
	_tracker = null
