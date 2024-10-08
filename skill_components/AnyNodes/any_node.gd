extends Node


## AnyNode is a placeholder node that can be put in a scene and, upon scene instantiation,
## it will replace itself with a random node from its list. This has a MAJOR caveat:
## _enter_tree or _ready logic that depends on the node in AnyNode's place may
## need to be moved to some place that get's called after AnyNode swaps out.


@export var possible_nodes: AnyNodeList


func _enter_tree() -> void:
	if get_child_count():
		var replacement_node: Node = possible_nodes.get_node()
		get_parent().add_child.call_deferred(replacement_node)
		for child in get_children():
			child.reparent(replacement_node)
	queue_free()
