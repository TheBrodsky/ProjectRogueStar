extends Resource
class_name EntityState


static func get_state() -> EntityState:
	var state: EntityState = EntityState.new()
	state.resource_local_to_scene = true
	return state


@export var aoe_radius: FloatStat = FloatStat.get_stat()


func merge(other: EntityState) -> void:
	aoe_radius.merge(other.aoe_radius)


func scale(scalar: float) -> void:
	aoe_radius.scale(scalar)
