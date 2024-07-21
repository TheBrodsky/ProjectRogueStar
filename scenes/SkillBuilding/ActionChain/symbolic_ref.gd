extends ActionNode


## A Symbolic Reference is a stand-in for another node.
## Effectively, this allows a node to have multiple parents as far as action chain
## flow is concerned. Since ActionNodes determine the next nodes in the chain via
## the parent-child relationship, it's impossible for multiple nodes to chain into
## the same child node. Symbolic References keep a reference to another node and
## pretend to be that node when called upon. If done correctly, other nodes dont
## even know the Symbolic Reference exists.


var ref_node: ActionNode = null


func get_node_if_type(type_whitelist: Array[ActionType]) -> ActionNode:
	if type_whitelist.size() == 0 or ref_node.action_type in type_whitelist:
		return ref_node
	else:
		return null


func _run(state: ActionState) -> void:
	ref_node._run(state)


func clone() -> ActionNode:
	return ref_node.clone()


func get_action_name() -> String:
	return ref_node.get_action_name()
