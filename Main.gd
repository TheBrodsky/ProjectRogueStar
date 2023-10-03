extends Node2D

@onready var Player : Node2D = $Player
@onready var Respawn : Marker2D = $"Player Spawn Point"

func _ready():
	Respawn.position = get_viewport_rect().size/2
	respawn()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		respawn()

func respawn():
	Player.global_position = Respawn.global_position
	get_tree().call_group("projectile", "queue_free")
