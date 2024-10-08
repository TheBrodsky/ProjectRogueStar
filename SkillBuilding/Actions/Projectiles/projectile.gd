extends Node2D
class_name Projectile
signal register_hit(body: Node2D, state: ActionState)


@export_group(Globals.INSPECTOR_CATEGORY)
@export var iaction: ActionInterface
@export var area: Area2D


func _ready() -> void:
	iaction.set_collision(area)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hittable"):
		iaction.signaler.register_hit.emit(iaction.state)
		iaction.do_effect(body)
	queue_free()
