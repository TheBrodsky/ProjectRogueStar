extends Node2D
class_name Follower


## A Follower is a behavioral component that defines movement.
## Followers use a Target to determine destination and then move towards it.
## The existence of a Follower on an entity additionally distinguishes what entities
## can be modified by movement-related modifiers, acting in a similar way as Registers
## work for TriggerHooks.


@export var parent_entity: Node2D ## The object moved by the follower
var target: Target ## Determines the destination of a follower
var speed: float = 0 ## In pixels/second
var aim_deviation: float = 0 ## in degrees


func _ready() -> void:
	assert(parent_entity != null)
	initialize()


func initialize() -> void:
	if "state" in parent_entity:
		_modify_from_state(parent_entity.get("state") as ActionState)


func _modify_from_state(state: ActionState) -> void:
	speed = state.get_speed()
	aim_deviation = state.get_aim_deviation()
	target = state.target


func _apply_movement(delta: float, direction: Vector2) -> void:
	if parent_entity is CharacterBody2D:
		(parent_entity as CharacterBody2D).velocity = _calc_move_vector(delta, direction)/delta # remove the delta we just added
		(parent_entity as CharacterBody2D).move_and_slide()
	else:
		parent_entity.position += _calc_move_vector(delta, direction)


func _calc_move_vector(delta: float, direction: Vector2) -> Vector2:
	return MovementTools.calcMoveVector(direction, speed, delta)


func _get_direction_vector() -> Vector2:
	var destination: Vector2 = target.get_target(get_tree())
	var aim_vector: Vector2 = parent_entity.global_position.direction_to(destination)
	var deviation: float = deg_to_rad(randf_range(-aim_deviation/2, aim_deviation/2))
	return aim_vector.rotated(deviation)
