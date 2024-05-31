extends CanvasLayer


var _prev_mouse_mode: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		toggle_visibility()


func toggle_visibility() -> void:
	if visible:
		hide()
		get_tree().paused = false
		Input.set_mouse_mode(_prev_mouse_mode)
	else:
		show()
		get_tree().paused = true
		_prev_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
