extends Node2D


@export var spawn_entity: PackedScene
@export var num_spawns: int = 4
@export var max_entities: int = 10
@export var time_between_spawns: float = 5 ## in seconds
@export var spread_distance: float = 50 ## num pixels from center of emission that spawns are spread out

@onready var timer: TimerTrigger = $ChainRoot/OnTimer
@onready var burst: ConeEmission = $ChainRoot/OnTimer/Event/FireCone


func _ready() -> void:
	burst.num_emissions = num_spawns
	burst.max_entities = max_entities
	burst.action_shape = spawn_entity
	timer.activations_per_second = 1 / time_between_spawns
	burst.head_start_distance = spread_distance
