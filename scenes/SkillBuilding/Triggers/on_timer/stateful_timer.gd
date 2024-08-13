extends Timer
class_name StatefulTimer
signal stateful_timeout(state: ActionState)


var state: ActionState


func _on_timeout() -> void:
	stateful_timeout.emit(state)
