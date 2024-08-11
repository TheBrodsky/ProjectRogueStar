extends ContainerModifier
class_name BuildFollower

@export_group(Globals.MODIFIABLE_CATEGORY)
@export var followers: Array[PackedScene]

enum FollowOf {ACTION, CONTAINER}
@export var follower_of: FollowOf = FollowOf.ACTION
@export var container_pos: EventContainer.ContainerPosition
@export var disable_rotation: bool = false

@export_group(Globals.PRIVATE_CATEGORY)
@export var built_follower: PackedScene = null


func _ready() -> void:
	if built_follower == null:
		_build_follower_scene()


## Modifications that need to happen BEFORE other things in the container
func modify_initialization(state: ActionState, container: EventContainer) -> void:
	if follower_of == FollowOf.ACTION:
		container.action_follower = built_follower
		state.follower.disable_rotation = disable_rotation
	else:
		container.container_follower = built_follower
	container.container_position = container_pos


func _build_follower_scene() -> void:
	assert(followers.size() > 0)
	var root_follower: Follower = followers[0].instantiate()
	for i in range(1, followers.size()): # skip first iteration because that's root_follower
		root_follower.add_child(followers[i].instantiate())
	built_follower = ScenePacker.packScene(root_follower)
	root_follower.queue_free()
