extends Resource
class_name EntityState


static func get_state() -> EntityState:
	var state: EntityState = EntityState.new()
	state.resource_local_to_scene = true
	return state


func merge(other: EntityState) -> void:
	aoe_radius_base += other.aoe_radius_base
	aoe_radius_multi *= other.aoe_radius_multi


@export var aoe_radius_base: float = 0 # AOE radius addend
@export var aoe_radius_multi: float = 1 # AOE radius multiplier 
func get_aoe_radius() -> float: return aoe_radius_base * aoe_radius_multi
