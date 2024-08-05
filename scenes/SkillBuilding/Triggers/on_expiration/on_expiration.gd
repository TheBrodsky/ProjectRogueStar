extends Trigger
class_name OnExpiration


func on_expire(transient: Node) -> void:
	if "state" in transient:
		state = transient.get("state")
	_do_trigger()

