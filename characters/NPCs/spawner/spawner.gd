extends Node2D


@export_group(Globals.MODIFIABLE_CATEGORY)
@export var num_spawns: int = 4
@export var max_entities: int = 10
@export var time_between_spawns: float = 5 ## in seconds
@export var spread_distance: float = 50 ## num pixels from center of emission that spawns are spread out
@export var enabled: bool = true

@export_group(Globals.INSPECTOR_CATEGORY)
@export var spawn_entity: PackedScene
@export var timer: OnTimer
@export var spawn_event: Event
@export var firecone_mod: FireconeMod


func _enter_tree() -> void:
	firecone_mod.num_actions = num_spawns
	firecone_mod.head_start_distance = spread_distance
	spawn_event.max_entities = max_entities
	spawn_event.action_entity_packed = spawn_entity
	timer.activations_per_second = 1 / time_between_spawns


func _ready() -> void:
	if not enabled:
		timer.pause()
