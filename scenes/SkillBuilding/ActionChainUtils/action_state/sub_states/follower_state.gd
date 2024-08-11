extends Resource
class_name FollowerState


static func get_state() -> FollowerState:
	var state: FollowerState = FollowerState.new()
	state.resource_local_to_scene = true
	return state


func merge(other: FollowerState) -> void:
	disable_rotation = other.disable_rotation
	speed_base += other.speed_base
	speed_mult *= other.speed_mult
	aim_deviation_base += other.aim_deviation_base
	aim_deviation_mult *= other.aim_deviation_mult
	group_deviation_base += other.group_deviation_base
	group_deviation_mult *= other.group_deviation_mult
	orbit_speed_base += other.orbit_speed_base
	orbit_speed_multi *= other.orbit_speed_multi
	orbit_distance_base += other.orbit_distance_base
	orbit_distance_multi *= other.orbit_distance_multi
	orbit_chases_target = other.orbit_chases_target
	homing_rate_base += other.homing_rate_base
	homing_rate_multi *= other.homing_rate_multi
	if other.target != null: target = other.target


@export_group("Basic")
@export var disable_rotation: bool = false
func is_rotation_disabled() -> bool: return disable_rotation

@export var speed_base: float = 0 # additive base speed value to any entities that move
@export var speed_mult: float = 1 # speed multiplier to any entities that move
func get_speed() -> float: return speed_base * speed_mult

@export var aim_deviation_base: float = 0 # angle of error from aiming line, in degrees
@export var aim_deviation_mult: float = 1 # aim deviation multiplier
func get_aim_deviation() -> float: return aim_deviation_base * aim_deviation_mult

@export var group_deviation_base: float = 0 # specifically for the share aim angle firecone (for now)
@export var group_deviation_mult: float = 1 # group deviation multiplier
func get_group_deviation() -> float: return group_deviation_base * group_deviation_mult


@export_group("Orbit")
@export var orbit_speed_base: float = 0
@export var orbit_speed_multi: float = 1
func get_orbit_speed() -> float: return orbit_speed_base * orbit_speed_multi

@export var orbit_distance_base: float = 0
@export var orbit_distance_multi: float = 1
func get_orbit_distance() -> float: return orbit_distance_base * orbit_distance_multi

@export var orbit_chases_target: bool = true
func does_orbit_chase_target() -> bool: return orbit_chases_target

@export_group("Misc")
@export var homing_rate_base: float = 0
@export var homing_rate_multi: float = 1
func get_homing_rate() -> float: return homing_rate_base * homing_rate_multi


@export_group(Globals.PRIVATE_CATEGORY)
@export var target: Target # determines where events/actions are aimed.
