extends Follower


## OrbitAt makes an entity orbit around the Target at a fixed distance.
## The speed of rotation is determined by "speed" and orbital circumference.
## The entity will always move at a rate equal to "speed," but it's angular velocity
## will be proportional to the orbital circumference, which is determined by orbit distance.


@export var orbit_distance: int = 50: ## in pixels
	set(value):
		orbit_distance = value
		orbit_circumference = TAU * orbit_distance
		arclength_per_second = (speed * TAU) / orbit_circumference

@onready var orbit_circumference: float # in pixels
@onready var arclength_per_second: float # in rads

var _orbit_angle: Vector2 = Vector2.ONE.normalized()


func _process(delta: float) -> void:
	_apply_movement(delta, _get_next_radial_position(delta))


func _modify_from_state(state: ActionState) -> void:
	super(state)
	orbit_distance = state.get_aoe_radius()


# This is going to look weird because we're not actually using "direction" in the same way as usual.
# Instead, direction is the point on the circle we're trying to go to.
# But it's an override so /shrug
func _apply_movement(delta: float, direction: Vector2) -> void:
	if parent_entity is CharacterBody2D:
		(parent_entity as CharacterBody2D).velocity = _calc_move_vector(delta, direction)
		(parent_entity as CharacterBody2D).move_and_slide()
	else:
		parent_entity.global_position = direction


# Similar to _apply_movement, this is using "direction" in a weird way. It's the destination point.
func _calc_move_vector(delta: float, direction: Vector2) -> Vector2:
	var move_vector: Vector2 = direction - parent_entity.global_position
	return move_vector


func _get_next_radial_position(delta: float) -> Vector2:
	var center: Vector2 = target.get_target(get_tree())
	_orbit_angle = _orbit_angle.rotated(arclength_per_second * delta)
	var next_pos: Vector2 = center + (_orbit_angle * orbit_distance)
	return next_pos
