extends OnCompoundTrigger


## It's a very common pattern to have a CompoundTrigger that consists of a timer
## and 1 other trigger. This effectively adds a "cooldown" to the other trigger.
## Because this pattern is so common, it made sense to make it its own trigger type.


@export var cooldown: float = 1: ## in seconds
	set(value):
		cooldown = value
		if timer != null:
			timer.activations_per_second = 1/cooldown

@onready var timer: TimerTrigger = $OnTimer


func _ready() -> void:
	super()
	timer.activations_per_second = 1/cooldown
