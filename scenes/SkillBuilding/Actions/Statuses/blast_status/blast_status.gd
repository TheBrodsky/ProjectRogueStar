extends Status
class_name BlastStatus


@export_group(Globals.INSPECTOR_CATEGORY)
@export var supported_triggers: SupportedTriggers
@export var expiration_trigger: OnExpiration


func initialize(state: ActionState, effect: Effect) -> void:
	super(state, effect)
	state.stats.status.proc_time = state.stats.status.duration.duplicate()
	expiration_trigger.engage(self)


func _on_expiration(tracker: StackTracker) -> void:
	expire.emit(self, state)
	_total_stacks -= tracker.stacks
	tracker.queue_free()
	_tracker = null
