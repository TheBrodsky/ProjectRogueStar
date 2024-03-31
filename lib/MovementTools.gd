extends Object
class_name MovementTools


# contains methods for common ways of moving game objects
static func clampPosition(position: Vector2, screen_size: Vector2, screen_position: Vector2) -> Vector2:
	var new_pos: Vector2 = Vector2.ZERO
	var x_edge: float = (screen_size.x/2) + screen_position.x
	new_pos.x = clamp(position.x, -x_edge, x_edge)
	new_pos.y = clamp(position.y, 0, screen_size.y)
	return new_pos


static func calcMoveVectorBetweenPoints(position: Vector2, target: Vector2, speed: float, delta: float) -> Vector2:
	return calcMoveVector(position.direction_to(target), speed, delta)


static func calcMoveVector(direction: Vector2, speed: float, delta: float) -> Vector2:
	return direction.normalized() * speed * delta


static func calcDirectionFromAngle(angle: float)  -> Vector2:
	return Vector2.RIGHT.rotated(angle)
