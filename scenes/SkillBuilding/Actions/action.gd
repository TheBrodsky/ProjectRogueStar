extends Node2D
class_name Action


#region action type properties
@export var trigger_hook: SupportedTriggers
@export var default_follower_packed: PackedScene = preload("res://scenes/BehaviorComponents/Targets and Followers/Followers/StaticFollower.tscn")

var effect: Effect
var state: ActionState
var follower: Follower # the follower at the top
#endregion


#region action type methods
func initialize(state: ActionState, effect: Effect, triggers: Array[Trigger]) -> void:
	self.state = state
	self.effect = effect.duplicate()
	
	_modify_action_state(self.state)
	_modify_from_action_state(self.state)
	_set_triggers(triggers)


## Reparents action under followers, returns follower at the top
func set_follower(follower_packed: PackedScene) -> Follower:
	var new_follower: Follower = null
	if follower_packed != null:
		new_follower = follower_packed.instantiate()
	else:
		new_follower = default_follower_packed.instantiate()
	tree_exited.connect(new_follower.queue_free)
	new_follower.modify_from_state(state)
	
	# add action to follower as child
	if get_parent() != null:
		reparent(new_follower)
	else:
		new_follower.add_child(self)
	
	if follower != null:
		follower.queue_free()
	
	follower = new_follower
	return follower


func do_effect(body: Node2D) -> void:
	effect.modify_from_action_state(state)
	effect.do_effect(body, state)


func _modify_from_action_state(state: ActionState) -> void:
	pass


func _set_triggers(triggers: Array[Trigger]) -> void:
	for trigger: Trigger in triggers:
		trigger_hook.set_trigger(trigger, state)


func _modify_action_state(state: ActionState) -> void:
	pass
#endregion
