extends Attacher


@export var decceleration_rate: float = 500


func modify_parent(delta: float) -> void:
	var cur_speed: float = parent_entity.get("speed")
	parent_entity.set("speed", cur_speed - (delta * decceleration_rate))


# given an entity, does it make sense for this Attacher to attach to it. e.g. an attacher might only attach to projectiles
func is_attachable(entity: Node2D) -> bool:
	return entity.is_in_group("projectile")


func _copy_from(other: Attacher) -> void:
	super._copy_from(other)
	decceleration_rate = other.get("decceleration_rate")

