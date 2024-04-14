class_name Attacher
extends Modifier


## Attachers are a class of modifiers that "attach" to persistant entities,
## modifying their behavior over their lifetime.


var parent_entity: Node2D


func _process(delta: float) -> void:
	if parent_entity != null:
		modify_parent(delta)


func modify_parent(delta: float) -> void:
	push_error("UNIMPLEMENTED_ERROR: Modifier.modify_state()")


func modify_state(state: ActionState) -> void:
	state.attachers.append(self)


func attach(entity: Node2D) -> void:
	if is_attachable(entity):
		var cloned_attacher: Attacher = clone()
		cloned_attacher.parent_entity = entity
		entity.add_child(cloned_attacher)


# given an entity, does it make sense for this Attacher to attach to it. e.g. an attacher might only attach to projectiles
func is_attachable(entity: Node2D) -> bool:
	return true


func clone(flags: int = 15) -> Attacher:
	var new_attacher : Attacher = self.duplicate(flags)
	new_attacher._copy_from(self)
	return new_attacher


func _copy_from(other: Attacher) -> void:
	pass
