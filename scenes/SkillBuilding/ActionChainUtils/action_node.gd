class_name ActionNode
extends Node


## The foundational class of the Action Chain
##
## ActionNodes follow a contract to create interoperability between them:
## 1. A node should never manipulate other nodes. Nodes should only interact through established methods.
## 2. When a node is finished, it should call _run() on the next node.
## 3. All communication between nodes should happen through the ActionState, 
## which is instantiated at the ChainRoot and passed down the chain
## 4. Chains follow a basic pattern of alternating between Trigger and Event. A trigger and event cannot proceed a node of its own type
## 5. Some nodes have more advanced logic, such as CompoundTriggers. See those nodes for more details.
## 6. A node shouldnt know or care where in the chain it is
##
## The common theme of these rules is that objects and causality should only move down the chain, never up.


enum ActionType {NONE, TRIGGER, EVENT, SYMBOLIC} # used as workaround for type identification since types cannot be passed as parameters
const ActionTypeLabels: Array[String] = ["NONE", "TRIGGER", "EVENT", "SYMBOLIC"] # used to map enum to labels

@export var num_next: int = -1 # maximum number of ActionNode children. -1 is no limit
@export var action_name: String # used for logging
@export var action_type: ActionType = ActionType.NONE

var _next: Array[ActionNode] = []


# Top-level entry point of an ActionNode. Called by previous nodes to initiate next node.
func _run(state: ActionState) -> void:
	_apply_quant_modifiers(state)


func find_next_action_nodes(type_whitelist: Array[ActionType] = []) -> void:
	_next = []
	for child: Node in get_children():
		if num_next > -1 and _next.size() == num_next:
			break
		
		if child is ActionNode:
			var node: ActionNode = (child as ActionNode).get_node_if_type(type_whitelist)
			if node != null:
				_next.append(child)


## this is basically a helper for find_next_action_nodes(). It passes the responsibility of type identification to the node in question.
func get_node_if_type(type_whitelist: Array[ActionType]) -> ActionNode:
	if type_whitelist.size() == 0 or action_type in type_whitelist:
		return self
	else:
		return null


func get_action_name() -> String:
	return action_name if action_name != null else ActionTypeLabels[action_type]
	

func clone() -> ActionNode:
	var copy: ActionNode = self.duplicate()
	copy.copy_from(self)
	return copy


func copy_from(other: ActionNode) -> void:
	action_type = other.action_type
	action_name = other.action_name


func _apply_quant_modifiers(state: ActionState) -> void:
	for child: Node in get_children():
		if child is QuantitativeModifier:
			(child as QuantitativeModifier).modify_state(state)
