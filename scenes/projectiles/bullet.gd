extends Area2D

@export var speed : int = 1000
@export var damage : int = 1

@onready var Notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
	
func _process(delta):
	position += MovementTools.calcMoveVector(Vector2.from_angle(rotation), speed, delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		var enemy : Enemy = body
		enemy.deal_damage(damage)
	queue_free()
