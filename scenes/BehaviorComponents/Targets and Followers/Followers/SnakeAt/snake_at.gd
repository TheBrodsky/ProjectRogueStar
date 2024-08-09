extends Follower
class_name SnakeAt

@export_group(Globals.MODIFIABLE_CATEGORY)
@export var period_duration: float = 2 ## how long a complete cycle takes 
@export var magnitude: float = 50 ## how many pixels away from the center the object goes

@export_group(Globals.INSPECTOR_CATEGORY)
@export var pendulum: PendulumAt
@export var straight: StraightAt


func _enter_tree() -> void:
	super()
	pendulum.period_duration = period_duration
	pendulum.magnitude = magnitude
	straight.speed = speed
	straight.aim_deviation = aim_deviation
