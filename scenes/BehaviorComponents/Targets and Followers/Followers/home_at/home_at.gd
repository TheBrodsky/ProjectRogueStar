extends Follower


## HomeAt will continually modify the flight-path of the parent entity to move towards the Target.


@export_range(0, 720) var homing_rate: int = 0: ## in degrees per second
	set(value):
		homing_rate = value
		_homing_rate_rads = deg_to_rad(value)

@export var rotate_towards_movement: bool = true

@onready var _homing_rate_rads: float = deg_to_rad(homing_rate)

var _prev_move_direction: Vector2


func _ready() -> void:
	super()
	_prev_move_direction = MovementTools.calcDirectionFromAngle(parent_entity.rotation)


func _process(delta: float) -> void:
	_apply_movement(delta, _get_direction_vector())


func _modify_from_state(state: ActionState) -> void:
	super(state)
	homing_rate = state.get_homing_rate()


func _calc_move_vector(delta: float, direction: Vector2) -> Vector2:
	var rotation_vector: Vector2 = _calc_rotation_to_destination(delta, direction)
	_prev_move_direction = rotation_vector
	
	if rotate_towards_movement:
		parent_entity.rotation = rotation_vector.angle()
	
	return MovementTools.calcMoveVector(rotation_vector, speed, delta)


func _calc_rotation_to_destination(delta: float, direction: Vector2) -> Vector2:
	var angle_to_homing_vector: float = _prev_move_direction.angle_to(direction) # angle between prev direction and destination direction
	var angle_sign: int = sign(angle_to_homing_vector) # preserve the sign bcuz abs() use in next step
	var adjusted_angle: float = min(abs(_homing_rate_rads * delta), abs(angle_to_homing_vector)) # cap rotation to homing_rate
	var adjusted_homing_direction: Vector2 = _prev_move_direction.rotated(adjusted_angle * angle_sign) # add sign back in and rotate
	return adjusted_homing_direction
