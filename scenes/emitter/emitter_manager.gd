extends Node


@export var emitter_scene : PackedScene = preload("res://scenes/emitter/Emitter.tscn")

@export var trigger_scene : PackedScene # Must be of type Trigger
@export var target_scene : PackedScene # Must be of type Target
@export var pattern_scene : PackedScene # Must be of type Pattern
@export var pathing_scene : PackedScene # Must be of type Pathing


func build_emitter() -> Emitter:
	var emitter : Emitter = emitter_scene.instantiate()
	emitter.add_components(trigger_scene.instantiate(), target_scene.instantiate(), pattern_scene.instantiate(), pathing_scene)
	return emitter


func build_emitter_scene() -> PackedScene:
	var emitter = build_emitter()
	var scene : PackedScene = PackedScene.new()
	var result = scene.pack(emitter)
	
	if result == OK:
		Logger.log_debug("Constructed packed Emitter scene")
	else:
		push_error("Failed to construct packed Emitter scene")
		
	return scene
	
