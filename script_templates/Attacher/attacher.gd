extends Attacher


func modify_parent(delta: float) -> void:
	push_error("UNIMPLEMENTED_ERROR: Modifier.modify_state()")


# given an entity, does it make sense for this Attacher to attach to it. e.g. an attacher might only attach to projectiles
func is_attachable(entity: Node2D) -> bool:
	return true


func _copy_from(other: Attacher) -> void:
	super._copy_from(other)
