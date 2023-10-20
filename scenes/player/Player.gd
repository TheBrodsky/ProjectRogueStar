extends CharacterBody2D


enum {IDLE, RUN, DODGE, DODGE_RECOVER}

const SPEED : int = 800
const DODGE_DISTANCE : int = 300

@export var Reticle : Area2D

var state : int = IDLE

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


# DEBUG METHODS
func _DEBUG_color_i_frames():
	match state:
		IDLE, RUN:
			modulate = Color("white")
		DODGE:
			modulate = Color("green")
