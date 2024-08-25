extends HexMap
class_name HexagonalHexMap


var radius: int ## number of hexes from the center to expand the map


static func new_map(radius: int) -> HexagonalHexMap:
	var hex_map: HexagonalHexMap = HexagonalHexMap.new()
	hex_map.radius = radius
	hex_map._populate_map()
	return hex_map


func _populate_map() -> void:
	for q in range(-radius, radius+1): # -radius - radius, inclusive
		var r1: int = max(-radius, -q - radius)
		var r2: int = min(radius, -q + radius)
		for r in range(r1, r2+1): # r1 to r2, inclusive
			insert(Hex.from_axial(Vector2(q, r)))
