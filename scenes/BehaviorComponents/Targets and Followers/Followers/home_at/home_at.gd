extends Follower


## HomeAt will continually modify the flight-path of the parent entity to move towards the Target.


@export_range(0, 720) var homing_rate: int = 720 ## in degrees per second

@onready var _homing_rate_rads: float = deg_to_rad(homing_rate)

var _prev_move_direction: Vector2


func _ready() -> void:
	super()
	_prev_move_direction = _get_direction_vector()


func _process(delta: float) -> void:
	_apply_movement(delta, _get_direction_vector())


# Explanation of the math here:
# Take 2 vectors (representing aim directions), called "previous" and "homing"
# The previous vector is the direction moved in the last process tick. The homing vector is the direction to the Target.
# We find the angle between them. Our new direction will be somewhere within this angle (edge inclusive).
# We multiply this angle by the homing strength and rotate the previous vector by that amount.
# If strength is 0, the previous vector wont be rotated. If it's 1, it'll be rotated the full amount (becoming equal to homing vector).
func _calc_move_vector(delta: float, direction: Vector2) -> Vector2:
	var angle_to_homing_vector: float = _prev_move_direction.angle_to(direction)
	var adjusted_angle: float = min(_homing_rate_rads * delta, angle_to_homing_vector)
	var adjusted_homing_direction: Vector2 = _prev_move_direction.rotated(adjusted_angle)
	_prev_move_direction = adjusted_homing_direction
	return MovementTools.calcMoveVector(adjusted_homing_direction, speed, delta)
