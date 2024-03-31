class_name ActionNode
extends Node2D


## The foundational class of the Action Chain
##
## ActionNodes follow a contract to create interoperability between them:
## 1. A node should never manipulate other nodes, though it can check what they are.
## 2. When a node is finished, it should call _run() on the next node
## 3. All communication between nodes should happen through the ActionState, 
## which is instantiated at the ChainRoot and passed down the chain
## 4. Chains follow a basic pattern of alternating between Trigger and Event. A trigger and event cannot proceed a node of its own type
## 5. Some nodes have more advanced logic, such as Branches and CompoundTriggers. See those nodes for more details.
## 6. A node shouldnt know or care where in the chain it is
##
## The common theme of these rules is that objects and causality should only move down the chain, never up.


enum ActionType {NONE, TRIGGER, EVENT, BRANCH} # used as workaround for type identification since types cannot be passed as parameters
const ActionTypeLabels: Array[String] = ["NONE", "TRIGGER", "EVENT", "BRANCH"] # used to map enum to labels


var actionType: ActionType = ActionType.NONE

var _next: ActionNode
var _name: String


# Top-level entry point of an ActionNode. Called by previous nodes to initiate next node.
func _run(state: ActionState) -> void:
	_apply_modifiers(state)


func get_next_action_node(type_whitelist: Array[ActionType] = []) -> ActionNode:
	var next_node : ActionNode
	for child: Node in get_children():
		if child is ActionNode:
			if !type_whitelist.is_empty():
				if (child as ActionNode).actionType in type_whitelist:
					next_node = child
			else:
				next_node = child
				break
	return next_node


func get_action_name() -> String:
	return _name if _name != null else ActionTypeLabels[actionType]
	

func clone() -> ActionNode:
	var copy: ActionNode = self.duplicate()
	copy.copy_from(self)
	return copy


func copy_from(other: ActionNode) -> void:
	actionType = other.actionType
	_name = other._name


# returns the next node, prioritizing _next
func _get_next() -> ActionNode:
	var nextNode : ActionNode = _next
	if nextNode == null:
		nextNode = get_next_action_node()
		_next = nextNode
	return nextNode


func _apply_modifiers(state: ActionState) -> void:
	for child: Node in get_children():
		if child is Modifier:
			(child as Modifier).modify_state(state)

