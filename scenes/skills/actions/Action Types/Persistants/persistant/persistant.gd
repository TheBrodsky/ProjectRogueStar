class_name IPersistant
extends IActionable


## An interface for IActionables that persist, as opposed to one-off actions.
## setup_persistent_entities() is the main method.


var state: ActionState # usually null if is_blueprint is true
	#set(value):
		#state = value.duplicate(true)
		#pass


func _ready() -> void:
	super()
	if is_blueprint:
		set_process(false)
	else:
		set_process(true)
		state = state.duplicate()


func _process(delta: float) -> void:
	if _should_exist():
		queue_free()


func _pre_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	(new_action as IPersistant).state = new_state.duplicate()
	super(new_action, new_state, next_triggers)


func _main_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	(new_action as IPersistant)._setup_persistent_entities()


func _post_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	super(new_action, new_state, next_triggers)
	(new_action as IPersistant).apply_state_attachers()
	

func _set_trigger(trigger: Trigger) -> void:
	for entity: Node in get_children():
		if entity is PersistantEntity:
			var persistent_entity: PersistantEntity = entity
			persistent_entity.set_trigger(trigger, state)


func _copy_from(other: IActionable) -> void:
	super(other)


# used by inheriting classes to perform additional setup during the do_action() call
func _setup_persistent_entities() -> void:
	push_error("UNIMPLEMENTED ERROR: IPersistant.setup()")


func _should_exist() -> bool:
	return get_child_count() == 0


func apply_state_attachers() -> void:
	for attacher: Attacher in state.attachers:
		for child in get_children():
			attacher.attach(child as Node2D)
