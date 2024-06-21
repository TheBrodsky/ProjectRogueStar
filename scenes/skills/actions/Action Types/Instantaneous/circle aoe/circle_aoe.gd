extends IActionable
class_name CircleAoe


@onready var area_node: Area2D = $Area2D
@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var circle: CircleShape2D = collision_shape.shape
@onready var texture_size: Vector2 = sprite.texture.get_size()
@onready var texture_scale: Vector2 = Vector2.ONE / (texture_size / (2*aoe_info.radius))

@export var aoe_info: CircleAoeRes


func _ready() -> void:
	if is_blueprint:
		hide()



## Overridable. Performs setup before calling _main_action()
func _pre_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	super(new_action, new_state, next_triggers)


## Overridable. Main component of the action
func _main_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	var action: CircleAoe = new_action
	action.show()
	action.do_animation()


## Overridable. Performs any kind of cleanup or additional setup that may be required for the action or action outcome to continue functioning.
func _post_action(new_action: IActionable, new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	super(new_action, new_state, next_triggers)


## Overridable
func _set_trigger(trigger: Trigger) -> void:
	push_error("UNIMPLEMENTED ERROR: IActionable._set_trigger()")


func _copy_from(other: IActionable) -> void:
	super(other)


func do_animation() -> void:
	sprite.scale = Vector2.ZERO
	circle.radius = 0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", texture_scale, aoe_info.animation_time).set_ease(aoe_info.animation_ease).set_trans(aoe_info.animation_trans)
	tween.parallel().tween_property(circle, "radius", aoe_info.radius, aoe_info.animation_time).set_ease(aoe_info.animation_ease).set_trans(aoe_info.animation_trans)
	tween.tween_callback(self.on_animation_complete)


func on_animation_complete() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
