extends Target


func _get_target():
	return _get_point_on_screen()


func _get_point_on_screen():
	var neg_to_pos_range = Vector2(-1, 1)
	var point = _find_random_point_in_rectangle(neg_to_pos_range * get_viewport_rect().size.x/2, neg_to_pos_range * get_viewport_rect().size.y/2)
	var offset = get_viewport().get_camera_2d().position
	return point + offset


func _find_random_point_in_rectangle(x_range : Vector2, y_range : Vector2):
	return Vector2(randf_range(x_range.x, x_range.y), randf_range(y_range.x, y_range.y))
