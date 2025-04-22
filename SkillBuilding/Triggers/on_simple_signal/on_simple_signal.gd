extends Trigger


@export var signal_name: String


func _engage_as_root(state: ActionState) -> void:
	if SignalBus.has_signal(signal_name):
		SignalBus.connect(signal_name, do_trigger)


func _engage_as_link(connecting_node: Node) -> void:
	# check if node is an action entity (ie if it implements the ActionInterface)
	if connecting_node is Node2D and ActionInterface.is_action(connecting_node as Node2D):
		# leverage ActionInterface's signaler
		var iaction: ActionInterface = ActionInterface.get_action_interface(connecting_node as Node2D)
		iaction.signaler.connect(signal_name, do_trigger)
	else:
		# node is not an action entity, check if signal exists
		if connecting_node.has_signal(signal_name):
			connecting_node.connect(signal_name, do_trigger)
