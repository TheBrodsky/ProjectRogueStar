class_name Pattern

extends Event


var entity : Area2D # The thing that gets placed in a pattern as part of the action
var num_entities : int


func _do_node_action(state : ActionState) -> ActionState:
	return null


#func modify_emission(emission: Emission) -> void:
	#for point: Vector2 in get_pattern(Vector2.ZERO):
		#var entity = emission.emit()
		#entity.position = point
		#pass

func get_pattern(target : Vector2) -> Array:
	var points: Array[Vector2] = []
	for i in num_entities:
		points.append(_get_point(target))
	return points


func _get_point(target : Vector2) -> Vector2:
	return Vector2.ZERO
