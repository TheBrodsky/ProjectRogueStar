extends Node


@export var possible_nodes: AnyNodeList


func _enter_tree() -> void:
	if get_child_count():
		var replacement_node: Node = possible_nodes.get_node()
		get_parent().add_child.call_deferred(replacement_node)
		for child in get_children():
			child.reparent(replacement_node)
	queue_free()
