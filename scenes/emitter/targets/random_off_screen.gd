extends Target


enum Type {LOCAL, ON_SCREEN, OFF_SCREEN}
enum Quadrant {TOP_RIGHT, TOP_LEFT, BOTTOM_RIGHT, BOTTOM_LEFT, RANDOM}

const QUADRANT_TRANSFORMS = [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)] # In order: 

# Precalculation variables for off-screen point generation algorithm.
@onready var half_screen_width : float
@onready var half_screen_height : float
@onready var no_zone_half : Vector2
@onready var rect_a : Vector2 
@onready var rect_b : Vector2
@onready var rect_a_weight : float


func _get_target() -> Vector2:
	return _get_point_off_screen()


func _get_point_off_screen(quadrant : Quadrant = Quadrant.RANDOM):
	var point = choose_inner_quadrant_point() * _determine_quadrant_transform(quadrant)
	var offset = get_viewport().get_camera_2d().position
	return point + offset


func choose_inner_quadrant_point():
	var point : Vector2
	if randf() > rect_a_weight:
		# In rect b
		point = _find_random_point_in_rectangle(Vector2(0, rect_b.x), Vector2(0, rect_b.y)) + Vector2(no_zone_half.x, 0)
	else:
		# In rect a
		point = _find_random_point_in_rectangle(Vector2(0, rect_a.x), Vector2(0, rect_a.y)) + Vector2(0, no_zone_half.y)
	
	return point


func _determine_quadrant_transform(quadrant : Quadrant):
	var quadrant_transform : Vector2
	if quadrant == Quadrant.RANDOM:
		quadrant_transform = Vector2(_coinflip(), _coinflip())
	else:
		quadrant_transform = QUADRANT_TRANSFORMS[quadrant]
	
	return quadrant_transform
	

func _precompute_off_screen_constants():
	half_screen_width = get_viewport_rect().size.x / 2
	half_screen_height = get_viewport_rect().size.y / 2
	no_zone_half = Vector2(half_screen_width + range, half_screen_height + range) # See _get_point_off_screen()
	var yes_zone_half = Vector2(no_zone_half.x + range, no_zone_half.y + range) # See _get_point_off_screen()
	
	rect_a = Vector2(yes_zone_half.x, range)
	rect_b = Vector2(range, no_zone_half.y)
	
	var rect_a_area : float = rect_a.dot(Vector2.ONE)
	var rect_b_area : float = rect_b.dot(Vector2.ONE)
	var total_area = rect_a_area + rect_b_area
	rect_a_weight = rect_a_area / total_area


func _find_random_point_in_rectangle(x_range : Vector2, y_range : Vector2):
	return Vector2(randf_range(x_range.x, x_range.y), randf_range(y_range.x, y_range.y))


func _coinflip(coin = [-1, 1]):
	return [-1, 1][randi() % 2]
