class_name ChainRoot
extends ActionNode


## A simple but significant node that defines the beginning of an ActionChain
##
## ChainRoots dont do a whole lot on their own. They create a new ActionState and initiate the child Trigger node.
## ChainRoots are important because Trigger nodes have no way of knowing if they're the start of the chain.



@onready var parent_entity: Node2D = get_parent()
@export var action_state_blueprint: PackedScene = preload("res://scenes/action_chain/util/ActionState.tscn")


func _ready() -> void:
	_next = get_next_action_node([ActionType.TRIGGER])
	assert(_next != null)
	build_chain()
	

func build_chain() -> void:
	var trigger: Trigger = _next
	Logger.log_debug("ChainRoot hooked to %s" % _next.get_action_name())
	var action_state: ActionState = _build_action_state()
	trigger._run(action_state)


func _build_action_state() -> ActionState:
	var action_state: ActionState = action_state_blueprint.instantiate()
	action_state.chain_owner = parent_entity
	action_state.source = parent_entity
	return action_state
