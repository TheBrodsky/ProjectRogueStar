extends Pattern


@export var range : int = 1


func _get_point(target) -> Vector2:
	return target + _get_point_in_circle()


func _get_point_in_circle():
	return (Vector2.ONE * randf_range(0, self.range)).rotated(randf_range(0, 2 * PI))
