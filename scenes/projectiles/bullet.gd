extends Area2D

@export var speed : int = 1000

@onready var Notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
	
func _process(delta):
	position += MovementTools.calcMoveVector(Vector2.from_angle(rotation), speed, delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
