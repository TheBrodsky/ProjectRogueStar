extends CharacterBody2D

# Nodes and Scenes
@export var Reticle : Area2D
@export var Bullet : PackedScene

# Public Vars
@export var speed : int = 800
@export var attack_speed : int = 10 # How many times per second a bullet is fired

# Private Vars
var time_between_attacks : float = 1.0/attack_speed
var time_since_last_attack : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement(delta)
	fire_weapon(delta)

func do_movement(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

func fire_weapon(delta):
	if time_since_last_attack <= 0:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
