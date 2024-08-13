extends Trigger



## Determines whether the connecting node meets the requirements to be able to trigger this Trigger
static func is_compatible(connecting_node: Node) -> bool:
	return true


func _engage_as_root(state: ActionState) -> void:
	pass


func _engage_as_link(connecting_node: Node) -> void:
	pass
