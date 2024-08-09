extends Action
class_name Projectile
signal register_hit(body: Node2D)


@export_group(Globals.INSPECTOR_CATEGORY)
@export var area: Area2D


func _modify_from_action_state(state: ActionState) -> void:
	var collision_masks: Array[int] = state.get_effect_collision()
	area.collision_layer |= collision_masks[0]
	area.collision_mask |= collision_masks[1]


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hittable"):
		register_hit.emit(body)
		effect.do_effect(body, state)
	queue_free()
