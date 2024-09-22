extends Node


var registry: Dictionary


func get_group_id(root: String) -> String:
	if root not in registry:
		registry[root] = 0
	
	var group_id: String = "%s_%s" % [root, registry[root]]
	registry[root] += 1
	return group_id
