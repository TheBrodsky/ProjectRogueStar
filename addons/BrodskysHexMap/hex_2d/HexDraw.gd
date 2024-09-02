extends Node2D
class_name HexDraw


## Draws all hexagons in the HexMap according to HexLayout and populates the spaces with Polygon2D objects.
## polygon_template MUST be a Polygon2D (or inherit from it)
static func draw_map(map: HexMapStruct, layout: HexLayout, polygon_template: PackedScene = null) -> Array[Polygon2D]:
	var drawn_hexes: Array[Polygon2D] = []
	for hex in map.get_hexes():
		if polygon_template != null:
			drawn_hexes.append(draw_hex(hex, layout, polygon_template.instantiate()))
		else:
			drawn_hexes.append(draw_hex(hex, layout, Polygon2D.new()))
	return drawn_hexes


## Draws a hexagon at Hex according to HexLayout and by populating a Polygon2D
static func draw_hex(hex: Hex, layout: HexLayout, polygon: Polygon2D) -> Polygon2D:
	var corners: Array[Vector2] = layout.calc_polygon_corners(hex)
	polygon.polygon = PackedVector2Array(corners)
	polygon.position = layout.hex_to_pixel(hex) # move hexagon center to its appropriate pixel center
	return polygon
