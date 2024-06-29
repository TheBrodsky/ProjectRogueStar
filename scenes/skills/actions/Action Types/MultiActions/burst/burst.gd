extends IMultiActionable
class_name BurstEmission

@export var angle_is_random: bool = false
@export var ignore_rotation: bool = false
@export var head_start_distance: float = 0

var _angle_offset: float


func _ready() -> void:
	super()
	_angle_offset = TAU / num_emissions


func add_indexed_entity(new_entity: Node2D, index: int) -> void:
	super(new_entity, index)
	rotate_entity(new_entity, index)


func rotate_entity(new_entity: Node2D, index: int) -> void:
	var entity_angle: float
	if angle_is_random:
		entity_angle = randf() * TAU
	else:
		entity_angle = _angle_offset * index
	new_entity.position += head_start_distance * MovementTools.calcDirectionFromAngle(entity_angle)
	if not ignore_rotation:
		new_entity.rotate(entity_angle)
