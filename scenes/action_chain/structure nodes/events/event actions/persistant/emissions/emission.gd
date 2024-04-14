class_name Emission
extends IPersistant


## Acts as a persistant parent of entities created for an event, such as a projectile.


@export var entity: PackedScene # must be Effect

var num_emissions: int = 1


func setup() -> void:
	for num in num_emissions:
		add_entity(build_entity())


# Meant to be overriden by inheriting classes
func add_entity(new_entity: Effect) -> void:
	add_child(new_entity)
	new_entity.modify_from_action_state(state)


func build_entity() -> Effect:
	return entity.instantiate()


func _should_exist(delta: float) -> bool:
	return get_child_count() == 0
