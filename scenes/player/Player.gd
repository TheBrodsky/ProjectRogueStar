extends CharacterBody2D

# Nodes and Scenes
@export var Reticle : Area2D
@export var Bullet : PackedScene

# Public Vars
@export var speed : int = 800
@export var attack_speed : int = 10 # How many times per second a bullet is fired
@export var dodge_decay : float = .96 # 0-1, How quickly dodge velocity decays
@export var dodge_speed_multiplier : float = 3.5 # How much dodging accelerates the player as a multiple of speed
@export var i_frame_velocity_cutoff : int = 400 # The velocity magnitude during dodge at which i_frames are disabled

# Private Vars
var time_between_attacks : float = 1.0/attack_speed
var time_since_last_attack : float = 0
var is_dodging : bool = false
var has_i_frames : bool = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		dodge()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_DEBUG_color_i_frames()
	do_movement(delta)
	fire_weapon(delta)

func do_movement(delta):
	if !is_dodging:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_direction * speed
	else:
		velocity *= dodge_decay
		if velocity.length() < i_frame_velocity_cutoff:
			has_i_frames = false
		if velocity.length() < 100:
			velocity = Vector2.ZERO
			is_dodging = false
	move_and_slide()

func dodge():
	is_dodging = true
	has_i_frames = true
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = speed * dodge_speed_multiplier * input_direction

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

func take_damage(damage):
	if !has_i_frames:
		pass

func _DEBUG_color_i_frames():
	if is_dodging:
		if velocity.length() > i_frame_velocity_cutoff:
			modulate = Color("green")
		else:
			modulate = Color("red")
	else:
		modulate = Color("white")
