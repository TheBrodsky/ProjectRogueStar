extends Node
class_name SupportedTriggers


## The SupportedTriggers node acts as a single point of reference to determine
## whether an action supports a given trigger type.
## SupportedTriggers defers much of its responsibility to individual trigger hooks. 


const CYCLICAL = 2**0
const HIT = 2**1
const HIT_RECEIVED = 2**2
const KILL = 2**3
const DEATH = 2**4
const CREATION = 2**5
const EXPIRATION = 2**6

# coupled with trigger.gd and trigger_hook.gd
@export_flags("Cyclical", "Hit", "HitReceived", "Kill", "Death", "Creation", "Expiration") var supported_types: int = 0


func _ready() -> void:
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
			pass


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
		pass


func _set_trigger_helper(trigger: Trigger, state: ActionState) -> Trigger:
	var cloned_trigger: Trigger = trigger.clone()
	var cloned_state: ActionState = state.duplicate()
	
	state.source = get_parent()
	add_child(cloned_trigger)
	cloned_trigger._run(cloned_state)
	return cloned_trigger
	
