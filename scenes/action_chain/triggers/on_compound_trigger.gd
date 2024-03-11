extends Trigger


var _sub_triggers: Array[Trigger]
var _expected_triggers: int
var _current_triggers: int = 0


func _ready() -> void:
	_next = get_next_action_node(ActionType.EVENT)
	assert(_next != null)
	_sub_triggers = _find_sub_triggers()
	_connect_sub_triggers(_sub_triggers)


func _find_sub_triggers() -> Array[Trigger]:
	var triggers : Array[Trigger] = []
	for child: Node in get_children():
		if child is Trigger:
			var trigger: Trigger = child as Trigger
			trigger.is_one_shot = true
			triggers.append(trigger)
	return triggers


func _connect_sub_triggers(triggers : Array[Trigger]) -> void:
	for trigger: Trigger in triggers:
		trigger.triggered.connect(_on_sub_trigger)
		_expected_triggers += 1


func _on_sub_trigger(origin: ActionNode) -> void:
	_current_triggers += 1
	if _current_triggers >= _expected_triggers:
		# all sub-triggers have triggered
		_current_triggers = 0
		_do_trigger()
		_unpause_sub_triggers()


func _unpause_sub_triggers() -> void:
	for trigger: Trigger in _sub_triggers:
		trigger.resume()
