extends Node
## An EmitterPacker is what "packs up" a hierarchy of Emitter components (Triggers, Targets, Patterns, and Pathings) and their modifiers.
## The hierarchy is packed up into a handful of packed scenes corresponding to each component type.
## These packed scenes are further packaged into an EmitterFactory.
## This is how a series of component and modifiers ordered by the player gets turned into a usable EmitterFactory and, in turn, an Emitter.

class_name EmitterPacker


# Because of the way EmitterPackers require things to be instanced in a hierarchy before blueprinting the Emitter,
# there's a lot of junk left over after packing. To solve this, the packer destroys itself and all its children
var _self_destruct = false


func _process(delta):
	if _self_destruct:
		queue_free()


func pack_emitter() -> EmitterFactory:
	_self_destruct = true
	var factory = EmitterFactory.new()
	var scene
	for child in get_children():
		scene = _pack_hierarchy(child)
		if child is Trigger:
			factory.trigger_scene = scene
		elif child is Target:
			factory.target_scene = scene
		elif child is Pattern:
			factory.pattern_scene = scene
		elif child is PathingManager:
			factory.pathing_manager = scene
		elif child is Area2D:
			factory.emitted_entity = scene
		elif child is EmitterPacker:
			var nested_factory = child.pack_emitter()
			factory.next_factory = nested_factory
	
	return factory


# Sets ownership of all nodes in the hierarchy to the top_node. Only nodes which are owned by top_node will be packed.
func _pack_hierarchy(top_node : Node) -> PackedScene:
	_set_hierarchy_owner(top_node, top_node)
	return NodePacker.packNode(top_node)

func _set_hierarchy_owner(parent : Node, hierarchy_owner : Node):
	if parent != hierarchy_owner:
		parent.owner = hierarchy_owner
	
	for child in parent.get_children():
		_set_hierarchy_owner(child, hierarchy_owner)
