extends Emission


@export var cone_angle: float = 0 # in degrees
@export var is_even_spread: bool = true

var _cone_angle_rad: float
var _angle_offset: float


func _ready() -> void:
	super()
	assert(num_emissions > 1) # prevents divide by 0 and special case where 1 bullet
	_cone_angle_rad = cone_angle * (PI / 180)
	_angle_offset = _cone_angle_rad / (num_emissions - 1)


func add_entity(new_entity: Effect, index: int) -> void:
	super.add_entity(new_entity, index)
	var entity_angle: float
	if is_even_spread:
		entity_angle = (_angle_offset * index) - (_cone_angle_rad / 2)
	else:
		entity_angle = randf_range(-1, 1) * (_cone_angle_rad / 2)
	new_entity.rotate(entity_angle)
