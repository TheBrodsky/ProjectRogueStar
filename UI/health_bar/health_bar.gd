extends TextureProgressBar
class_name HealthBar
signal no_health


@export var max_hp: float = 100


func _ready() -> void:
	max_value = max_hp
	value = max_value
	step = 0.1


func reduce(amount: float) -> void:
	value -= amount
	if value <= 0:
		no_health.emit()


func increase(amount: float) -> void:
	value += amount

