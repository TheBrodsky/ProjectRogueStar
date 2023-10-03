extends Node2D

@onready var Player : Area2D = $Player
@onready var Reticle : Area2D = $Reticle

var player_jump_to_mouse_threshold : int = 5 # How close a Player can be to the mouse before Player and mouse movement is synced. Creates smoother movement close to mouse.
var max_reticle_distance_from_player = 50 # How long the "leash" is between the Player and Reticle

func _process(delta):
	var player_vector = do_player_movement(delta)
	do_reticle_movement(delta, player_vector)

func do_player_movement(delta):
	var previous_position = Player.position
	var to_mouse = get_global_mouse_position() - Player.position
	var distance_from_mouse = to_mouse.length()
	
	if distance_from_mouse > player_jump_to_mouse_threshold:
		Player.position += MovementTools.calcMoveVector(to_mouse, Player.speed, delta)
		Player.position = MovementTools.clampPosition(Player.position, get_viewport_rect().size)
	else:
		Player.position = get_global_mouse_position()
		
	return Player.position - previous_position

func do_reticle_movement(delta, player_vector):
	var vectorToPlayer : Vector2 = Player.position - Reticle.position
	var distance_to_player = vectorToPlayer.length()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Locked movement (handled by Player)
		Reticle.position += player_vector
	else:
		# Free movement
		if distance_to_player > max_reticle_distance_from_player:
			var move_limiter_factor = max_reticle_distance_from_player/distance_to_player # what fraction of the length between reticle and player is within the max distance
			Reticle.position += vectorToPlayer.normalized() * distance_to_player * (1-move_limiter_factor)
