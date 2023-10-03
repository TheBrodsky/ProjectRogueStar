extends Area2D

# Nodes and Scenes
@export var Reticle : Area2D
@export var Bullet : PackedScene

# Public Vars
@export var speed : int = 1500
@export var attack_speed : int = 10 # How many times per second a bullet is fired

# Private Vars
var time_between_attacks : float = 1.0/attack_speed
var time_since_last_attack : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_weapon(delta)

func fire_weapon(delta):
	if time_since_last_attack <= 0:
		time_since_last_attack += time_between_attacks
		create_bullet()
	else:
		time_since_last_attack -= delta

func create_bullet():
	var new_bullet = Bullet.instantiate()
	owner.add_child(new_bullet)
	new_bullet.position = position
	new_bullet.rotation = angle_to_reticle()

func angle_to_reticle():
	return position.angle_to_point(Reticle.position)
