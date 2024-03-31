extends Event


func _ready() -> void:
	super._ready()
	_name = "DebugEvent"


func _do_event_action(state : ActionState) -> ActionState:
	return null
