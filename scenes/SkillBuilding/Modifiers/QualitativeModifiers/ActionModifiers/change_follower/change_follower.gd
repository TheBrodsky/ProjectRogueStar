extends ActionModifier


@export var new_follower_packed: PackedScene
@export var force_add: bool = false

var _existing_follower: Follower


func _ready() -> void:
	assert(new_follower_packed != null)


## In this case, this modifier attaches the Follower rather than itself
func attach(action: Node2D, state: ActionState) -> void:
	if is_attachable(action):
		_replace_follower(action, state)


func is_attachable(action: Node2D) -> bool:
	if force_add:
		return true
	else:
		for child in action.get_children():
			if child is Follower:
				_existing_follower = child
				return true
	return false


func _replace_follower(action: Node2D, state: ActionState) -> void:
	var new_follower: Follower = new_follower_packed.instantiate()
	new_follower.target = state.target
	new_follower.parent_entity = action
	action.add_child(new_follower)
	
	if !force_add:
		_existing_follower.queue_free()
