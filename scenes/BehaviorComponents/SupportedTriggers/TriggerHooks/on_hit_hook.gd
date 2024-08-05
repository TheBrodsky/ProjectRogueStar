extends TriggerHook
class_name OnHitHook


const _hit_signal: String = "register_hit"


## Performs any setup needed to "activate" the trigger on the parent node
static func set_trigger(triggering_node: Node, trigger: Trigger, state: ActionState) -> void:
	triggering_node.connect(_hit_signal, (trigger as OnHit).on_hit)
	super(triggering_node, trigger, state)


## Determines whether the parent node is compatible with this trigger type
static func is_compatible(parent_node: Node) -> bool:
	return parent_node.has_signal(_hit_signal)
