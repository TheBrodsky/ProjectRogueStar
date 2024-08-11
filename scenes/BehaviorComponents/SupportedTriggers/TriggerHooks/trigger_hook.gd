extends Resource
class_name TriggerHook


## Triggers hooks are simple static classes that add compatibility verification
## and any additional setup required for a given trigger type


## Performs any setup needed to "activate" the trigger on the triggering node
static func set_trigger(triggering_node: Node, trigger: Trigger, state: ActionState) -> void:
	var cloned_state: ActionState = state.clone() # Action -> Trigger state duplication
	cloned_state.source = triggering_node
	trigger._run(cloned_state)


## Determines whether the parent node is compatible with this trigger type
static func is_compatible(parent_node: Node) -> bool:
	return true
