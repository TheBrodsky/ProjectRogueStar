extends Node2D
## The actual emission device which creates entities and emits them.
## The Emitter itself is basically a manager that passes responsibility off to its subordinate components.
## What the components do to alter the emission is not up to the Emitter--the Emitter doesn't even know what the components are doing.
## Once the Emitter has handed off the emission object to all the components, it adds it to the scene tree and completes an emission cycle.

class_name Emitter


@export var emission_entity : PackedScene # WHAT the Emitter emits
@export var trigger : Trigger # WHEN the Emitter emits
@export var target : Target # WHERE the Emitter emits
@export var pattern : Pattern # HOW (in what shape) the Emitter emits
@export var pathing_manager : PathingManager # Controls how Pathing nodes get added to the emission and contains the Pathing blueprint
@export var next_emitter : EmitterFactory # Must be of type Emitter. (Optional) Emitter that will get attached to each emitted entity, chaining emissions.

@onready var emission_scene : PackedScene = preload("res://scenes/emitter/Emission.tscn")


func _ready():
	trigger.triggered.connect(emit_cycle)


func emit_cycle():
	var emission : Emission = _create_emission()
	target.modify_emission(emission)
	pattern.modify_emission(emission)
	_add_chained_emitters(emission)
	pathing_manager.modify_emission(emission)
	get_tree().root.add_child(emission)


func add_components(new_emission_entity : PackedScene, new_trigger : Trigger, new_target : Target, new_pattern : Pattern, new_path_manager : PathingManager, new_next_emitter : EmitterFactory):
	emission_entity = new_emission_entity
	_add_trigger(new_trigger)
	_add_target(new_target)
	_add_pattern(new_pattern)
	_add_path_manager(new_path_manager)
	_add_next_emitter(new_next_emitter)


func _create_emission():
	var emission : Emission = emission_scene.instantiate()
	emission.emission_entity = emission_entity
	return emission


func _add_chained_emitters(emission : Emission):
	if next_emitter != null:
		for child in emission.get_children():
			child.add_child(next_emitter.build_emitter())


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


func _add_path_manager(new_path_manager : PathingManager):
	_replace_child(pathing_manager, new_path_manager)
	pathing_manager = new_path_manager


func _add_next_emitter(new_next_emitter : EmitterFactory):
	_replace_child(next_emitter, new_next_emitter)
	next_emitter = new_next_emitter


func _replace_child(old_child, new_child):
	if old_child != null:
		old_child.queue_free()
	add_child(new_child)
