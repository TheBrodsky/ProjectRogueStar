@tool
@icon("res://assets/editor_icons/modifier.png")
class_name QuantitativeModifier
extends Node


## A modifier changes the behavior of something in the action chain.
## Modifiers fall under several categories, but broadly there are two: Quantative and Qualitative.
## (See QualitativeModifier for more info on them)
## Quantitative modifiers just change numbers through the ActionState. 
##
## The ActionState acts as a contract between nodes and modifiers (see ActionState for more),
## which makes Quantitative modifiers very straightforward and predictable.


@export_group("Damage Stats")
@export var modifies_damage: bool = false:
	set(value):
		modifies_damage = value
		if modifies_damage:
			damage_stats = DamageState.get_state()
		else:
			damage_stats = null
@export var damage_stats: DamageState

@export_group("Entity Stats")
@export var modifies_entity: bool = false:
	set(value):
		modifies_entity = value
		if modifies_entity:
			entity_stats = EntityState.get_state()
		else:
			entity_stats = null
@export var entity_stats: EntityState

@export_group("Follower Stats")
@export var modifies_follower: bool = false:
	set(value):
		modifies_follower = value
		if modifies_follower:
			follower_stats = FollowerState.get_state()
		else:
			follower_stats = null
@export var follower_stats: FollowerState

@export_group("Status Stats")
@export var modifies_status: bool = false:
	set(value):
		modifies_status = value
		if modifies_status:
			status_stats = StatusState.get_state()
		else:
			status_stats = null
@export var status_stats: StatusState

@export_group("Trigger Stats")
@export var modifies_trigger: bool = false:
	set(value):
		modifies_trigger = value
		if modifies_trigger:
			trigger_stats = TriggerState.get_state()
		else:
			trigger_stats = null
@export var trigger_stats: TriggerState


func modify_state(state: ActionState) -> void:
	if modifies_damage: state.damage.merge(damage_stats)
	if modifies_entity: state.entity.merge(entity_stats)
	if modifies_follower: state.follower.merge(follower_stats)
	if modifies_status: state.status.merge(status_stats)
	if modifies_trigger: state.trigger.merge(trigger_stats)
