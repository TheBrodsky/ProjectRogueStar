extends Target
class_name AtReticle


var RETICLE_GROUP_NAME: String = "reticle"


func get_target(scene_tree: SceneTree) -> Vector2:
	var reticles: Array[Node] = scene_tree.get_nodes_in_group(RETICLE_GROUP_NAME)
	
	if reticles.size() == 0:
		Logger.log_error("Could not find Reticle in tree")
	
	if reticles.size() > 1:
		Logger.log_error("More than 1 Reticle exists in tree. Target ambiguous.")

	return (reticles[0] as Node2D).global_position
