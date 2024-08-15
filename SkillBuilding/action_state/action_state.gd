class_name ActionState
extends Node


## The master record of information about the current execution of the ActionChain
## An ActionState is a contract between nodes and modifiers that establishes what kinds of information
## can be modified, but not necessarily how it's used. A Modifier only knows that information exists to modify,
## a node (ActionNode, Action, Container, etc) knows how to use that information to modify itself.
##
## ActionStates store information that may affect how other nodes behave.
## ActionStates are most commonly changed by Modifiers.
## A blank ActionState is instantiated at the beginning of a chain. See ChainRoot for more info.


static func get_state(other: ActionState = null) -> ActionState:
	var state: ActionState = ActionState.new()
	state.stats.populate_substats()
	if other != null:
		state.owner_type = other.owner_type
		state.source = other.source
	return state



@export_group(Globals.PRIVATE_CATEGORY)
enum OwnerType {PLAYER, ENEMY}
@export var owner_type: OwnerType # who initially kicked off the chain. Used for determining collision, e.g. a Player shouldnt be able to hurt themselves
@export var source: Node2D: # origin of an event, e.g. from a Player, from an Enemy
	set(value):
		if value is Node2D:
			source = value
		else:
			Logger.log_debug("Attempted to assign non-2D source to action state")

@export var stats: ActionStateStats = ActionStateStats.get_state()


#region state manipulation
## Merges an ActionStateStats object into this state
func merge(other_stats: ActionStateStats) -> ActionState:
	if other_stats != null:
		stats.merge(other_stats)
	return self


func scale(scalar: float) -> ActionState:
	stats.scale(scalar)
	return self


## Returns a clone of this state with identical properties but different references
func clone() -> ActionState:
	var cloned_state: ActionState = self.duplicate()
	cloned_state.stats = stats.duplicate(true)
	return cloned_state
#endregion


#region getters and setters
## Checks node groups to determine whether the owner of this chain is a player or enemy
func set_owner_type_from_node(owner: Node2D) -> void:
	if owner.is_in_group("Enemy"):
		owner_type = OwnerType.ENEMY
	else:
		owner_type = OwnerType.PLAYER


## Returns the collision layer and mask for action entities according to ownership of this chain
func get_effect_collision() -> Array[int]:
	match owner_type:
		OwnerType.PLAYER:
			return [Globals.player_effect_collision_layer, Globals.player_effect_collision_mask]
		OwnerType.ENEMY:
			return [Globals.enemy_effect_collision_layer, Globals.enemy_effect_collision_mask]
		_:
			return []
#endregion
