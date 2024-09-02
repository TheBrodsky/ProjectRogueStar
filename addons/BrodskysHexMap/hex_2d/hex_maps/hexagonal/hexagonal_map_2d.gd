extends HexMap2D


@export_range(1, 10, 1, "or_greater") var radius: int ## number of hexes from center to edge, including center


func _populate_map() -> void:
	for q in range(-radius, radius+1): # -radius - radius, inclusive
		var r1: int = max(-radius, -q - radius)
		var r2: int = min(radius, -q + radius)
		for r in range(r1, r2+1): # r1 to r2, inclusive
			map.insert(Hex.from_axial(Vector2(q, r)))
