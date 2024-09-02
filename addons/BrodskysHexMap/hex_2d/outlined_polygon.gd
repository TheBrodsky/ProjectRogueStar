extends Polygon2D
class_name OutlinedPolygon


## This is just in here to help make drawn maps more clear.
## It's not necessary to do anything; any Polygon2D will work


@export var outline: Line2D


func _on_draw() -> void:
	outline.points = polygon.duplicate()
