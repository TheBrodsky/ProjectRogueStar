class_name Emission
extends IPersistant


## Acts as a persistant parent of entities created for an event, such as a projectile.

@export var projectile: PackedScene # must be of type Projectile
@export var num_emissions: int = 1


func setup_persistent_entities() -> void:
	for i in num_emissions:
		add_entity(build_projectile(), i)


## Meant to be overriden by inheriting classes
func add_entity(new_entity: Projectile, index: int) -> void:
	add_child(new_entity)
	new_entity.modify_from_action_state(state)


func build_projectile() -> Projectile:
	return projectile.instantiate()
