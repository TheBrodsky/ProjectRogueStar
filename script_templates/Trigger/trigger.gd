extends Trigger


func _ready() -> void:
	super._ready()
	_name = ""


func resume() -> void:
	_is_paused = false


func pause() -> void:
	_is_paused = true
