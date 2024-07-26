class_name Projectile
extends Node2D


@export var effect: Effect ## This is what happens when the projectile hits something

var state: ActionState


func _ready() -> void:
	effect = effect.duplicate()


func modify_from_action_state(state: ActionState) -> void:
	self.state = modify_action_state(state)


func modify_action_state(state: ActionState) -> ActionState:
	for child in get_children():
		if child is QuantitativeModifier:
			(child as QuantitativeModifier).modify_state(state)
	return state


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_hit_t_hook_register_hit(body: Node2D) -> void:
	effect.do_effect(body)
	queue_free()


func _on_hit_register_register_hit(body: Node2D) -> void:
	queue_free()
