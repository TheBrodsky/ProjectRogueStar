extends Follower
class_name OrbitAt


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var orbital_speed: float = PI/2 ## how much of the orbit is traversed per second, in radians
@export var orbital_distance: float = 50 ## how many pixels away from the center the object orbits
@export var chases_target: bool = true ## makes a cool thing when combined with Firecone + head start distance

@export_group(Globals.INSPECTOR_CATEGORY)
@export var orbitor: FollowerLink


func _ready() -> void:
	orbitor.position = Vector2(orbital_distance, 0)


func _process(delta: float) -> void:
	if chases_target:
		global_position = target.get_target(get_tree())
	rotate(orbital_speed * delta)


func initialize(state: ActionState) -> void:
	super(state)
	if chases_target:
		global_position = target.get_target(get_tree())


func modify_from_state(state: ActionState) -> void:
	super(state)
	orbital_speed = state.stats.follower.orbit_speed.val()
	orbital_distance = state.stats.follower.orbit_distance.val()
	chases_target = state.stats.follower.does_orbit_chase_target()
