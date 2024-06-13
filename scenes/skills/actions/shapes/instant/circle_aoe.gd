extends IActionable


@onready var area_node: Area2D = $Area2D
@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var circle: CircleShape2D = collision_shape.shape
@onready var texture_size: Vector2 = sprite.texture.get_size()
@onready var texture_scale: Vector2 = Vector2.ONE / (texture_size / (2*radius))

@export var radius: float
@export var animation_time: float = .75 # in seconds
@export var animation_ease: Tween.EaseType = Tween.EASE_OUT
@export var animation_trans: Tween.TransitionType = Tween.TRANS_CIRC

var time_left: float = 1.5

func _ready() -> void:
	super()
	hide()


func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		do_action(null, [])
		time_left = 1.5 + time_left
	


func do_action(new_state: ActionState, next_triggers: Array[Trigger]) -> void:
	show()
	do_animation()


func do_animation() -> void:
	sprite.scale = Vector2.ZERO
	circle.radius = 0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", texture_scale, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.parallel().tween_property(circle, "radius", radius, animation_time).set_ease(animation_ease).set_trans(animation_trans)
	tween.tween_callback(self.on_animation_complete)


func on_animation_complete() -> void:
	hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
