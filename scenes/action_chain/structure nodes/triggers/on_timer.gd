extends Trigger


@export var activations_per_second: int = 10

@onready var timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	timer.wait_time = 1.0 / activations_per_second
	timer.start()


func _on_timer_timeout() -> void:
	_do_trigger()


func pause() -> void:
	_is_paused = true
	timer.stop()


func resume() -> void:
	_is_paused = false
	timer.start()
