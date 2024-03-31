class_name Branch
extends ActionNode


## A node which splits the action chain, creating a tree.
##
## On ready, Branches check the type of the parent node. 
## This is necessary to enforce rule 4 of the ActionChain. See ActionNode for more info.
##
## Branches are allowed to proceed eachother.


@export var max_branches: int = 2

var childType: ActionType # what kinds of ActionNodes are allowed to proceed this one. Determined by parent type.


func _enter_tree() -> void:
	actionType = ActionType.BRANCH

func _ready() -> void:
	_name = "Branch"
	_determine_child_type()


func _run(state: ActionState) -> void:
	super._run(state)
	var num_branches: int = 0
	for child: Node in get_children():
		if child is ActionNode and (child as ActionNode).actionType == childType:
			Logger.log_debug("%s: connecting to node %s" % [get_action_name(), (child as ActionNode).get_action_name()])
			(child as ActionNode)._run(state)
			num_branches += 1
		
		if num_branches >= max_branches:
			break


# A slightly gross workaround for the situation where a branch proceeds an event.
# The event needs to add all following triggers to its EventContainer, but a branch could be in between.
# Per ActionNode rules, the event node shouldnt be getting all up in Branch's business, so it's better to ask Branch to do it instead.
func get_next_triggers() -> Array[Trigger]:
	assert(childType == ActionType.TRIGGER)
	var triggers: Array[Trigger] = []
	for child: Node in get_children():
		if child is Trigger:
			triggers.append(child as Trigger)
	return triggers


func _determine_child_type() -> void:
	var parent: ActionNode = get_parent()
	match(parent.actionType):
		ActionType.EVENT:
			childType = ActionType.TRIGGER
		ActionType.TRIGGER:
			childType = ActionType.EVENT
		ActionType.BRANCH:
			childType = (parent as Branch).childType
		
