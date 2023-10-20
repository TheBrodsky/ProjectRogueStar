extends Node2D

class_name Pattern


@export var num_points : int = 1


func get_pattern(target : Vector2) -> Array:
	var points = []
	for i in num_points:
		points.append(_get_point(target))
	return points

func _get_point(target : Vector2) -> Vector2:
	return target
