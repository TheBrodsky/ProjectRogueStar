class_name Emission
extends IPersistant


## Acts as a persistant parent of entities created for an event, such as a projectile.


@export var entity: PackedScene # must be Effect
@export var num_emissions: int = 1


func setup() -> void:
	for i in num_emissions:
		add_entity(build_entity(), i)


# Meant to be overriden by inheriting classes
func add_entity(new_entity: Effect, index: int) -> void:
	add_child(new_entity)
	new_entity.modify_from_action_state(state)


func build_entity() -> Effect:
	return entity.instantiate()
