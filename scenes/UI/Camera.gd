extends Camera2D


@export var Player : Node2D
@export var Reticle : Node2D

const PLAYER_POSITION_INFLUENCE = .75 # 0-1, how highly player position is weighted when calculated camera center
const RETICLE_POSITION_INFLUENCE = 1 - PLAYER_POSITION_INFLUENCE


func _process(delta):
	position = (Player.position*PLAYER_POSITION_INFLUENCE) + (Reticle.position*RETICLE_POSITION_INFLUENCE)
