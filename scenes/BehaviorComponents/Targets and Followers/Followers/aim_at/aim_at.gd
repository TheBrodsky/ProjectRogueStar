extends Follower


## AimAt will aim the parent entity at the target and then just send it.
## If the target moves afterward, AimAt doesn't care.
## The parent entity always moves in the initial direction it was aimed at.


var _direction: Vector2


func _ready() -> void:
	super()
	_direction = _get_direction_vector()
	parent_entity.rotation = _direction.angle()
		


func _process(delta: float) -> void:
	_apply_movement(delta, _direction)

