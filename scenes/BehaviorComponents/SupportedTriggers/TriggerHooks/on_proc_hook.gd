extends TriggerHook
class_name OnProcHook


const _proc_signal: String = "proc"


## Performs any setup needed to "activate" the trigger on the parent node
static func set_trigger(triggering_node: Node, trigger: Trigger, state: ActionState) -> void:
	triggering_node.connect(_proc_signal, (trigger as OnProc).on_proc)
	super(triggering_node, trigger, state)


## Determines whether the parent node is compatible with this trigger type
static func is_compatible(parent_node: Node) -> bool:
	return parent_node.has_signal("proc")
