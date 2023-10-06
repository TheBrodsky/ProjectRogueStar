class_name MovementTools

extends Object


# contains methods for common ways of moving game objects
static func clampPosition(position: Vector2, screen_size: Vector2) -> Vector2:
	var new_pos = Vector2.ZERO 
	new_pos.x = clamp(position.x, 0, screen_size.x)
	new_pos.y = clamp(position.y, 0, screen_size.y)
	return new_pos


static func calcMoveVectorBetweenPoints(position: Vector2, target: Vector2, speed, delta) -> Vector2:
	return calcMoveVector(position.direction_to(target), speed, delta)


static func calcMoveVector(direction: Vector2, speed, delta) -> Vector2:
	return direction.normalized() * speed * delta
