extends Node

class_name PathingManager


@export var pathing_scene : PackedScene


func _ready():
	if pathing_scene == null:
		var child = get_child(0)
		if child is Pathing:
			pathing_scene = NodePacker.packNode(child)
		else:
			Logger.log_warn("Pathing manager has no pathing child")


func modify_emission(emission : Emission):
	pass
