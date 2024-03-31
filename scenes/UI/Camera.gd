extends Camera2D


@export var Player : Node2D
@export var Reticle : Node2D

const PLAYER_POSITION_INFLUENCE: float = .75 # 0-1, how highly player position is weighted when calculated camera center
const RETICLE_POSITION_INFLUENCE: float = 1 - PLAYER_POSITION_INFLUENCE


func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		pass
	else:
		position = (Player.position*PLAYER_POSITION_INFLUENCE) + (Reticle.position*RETICLE_POSITION_INFLUENCE) # centered between player and reticle
