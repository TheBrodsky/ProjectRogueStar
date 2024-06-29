class_name ChainRoot
extends ActionNode


## A simple but significant node that defines the beginning of an ActionChain
##
## ChainRoots dont do a whole lot on their own. They create a new ActionState and initiate the child Trigger node.
## ChainRoots are important because Trigger nodes have no way of knowing if they're the start of the chain.


@onready var parent_entity: Node2D = get_parent()

var ACTION_STATE_BLUEPRINT: PackedScene = preload("res://scenes/Skills/Action Chain/ActionState.tscn")


func _ready() -> void:
	find_next_action_nodes([ActionType.TRIGGER])
	assert(_next.size() > 0)
	run_chain()


func run_chain() -> void:
	for trigger: Trigger in (_next as Array[Trigger]):
		Logger.log_trace("ChainRoot hooked to %s" % trigger.get_action_name())
		var action_state: ActionState = _build_action_state()
		trigger._run(action_state)


func _build_action_state() -> ActionState:
	var action_state: ActionState = ACTION_STATE_BLUEPRINT.instantiate()
	action_state.chain_owner = parent_entity
	action_state.source = parent_entity
	return action_state
