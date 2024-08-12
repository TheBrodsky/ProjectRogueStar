extends FollowerLink
class_name Follower


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var target: Target ## Determines the destination of a follower
@export var speed: float = 0 ## In pixels/second
@export var aim_deviation: float = 0 ## in degrees


func initialize(state: ActionState) -> void:
	modify_from_state(state)
	super(state)


func modify_from_state(state: ActionState) -> void:
	target = state.stats.follower.target
	speed = state.stats.follower.speed.val()
	aim_deviation = state.stats.follower.aim_deviation.val()


func _get_direction_to_target() -> Vector2:
	return (target.get_target(get_tree()) - global_position).normalized()


func _get_current_direction() -> Vector2:
	return Vector2.from_angle(rotation)
