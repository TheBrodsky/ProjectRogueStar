extends CharacterBody2D

class_name Enemy

func take_damage(damage):
	pass

func add_effect(effect):
	pass

func die():
	queue_free()
