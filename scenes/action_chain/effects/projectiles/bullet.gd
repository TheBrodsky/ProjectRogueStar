extends Effect


@export var damage: float = 1
@export var speed: float = 600

@onready var Notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _process(delta: float) -> void:
	position += MovementTools.calcMoveVector(MovementTools.calcDirectionFromAngle(rotation), speed, delta)


func modify_from_action_state(state: ActionState) -> void:
	var new_rotation: float = state.calc_direction_from_points(state.source.global_position, get_global_mouse_position())
	rotation = new_rotation
	speed *= state.speed_mult


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	get_global_mouse_position()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy : Enemy = body
		enemy.take_damage(damage)
	queue_free()
