extends ContainerModifier
class_name SetFollower


@export var follower: PackedScene

enum FollowOf {ACTION, CONTAINER}
@export var follower_of: FollowOf = FollowOf.ACTION
@export var container_pos: EventContainer.ContainerPosition
@export var disable_rotation: bool = false


## Modifications that need to happen BEFORE other things in the container
func modify_initialization(state: ActionState, container: EventContainer) -> void:
	if follower_of == FollowOf.ACTION:
		container.action_follower = follower
		state.follower.disable_rotation = disable_rotation
	else:
		container.container_follower = follower
	container.container_position = container_pos
