extends Action
class_name CircleAoe


@onready var hit_hook: HitTriggerHook = $Hit_T_Hook
@onready var area_node: Area2D = $Area2D
@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var circle: CircleShape2D = collision_shape.shape
@onready var texture_size: Vector2 = sprite.texture.get_size()
@onready var texture_scale: Vector2 = Vector2.ONE / (texture_size / (2*aoe_info.radius))

@export var aoe_info: CircleAoeRes
@export var effect: Effect ## This is what happens when the aoe hits something


var _bodies_hit: Dictionary = {}


func _ready() -> void:
	effect = effect.duplicate()
	hit_hook.hit_condition_method = Callable(self, "does_hit")
	show()
	do_animation()


func does_hit(body: Node2D) -> bool:
	return body not in _bodies_hit


func do_animation() -> void:
	sprite.scale = Vector2.ZERO
	circle.radius = 0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", texture_scale, aoe_info.animation_time).set_ease(aoe_info.animation_ease).set_trans(aoe_info.animation_trans)
	tween.parallel().tween_property(circle, "radius", aoe_info.radius, aoe_info.animation_time).set_ease(aoe_info.animation_ease).set_trans(aoe_info.animation_trans)
	tween.tween_callback(self.on_animation_complete)


func on_animation_complete() -> void:
	queue_free()


func _on_hit_t_hook_register_hit(body: Node2D) -> void:
	_bodies_hit[body] = null
	effect.do_effect(body)
