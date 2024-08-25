extends RefCounted
class_name HexLayout


## HexLayout performs translations between cube coordinates (in Hex) and 
## pixel coordinates (in HexDraw)


enum Orientation {FLAT, POINTY}

var orient: Orientation
var size: Vector2 ## pixel width and height of the hex
var origin : Vector2 ## pixel coords of the center of the hex


## HexLayout constructor
static func new_layout(orientation: Orientation, size: Vector2, origin: Vector2) -> HexLayout:
	var layout: HexLayout = HexLayout.new()
	layout.orient = orientation
	layout.size = size
	layout.origin = origin
	return layout


## helper func that sums a Vector2 because I can't believe GDScript doesn't already have this???
static func sum_vec(vec: Vector2) -> float:
	return vec.x + vec.y


#region hex-pixel conversion
## Returns the point in pixel space corresponding to the center of "hex"
func hex_to_pixel(hex: Hex) -> Vector2:
	var conversion_mat: Transform2D = _get_conversion_matrix(orient)
	var x: float = sum_vec(hex.get_axial() * conversion_mat.x) * size.x
	var y: float = sum_vec(hex.get_axial() * conversion_mat.y) * size.y
	return Vector2(x,y) + origin


## Returns the point in hex space corresponding to the pixel position
func pixel_to_hex(pos: Vector2) -> Hex:
	var conversion_mat: Transform2D = _get_conversion_matrix(orient).affine_inverse()
	var adj_pos: Vector2 = (pos - origin)/size
	var q: float = sum_vec(adj_pos * conversion_mat.x)
	var r: float = sum_vec(adj_pos * conversion_mat.y)
	return Hex.from_fractional_cube(Vector3(q, r, -q -r))


## Gets the relevant conversion matrix according to the orientation
func _get_conversion_matrix(orientation: Orientation) -> Transform2D:
	if orientation == Orientation.FLAT:
		return HexOrientation.FLAT_CONVERSION_MAT
	else:
		return HexOrientation.POINTY_CONVERSION_MAT
#endregion

#region draw hex
## Returns a vector from the center of a hex to its corner
func calc_hex_corner_offset(corner: int) -> Vector2:
	var angle: float = _get_corner_angle(corner, orient)
	return Vector2(size.x * cos(angle), size.y * sin(angle))


## Returns an array of the positions (in pixel space relative to center point) of the corners of a hex
func calc_polygon_corners(hex: Hex) -> Array[Vector2]:
	var corners: Array[Vector2] = []
	for i in 6:
		corners.append(calc_hex_corner_offset(i))
		# In the RedBlobGames implementation, the pixel center is calculated and added here.
		# In Godot, we can accomplish the same effect by keeping the corner offset relative to the center
		# and just moving the drawn hexagon to the correct pixel center
	return corners


## Returns the angle offset (in radians) corresponding to the given corner, beginning at the starting angle and rotation counterclockwise
func _get_corner_angle(corner: int, orientation: Orientation) -> float:
	return _get_start_angle(orientation) + (TAU / 6 * corner)


## Gets the relevant starting angle of the 1st corner according to the orientation
func _get_start_angle(orientation: Orientation) -> float:
	if orientation == Orientation.FLAT:
		return HexOrientation.FLAT_START_ANGLE
	else:
		return HexOrientation.POINTY_START_ANGLE
#endregion
