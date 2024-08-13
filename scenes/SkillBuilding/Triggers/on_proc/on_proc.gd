extends Trigger
class_name OnProc


## A proc is the "hit" equivalent for DoTs. A DoT procs whenever it makes its effect happen.


##signal: proc(procable: Node, state: ActionState), where "procable" is the DoT that procced
const _proc_signal: String = "proc"


static func is_compatible(connecting_node: Node) -> bool:
	return connecting_node.has_signal(_proc_signal)


func on_proc(proccable: Node, state: ActionState) -> void:
	do_trigger(_build_state_for_trigger(state))


func _engage_as_root(state: ActionState) -> void:
	SignalBus.proc.connect(on_proc)


func _engage_as_link(connecting_node: Node) -> void:
	connecting_node.connect(_proc_signal, on_proc)
