extends Node2D

class_name Target


@export var range : int


func modify_emission(emission : Emission):
	emission.global_position = _get_target()


func _get_target() -> Vector2:
	return Vector2.ZERO
