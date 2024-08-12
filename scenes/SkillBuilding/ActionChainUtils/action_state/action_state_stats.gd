@tool
extends Resource
class_name ActionStateStats


static func get_state() -> ActionStateStats:
	var state: ActionStateStats = ActionStateStats.new()
	state.resource_local_to_scene = true
	return state


@export_group("Damage Stats")
@export var modifies_damage: bool = false:
	set(value):
		modifies_damage = value
		if modifies_damage:
			damage = DamageState.get_state()
		else:
			damage = null
@export var damage: DamageState

@export_group("Entity Stats")
@export var modifies_entity: bool = false:
	set(value):
		modifies_entity = value
		if modifies_entity:
			entity = EntityState.get_state()
		else:
			entity = null
@export var entity: EntityState

@export_group("Follower Stats")
@export var modifies_follower: bool = false:
	set(value):
		modifies_follower = value
		if modifies_follower:
			follower = FollowerState.get_state()
		else:
			follower = null
@export var follower: FollowerState

@export_group("Status Stats")
@export var modifies_status: bool = false:
	set(value):
		modifies_status = value
		if modifies_status:
			status = StatusState.get_state()
		else:
			status = null
@export var status: StatusState

@export_group("Trigger Stats")
@export var modifies_trigger: bool = false:
	set(value):
		modifies_trigger = value
		if modifies_trigger:
			trigger = TriggerState.get_state()
		else:
			trigger = null
@export var trigger: TriggerState


func populate_substats() -> void:
	modifies_damage = true
	modifies_entity = true
	modifies_follower = true
	modifies_status = true
	modifies_trigger = true


func merge(other: ActionStateStats) -> ActionStateStats:
	if other.modifies_damage: damage.merge(other.damage)
	if other.modifies_entity: entity.merge(other.entity)
	if other.modifies_follower: follower.merge(other.follower)
	if other.modifies_status: status.merge(other.status)
	if other.modifies_trigger: trigger.merge(other.trigger)
	return self


func scale(scalar: float) -> ActionStateStats:
	if modifies_damage: damage.scale(scalar)
	if modifies_entity: entity.scale(scalar)
	if modifies_follower: follower.scale(scalar)
	if modifies_status: status.scale(scalar)
	if modifies_trigger: trigger.scale(scalar)
	return self
