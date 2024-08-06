@tool
extends Node
class_name SupportedTriggers


## The SupportedTriggers node acts as a single point of reference to determine
## whether an action supports a given trigger type.
## SupportedTriggers delegates much of its responsibility to individual trigger hooks.
##
## SupportedTriggers also have the concept of "deferrance," wherein a complex action
## might not directly support a trigger type but may do so indirectly because a child
## of the action *does* support that type. In these cases, the action can defer
## setting the trigger and pass it down to a child event.


const CYCLICAL = 2**0
const HIT = 2**1
const HIT_RECEIVED = 2**2
const KILL = 2**3
const DEATH = 2**4
const CREATION = 2**5
const EXPIRATION = 2**6
const PROC = 2**7

# coupled with trigger.gd
@export_flags("Cyclical", "Hit", "HitReceived", "Kill", "Death", "Creation", "Expiration", "Proc") var supported_types: int = 0

## Allows unsupported triggers to be deferred to a supporting child event
## BE CAREFUL: deferring the same trigger flag to multiple events may produce more triggers than intended.
@export_category("Deferrance") 
@export_flags("Cyclical", "Hit", "HitReceived", "Kill", "Death", "Creation", "Expiration", "Proc") var deferred_types: int = 0
@export var add_flags: bool = false: ## When clicked, saves the value of deferred_types to deferred_flags array
	set(value):
		deferred_flags.append(deferred_types)
@export var deferred_flags: Array[int] = [] ## DO NOT ADD TO THIS MANUALLY. See "Add Flags". Index MUST correspond to deferred array.
@export var deferred_events: Array[Event] = [] ## Events that triggers can be deferred to. Index MUST correspond to deferred_flags array.


func _ready() -> void:
	if not Engine.is_editor_hint():
		_verify_type_requirements()


func set_trigger(trigger: Trigger, state: ActionState) -> void:
	if trigger.trigger_type & supported_types:
		var cloned_trigger: Trigger = _set_trigger_helper(trigger, state)
		if cloned_trigger.trigger_type & CYCLICAL:
			pass
		if cloned_trigger.trigger_type & HIT:
			OnHitHook.set_trigger(get_parent(), cloned_trigger, state)
		if cloned_trigger.trigger_type & HIT_RECEIVED:
			pass
		if cloned_trigger.trigger_type & KILL:
			pass
		if cloned_trigger.trigger_type & DEATH:
			pass
		if cloned_trigger.trigger_type & CREATION:
			pass
		if cloned_trigger.trigger_type & EXPIRATION:
			OnExpireHook.set_trigger(get_parent(), cloned_trigger, state)
		if cloned_trigger.trigger_type & PROC:
			OnProcHook.set_trigger(get_parent(), cloned_trigger, state)
	else:
		set_trigger_on_deferred(trigger, state)


func set_trigger_on_deferred(trigger: Trigger, state: ActionState) -> void:
	for i in range(deferred_events.size()):
		var defer_event: Event = deferred_events[i]
		var flags: int = deferred_flags[i]
		if flags & trigger.trigger_type:
			var cloned_trigger: Trigger = trigger.clone()
			defer_event.add_child(cloned_trigger)
			defer_event.find_next_action_nodes([ActionNode.ActionType.TRIGGER]) # TODO: this smells. Events should probably have a method to add a trigger to them.


func _verify_type_requirements() -> void:
	if supported_types & CYCLICAL:
		pass
	if supported_types & HIT:
		assert(OnHitHook.is_compatible(get_parent()))
	if supported_types & HIT_RECEIVED:
		pass
	if supported_types & KILL:
		pass
	if supported_types & DEATH:
		pass
	if supported_types & CREATION:
		pass
	if supported_types & EXPIRATION:
		assert(OnExpireHook.is_compatible(get_parent()))
	if supported_types & PROC:
		assert(OnProcHook.is_compatible(get_parent()))


func _set_trigger_helper(trigger: Trigger, state: ActionState) -> Trigger:
	var cloned_trigger: Trigger = trigger.clone()
	add_child(cloned_trigger)
	return cloned_trigger
	
