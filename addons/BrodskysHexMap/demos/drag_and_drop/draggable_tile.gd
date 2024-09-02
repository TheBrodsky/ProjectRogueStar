extends Control
class_name DraggableTile


var hex: Hex
var polygon: Polygon2D


func initialize(hex: Hex, polygon: Polygon2D) -> void:
	self.hex = hex
	self.polygon = polygon
	add_child(polygon)


func move(hex: Hex, at_pos: Vector2) -> void:
	self.hex = hex
	position = at_pos
