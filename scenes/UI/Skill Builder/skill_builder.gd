extends GraphEdit

var _prev_mouse_mode: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		toggle_visibility()


func toggle_visibility() -> void:
	if visible:
		hide()
		get_tree().paused = false
		Input.set_mouse_mode(_prev_mouse_mode)
		#OS.low_processor_usage_mode = false
	else:
		show()
		get_tree().paused = true
		_prev_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#OS.low_processor_usage_mode = true


## Basically an override of disconnect_node()
func _disconnect_nodes(from_block: SkillNode, from_port: int, to_block: SkillNode, to_port: int) -> void:
	if from_block.disconnect_to(from_port) and to_block.disconnect_from(to_port):
		disconnect_node(from_block.name, from_port, to_block.name, to_port)
	else:
		Logger.log_warn("Disconnection failed between %s and %s" % [from_block, to_block])


func _disconnect_from_if_connected(from_block: SkillNode, from_port: int) -> void:
	var to_block: SkillNode = from_block.outputs[from_port]
	if to_block != null:
		var to_port: int = from_block.outputs.find(to_block)
		if to_port != -1: # -1 = not found
			_disconnect_nodes(from_block, from_port, to_block, to_port)


func _disconnect_to_if_connected(to_block: SkillNode, to_port: int) -> void:
	var from_block: SkillNode = to_block.inputs[to_port]
	if from_block != null:
		var from_port: int = to_block.inputs.find(from_block)
		if from_port != -1: # -1 = not found
			_disconnect_nodes(from_block, from_port, to_block, to_port)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_node != to_node:
		var from_block: SkillNode = find_child(from_node, false) as SkillNode
		var to_block: SkillNode = find_child(to_node, false) as SkillNode
		_disconnect_from_if_connected(from_block, from_port)
		_disconnect_to_if_connected(to_block, to_port)
		if from_block.connect_to(to_block, from_port) and to_block.connect_from(from_block, to_port):
			connect_node(from_node, from_port, to_node, to_port)
		else:
			Logger.log_warn("Connection failed between %s and %s" % [from_node, to_node])


# This might actually never get called
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var from_block: SkillNode = find_child(from_node, false) as SkillNode
	var to_block: SkillNode = find_child(to_node, false) as SkillNode
	_disconnect_nodes(from_block, from_port, to_block, to_port)


func _on_connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2) -> void:
	var to_block: SkillNode = find_child(to_node, false) as SkillNode
	_disconnect_to_if_connected(to_block, to_port)


func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	var from_block: SkillNode = find_child(from_node, false) as SkillNode
	_disconnect_from_if_connected(from_block, from_port)
