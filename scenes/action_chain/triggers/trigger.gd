class_name Trigger

extends ActionNode


signal triggered(origin: Trigger)


@export var is_one_shot: bool = false # one shot triggers will pause after triggering once. Once paused, they will not run until resumed.

var _action_state: ActionState
var _is_paused: bool = false


func _ready() -> void:
	actionType = ActionType.TRIGGER


func resume() -> void:
	_is_paused = false


func pause() -> void:
	_is_paused = true
	

func _do_trigger() -> void:
	if !_is_paused:
		if is_one_shot:
			pause()
		triggered.emit(self)
		run_next(_action_state)

# TODO
func _run(state: ActionState) -> void:
	push_error("UNIMPLEMENTED ERROR: ActionNode._run()")
