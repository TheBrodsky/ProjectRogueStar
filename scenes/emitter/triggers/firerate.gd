extends Trigger


@export var activations_per_second : int = 10

@onready var timer : Timer = $Timer


func _ready():
	timer.wait_time = 1.0 / activations_per_second
	timer.start()


func _on_timer_timeout():
	triggered.emit()
	print("triggered")


func pause():
	_paused = true
	set_process(false)
	timer.paused = true


func unpause():
	_paused = false
	set_process(true)
	timer.paused = false
