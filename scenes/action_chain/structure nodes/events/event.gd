class_name Event
extends ActionNode


@onready var event_container_blueprint: PackedScene = preload("res://scenes/action_chain/util/EventContainer.tscn")


func _enter_tree() -> void:
	actionType = ActionType.EVENT


func _ready() -> void:
	pass


# PROTECTED. MUST BE OVERRIDEN. What defines an event's actual behavior.
func _do_event_action(container: EventContainer) -> void:
	push_error("UNIMPLEMENTED ERROR: Event._do_event_action()")


func _run(state : ActionState) -> void:
	super._run(state)
	var container: EventContainer = _create_container(state)
	container.sync_with_source()
	_do_event_action(container)
	get_tree().get_root().add_child(container)
	run_next(container)


# Events work a little bit differently and have to attach the next triggers to the event container.
# The event trusts that the container will handle everything that needs to happen and continue the chain.
func run_next(container: EventContainer) -> void:
	var next: ActionNode = _get_next()
	if next != null:
		if next is Branch:
			for trigger: Trigger in (next as Branch).get_next_triggers():
				Logger.log_debug("%s: connecting to node %s" % [get_action_name(), next.get_action_name()])
				container.add_trigger(trigger)
		else:
			Logger.log_debug("%s: connecting to node %s" % [get_action_name(), next.get_action_name()])
			container.add_trigger(next as Trigger)


func _create_container(state: ActionState) -> EventContainer:
	var new_container : EventContainer = event_container_blueprint.instantiate()
	new_container.set_state(state)
	return new_container
