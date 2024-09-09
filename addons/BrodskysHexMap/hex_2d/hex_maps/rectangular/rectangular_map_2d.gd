@tool
extends HexMap2D


@export_range(1, 10, 1, "or_greater") var width: int ## number of hexes that make up the width of the rectangle
@export_range(1, 10, 1, "or_greater") var height: int ## number of hexes that make up the height of the rectangle


func _populate_map() -> void:
	for r in height:
		var r_offset: int = floor(r/2)
		for q in range(-r_offset, width - r_offset):
			map.insert(Hex.from_axial(Vector2(q, r)))
