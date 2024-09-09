extends OutlinedPolygon
class_name TileStyle


@export var area: Area2D


func _on_draw() -> void:
	super()
	var collision_poly: CollisionPolygon2D = $Area2D/CollisionPolygon2D
	collision_poly.polygon = polygon.duplicate()
