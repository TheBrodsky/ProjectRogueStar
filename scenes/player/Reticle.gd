extends Area2DPlus

@onready var player = get_node("/root/Player")
@export var max_distance_from_player = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_size()/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement()

func do_movement():
	var to_player = player.global_position - position
	var distance_to_player = to_player.length()
	if distance_to_player > max_distance_from_player:
		var move_limiter_factor = max_distance_from_player/distance_to_player # what fraction of the length between reticle and player is within the max distance
		position += to_player.normalized() * distance_to_player * (1-move_limiter_factor)
