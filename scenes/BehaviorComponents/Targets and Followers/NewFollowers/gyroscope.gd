extends Node2D
class_name Gyroscope


@export var is_on: bool = true


func _process(delta: float) -> void:
	if is_on:
		global_rotation = 0
