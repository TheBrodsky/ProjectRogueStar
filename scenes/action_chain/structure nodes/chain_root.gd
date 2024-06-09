class_name ChainRoot
extends ActionNode


## A simple but significant node that defines the beginning of an ActionChain
##
## ChainRoots dont do a whole lot on their own. They create a new ActionState and initiate the child Trigger node.
## ChainRoots are important because Trigger nodes have no way of knowing if they're the start of the chain.


@onready var parent_entity: Node2D = get_parent()
@export var action_state_blueprint: PackedScene = preload("res://scenes/action_chain/util/ActionState.tscn")


func _ready() -> void:
	scaling_tags = merge_child_tags()
	find_next_action_nodes([ActionType.TRIGGER])
	assert(_next.size() > 0)


func _run(state: ActionState) -> void:
	super._run(state)
	run_chain(state)


func run_chain(state: ActionState) -> void:
	for trigger: Trigger in (_next as Array[Trigger]):
		Logger.log_debug("ChainRoot hooked to %s" % trigger.get_action_name())
		var action_state: ActionState
		if state == null:
			action_state = _build_action_state()
		else:
			action_state = state.clone()
		trigger._run(action_state)


func _build_action_state() -> ActionState:
	var action_state: ActionState = action_state_blueprint.instantiate()
	action_state.chain_owner = parent_entity
	action_state.source = parent_entity
	return action_state
