extends Node2D

@onready var Player : Node2D = $Player
@onready var Respawn : Marker2D = $PlayerSpawnPoint

func _ready():
	respawn()

func _input(event):
	if event.is_action_pressed("ui_filedialog_refresh"):
		respawn()

func respawn():
	Player.global_position = Respawn.global_position
	get_tree().call_group("projectile", "queue_free")
