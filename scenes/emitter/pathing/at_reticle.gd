extends Pathing


func _ready_override():
	pathed_entity.rotation = pathed_entity.position.angle_to_point(get_global_mouse_position())


func _process_override(delta):
	pathed_entity.position += MovementTools.calcMoveVector(Vector2.from_angle(pathed_entity.rotation), speed, delta)
