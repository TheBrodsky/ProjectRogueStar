extends Trigger


func _ready() -> void:
	super._ready()
	_name = "InputTrigger"


func _process(delta: float) -> void:
	if !_is_paused and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_do_trigger()
