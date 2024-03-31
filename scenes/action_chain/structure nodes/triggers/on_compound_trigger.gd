extends Trigger


## Allows multiple triggers to be combined into a single trigger, creating more complex trigger logic.
##
## Works by connecting to the triggered signals of all sub_triggers.

@export var is_ordered: bool = false # whether the sub_triggers are ordered. An ordered sub_trigger will be ignored if the previous sub_trigger did not yet trigger

var _sub_triggers: Array[Trigger] = []
var _expected_triggers: int
var _current_triggers: int = 0
var _ready_to_trigger: bool = false
var _index_map: Dictionary = {} # maps sub_triggers to their index in the _sub_triggers list. Mainly used for when _is_ordered == true


func _ready() -> void:
	super._ready()
	_name = "CompoundTrigger"
	_next = get_next_action_node([ActionType.EVENT, ActionType.BRANCH])
	assert(_next != null)
	_find_sub_triggers()
	_connect_sub_triggers()


func resume() -> void:
	if _ready_to_trigger:
		_do_trigger()
	_resume_sub_triggers()
	_is_paused = false


func pause() -> void:
	_pause_sub_triggers()
	_is_paused = true


func _pause_sub_triggers() -> void:
	for trigger: Trigger in _sub_triggers:
		trigger.pause()


func _resume_sub_triggers() -> void:
	for trigger: Trigger in _sub_triggers:
		trigger.resume()


func _find_sub_triggers() -> void:
	for child: Node in get_children():
		if child is Trigger:
			var trigger: Trigger = child as Trigger
			trigger.is_one_shot = true
			_index_map[trigger] = _sub_triggers.size()
			_sub_triggers.append(trigger)


func _connect_sub_triggers() -> void:
	for trigger: Trigger in _sub_triggers:
		trigger.triggered.connect(_on_sub_trigger)
		_expected_triggers += 1


func _on_sub_trigger(origin: Trigger) -> void:
	if is_ordered:
		var trigger_index: int = _index_map[origin]
		if _current_triggers == trigger_index: # if this is the current trigger in the ordered list
			_current_triggers += 1
		else:
			origin.resume()
	else:
		_current_triggers += 1
	
	if _current_triggers >= _expected_triggers:
		# all sub-triggers have triggered
		if _is_paused:
			_ready_to_trigger = true
		else:
			_do_trigger()


func _do_trigger() -> void:
	super._do_trigger()
	_current_triggers = 0
	_unpause_sub_triggers()


func _unpause_sub_triggers() -> void:
	for trigger: Trigger in _sub_triggers:
		trigger.resume()
