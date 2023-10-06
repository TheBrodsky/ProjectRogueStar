extends CharacterBody2D

class_name Enemy


@export var max_health : int = 5

var cur_health : int = max_health


func _process(delta):
	_do_movement(delta)
	_do_attack(delta)


func take_damage(damage):
	cur_health -= damage
	if cur_health <= 0:
		die()


func die():
	queue_free()


func _do_movement(delta):
	pass


func _do_attack(delta):
	pass
