extends Area2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta: float) -> void:
	position = get_global_mouse_position()
