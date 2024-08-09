extends Follower
class_name OrbitAt


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var orbital_speed: float = PI/2 ## how much of the orbit is traversed per second, in radians
@export var orbital_distance: float = 50 ## how many pixels away from the center the object orbits
@export var chases_target: bool = true ## makes a cool thing when combined with Firecone + head start distance


func _ready() -> void:
	bottom_node.position = Vector2(orbital_distance, 0)


func _process(delta: float) -> void:
	if chases_target:
		global_position = target.get_target(get_tree())
	rotate(orbital_speed * delta)


func modify_from_state(state: ActionState) -> void:
	super(state)
	orbital_speed = state.get_orbit_speed()
	orbital_distance = state.get_orbit_distance()
	chases_target = state.does_orbit_chase_target()
