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


func reset() -> ActionState:
	var blank_state: ActionState = ActionState.new()
	blank_state.chain_owner = chain_owner
	blank_state.source = source
	return blank_state


@export var chain_owner: Node # who initially kicked off the chain. Used for determining bullet/effect interactions, e.g. a Player shouldnt be able to hurt themselves
@export var source: Node2D # origin of an event, e.g. from a Player, from an Enemy
@export var target: Target # determines where events/actions are aimed.

@export var aim_deviation_base: float = 0 # angle of error from aiming line, in degrees
@export var aim_deviation_mult: float = 1 # aim deviation multiplier
func get_aim_deviation() -> float: return aim_deviation_base * aim_deviation_mult

@export var group_deviation_base: float = 0 # specifically for the share aim angle firecone (for now)
@export var group_deviation_mult: float = 1 # group deviation multiplier
func get_group_deviation() -> float: return group_deviation_base * group_deviation_mult

@export var speed_base: float = 0 # additive base speed value to any entities that move
@export var speed_mult: float = 1 # speed multiplier to any entities that move
func get_speed() -> float: return speed_base * speed_mult

@export var damage_base: float = 0 # additive base damage value (add additive damage increases to this one)
@export var damage_multi: float = 1 # damage multiplier (multiply other multipliers to this one)
func get_damage() -> float: return damage_base * damage_multi

@export var aoe_radius_base: float = 0 # AOE radius addend
@export var aoe_radius_multi: float = 1 # AOE radius multiplier 
func get_aoe_radius() -> float: return aoe_radius_base * aoe_radius_multi

@export var homing_rate_base: float = 0
@export var homing_rate_multi: float = 1
func get_homing_rate() -> float: return homing_rate_base * homing_rate_multi
