extends Node
## An EmitterFactory contains a blueprint for an Emitter and uses it to manufacture Emitter instances according to that blueprint.
## Using a factory pattern fits with what the player is doing: designing a blueprint for a weapon, which consists of potentially many custom emitters.
## The factory pattern also allows us to chain emitters more easily: an EmitterFactory simply passes the next factory into the Emitters it manufactures.
## Those Emitters in turn will use the EmitterFactory to create an Emitter instance on each of the emissions, which will themselves use their EmitterFactories...

class_name EmitterFactory


@export var emitted_entity : PackedScene
@export var trigger_scene : PackedScene # Must be of type Trigger
@export var target_scene : PackedScene # Must be of type Target
@export var pattern_scene : PackedScene # Must be of type Pattern
@export var pathing_manager : PackedScene # Must be of type Pathing

var next_factory : EmitterFactory


func _ready():
	#_next_factory = _get_next_factory()	
	pass


func build_emitter() -> Emitter:
	var emitter : Emitter = Emitter.new()
	emitter.add_components(emitted_entity, trigger_scene.instantiate(), target_scene.instantiate(), pattern_scene.instantiate(), pathing_manager.instantiate(), next_factory)
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
	

func _get_next_factory():
	var factory = null
	for child in get_children():
		if child is EmitterFactory:
			factory = child
			break
	return factory
