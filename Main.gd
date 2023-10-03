extends Node2D

@onready var FullPlayer : Node2D = $FullPlayer
@onready var Player : Node2D = $FullPlayer/Player
@onready var Respawn : Marker2D = $"Player Respawn"

func _ready():
	respawn()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		respawn()

func respawn():
	Player.global_position = Respawn.global_position
	FullPlayer.toggle_state(false)
	get_tree().call_group("projectile", "queue_free")
