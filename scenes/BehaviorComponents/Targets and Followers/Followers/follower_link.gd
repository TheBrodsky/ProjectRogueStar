extends Node2D
class_name FollowerLink


## A FollowerLink is any node that can form the basis of a chain of Followers.
##
## If a FollowerLink has any children, the first child MUST be another FollowerLink.
## If a FollowerLink does NOT have any children, it is assumed to be the bottom of the chain.
## If a FollowerLink has multiple children that are FollowerLinks, the first will be the next link.


var _next_link: FollowerLink = null


## Assembles chain of Followers with moved_entity at the bottom. Does not perform most modifications from state.
func assemble_chain(state: ActionState, moved_entity: Node2D) -> void:
	_build_follower_chain(state, moved_entity)


## Modifies follower properties and performs any needed setup. Call AFTER assemble_chain
func initialize(state: ActionState) -> void:
	if _next_link != null:
		_next_link.initialize(state)


## Called sort of recursively down the chain of FollowerLinks to ensure
func _build_follower_chain(state: ActionState, moved_entity: Node2D) -> void:
	var first_child: Node = get_child(0)
	if first_child != null:
		# FollowerLink HAS A child and therefore MUST NOT BE the bottom of the follower chain
		assert(first_child is FollowerLink) # enforce that FollowerLinks with children must have a FollowerLink child first
		_next_link = first_child
		_reparent_children_to_next_link(state, moved_entity)
	else:
		# FollowerLink HAS NO children and therefore MUST BE the bottom of the follower chain
		_add_moved_entity_to_bottom_of_chain(state, moved_entity)


func _reparent_children_to_next_link(state: ActionState, moved_entity: Node2D) -> void:
	for child in get_children():
		if child != _next_link and not child is Sprite2D:
			child.reparent(_next_link)
	_next_link.assemble_chain(state, moved_entity)


func _add_moved_entity_to_bottom_of_chain(state: ActionState, moved_entity: Node2D) -> void:
	if state.follower.is_rotation_disabled():
		var gyroscope: Gyroscope = Gyroscope.new()
		add_child(gyroscope)
		_add_moved_entity(moved_entity, gyroscope)
	else:
		_add_moved_entity(moved_entity, self)


func _add_moved_entity(moved_entity: Node2D, parent: Node2D) -> void:
	if moved_entity.get_parent() != null:
		# moved_entity already has parent and thus must be reparented
		moved_entity.reparent(parent)
	else:
		parent.add_child(moved_entity)
