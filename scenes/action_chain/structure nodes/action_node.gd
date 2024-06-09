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


enum ActionType {NONE, TRIGGER, EVENT} # used as workaround for type identification since types cannot be passed as parameters
const ActionTypeLabels: Array[String] = ["NONE", "TRIGGER", "EVENT"] # used to map enum to labels

@onready var inclusive_tags: Tags = $AddTags
@onready var exclusive_tags: Tags = $SubTags

@export var num_next: int = 1
@export var action_name: String
@export var action_type: ActionType = ActionType.NONE

var _next: Array[ActionNode] = []


func _ready() -> void:
	if inclusive_tags == null:
		inclusive_tags = Tags.get_empty_tags()
	if exclusive_tags == null:
		exclusive_tags = Tags.get_empty_tags()


# Top-level entry point of an ActionNode. Called by previous nodes to initiate next node.
func _run(state: ActionState) -> void:
	_apply_modifiers(state)


func run_next(state: ActionState) -> void:
	for child: ActionNode in _next:
		Logger.log_debug("%s: connecting to node %s" % [get_action_name(), child.get_action_name()])
		child._run(state.clone())


func find_next_action_nodes(type_whitelist: Array[ActionType] = []) -> void:
	_next = []
	var next_node : Array[ActionNode]
	for child: Node in get_children():
		if _next.size() == num_next:
			break
		
		if child is ActionNode:
			var is_in_whitelist: bool = type_whitelist.size() == 0 or (child as ActionNode).action_type in type_whitelist
			if is_in_whitelist:
				_next.append(child)


func get_action_name() -> String:
	return action_name if action_name != null else ActionTypeLabels[action_type]
	

func clone() -> ActionNode:
	var copy: ActionNode = self.duplicate()
	copy.copy_from(self)
	return copy


func copy_from(other: ActionNode) -> void:
	action_type = other.action_type
	action_name = other.action_name


func merge_child_tags() -> Array[Tags]:
	var cum_inc_tags: Tags = inclusive_tags
	var cum_exc_tags: Tags = exclusive_tags
	for child in get_children():
		if child is ActionNode:
			var child_tags: Array[Tags] = (child as ActionNode).merge_child_tags()
			cum_inc_tags = cum_inc_tags.add(child_tags[0])
			cum_exc_tags = cum_exc_tags.add(child_tags[1])
	return [cum_inc_tags, cum_exc_tags]


# returns the next node, prioritizing _next
func _get_next() -> Array[ActionNode]:
	if _next.size() < num_next:
		find_next_action_nodes()
	return _next


func _apply_modifiers(state: ActionState) -> void:
	for child: Node in get_children():
		if child is Modifier:
			(child as Modifier).modify_state(state)
