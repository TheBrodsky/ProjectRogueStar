extends Node2D

enum Type {LOCAL, ON_SCREEN, OFF_SCREEN}

@export_group("Spawn Control")
@export var camera : Camera2D
@export var entity_to_spawn : PackedScene
@export var spawn_frequency : int = 10 ## Time (in seconds) between spawn cycles.
@export var is_instant : bool = false ## Non-instant spawns are telegraphed by a marker [NYI]
@export var is_automatic : bool = true ## Automatic spawners run through cycles according to spawn_frequency. Non-automatic (manual) spawners do not spawn unless a spawn method is called.

@export_group("Spawn Groups")
@export var amount : int = 1 ## Number of enemies to spawn in a cycle [NYI]
@export var max_entities : int = -1 ## Number of enemies spawned by this spawner that can exist before it stops. Negative is no cap.
@export var is_grouped : bool = false ## Whether multiple enmies are spawned in a group or scattered. Has no effect if spawn_amount is 1 [NYI]

@export_group("Spawn Location")
@export var type : Type = Type.LOCAL
@export var spawn_range : int = 100 ## Number of pixels range for local and global, off-screen spawn locations. No effect for global, on-screen

@onready var half_screen_width = (camera.get_viewport_rect().size.x / 2)
@onready var half_screen_height = (camera.get_viewport_rect().size.y / 2)
@onready var _spawn_timer = spawn_frequency

var _num_entities = 0
var _ID


func _ready():
	_ID = Globals.get_unsaved_ID()
	print(_spawn_timer)


func _process(delta):
	if is_automatic:
		_do_spawn_cycle(delta)


func _do_spawn_cycle(delta):
	if max_entities < 0 or _num_entities < max_entities:
		_spawn_timer -= delta
		if _spawn_timer <= 0:
			_spawn_timer += spawn_frequency
			
			var spawn_point : Vector2 = _find_central_spawn_point()
			Logger.log_debug("Spawner: spawning enemies at %v" % spawn_point)
			_spawn_enemies(spawn_point)


func _spawn_enemies(location : Vector2):
	Logger.log_debug("Spawner: spawning enemies")
	for i in amount:
		if max_entities >= 0 and _num_entities >= max_entities:
			Logger.log_debug("Spawner: reached entities cap before spawning all entities.")
			break
		_spawn(location + _get_point_in_circle())


func _spawn(location : Vector2):
	Logger.log_debug("Spawner: spawning entity at %v" % location)
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


func _get_point_off_screen():
	var neg_or_pos = [-1, 1][randi() % 2] # coinflip -1 and 1
	var x = (randf_range(0, spawn_range) + half_screen_width + spawn_range) * neg_or_pos
	var y =  (randf_range(0, spawn_range) + half_screen_height+ spawn_range) * neg_or_pos
	return camera.position + Vector2(x, y)


## Finds a point on a radial line between 0 and radius then randomly rotates it
func _get_point_in_circle():
	return (Vector2.ONE * randf_range(0, spawn_range)).rotated(randf_range(0, 2 * PI))


func _entity_died(spawner_ID):
	if spawner_ID == _ID:
		_num_entities -= 1
