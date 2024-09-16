extends Resource
class_name AnyNodeList


@export var node_list: Array[PackedScene] = []


func get_node() -> Node:
	var scene: PackedScene = node_list.pick_random()
	return scene.instantiate()
