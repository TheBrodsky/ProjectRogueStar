extends Trigger
class_name OnHit


func on_hit(body: Node2D) -> void:
	state.source = body
	_do_trigger()
