extends Node
class_name HitRegister
signal register_hit(body: Node2D)


@export var collision_node: Area2D
@export var group_whitelist: Array[String]
@export var group_blacklist: Array[String]
@export var hit_condition_method: Callable = Callable(self, "_placeholder_hit_condition")


func _ready() -> void:
	collision_node.body_entered.connect(check_hit)


func check_hit(body: Node2D) -> void:
	if does_hit(body):
		register_hit.emit(body)


func does_hit(body: Node2D) -> bool:
	var hits: bool = hit_condition_method.call(body)
	return hits and is_whitelisted(body) and not is_blacklisted(body)


func is_blacklisted(body: Node2D) -> bool:
	return _is_listed_helper(body, group_blacklist)


func is_whitelisted(body: Node2D) -> bool:
	if group_whitelist.size() == 0:
		return true
	return _is_listed_helper(body, group_whitelist)


func _is_listed_helper(body: Node2D, list: Array[String]) -> bool:
	var is_listed: bool = false
	for group in list:
		if body.is_in_group(group):
			is_listed = true
			break
	return is_listed


## a Callable property cannot be null. Thus, there's no way to check if a property has been assigned to hit_condition_method. Hence this placeholder.
func _placeholder_hit_condition(body: Node2D) -> bool:
	return true
