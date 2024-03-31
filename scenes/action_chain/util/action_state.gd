class_name ActionState
extends Node2D


## The master record of information about the current execution of the ActionChain
##
## ActionStates store information that may affect how other nodes behave.
## ActionStates are most commonly changed by Modifiers.
## A new ActionState is instantiated at the beginning of a chain. See ChainRoot for more info.
##
## The other purpose of an ActionState is to perform certain calculations for ActionNodes.
## This is because the ActionState has the information but not the entities,
## and the ActionNodes have the entities but not the information.
## Since calculation is an information operation, it happens here.


var chain_owner: Node # who initially kicked off the chain. Used for determining bullet/effect interactions, e.g. a Player shouldnt be able to hurt themselves
var source: Node2D # origin of all events, e.g. from a Player, from an Enemy
var accuracy: float  = 0 # angle of error from aiming line, in degrees
var speed_mult: float = 1 # speed multiplier to any entities that move


func calc_direction_from_points(from: Vector2, to: Vector2) -> float:
	return from.angle_to_point(to) + deg_to_rad(randf_range(-accuracy, accuracy))


func clone(flags: int = 15) -> ActionState:
	var new_action_state : ActionState = self.duplicate(flags)
	new_action_state._copy_from(self)
	return new_action_state


func _copy_from(other: ActionState) -> void:
	chain_owner = other.chain_owner
	source = other.source


func modify(entity: Node2D) -> void:
	_modify_projectile(entity)


func _modify_projectile(entity: Node2D) -> void:
	if entity.is_in_group("projectile"):
		entity.set("speed", entity.get("speed") * speed_mult)
