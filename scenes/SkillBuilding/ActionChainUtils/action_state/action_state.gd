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


enum OwnerType {PLAYER, ENEMY}
@export var owner_type: OwnerType # who initially kicked off the chain. Used for determining collision, e.g. a Player shouldnt be able to hurt themselves
@export var source: Node2D: # origin of an event, e.g. from a Player, from an Enemy
	set(value):
		if value is Node2D:
			source = value
		else:
			Logger.log_debug("Attempted to assign non-2D source to action state")

@export var trigger: TriggerState = TriggerState.get_state()
@export var status: StatusState = StatusState.get_state()
@export var follower: FollowerState = FollowerState.get_state()
@export var entity: EntityState = EntityState.get_state()
@export var damage: DamageState = DamageState.get_state()


func reset() -> ActionState:
	var blank_state: ActionState = ActionState.new()
	blank_state.owner_type = owner_type
	blank_state.source = source
	return blank_state


func clone() -> ActionState:
	var cloned_state: ActionState = self.duplicate()
	cloned_state.trigger = trigger.duplicate()
	cloned_state.status = status.duplicate()
	cloned_state.follower = follower.duplicate()
	cloned_state.entity = entity.duplicate()
	cloned_state.damage = damage.duplicate()
	return cloned_state


## Checks node groups to determine whether the owner of this chain is a player or enemy
func set_owner_type_from_node(owner: Node2D) -> void:
	if owner.is_in_group("Enemy"):
		owner_type = OwnerType.ENEMY
	else:
		owner_type = OwnerType.PLAYER


func get_effect_collision() -> Array[int]:
	match owner_type:
		OwnerType.PLAYER:
			return [Globals.player_effect_collision_layer, Globals.player_effect_collision_mask]
		OwnerType.ENEMY:
			return [Globals.enemy_effect_collision_layer, Globals.enemy_effect_collision_mask]
		_:
			return []

