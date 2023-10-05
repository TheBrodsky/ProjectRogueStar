extends Enemy

@export var max_health : int = 5
var cur_health : int = max_health

func take_damage(damage):
	cur_health -= damage
	if cur_health <= 0:
		die()
