extends CharacterBody2D
class_name Player


enum {IDLE, RUN, DODGE, DODGE_RECOVER}

const SPEED: int = 800
const DODGE_DISTANCE: int = 300

@export var Reticle: Area2D

var state: int = IDLE

var _dodge_direction: Vector2

@onready var SkillOne: ChainRoot = $"Left Click Weapon"
@onready var SkillTwo: ChainRoot = $"Right Click Weapon"
@onready var DodgeTimer: Timer = $DodgeTimer
@onready var _dodge_speed: float = DODGE_DISTANCE / DodgeTimer.wait_time


# VIRTUAL METHODS
func _ready() -> void:
	pass 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_state_change_dodge()


func _process(delta: float) -> void:
	_DEBUG_color_i_frames()
	_do_movement(delta)

func _on_dodge_timer_timeout() -> void:
	state = IDLE
	velocity = Vector2.ZERO


# PUBLIC METHODS
func take_damage(damage: float) -> void:
	if state == DODGE:
		pass


# STATES
func _state_change_dodge() -> void:
	_dodge_direction = _get_input()
	if _dodge_direction != Vector2.ZERO: # Cannot dodge with no direction input
		state = DODGE
		DodgeTimer.start()
	

# MOVEMENT
func _do_movement(delta: float) -> void:
	match state:
		IDLE, RUN:
			_run()
		DODGE:
			_dodge()
		DODGE_RECOVER:
			pass
	move_and_slide()


func _run() -> void:
	var input_direction: Vector2 = _get_input()
	velocity = input_direction * SPEED


func _dodge() -> void:
	velocity = _dodge_direction * _dodge_speed


func _get_input() -> Vector2:
	return Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()


# DEBUG METHODS
func _DEBUG_color_i_frames() -> void:
	match state:
		IDLE, RUN:
			modulate = Color("white")
		DODGE:
			modulate = Color("green")
