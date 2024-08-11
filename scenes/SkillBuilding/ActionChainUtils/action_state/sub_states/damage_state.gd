extends Resource
class_name DamageState


static func get_state() -> DamageState:
	var state: DamageState = DamageState.new()
	state.resource_local_to_scene = true
	return state


func merge(other: DamageState) -> void:
	damage_base += other.damage_base
	damage_multi *= other.damage_multi


@export var damage_base: float = 0 # additive base damage value (add additive damage increases to this one)
@export var damage_multi: float = 1 # damage multiplier (multiply other multipliers to this one)
func get_damage() -> float: return damage_base * damage_multi
