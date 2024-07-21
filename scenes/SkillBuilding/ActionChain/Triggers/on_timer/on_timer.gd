extends Trigger
class_name TimerTrigger


@onready var timer: Timer = $Timer

@export var activations_per_second: float = 10:
	set(value):
		activations_per_second = value
		if timer != null:
			timer.wait_time = 1.0 / activations_per_second
			timer.start()


func _ready() -> void:
	super()
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
