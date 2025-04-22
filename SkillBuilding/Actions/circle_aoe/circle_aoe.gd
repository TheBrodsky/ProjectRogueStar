extends Node2D
class_name CircleAoe


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var animation_time: float = 1 # in seconds

@export_group(Globals.INSPECTOR_CATEGORY)
@export var iaction: ActionInterface
@export var area_node: Area2D
@export var animation_ease: Tween.EaseType = Tween.EASE_OUT
@export var animation_trans: Tween.TransitionType = Tween.TRANS_CIRC

@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var texture_size: Vector2 = sprite.texture.get_size()
@onready var circle: CircleShape2D = collision_shape.shape

var _bodies_hit: Dictionary = {}


func _ready() -> void:
	iaction.set_collision(area_node)
	show()
	do_animation()


func does_hit(body: Node2D) -> bool:
	return body not in _bodies_hit


func do_animation() -> void:
	var max_radius: float = iaction.state.stats.entity.aoe_radius.val()
	var max_scale: Vector2 = Vector2.ONE / (texture_size / (2*max_radius))
	sprite.scale = Vector2.ZERO
	circle.radius = 0
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", max_scale, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.parallel().tween_property(circle, "radius", max_radius, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.tween_callback(self.on_animation_complete)


func on_animation_complete() -> void:
	iaction.signaler.expired.emit(iaction.state)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hittable") and does_hit(body):
		iaction.signaler.has_hit.emit(iaction.state)
		iaction.do_effect(body)
	_bodies_hit[body] = null
