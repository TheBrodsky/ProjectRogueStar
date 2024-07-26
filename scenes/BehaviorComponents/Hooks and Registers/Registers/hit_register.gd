extends Node
class_name HitRegister
signal register_hit(body: Node2D)


@export var collision_node: Area2D
@export_flags_2d_physics var collision_mask: int
@export var mask_is_blacklist: bool = false
@export var include_tilemaps: bool = false
@export var hit_condition_method: Callable = Callable(self, "_placeholder_hit_condition")


func _ready() -> void:
	collision_node.body_entered.connect(check_hit)


func check_hit(body: Node2D) -> void:
	if does_hit(body):
		register_hit.emit(body)


func does_hit(body: Node2D) -> bool:
	var hits: bool = true
	if body is TileMap:
		hits = hits and include_tilemaps
	else:
		if collision_mask & body.get("collision_layer"):
			hits = hits and !mask_is_blacklist
	
	if hits: # no point in checking the hit_condition_method if hits is already false
		hits = hits and hit_condition_method.call(body)
	return hits


## a Callable property cannot be null. Thus, there's no way to check if a property has been assigned to hit_condition_method. Hence this placeholder.
func _placeholder_hit_condition(body: Node2D) -> bool:
	return true
