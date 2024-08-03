extends Resource
class_name TriggerHook


## Triggers hooks are simple static classes that add compatibility verification
## and any additional setup required for a given trigger type


## Performs any setup needed to "activate" the trigger on the parent node
static func set_trigger(parent_node: Node, trigger: Trigger, state: ActionState) -> void:
	pass


## Determines whether the parent node is compatible with this trigger type
static func is_compatible(parent_node: Node) -> bool:
	return true
