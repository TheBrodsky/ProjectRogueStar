extends Node
class_name ActionInterface
signal state_modified


## A common interface* for compatibility with the action chain. Any entity that can be
## created and modified by the action chain must contain this component.
##
## * this isn't technically an interface by typical code definition. In a better language, it would be.


@export_group(Globals.INSPECTOR_CATEGORY)
@export var base_stats: ActionStateStats = ActionStateStats.get_state()
@export var default_follower_packed: PackedScene = preload("res://SkillBuilding/Movement/Followers/StaticFollower.tscn")

var action_entity: Node2D = get_parent()
var signaler: ActionSignaler = ActionSignaler.new()
var follower: Follower # the follower at the top
var effect: Effect
var triggers: Array[Trigger] = []
var state: ActionState


## Checks if a node is an action based on whether it implements this interface
static func is_action(action: Node2D) -> bool:
	return "iaction" in action


## gets the iaction/ActionInterface property from an action entity.
static func get_action_interface(action: Node2D) -> ActionInterface:
	assert(is_action(action))
	@warning_ignore("unsafe_property_access")
	var interface: ActionInterface = action.iaction
	return interface


func pre_tree_initialize(state: ActionState, effect: Effect) -> void:
	action_entity = get_parent()
	self.effect = effect
	_initialize_state(state)


func post_tree_initialize(triggers: Array[Trigger]) -> void:
	self.triggers = triggers
	_set_triggers()
	follower.initialize(state)


func merge_stats(other_state: ActionState) -> void:
	state.merge(other_state.stats)
	state_modified.emit()


func do_effect(effect_body: Node2D) -> void:
	effect.do_effect(effect_body, state, triggers)


## Reparents entity under followers, returns follower at the top
func set_follower(follower_packed: PackedScene, state: ActionState, moveable_node: Node2D) -> Follower:
	# build the follower
	var new_follower: Follower = null
	if follower_packed != null:
		new_follower = follower_packed.instantiate()
	else:
		new_follower = default_follower_packed.instantiate()
	
	# initialize and connect
	new_follower.assemble_chain(state, moveable_node)
	moveable_node.tree_exited.connect(new_follower.queue_free)
	
	# cleanup
	if follower != null:
		follower.queue_free()
	follower = new_follower
	
	return follower


func set_collision(collision_body: CollisionObject2D) -> void:
	var collision_masks: Array[int] = state.get_effect_collision()
	collision_body.collision_layer |= collision_masks[0]
	collision_body.collision_mask |= collision_masks[1]


func _initialize_state(seed_state: ActionState) -> void:
	# update stats
	var merged_stats: ActionStateStats = base_stats.merge(seed_state.stats)
	state = ActionState.get_state(seed_state)
	state.stats = merged_stats
	
	# set action_entity as the new source for future parts of the action chain
	state.source = action_entity
	
	# signal completion
	state_modified.emit()


func _set_triggers() -> void:
	for trigger: Trigger in triggers:
		trigger.engage(action_entity)
