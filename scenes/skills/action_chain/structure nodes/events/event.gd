class_name Event
extends ActionNode


@export var action: IActionable


func _enter_tree() -> void:
	action_type = ActionType.EVENT


func _ready() -> void:
	super()
	find_next_action_nodes([ActionType.TRIGGER])


func _run(state : ActionState) -> void:
	super._run(state)
	find_action()
	action.do_action(state, get_next_triggers())
	

func find_action() -> void:
	if action == null:
		for child: Node in get_children():
			if child is IActionable:
				action = child
				break


# really just exists to log the connection and cast the type
func get_next_triggers() -> Array[Trigger]:
	for trigger: Trigger in _next:
		Logger.log_debug("%s: connecting to node %s" % [get_action_name(), trigger.get_action_name()])
	var next_as_triggers: Array[Trigger]
	next_as_triggers.assign(_next)
	return next_as_triggers
