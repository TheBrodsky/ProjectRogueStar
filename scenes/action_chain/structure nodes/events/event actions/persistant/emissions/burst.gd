extends Emission


var _angle_offset: float

func setup() -> void:
	_angle_offset = TAU / num_emissions
	super.setup()


func add_entity(new_entity: Effect, index: int) -> void:
	add_child(new_entity)
	new_entity.modify_from_action_state(state)
	new_entity.rotation += _angle_offset * index
