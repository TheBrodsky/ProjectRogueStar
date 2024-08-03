extends Follower


## AimAt will aim the parent entity at the target and then just send it.
## If the target moves afterward, AimAt doesn't care.
## The parent entity always moves in the initial direction it was aimed at.


func _ready() -> void:
	super()
	parent_entity.rotation = _get_direction_vector().angle()


func _process(delta: float) -> void:
	_apply_movement(delta, MovementTools.calcDirectionFromAngle(parent_entity.rotation))

