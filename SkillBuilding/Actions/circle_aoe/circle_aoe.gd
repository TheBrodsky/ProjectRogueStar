extends Action
class_name CircleAoe
signal register_hit(body: Node2D, state: ActionState)
signal expire(transient: Node, state: ActionState)


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var radius: float = 100
@export var animation_time: float = 1 # in seconds

@export_group(Globals.INSPECTOR_CATEGORY)
@export var area_node: Area2D
@export var animation_ease: Tween.EaseType = Tween.EASE_OUT
@export var animation_trans: Tween.TransitionType = Tween.TRANS_CIRC

@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var texture_size: Vector2 = sprite.texture.get_size()
@onready var texture_scale: Vector2 = Vector2.ONE / (texture_size / (2*radius))
@onready var circle: CircleShape2D = collision_shape.shape

var _bodies_hit: Dictionary = {}


func _ready() -> void:
	show()
	do_animation()


func does_hit(body: Node2D) -> bool:
	return body not in _bodies_hit


func do_animation() -> void:
	sprite.scale = Vector2.ZERO
	circle.radius = 0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", texture_scale, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.parallel().tween_property(circle, "radius", radius, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.tween_callback(self.on_animation_complete)


func on_animation_complete() -> void:
	expire.emit(self, state)
	queue_free()


func _modify_from_action_state() -> void:
	radius = state.stats.entity.aoe_radius.val()
	var collision_masks: Array[int] = state.get_effect_collision()
	area_node.collision_layer = collision_masks[0]
	area_node.collision_mask = collision_masks[1]


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hittable") and does_hit(body):
		register_hit.emit(body, state)
		effect.do_effect(body, state)
	_bodies_hit[body] = null

