extends TextureProgressBar
class_name HealthBar
signal no_health


@export var max_hp: int = 10


func _ready() -> void:
	max_value = max_hp
	value = max_value


func reduce(amount: int) -> void:
	value -= amount
	if value <= 0:
		no_health.emit()


func increase(amount: int) -> void:
	value += amount

