extends Follower
class_name SpiralAt


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var orbital_speed: float = TAU ## how much of the orbit is traversed per second, in radians
@export var orbital_distance: float = 0 ## how many pixels away from the center the object orbits

@export_group(Globals.INSPECTOR_CATEGORY)
@export var orbit: OrbitAt
@export var straight: StraightAt


func _enter_tree() -> void:
	orbit.target = target
	orbit.orbital_speed = orbital_speed
	orbit.orbital_distance = orbital_distance
	straight.speed = speed
	straight.aim_deviation = aim_deviation
