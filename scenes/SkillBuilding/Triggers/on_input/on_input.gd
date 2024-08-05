extends Trigger
class_name OnInput


enum InputTriggerButtonInputs {AUTOMATIC, MOUSE_LEFT, MOUSE_RIGHT}
static var InputTriggerButtonInputsLabels: Array[String] = ["automatic", "mouse_left", "mouse_right"]
@export var input_action: InputTriggerButtonInputs


func _process(delta: float) -> void:
	if !_is_paused and Input.is_action_pressed(_get_input_label(input_action)):
		_do_trigger()


func _get_input_label(input: InputTriggerButtonInputs) -> String:
	return InputTriggerButtonInputsLabels[input]
