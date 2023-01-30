extends Area2DPlus

# Exported
@export var speed : int = 1200
var mouse_distance_threshold : int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_size()/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement(delta)
	
func do_movement(delta):
	var to_mouse = get_global_mouse_position() - position
	var distance_from_mouse = to_mouse.length()
	if distance_from_mouse > mouse_distance_threshold:
		position += MovementTools.calcMoveVector(to_mouse, speed, delta)
		position = MovementTools.clampPosition(position, get_viewport_size())
	else:
		position = get_global_mouse_position()
