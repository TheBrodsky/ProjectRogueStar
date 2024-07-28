extends Node2D


@export var spawn_entity: PackedScene
@export var num_spawns: int = 4
@export var max_entities: int = 10
@export var time_between_spawns: float = 5 ## in seconds
@export var spread_distance: float = 50 ## num pixels from center of emission that spawns are spread out
@export var enabled: bool = true:
	set(value):
		enabled = value
		if root != null:
			root.enabled = value

@onready var timer: TimerTrigger = $ChainRoot/OnTimer
@onready var spawn_event: Event = $ChainRoot/OnTimer/Event
@onready var firecone_mod: FireconeMod = $ChainRoot/OnTimer/Event/Firecone

var root: ChainRoot


func _enter_tree() -> void:
	root = $ChainRoot
	root.enabled = enabled


func _ready() -> void:
	firecone_mod.num_actions = num_spawns
	firecone_mod.head_start_distance = spread_distance
	spawn_event.max_entities = max_entities
	spawn_event.action = spawn_entity
	timer.activations_per_second = 1 / time_between_spawns
	
