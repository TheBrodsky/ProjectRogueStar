extends IMultiActionable
class_name ConeEmission




@export_range(1,360) var cone_angle: float = 0 ## in degrees
@export var is_even_spread: bool = true ## same effect as angle_is_random from Burst
@export var ignore_rotation: bool = false
@export var head_start_distance: float = 0 ## use this to set the radius for the arc of grouped projectiles
@export var share_aimed_angle: bool = false ## if true, the cone will be centered in direction of cursor even when ignore_rotation is true


var _cone_angle_rad: float
var _angle_offset: float


func _ready() -> void:
	super()
	assert(num_emissions > 1) # prevents divide by 0 and special case where 1 bullet
	_cone_angle_rad = cone_angle * (PI / 180)
	set_angle_offset()
	set_cone_rotation()

func set_angle_offset() -> void:
	var cone_angle_threshold: float = 360 - (360/num_emissions)
	if (cone_angle > cone_angle_threshold):
		_angle_offset = _cone_angle_rad / num_emissions
	else:
		_angle_offset = _cone_angle_rad / (num_emissions - 1)

func set_cone_rotation() -> void:
	if share_aimed_angle and not is_blueprint:
		var aim_vector: Vector2 = state.target - state.source.position 
		var aim_angle_rad: float = aim_vector.angle()
		rotate(aim_angle_rad)

func add_indexed_entity(new_entity: Node2D, index: int) -> void:
	super(new_entity, index)
	rotate_entity(new_entity, index)
	
func rotate_entity(new_entity: Node2D, index: int) -> void:
	var entity_angle: float
	if is_even_spread:
		entity_angle = (_angle_offset * index) - (_cone_angle_rad / 2)
	else:
		entity_angle = randf_range(-1, 1) * (_cone_angle_rad / 2)
	new_entity.position += head_start_distance * MovementTools.calcDirectionFromAngle(entity_angle)
	if not ignore_rotation:
		new_entity.rotate(entity_angle)
	elif share_aimed_angle: 
		#rotate projectiles the opposite of the fire cone, so they travel in the direction we aim
		new_entity.rotate(-rotation)
