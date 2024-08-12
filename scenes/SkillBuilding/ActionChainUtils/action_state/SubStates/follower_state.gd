extends Resource
class_name FollowerState


static func get_state() -> FollowerState:
	var state: FollowerState = FollowerState.new()
	state.resource_local_to_scene = true
	return state


@export_group("Basic")
@export var disable_rotation: bool = false
func is_rotation_disabled() -> bool: return disable_rotation

@export var speed: FloatStat = FloatStat.get_stat()
@export var aim_deviation: FloatStat = FloatStat.get_stat()
@export var group_aim_deviation: FloatStat = FloatStat.get_stat()


@export_group("Orbit")
@export var orbit_chases_target: bool = true
func does_orbit_chase_target() -> bool: return orbit_chases_target

@export var orbit_speed: FloatStat = FloatStat.get_stat()
@export var orbit_distance: FloatStat = FloatStat.get_stat()
@export var homing_rate: FloatStat = FloatStat.get_stat()


@export_group(Globals.PRIVATE_CATEGORY)
@export var target: Target # determines where events/actions are aimed.



func merge(other: FollowerState) -> void:
	if other.target != null:
		target = other.target
	
	disable_rotation = other.disable_rotation
	orbit_chases_target = other.orbit_chases_target
	
	speed.merge(other.speed)
	aim_deviation.merge(other.aim_deviation)
	group_aim_deviation.merge(other.group_aim_deviation)
	orbit_speed.merge(other.orbit_speed)
	orbit_distance.merge(other.orbit_distance)
	homing_rate.merge(other.homing_rate)


func scale(scalar: float) -> void:
	speed.scale(scalar)
	aim_deviation.scale(scalar)
	group_aim_deviation.scale(scalar)
	orbit_speed.scale(scalar)
	orbit_distance.scale(scalar)
	homing_rate.scale(scalar)
