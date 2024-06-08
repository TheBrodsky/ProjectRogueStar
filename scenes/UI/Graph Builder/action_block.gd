class_name ActionBlock
extends GraphNode


var inputs: Array[ActionBlock] = []
var outputs: Array[ActionBlock] = []


func _ready() -> void:
	for i in get_input_port_count():
		inputs.append(null)
	
	for i in get_output_port_count():
		outputs.append(null)


## Connects an outgoing connection from this block
func connect_to(block: ActionBlock, port: int) -> bool:
	Logger.log_debug("Attempting to connect %s to %s out port %s" % [self, block, port])
	return _modify_connection(outputs, block, port)

## Connects an incoming connection to this block
func connect_from(block: ActionBlock, port: int) -> bool:
	Logger.log_debug("Attempting to connect %s from %s into port %s" % [self, block, port])
	return _modify_connection(inputs, block, port)

## Disconnects an outgoing connection from this block
func disconnect_to(port: int) -> bool:
	Logger.log_debug("Attempting to disconnect %s output port %s" % [self, port])
	return _modify_connection(outputs, null, port)

## Disconnects an incoming connection to this block
func disconnect_from(port: int) -> bool:
	Logger.log_debug("Attempting to disconnect %s input port %s" % [self, port])
	return _modify_connection(inputs, null, port)


func _modify_connection(side: Array[ActionBlock], block: ActionBlock, port: int) -> bool:
	var is_successful: bool = false
	# if block is null, it's disconnecting; otherwise we only want to connect nodes that aren't already connected
	if block == null or block not in side:
		side[port] = block
		is_successful = true
	return is_successful
