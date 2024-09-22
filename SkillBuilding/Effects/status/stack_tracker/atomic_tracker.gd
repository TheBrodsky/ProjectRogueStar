extends StackTracker


func _ready() -> void:
	stacks = 1


func initialize(state: ActionState, num_stacks: int, affected_entity: Node2D) -> void:
	self.state = state
	self.affected_entity = affected_entity
	_update_properties_from_state(state)


func update(new_state: ActionState, num_stacks: int, reset_expiration: bool) -> void:
	self.state = new_state
	_update_properties_from_state(new_state)
	if reset_expiration:
		expiration_timer.start()
