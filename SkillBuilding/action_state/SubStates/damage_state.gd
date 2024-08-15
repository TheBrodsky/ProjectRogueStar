extends Resource
class_name DamageState


static func get_state() -> DamageState:
	var state: DamageState = DamageState.new()
	state.resource_local_to_scene = true
	return state


@export var damage: FloatStat = FloatStat.get_stat()


func merge(other: DamageState) -> void:
	damage.merge(other.damage)


func scale(scalar: float) -> void:
	damage.scale(scalar)

