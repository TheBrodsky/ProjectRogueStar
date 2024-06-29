class_name Enemy
extends CharacterBody2D


@onready var health_bar: HealthBar = $HealthBar


func _process(delta: float) -> void:
	_do_movement(delta)
	_do_attack(delta)


func take_damage(damage: float) -> void:
	health_bar.reduce(damage)


func die() -> void:
	queue_free()


func _do_movement(delta: float) -> void:
	pass


func _do_attack(delta: float) -> void:
	pass


func _on_health_bar_no_health() -> void:
	die()
