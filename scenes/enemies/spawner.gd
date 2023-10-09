extends Node2D

enum Type {LOCAL, ON_SCREEN, OFF_SCREEN}

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

@onready var half_screen_width = (camera.get_viewport_rect().size.x / 2)
@onready var half_screen_height = (camera.get_viewport_rect().size.y / 2)
@onready var no_zone_halfs = Vector2(half_screen_width + spawn_range, half_screen_height + spawn_range) # See _get_point_off_screen()
@onready var spawn_zone_halfs = Vector2(no_zone_halfs.x + spawn_range, no_zone_halfs.y + spawn_range) # See _get_point_off_screen()
@onready var _spawn_timer = spawn_frequency

var _num_entities = 0
var _ID


func _ready():
	_ID = Globals.get_unsaved_ID()

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


# The math here is a bit tricky. There are 3 rectangles: the viewport (the camera), the viewport + spawn_range buffer (the "no-zone"), and no-zone + spawn_range (the "spawn_zone")
# The camera is the smallest, the spawn-zone is the largest. We want to pick points within the spawn-zone but not within the no-zone.
# The X coord is any point on the x-axis of the spawn-zone
# If the X coord is on the outer edges (outside the no-zone), the Y coord is any point on the y-axis of the spawn-zone.
# If the X coord is within the no-zone's x-axis, the Y coord is a narrow band of height spawn_range and is offset by the height of the no-zone
func _get_point_off_screen():
	return camera.position + _get_point_off_screen_helper(no_zone_halfs, spawn_zone_halfs, randi() % 2)


# See _get_point_off_screen for explanation of the math.
# This is a generalized version of that math so that the x and y can be swapped to control the distribution of spawns
func _get_point_off_screen_helper(no_zone_halfs: Vector2, spawn_zone_halfs: Vector2, is_width_first_generated: bool):
	var primary_axis_index = is_width_first_generated as int
	var secondary_axis_index = !is_width_first_generated as int
	
	var primary = (randf_range(-spawn_zone_halfs[primary_axis_index], spawn_zone_halfs[primary_axis_index]))
	var secondary
	if abs(primary) > no_zone_halfs[primary_axis_index]:
		secondary = randf_range(-spawn_zone_halfs[secondary_axis_index], spawn_zone_halfs[secondary_axis_index])
	else:
		var neg_or_pos = [-1, 1][randi() % 2] # coinflip -1 and 1
		secondary = (randf_range(0, spawn_range) + no_zone_halfs[secondary_axis_index]) * neg_or_pos
	
	return Vector2(secondary, primary) if is_width_first_generated else Vector2(primary, secondary)


## Finds a point on a radial line between 0 and radius then randomly rotates it
func _get_point_in_circle():
	return (Vector2.ONE * randf_range(0, spawn_range)).rotated(randf_range(0, 2 * PI))


func _entity_died(spawner_ID):
	if spawner_ID == _ID:
		_num_entities -= 1
