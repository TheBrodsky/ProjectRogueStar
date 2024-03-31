class_name EventContainer
extends Node2D

## Acts as a parent of entities created for an event, such as a projectile.

var state: ActionState


func _process(delta: float) -> void:
	if get_child_count() == 0:
		queue_free()


func set_state(new_state: ActionState) -> void:
	if state != null:
		Logger.log_warn("Overriding ActionState in event container.")
	state = new_state


# TODO
func add_trigger(trigger: Trigger) -> void:
	for entity: Node in get_children():
		var trigger_copy: Trigger = trigger.clone()
		entity.add_child(trigger_copy)
		var state_copy: ActionState = state.clone()
		state_copy.source = entity
		trigger_copy._run(state_copy)
	

func add_entity(entity: Node2D) -> void:
	add_child(entity)


func sync_with_source() -> void:
	position = state.source.global_position
