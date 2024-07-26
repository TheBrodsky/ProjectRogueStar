extends Node
class_name TriggerHook


## TriggerHooks are nodes that can be attached to an entity which allow triggers
## to "hook" onto that entity. For example, a projectile would have trigger hooks
## for allowing hit triggers, expiration triggers, etc to hook onto it.
##
## Each TriggerHook corresponds to a specific TriggerType.
## In this way, TriggerHooks also effectively "tag" an entity as well.


@export var trigger_type: Trigger.TriggerType # what type of trigger this 


func _ready() -> void:
	assert(get_parent() is Node2D) # Due to ActionState needing a Node2D "source", a trigger hook can only be on a Node2D


func perform_additional_setup(trigger: Trigger, state: ActionState) -> void:
	pass


func set_trigger(trigger: Trigger, state: ActionState) -> void:
	if trigger.trigger_type == trigger_type:
		var new_trigger: Trigger = trigger.clone()
		var new_state: ActionState = state.duplicate()
		new_state.source = get_parent()
		
		add_child(new_trigger)
		new_trigger._run(new_state)
		perform_additional_setup(new_trigger, new_state)
