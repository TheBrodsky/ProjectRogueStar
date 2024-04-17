class_name IPersistant
extends IActionable


## An interface for IActionables that persist, as opposed to one-off actions.


var is_blueprint: bool = true # blueprints live in the action chain and serve as a blueprint to copy
var state: ActionState


func _ready() -> void:
	if is_blueprint:
		set_process(false)
	else:
		set_process(true)


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


# used by inheriting classes to perform additional setup during the do_action() call
func setup() -> void:
	push_error("UNIMPLEMENTED ERROR: IPersistant.setup()")


func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	var new_persistant: IPersistant = clone()
	new_persistant.state = new_state
	get_tree().get_root().add_child(new_persistant)
	new_persistant.position = new_state.source.global_position
	
	new_persistant.setup()
	new_persistant.set_triggers(next_triggers)
	new_persistant.apply_state_attachers()


func apply_state_attachers() -> void:
	for attacher: Attacher in state.attachers:
		for child in get_children():
			attacher.attach(child as Node2D)


func set_triggers(next_triggers: Array[Trigger]) -> void:
	for trigger: Trigger in next_triggers:
		set_trigger(trigger)


func set_trigger(trigger: Trigger) -> void:
	for entity: Node in get_children():
		var trigger_copy: Trigger = trigger.clone()
		entity.add_child(trigger_copy)
		var state_copy: ActionState = state.clone()
		state_copy.source = entity
		trigger_copy._run(state_copy)


func clone(flags: int = 15) -> IPersistant:
	var new_persistant: IPersistant = self.duplicate(flags)
	new_persistant._copy_from(self)
	return new_persistant


func _copy_from(other: IPersistant) -> void:
	is_blueprint = false # is_blueprint is NEVER passed on


func _should_exist() -> bool:
	return get_child_count() == 0
