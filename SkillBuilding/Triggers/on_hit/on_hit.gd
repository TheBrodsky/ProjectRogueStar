extends Trigger
class_name OnHit


## A hit has a specific meaning in ARPGs. It is mutually exlusive from a proc (associated with DoTs).
## A hit is how a non-DoT entity interacts with another entity.


## signal: register_hit(body: Node2D, state: ActionState), where "body" is the object hit
const _hit_signal: String = "register_hit"


static func is_compatible(connecting_node: Node) -> bool:
	return connecting_node.has_signal(_hit_signal)


func on_hit(body: Node2D, state: ActionState) -> void:
	state = _build_state_for_trigger(state)
	state.source = body
	do_trigger(state)


func _engage_as_root(state: ActionState) -> void:
	SignalBus.register_hit.connect(on_hit)


func _engage_as_link(connecting_node: Node) -> void:
	connecting_node.connect(_hit_signal, on_hit)


func _build_state_for_trigger(state: ActionState) -> ActionState:
	if not preserves_state:
		state = ActionState.get_state(state) # get a clean state with owner and source from passed-in state
	else:
		state = state.clone()
	return state
