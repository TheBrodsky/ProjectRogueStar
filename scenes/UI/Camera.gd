extends Camera2D

@export var Player : Node2D
@export var Reticle : Node2D

@export var player_position_influence = .75 # 0-1, how highly player position is weighted when calculated camera center
var reticle_position_influence = 1 - player_position_influence

func _process(delta):
	position = (Player.position*player_position_influence) + (Reticle.position*reticle_position_influence)
