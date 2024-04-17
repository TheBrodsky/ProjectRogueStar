class_name Status
extends Effect


@export var lifetime: float = 1 # Time in seconds the status lasts

var affected_entity: Node2D # A status has to be inflicted on something or someone

var _cur_lifetime: float = 0


func _process(delta: float) -> void:
	_cur_lifetime += delta
	if _cur_lifetime >= lifetime:
		var remaining_lifetime: float = delta - (_cur_lifetime - lifetime) # gets the time elapsed this tick up to the point it hits lifetime, preventing overages
		do_status(remaining_lifetime)
		queue_free()
	else:
		do_status(delta)


func do_status(delta: float) -> void:
	push_error("UNIMPLEMENTED ERROR: Effect.do_status()")


func modify_from_action_state(state: ActionState) -> void:
	push_error("UNIMPLEMENTED ERROR: Effect.modify_from_action_state()")
