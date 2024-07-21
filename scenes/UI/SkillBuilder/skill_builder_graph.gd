extends GraphEdit
class_name SkillBuilderGraph


@onready var skill_node_packed: PackedScene = preload("res://scenes/UI/SkillBuilder/skill_node/SkillNode.tscn")
@onready var root_node: SkillNode = $Root

var connections_from: Dictionary = {}


func build_chain() -> ChainRoot:
	return root_node.build_chain(connections_from)


func _disconnect_node(node: StringName) -> void:
	# disconnect all connections from this node
	if node in connections_from.keys():
		for to_node: StringName in connections_from[node]:
			disconnect_node(node, 0, to_node, 0)
		connections_from.erase(node)
	
	# disconnect all connections to this node
	for other_node: StringName in connections_from.keys():
		if node in connections_from[other_node]:
			@warning_ignore("unsafe_method_access")
			connections_from[other_node].erase(node)
			disconnect_node(other_node, 0, node, 0)


func _is_valid_connection(from_node: StringName, to_node: StringName) -> bool:
	var is_valid: bool = true
	var from_skill_node: SkillNode = _get_node_by_string_name(from_node)
	var to_skill_node: SkillNode = _get_node_by_string_name(to_node)
	is_valid = from_skill_node.skill_node_type != to_skill_node.skill_node_type # check that nodes are different
	
	if is_valid:
		if from_node in connections_from.keys():
			is_valid = to_node not in connections_from[from_node] # check that nodes arent already connected
	
	return is_valid


func _add_connection_to_dict(from_node: StringName, to_node: StringName) -> void:
	if from_node not in connections_from.keys():
		connections_from[from_node] = {}
	@warning_ignore("unsafe_method_access")
	connections_from[from_node][to_node] = _get_node_by_string_name(to_node)


func _remove_connection_from_dict(from_node: StringName, to_node: StringName) -> void:
	if from_node in connections_from.keys():
		@warning_ignore("unsafe_method_access")
		connections_from[from_node].erase(to_node)


## For reasons beyond my comprehension, finding the node by name does not work consistently. Turning that into a nodepath first, however, works just fine. /shrug
func _get_node_by_string_name(name: StringName) -> SkillNode:
	var node_path: NodePath = NodePath(name)
	return get_node(node_path)


func _connect_nodes(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if _is_valid_connection(from_node, to_node):
		_add_connection_to_dict(from_node, to_node)
		connect_node(from_node, from_port, to_node, to_port)


func _create_new_node(from_node: StringName, node_pos: Vector2) -> SkillNode:
	var new_node: SkillNode = skill_node_packed.instantiate()
	add_child(new_node)
	new_node.on_delete.connect(_disconnect_node)
	new_node.position_offset = node_pos
	new_node.switch_node_type(_get_node_by_string_name(from_node))
	return new_node


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	_connect_nodes(from_node, from_port, to_node, to_port)


## creates new node when connecting to nothing
func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	var new_node: SkillNode = _create_new_node(from_node, release_position)
	_connect_nodes(from_node, from_port, new_node.name, 0) # Assuming the new node has an input port at index 0


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	_remove_connection_from_dict(from_node, to_node)
