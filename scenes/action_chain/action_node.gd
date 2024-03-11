class_name ActionNode

extends Node


enum ActionType {NONE, TRIGGER, EVENT}

var actionType: ActionType

var _next: ActionNode


@onready var action_state_blueprint: PackedScene = preload("res://scenes/action_chain/ActionState.tscn")


# PROTECTED. MUST BE OVERRIDEN. Top-level entry point of an ActionNode. Called by previous nodes to initiate next node.
func _run(state: ActionState) -> void:
	push_error("UNIMPLEMENTED ERROR: ActionNode._run()")


func run_next(state: ActionState) -> void:
	var next: ActionNode = _get_next()
	if next != null:
		next._run(state)


func get_next_action_node(node_type: ActionType = ActionType.NONE) -> ActionNode:
	var next_node : ActionNode
	for child: Node in get_children():
		if child is ActionNode:
			if node_type != ActionType.NONE:
				if (child as ActionNode).actionType == node_type:
					next_node = child
			else:
				next_node = child
				break
	return next_node


# returns the next node, prioritizing _next
func _get_next() -> ActionNode:
	var nextNode : ActionNode = _next
	if nextNode == null:
		nextNode = get_next_action_node()
		_next = nextNode
	return nextNode
