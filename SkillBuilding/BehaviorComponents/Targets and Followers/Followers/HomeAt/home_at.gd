extends Follower
class_name HomeAt


@export var is_perfect_homing: bool = false
@export_range(0, 720, 1, "or_greater") var homing_rate: int = 360: ## in degrees per second
	set(value):
		homing_rate = value
		_homing_rate_rads = deg_to_rad(value)

@onready var _homing_rate_rads: float = deg_to_rad(homing_rate)


func _ready() -> void:
	if is_perfect_homing:
		homing_rate = 50000 # eh, good enough


func _process(delta: float) -> void:
	_rotate_towards_target(delta)
	position += Vector2.from_angle(rotation) * speed * delta
	#if (target.get_target(get_tree()) - position).length() <= speed * delta:
		#position = target.get_target(get_tree())
	#else:
		#position += Vector2.from_angle(rotation) * speed * delta
	
	


func _rotate_towards_target(delta: float) -> void:
	var full_rotation_angle: float = _get_current_direction().angle_to(_get_direction_to_target()) # rotation needed to point towards target
	var max_rotation_angle: float = _homing_rate_rads * delta # the max ALLOWED rotation by homing rate
	var angle_sign: int = sign(full_rotation_angle) # preserve sign from abs() use
	var actual_rotation_angle: float = min(abs(full_rotation_angle), max_rotation_angle) # cap rotation to homing rate
	rotate(actual_rotation_angle * angle_sign)
	
	


#@onready var _prev_move_direction: Vector2 = Vector2.from_angle(rotation)
#
#
#func _calc_rotation_to_destination(delta: float, direction: Vector2) -> Vector2:
	#var angle_to_homing_vector: float = _prev_move_direction.angle_to(direction) # angle between prev direction and destination direction
	#var angle_sign: int = sign(angle_to_homing_vector) # preserve the sign bcuz abs() use in next step
	#var adjusted_angle: float = min(abs(_homing_rate_rads * delta), abs(angle_to_homing_vector)) # cap rotation to homing_rate
	#var adjusted_homing_direction: Vector2 = _prev_move_direction.rotated(adjusted_angle * angle_sign) # add sign back in and rotate
	#return adjusted_homing_direction
