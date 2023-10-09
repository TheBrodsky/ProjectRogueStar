extends Node2D


enum Type {LOCAL, ON_SCREEN, OFF_SCREEN}
enum Quadrant {TOP_RIGHT, TOP_LEFT, BOTTOM_RIGHT, BOTTOM_LEFT, RANDOM}

const QUADRANT_TRANSFORMS = [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)] # In order: 

@export_group("Spawn Control")
@export var camera : Camera2D
@export var entity_to_spawn : PackedScene
@export var spawn_frequency : float = 10 ## Time (in seconds) between spawn cycles.
@export var is_instant : bool = false ## [NYI] Non-instant spawns are telegraphed by a marker
@export var is_automatic : bool = true ## Automatic spawners run through cycles according to spawn_frequency. Non-automatic (manual) spawners do not spawn unless a spawn method is called.

@export_group("Spawn Groups")
@export var amount : int = 1 ## Number of enemies to spawn in a cycle [NYI]
@export var max_entities : int = -1 ## Number of enemies spawned by this spawner that can exist before it stops. Negative is no cap.
@export var is_grouped : bool = false ## [NYI] Whether multiple enmies are spawned in a group or scattered. Has no effect if spawn_amount is 1.

@export_group("Spawn Location")
@export var type : Type = Type.LOCAL
@export var spawn_range : int = 100 ## Number of pixels range for local and global, off-screen spawn locations. No effect for global, on-screen

# Precalculations done for off-screen point generation algorithm.
@onready var half_screen_width : float
@onready var half_screen_height : float
@onready var no_zone_half : Vector2
@onready var rect_a : Vector2 
@onready var rect_b : Vector2
@onready var rect_a_weight : float

@onready var _spawn_timer = spawn_frequency

var _num_entities = 0
var _ID


func _ready():
	_ID = Globals.get_unsaved_ID()
	if type == Type.OFF_SCREEN:
		_precompute_off_screen_constants()

func _process(delta):
	if is_automatic:
		_do_spawn_cycle(delta)


func spawn_enemies(location : Vector2):
	Logger.log_trace("Spawner: spawning enemies at %v" % location)
	for i in amount:
		if max_entities >= 0 and _num_entities >= max_entities:
			Logger.log_debug("Spawner: reached entities cap before spawning all entities.")
			break
		
		_spawn(location + _get_point_in_circle())


func _do_spawn_cycle(delta):
	if max_entities < 0 or _num_entities < max_entities:
		_spawn_timer -= delta
		if _spawn_timer <= 0:
			_spawn_timer += spawn_frequency
			
			var spawn_point : Vector2 = _find_central_spawn_point()
			spawn_enemies(spawn_point)


func _spawn(location : Vector2):
	Logger.log_trace("Spawner: spawning entity at %v" % location)
	var entity : Enemy = entity_to_spawn.instantiate()
	owner.add_child(entity)
	
	entity.position = location
	entity.spawner_parent_ID = _ID
	entity.died.connect(_entity_died)
	
	_num_entities += 1


func _find_central_spawn_point():
	var spawn_point
	match type:
		Type.LOCAL:
			spawn_point = position
		Type.ON_SCREEN:
			spawn_point = _get_point_on_screen()
		Type.OFF_SCREEN:
			spawn_point = _get_point_off_screen()
			
	return spawn_point


func _get_point_on_screen():
	var x_boundary : float = half_screen_width
	var x = randf_range(-x_boundary, x_boundary)
	var y_boundary : float = half_screen_height
	var y = randf_range(-y_boundary, y_boundary)
	
	return camera.position + Vector2(x, y)


func _get_point_off_screen(quadrant : Quadrant = Quadrant.RANDOM):
	return choose_inner_quadrant_point() * _determine_quadrant_transform(quadrant)


func choose_inner_quadrant_point():
	var point : Vector2
	if randf() > rect_a_weight:
		# you're in rect b
		var x = randf_range(0, rect_b.x) + no_zone_half.x
		var y = randf_range(0, rect_b.y)
		point = Vector2(x, y)
	else:
		# you're in rect a
		var x = randf_range(0, rect_a.x)
		var y = randf_range(0, rect_a.y) + no_zone_half.y
		point = Vector2(x, y)
	
	return point


func _determine_quadrant_transform(quadrant : Quadrant):
	var quadrant_transform : Vector2
	if quadrant == Quadrant.RANDOM:
		quadrant_transform = Vector2(_coinflip(), _coinflip())
	else:
		quadrant_transform = QUADRANT_TRANSFORMS[quadrant]
	
	return quadrant_transform
	

func _precompute_off_screen_constants():
	half_screen_width = camera.get_viewport_rect().size.x / 2
	half_screen_height = (camera.get_viewport_rect().size.y / 2)
	no_zone_half = Vector2(half_screen_width + spawn_range, half_screen_height + spawn_range) # See _get_point_off_screen()
	var spawn_zone_half = Vector2(no_zone_half.x + spawn_range, no_zone_half.y + spawn_range) # See _get_point_off_screen()
	
	rect_a = Vector2(spawn_zone_half.x, spawn_range)
	rect_b = Vector2(spawn_range, no_zone_half.y)
	
	var rect_a_area : float = rect_a.dot(Vector2.ONE)
	var rect_b_area : float = rect_b.dot(Vector2.ONE)
	var total_area = rect_a_area + rect_b_area
	rect_a_weight = rect_a_area / total_area


## Finds a point on a radial line between 0 and radius then randomly rotates it
func _get_point_in_circle():
	return (Vector2.ONE * randf_range(0, spawn_range)).rotated(randf_range(0, 2 * PI))
	

func _coinflip(coin = [-1, 1]):
	return [-1, 1][randi() % 2]


func _entity_died(spawner_ID):
	if spawner_ID == _ID:
		_num_entities -= 1
