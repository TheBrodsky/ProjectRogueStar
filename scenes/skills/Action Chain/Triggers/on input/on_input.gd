extends Trigger


@export_enum("mouse_left", "mouse_right") var input_action: String


func _process(delta: float) -> void:
	if !_is_paused and Input.is_action_pressed(input_action):
		_do_trigger()
