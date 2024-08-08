extends Follower
class_name PendulumAt


@export_enum("Y_AXIS", "X_AXIS") var axis_of_movement: int = 0

@export var period_duration: float = 2 ## in seconds
@export var magnitude: float = 50
@export var tween_trans: Tween.TransitionType = Tween.TRANS_SINE

@onready var periodic_motion: Tween = get_tree().create_tween()

var start_pos: Vector2
var up_pos: Vector2
var down_pos: Vector2


func _ready() -> void:
	if axis_of_movement == 1:
		rotate(PI / 2)
	_set_points()
	periodic_motion.tween_property(self, "position", up_pos, period_duration / 4).set_trans(tween_trans).set_ease(Tween.EASE_OUT)
	periodic_motion.tween_property(self, "position", down_pos, period_duration / 2).set_trans(tween_trans).set_ease(Tween.EASE_IN_OUT)
	periodic_motion.tween_property(self, "position", start_pos, period_duration / 4).set_trans(tween_trans).set_ease(Tween.EASE_IN)
	periodic_motion.set_loops() # loop indefinitely
	periodic_motion.play()


func _set_points() -> void:
	start_pos= position + Vector2(0, 0)
	up_pos = position + Vector2(0, magnitude).rotated(rotation)
	down_pos = position + Vector2(0, -magnitude).rotated(rotation)
