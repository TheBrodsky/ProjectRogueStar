extends ContainerModifier
class_name FireconeMod


@export var num_actions: int = 2
@export_range(1,360) var cone_angle: float = 0 ## in degrees
@export var is_even_spread: bool = true ## whether the angle between each entity is equal
@export var head_start_distance: float = 0 ## how far along an object's flight path it starts
@export var group_spread: float = 0 ## ONLY RELEVANT FOR GROUP_ROTATED; how much the group is spread out

enum RotationMode {INDIVIDUAL_ROTATED, GROUP_ROTATED, NON_ROTATED}
@export var rotation_mode: RotationMode

var _cone_angle_rad: float
var _angle_offset: float


func _ready() -> void:
	assert(num_actions > 1) # prevents divide by 0 and special case where 1 bullet
	_cone_angle_rad = cone_angle * (PI / 180)
	_set_angle_offset()


func modify_initialization(state: ActionState, container: EventContainer) -> void:
	container.num_actions = num_actions
	_set_cone_rotation(state, container)


func modify_action(state: ActionState, container: EventContainer, action: Node2D, action_follower: Follower, action_index: int) -> void:
	_rotate_action(container, action_follower, action_index)


func modify_build(state: ActionState, container: EventContainer) -> void:
	if rotation_mode == RotationMode.GROUP_ROTATED:
		container.position += head_start_distance * MovementTools.calcDirectionFromAngle(container.rotation)


func _rotate_action(container: EventContainer, action_follower: Follower, index: int) -> void:
	var rotation_angle: float = _get_rotation_angle(index)
	
	if rotation_mode == RotationMode.INDIVIDUAL_ROTATED:
		action_follower.rotate(rotation_angle)
		action_follower.position += head_start_distance * MovementTools.calcDirectionFromAngle(action_follower.rotation)
	elif rotation_mode == RotationMode.GROUP_ROTATED:
		#rotate projectiles the opposite of the fire cone, so they travel in the direction we aim
		action_follower.rotate(-container.rotation)
		action_follower.position += group_spread * MovementTools.calcDirectionFromAngle(rotation_angle)
	elif rotation_mode == RotationMode.NON_ROTATED:
		action_follower.position += head_start_distance * MovementTools.calcDirectionFromAngle(rotation_angle)


func _set_cone_rotation(state: ActionState, container: EventContainer) -> void:
	if rotation_mode == RotationMode.GROUP_ROTATED:
		var aim_vector: Vector2 = state.source.position.direction_to(state.stats.follower.target.get_target(get_tree())) 
		#TODO aim deviation on group rotated
		#var accuracy: float = state.group_deviation_base * state.group_deviation_mult
		#aim_angle_rad += deg_to_rad(randf_range(-accuracy, accuracy))
		container.rotate(aim_vector.angle())


func _get_rotation_angle(index: int) -> float:
	if is_even_spread:
		return (_angle_offset * index) - (_cone_angle_rad / 2)
	else:
		return randf_range(-1, 1) * (_cone_angle_rad / 2)


func _set_angle_offset() -> void:
	var cone_angle_threshold: float = 360 - (360/num_actions)
	if (cone_angle > cone_angle_threshold):
		_angle_offset = _cone_angle_rad / num_actions
	else:
		_angle_offset = _cone_angle_rad / (num_actions - 1)
