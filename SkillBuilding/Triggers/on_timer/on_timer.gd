extends Trigger
class_name OnTimer


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var activations_per_second: float = 10:
	set(value):
		activations_per_second = value
		_wait_time = 1 / value

var _wait_time: float
var _root_timer: StatefulTimer
var _stateful_timer_packed: PackedScene = preload("res://SkillBuilding/Triggers/on_timer/StatefulTimer.tscn")


static func is_compatible(connecting_node: Node) -> bool:
	return true


## Only works as root
func pause() -> void:
	_root_timer.paused = true


## Only works as root
func resume() -> void:
	_root_timer.paused = false


func on_timeout(state: ActionState) -> void:
	do_trigger(_build_state_for_trigger(state))


func _engage_as_root(state: ActionState) -> void:
	_root_timer = _build_timer(state)
	add_child(_root_timer)
	_root_timer.start()


func _engage_as_link(connecting_node: Node) -> void:
	@warning_ignore("unsafe_property_access")
	var state: ActionState = connecting_node.state if "state" in connecting_node else ActionState.get_state()
	var timer: StatefulTimer = _build_timer(state)
	connecting_node.add_child(timer)
	timer.start()


func _build_timer(state: ActionState) -> StatefulTimer:
	var timer: StatefulTimer = _stateful_timer_packed.instantiate()
	timer.wait_time = _wait_time
	timer.state = state
	timer.stateful_timeout.connect(on_timeout)
	return timer
