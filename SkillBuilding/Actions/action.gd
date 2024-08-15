extends Node2D
class_name Action


#region action type properties
@export_group(Globals.INSPECTOR_CATEGORY)
@export var trigger_hook: SupportedTriggers
@export var base_stats: ActionStateStats
@export var default_follower_packed: PackedScene = preload("res://SkillBuilding/BehaviorComponents/Targets and Followers/Followers/StaticFollower.tscn")

var effect: Effect
var state: ActionState
var follower: Follower # the follower at the top
#endregion


#region action type methods
func pre_tree_initialize(state: ActionState, effect: Effect) -> void:
	self.state = state
	self.effect = effect.duplicate()
	
	_modify_action_state()
	_modify_from_action_state()


func post_tree_initialize(triggers: Array[Trigger]) -> void:
	follower.initialize(state)
	_set_triggers(triggers)


## Reparents action under followers, returns follower at the top
func set_follower(follower_packed: PackedScene) -> Follower:
	# build the follower
	var new_follower: Follower = null
	if follower_packed != null:
		new_follower = follower_packed.instantiate()
	else:
		new_follower = default_follower_packed.instantiate()
	
	# initialize and connect
	new_follower.assemble_chain(state, self)
	tree_exited.connect(new_follower.queue_free)
	
	# cleanup
	if follower != null:
		follower.queue_free()
	follower = new_follower
	
	return follower


func _do_effect(body: Node2D) -> void:
	effect.modify_from_action_state(state)
	effect.do_effect(body, state)


func _modify_from_action_state() -> void:
	pass


func _set_triggers(triggers: Array[Trigger]) -> void:
	for trigger: Trigger in triggers:
		trigger_hook.set_trigger(trigger)


## Modifies action state IN PLACE
func _modify_action_state() -> void:
	state.merge(base_stats)
#endregion
