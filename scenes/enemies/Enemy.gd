extends CharacterBody2D

class_name Enemy

signal died(spawner_ID : int)

@export var max_health : int = 5

var cur_health : int = max_health
var spawner_parent_ID


func _process(delta):
	_do_movement(delta)
	_do_attack(delta)


func take_damage(damage):
	cur_health -= damage
	if cur_health <= 0:
		die()


func die():
	if spawner_parent_ID != null:
		died.emit(spawner_parent_ID)
	queue_free()


func _do_movement(delta):
	pass


func _do_attack(delta):
	pass
