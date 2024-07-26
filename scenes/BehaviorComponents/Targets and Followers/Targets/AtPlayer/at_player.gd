extends Target
class_name AtPlayer


var PLAYER_GROUP_NAME: String = "player"


func get_target(scene_tree: SceneTree) -> Vector2:
	var players: Array[Node] = scene_tree.get_nodes_in_group(PLAYER_GROUP_NAME)
	
	if players.size() == 0:
		Logger.log_error("Could not find Player in tree")
	
	if players.size() > 1:
		Logger.log_error("More than 1 Player exists in tree. Target ambiguous.")
	
	return (players[0] as CharacterBody2D).global_position
