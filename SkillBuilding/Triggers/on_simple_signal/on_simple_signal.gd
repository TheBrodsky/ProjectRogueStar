extends Trigger


@export var signal_name: String


func _engage_as_root(state: ActionState) -> void:
	if SignalBus.has_signal(signal_name):
		SignalBus.connect(signal_name, do_trigger)


func _engage_as_link(connecting_node: Node) -> void:
	if connecting_node.has_signal(signal_name):
		connecting_node.connect(signal_name, do_trigger)
