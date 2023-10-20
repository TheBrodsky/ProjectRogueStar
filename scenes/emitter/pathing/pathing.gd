extends Node2D


# Pathing nodes work a bit differently from the other Emitter components.
# Pathing nodes act as "managers" of the emitted entity, staying alive as long as the entity does.
# While alive, the Pathing node controls how the entity moves each processing tick.
class_name Pathing


@export var speed : int = 1000

var pathed_entity : Node2D
