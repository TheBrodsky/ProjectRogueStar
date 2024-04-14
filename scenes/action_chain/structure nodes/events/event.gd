class_name Event
extends ActionNode


@export var action: IActionable


func _enter_tree() -> void:
	actionType = ActionType.EVENT


func _ready() -> void:
	pass


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


func get_next_triggers() -> Array[Trigger]:
	var triggers: Array[Trigger] = []
	var next: ActionNode = _get_next()
	if next != null:
		if next is Branch:
			for trigger: Trigger in (next as Branch).get_next_triggers():
				Logger.log_debug("%s: connecting to node %s" % [get_action_name(), next.get_action_name()])
				triggers.append(trigger)
		else:
			Logger.log_debug("%s: connecting to node %s" % [get_action_name(), next.get_action_name()])
			triggers.append(next as Trigger)
	return triggers
