extends Node2D

class_name Emitter


@export var emission_entity : PackedScene # WHAT the Emitter emits
@export var trigger : Trigger # WHEN the Emitter emits
@export var target : Target # WHERE the Emitter emits
@export var pattern : Pattern # HOW (in what shape) the Emitter emits
@export var pathing : PackedScene # Must be of type Pathing. (Optional) Controls how the emitted entity moves after emission


func _ready():
	trigger.triggered.connect(emit_cycle)


func emit_cycle():
	var center : Vector2 = target._get_target()
	var spawn_points : Array = pattern.get_pattern(center)
	for point in spawn_points:
		_emit(point)


func add_components(new_trigger, new_target, new_pattern, new_pathing):
	_add_trigger(new_trigger)
	_add_target(new_target)
	_add_pattern(new_pattern)
	pathing = new_pathing


func _emit(point : Vector2):
	var entity = emission_entity.instantiate()
	var parent_entity
	if pathing != null:
		parent_entity = pathing.instantiate()
		parent_entity.add_child(entity)
		parent_entity.pathed_entity = entity
	else:
		parent_entity = entity
	
	parent_entity.global_position = point
	get_tree().root.add_child(parent_entity)


func _add_trigger(new_trigger : Trigger):
	_replace_child(trigger, new_trigger)
	trigger = new_trigger
	trigger.triggered.connect(emit_cycle)


func _add_target(new_target : Target):
	_replace_child(target, new_target)
	target = new_target


func _add_pattern(new_pattern : Pattern):
	_replace_child(pattern, new_pattern)
	pattern = new_pattern


func _replace_child(old_child, new_child):
	if old_child != null:
		old_child.queue_free()
	add_child(new_child)


func _find_children():
	for node in get_children():
		if node is Trigger:
			_add_trigger(node)
		if node is Target:
			_add_target(node)
		if node is Pattern:
			_add_pattern(node)
