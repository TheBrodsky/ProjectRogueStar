extends Node2D
class_name Follower


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var target: Target ## Determines the destination of a follower
@export var speed: float = 0 ## In pixels/second
@export var aim_deviation: float = 0 ## in degrees
@export var prevent_entity_rotation: bool = false ## prevents the entity being moved by the follower from rotating with the follower

@export_group(Globals.INSPECTOR_CATEGORY)
@export var bottom_node: Node2D = null ## reparents all children to this node. Used in multi-node followers.


func _enter_tree() -> void:
	if prevent_entity_rotation:
		# to prevent entity rotation, stick a Gyroscope where the entity would be in the chain and make it the child of that Gyroscope
		var gyroscope: Gyroscope = Gyroscope.new()
		if bottom_node != null:
			bottom_node.add_child(gyroscope)
		else:
			add_child(gyroscope)
		bottom_node = gyroscope
	_reparent_children()


func modify_from_state(state: ActionState) -> void:
	target = state.target
	speed = state.get_speed()
	aim_deviation = state.get_aim_deviation()
	prevent_entity_rotation = state.is_rotation_disabled()


func _get_direction_to_target() -> Vector2:
	return (target.get_target(get_tree()) - global_position).normalized()


func _get_current_direction() -> Vector2:
	return Vector2.from_angle(rotation)


## This is hacky but necessary. A chain of Followers must be linear (ie each node has only 1 Follower child)
## Additionally, the action/entity that is being moved by the Followers must be at the very bottom.
## Finally, some Followers (like orbit) rely on a non-follower child node to do its movement. This must be "bottom_node"
## In short, bottom_node should be whichever node in the scene an action/entity should be a child of.
## It is the "bottom" of the chain. Bottom is local to each Follower scene.
func _reparent_children() -> void:
	if bottom_node != null and bottom_node != self:
		for child in get_children():
			if not child is Follower and child != bottom_node and not child is Sprite2D:
				child.reparent(bottom_node)
