extends CharacterBody2D


enum {IDLE, RUN, DODGE, DODGE_RECOVER}

const SPEED : int = 800
const DODGE_DISTANCE : int = 300
const ATTACK_SPEED : int = 10 # How many times per second a bullet is fired

@export var Reticle : Area2D
@export var Bullet : PackedScene

var state : int = IDLE

var _time_between_attacks : float = 1.0/ATTACK_SPEED
var _time_since_last_attack : float = 0
var _dodge_direction : Vector2

@onready var DodgeTimer : Timer = $DodgeTimer
@onready var _dodge_speed : float = DODGE_DISTANCE / DodgeTimer.wait_time

# VIRTUAL METHODS
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_state_change_dodge()


func _process(delta):
	_DEBUG_color_i_frames()
	_do_movement(delta)
	_fire_weapon(delta)

func _on_dodge_timer_timeout():
	state = IDLE
	velocity = Vector2.ZERO

# PUBLIC METHODS
func take_damage(damage):
	if state == DODGE:
		pass


# STATES
func _state_change_dodge():
	_dodge_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if _dodge_direction != Vector2.ZERO: # Cannot dodge with no direction input
		state = DODGE
		DodgeTimer.start()
	

# MOVEMENT
func _do_movement(delta):
	match state:
		IDLE, RUN:
			_run()
		DODGE:
			_dodge()
		DODGE_RECOVER:
			pass
	move_and_slide()


func _run():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED


func _dodge():
	velocity = _dodge_direction * _dodge_speed


# WEAPON AND FIRING
func _fire_weapon(delta):
	if _time_since_last_attack <= 0:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_time_since_last_attack += _time_between_attacks
			_create_bullet()
	else:
		_time_since_last_attack -= delta


func _create_bullet():
	var new_bullet = Bullet.instantiate()
	owner.add_child(new_bullet)
	new_bullet.position = position
	new_bullet.rotation = _angle_to_reticle()


func _angle_to_reticle():
	return position.angle_to_point(Reticle.position)


# DEBUG METHODS
func _DEBUG_color_i_frames():
	match state:
		IDLE, RUN:
			modulate = Color("white")
		DODGE:
			modulate = Color("green")
