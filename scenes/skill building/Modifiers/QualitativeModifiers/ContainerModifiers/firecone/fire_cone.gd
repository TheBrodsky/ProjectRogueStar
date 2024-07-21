extends ContainerModifier
class_name FireconeMod


@export var num_actions: int = 2
@export_range(1,360) var cone_angle: float = 0 ## in degrees
@export var is_even_spread: bool = true ## same effect as angle_is_random from Burst
@export var ignore_rotation: bool = false
@export var head_start_distance: float = 0 ## use this to set the radius for the arc of grouped projectiles
@export var share_aimed_angle: bool = false ## if true, the cone will be centered in direction of cursor even when ignore_rotation is true


var _cone_angle_rad: float
var _angle_offset: float


func _ready() -> void:
	assert(num_actions > 1) # prevents divide by 0 and special case where 1 bullet
	_cone_angle_rad = cone_angle * (PI / 180)
	_set_angle_offset()


func modify_initialization(state: ActionState, container: EventContainer) -> void:
	container.num_actions = num_actions
	_set_cone_rotation(state, container)


func modify_action(state: ActionState, container: EventContainer, action: Node2D, action_index: int) -> void:
	_rotate_action(container, action, action_index)


func _rotate_action(container: EventContainer, action: Node2D, index: int) -> void:
	var rotation_angle: float
	if is_even_spread:
		rotation_angle = (_angle_offset * index) - (_cone_angle_rad / 2)
	else:
		rotation_angle = randf_range(-1, 1) * (_cone_angle_rad / 2)
	action.position += head_start_distance * MovementTools.calcDirectionFromAngle(rotation_angle)
	if not ignore_rotation:
		action.rotate(rotation_angle)
	elif share_aimed_angle: 
		#rotate projectiles the opposite of the fire cone, so they travel in the direction we aim
		action.rotate(-container.rotation)


func _set_cone_rotation(state: ActionState, container: EventContainer) -> void:
	if share_aimed_angle:
		var aim_vector: Vector2 = state.target - state.source.position 
		var aim_angle_rad: float = aim_vector.angle()
		#TODO
		#var accuracy: float = state.group_deviation_base * state.group_deviation_mult
		#aim_angle_rad += deg_to_rad(randf_range(-accuracy, accuracy))
		container.rotate(aim_angle_rad)


func _set_angle_offset() -> void:
	var cone_angle_threshold: float = 360 - (360/num_actions)
	if (cone_angle > cone_angle_threshold):
		_angle_offset = _cone_angle_rad / num_actions
	else:
		_angle_offset = _cone_angle_rad / (num_actions - 1)
