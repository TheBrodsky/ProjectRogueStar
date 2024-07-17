class_name Projectile
extends Node2D


@export var damage: float = 1
@export var speed: float = 600
@export var effect: Effect ## This is what happens when the projectile hits something

@onready var Notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var HitRegister: HitRegister = $HitRegister


func _ready() -> void:
	effect = effect.duplicate()


func _process(delta: float) -> void:
	position += MovementTools.calcMoveVector(MovementTools.calcDirectionFromAngle(rotation), speed, delta)


func modify_from_action_state(state: ActionState) -> void:
	var new_rotation: float = state.calc_aim_to_target(state.source.global_position)
	rotation = new_rotation
	speed = (speed + state.speed_base) * state.speed_mult


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_hit_t_hook_register_hit(body: Node2D) -> void:
	effect.do_effect(body)
	queue_free()


func _on_hit_register_register_hit(body: Node2D) -> void:
	queue_free()
