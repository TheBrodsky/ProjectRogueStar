extends HexMap2D


enum Direction {RIGHT_OR_UP, LEFT_OR_DOWN} ## right/left if flat, up/down if pointy

@export_range(1, 10, 1, "or_greater") var side_length: int ## number of hexes that make up the side of the triangle
@export var direction: Direction


func _populate_map() -> void:
	if direction == Direction.RIGHT_OR_UP:
		for q in side_length:
			for r in side_length - q:
				map.insert(Hex.from_cube(map_to_axes(Vector2(q, r), primary_axes)))
	else:
		for q in side_length:
			for r in range(side_length - q, side_length + 1):
				map.insert(Hex.from_cube(map_to_axes(Vector2(q, r), primary_axes)))
