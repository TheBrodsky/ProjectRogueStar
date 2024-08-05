class_name Projectile
extends Node2D
signal register_hit(body: Node2D)


@export var effect: Effect ## This is what happens when the projectile hits something
@export var area: Area2D

var state: ActionState


func _ready() -> void:
	effect = effect.duplicate()


func modify_from_action_state(state: ActionState) -> void:
	self.state = modify_action_state(state)
	var collision_masks: Array[int] = state.get_effect_collision()
	area.collision_layer |= collision_masks[0]
	area.collision_mask |= collision_masks[1]


func modify_action_state(state: ActionState) -> ActionState:
	for child in get_children():
		if child is QuantitativeModifier:
			(child as QuantitativeModifier).modify_state(state)
	return state


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hittable"):
		register_hit.emit(body)
		effect.do_effect(body, state)
	queue_free()
