class_name Enemy
extends CharacterBody2D
signal died(spawner_ID: int)


@export var max_health: int = 5

var cur_health: float = max_health
var spawner_parent_ID: int


func _process(delta: float) -> void:
	_do_movement(delta)
	_do_attack(delta)


func take_damage(damage: float) -> void:
	cur_health -= damage
	if cur_health <= 0:
		die()


func die() -> void:
	if spawner_parent_ID != null:
		died.emit(spawner_parent_ID)
	queue_free()


func _do_movement(delta: float) -> void:
	pass


func _do_attack(delta: float) -> void:
	pass
