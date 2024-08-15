extends Trigger
class_name OnExpiration


## An expiration is when something terminates for a reason other than death.
## An effect running out of duration, a projectile hitting something or flying off screen.
## The rule of thumb is that if the thing disappearing has health, it's death, otherwise it's expiration.


## signal: expire(transient: Node, state: ActionState), where "transient" is the object that expired
const _expire_signal: String = "expire"


static func is_compatible(connecting_node: Node) -> bool:
	return connecting_node.has_signal(_expire_signal)


func on_expire(transient: Node, state: ActionState) -> void:
	do_trigger(_build_state_for_trigger(state))


func _engage_as_root(state: ActionState) -> void:
	SignalBus.expire.connect(on_expire)


func _engage_as_link(connecting_node: Node) -> void:
	connecting_node.connect(_expire_signal, on_expire)
