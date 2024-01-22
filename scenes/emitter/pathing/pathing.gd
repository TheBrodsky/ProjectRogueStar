extends Node2D


# Pathing nodes work a bit differently from the other Emitter components.
# Pathing nodes act as "managers" of the emitted entity, staying alive as long as the entity does.
# While alive, the Pathing node controls how the entity moves each processing tick.
class_name Pathing


@export var speed : int = 1000

var pathed_entity : Node2D


func _ready():
	var parent = get_parent()
	if parent is Node2D:
		pathed_entity = parent
	
	if pathed_entity != null:
		_ready_override()


func _process(delta):
	if pathed_entity != null:
		_process_override(delta)


# Inner-body of _ready(). Allows this parent class to add guardrails on _ready() that child classes shouldnt override
func _ready_override():
	pass


# Inner-body of _process(). Allows this parent class to add guardrails on _process() that child classes shouldnt override
func _process_override(delta):
	pass
