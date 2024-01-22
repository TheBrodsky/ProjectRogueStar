extends Node2D
## A very simple class which represents the product of a single Emitter emission cycle.
## Emission entities (e.g. bullets) are instantiated and added as children to the Emission object.
## The purpose of this class is to allow Emitter components to have greater flexibility in how they change the emission,
## rather than relying on the Emitter to have low-level control over an emission cycle.
class_name Emission


var emission_entity : PackedScene


func emit():
	var entity = emission_entity.instantiate()
	add_child(entity)
	return entity
