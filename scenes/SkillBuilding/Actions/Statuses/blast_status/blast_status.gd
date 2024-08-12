extends Status
class_name BlastStatus


@export_group(Globals.INSPECTOR_CATEGORY)
@export var supported_triggers: SupportedTriggers
@export var expiration_trigger: OnExpiration


func initialize(state: ActionState, effect: Effect) -> void:
	super(state, effect)
	OnExpireHook.set_trigger(self, expiration_trigger, state)
	#supported_triggers.set_trigger(expiration_trigger, self.state)


func _on_expiration(tracker: StackTracker) -> void:
	expire.emit(self)
	_total_stacks -= tracker.stacks
	tracker.queue_free()
	_tracker = null
