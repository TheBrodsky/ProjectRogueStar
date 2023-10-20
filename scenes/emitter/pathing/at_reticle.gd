extends Pathing


func _ready():
	rotation = position.angle_to_point(get_global_mouse_position())


func _process(delta):
	position += MovementTools.calcMoveVector(Vector2.from_angle(rotation), speed, delta)
