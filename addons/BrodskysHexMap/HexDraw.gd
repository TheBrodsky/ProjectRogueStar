extends Node2D
class_name HexDraw


static func draw_map(map: HexMap, layout: HexLayout, line_style: Line2D) -> Array[Line2D]:
	var drawn_hexes: Array[Line2D] = []
	for hex in map.get_hexes():
		drawn_hexes.append(draw_hex(hex, layout, line_style.duplicate()))
	return drawn_hexes


static func draw_hex(hex: Hex, layout: HexLayout, line: Line2D) -> Line2D:
	if line == null:
		line == Line2D.new()
	var corners: Array[Vector2] = layout.calc_polygon_corners(hex)
	for point in corners:
		line.add_point(point)
	line.add_point(corners[0]) # make sure it loops back on itself
	line.position = layout.hex_to_pixel(hex) # move hexagon center to its appropriate pixel center
	return line
