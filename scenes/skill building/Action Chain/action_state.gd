class_name ActionState
extends Node


## The master record of information about the current execution of the ActionChain
##
## ActionStates store information that may affect how other nodes behave.
## ActionStates are most commonly changed by Modifiers.
## A blank ActionState is instantiated at the beginning of a chain. See ChainRoot for more info.
##
## The other purpose of an ActionState is to perform certain calculations for ActionNodes.
## This is because the ActionState has the information but not the entities,
## and the ActionNodes have the entities but not the information.
## Since calculation is an information operation, it happens here.


@export var chain_owner: Node # who initially kicked off the chain. Used for determining bullet/effect interactions, e.g. a Player shouldnt be able to hurt themselves
@export var source: Node2D # origin of an event, e.g. from a Player, from an Enemy
@export var target: Vector2 # position of target, if there is one. Most of the time this is mouse position.
@export var aim_deviation_base: float = 0 # angle of error from aiming line, in degrees
@export var aim_deviation_mult: float = 1 # aim deviation multiplier 
@export var group_deviation_base: float = 0 # specifically for the share aim angle firecone (for now)
@export var group_deviation_mult: float = 1 # group deviation multiplier
@export var speed_mult: float = 1 # speed multiplier to any entities that move
@export var speed_base: float = 1 # additive base speed value to any entities that move
@export var damage_base: float = 1 # additive base damage value (add additive damage increases to this one)
@export var damage_multi: float = 1 # damage multiplier (multiply other multipliers to this one)
@export var aoe_radius_base: float = 1 # AOE radius addend
@export var aoe_radius_multi: float = 1 # AOE radius multiplier 

# Attachers are a type of modifier that gets instantiated and attached to an entity as a child node to continuously apply some behavior modification
var attachers: Array[Attacher] = []


func calc_aim_to_target(from: Vector2) -> float:
	var accuracy: float = aim_deviation_base * aim_deviation_mult
	return from.angle_to_point(target) + deg_to_rad(randf_range(-accuracy, accuracy))
