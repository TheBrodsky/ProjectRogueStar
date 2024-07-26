class_name ChainRoot
extends ActionNode


## A simple but significant node that defines the beginning of an ActionChain
## ChainRoots dont do a whole lot on their own. They create a new ActionState and initiate the child Trigger node.
## ChainRoots are important because Trigger nodes have no way of knowing if they're the start of the chain.

@export var enabled: bool = true
@export var input_type: OnInputTrigger.InputTriggerButtonInputs
@onready var parent_entity: Node2D = get_parent()

var ACTION_STATE_BLUEPRINT: PackedScene = preload("res://scenes/SkillBuilding/ActionChain/ActionState.tscn")


func _ready() -> void:
	find_next_action_nodes([ActionType.TRIGGER])
	_add_input_trigger()
	if enabled:
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


#region special case trigger methods
## It's often the case that action chains begin with a compound trigger that ends in an OnInputTrigger. This automates that and helps with skill building
func _add_input_trigger() -> void:
	if input_type != OnInputTrigger.InputTriggerButtonInputs.AUTOMATIC:
		for trigger: Trigger in _next:
			if trigger is OnCompoundTrigger:
				trigger.add_child(_make_input_trigger())
			else:
				var compound_trigger: OnCompoundTrigger = _make_ordered_compound_trigger()
				compound_trigger.add_child(trigger)
				compound_trigger.add_child(_make_input_trigger())


func _make_ordered_compound_trigger() -> OnCompoundTrigger:
	var trigger: OnCompoundTrigger = OnCompoundTrigger.new()
	trigger.is_ordered = true
	return trigger


func _make_input_trigger() -> OnInputTrigger:
	var trigger: OnInputTrigger = OnInputTrigger.new()
	trigger.input_action = input_type
	return trigger
#endregion
