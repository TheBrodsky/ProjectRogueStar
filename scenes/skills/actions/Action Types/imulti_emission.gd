class_name IMultiActionable
extends Actionable


## MultiActionables are Actionables that create multiple entities or perform an action multiple times.

@export var num_emissions: int = 1


func _main_action(next_triggers: Array[Trigger]) -> void:
	for i in num_emissions:
		add_indexed_entity(_build_entity(), i)


## Overridable. Meant to be overriden by inheriting classes
func add_indexed_entity(new_entity: Node2D, index: int) -> void:
	add_entity(new_entity)
