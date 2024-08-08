extends Follower
class_name StraightAt


func _process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta
