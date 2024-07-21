extends ActionModifier


@export var decceleration_rate: float = 500


func modify_parent(delta: float) -> void:
	var cur_speed: float = parent_entity.get("speed")
	parent_entity.set("speed", cur_speed - (delta * decceleration_rate))


func is_attachable(action: Node2D) -> bool:
	return action.is_in_group("projectile")


func _copy_from(other: ActionModifier) -> void:
	super._copy_from(other)
	decceleration_rate = other.get("decceleration_rate")

