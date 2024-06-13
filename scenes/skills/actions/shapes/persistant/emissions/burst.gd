extends Emission


@export var angle_is_random: bool = false

var _angle_offset: float


func _ready() -> void:
	super()
	_angle_offset = TAU / num_emissions


func add_entity(new_entity: Effect, index: int) -> void:
	super.add_entity(new_entity, index)
	var entity_angle: float
	if angle_is_random:
		entity_angle = randf() * TAU
	else:
		entity_angle = _angle_offset * index
	new_entity.rotate(entity_angle)
