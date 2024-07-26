extends QualitativeModifier
class_name ActionModifier


## ActionModifiers modify Actions.
## As a QualitativeModifier, ActionModifiers change the behavior of Actions in a way
## which is not strictly numerical. Since Actions are often persistent entities,
## ActionModifiers will "attach" to an instance of an Action and continually modify it.


@export var is_pre_attached: bool = false

var parent_entity: Node2D


func _ready() -> void:
	if is_pre_attached:
		parent_entity = get_parent()


func _process(delta: float) -> void:
	if parent_entity != null:
		_modify_parent(delta)


func _modify_parent(delta: float) -> void:
	push_error("UNIMPLEMENTED_ERROR: ActionModifier.modify_parent()")


func attach(action: Node2D, state: ActionState) -> void:
	if is_attachable(action):
		var cloned_modifier: ActionModifier = clone()
		cloned_modifier.parent_entity = action
		action.add_child(cloned_modifier)


## given an Action, does it make sense for this modifier to attach to it. e.g. an ActionModifier might only attach to projectile actions
func is_attachable(action: Node2D) -> bool:
	return true


func clone(flags: int = 15) -> ActionModifier:
	var new_modifier : ActionModifier = self.duplicate(flags)
	new_modifier._copy_from(self)
	return new_modifier


func _copy_from(other: ActionModifier) -> void:
	pass
