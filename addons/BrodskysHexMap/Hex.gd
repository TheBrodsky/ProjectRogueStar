extends RefCounted
class_name Hex


## An implementation of a Hex class to be used in a Hexmap, according to the
## implementation details outlined by redbloggames (https://www.redblobgames.com/grids/hexagons/)
##
## THIS IS NOT THE CLASS YOU SHOULD USE FOR THE ACTUAL HEXES ON A HEX GRID.
## This class only deals with hex coordinates, which are the relative positions of hexes
## on a hex grid. This class has no concept or knowledge of "pixels" or "screens."
## If that's what you're looking for, check "HexTile"
##
## This class uses cube coordinates for all calculations.
## Axial coordinates are also supported for the constructor, but the underlying
## implementation is still in Cube coordinates.
##
## This class is designed for usability and readability over efficiency.


var coords: Vector3i # (x,y,z) -> (q,r,s)


## Returns a new Hex from cube coordinates
static func from_cube(vec: Vector3i) -> Hex:
	assert(sum_vec(vec) == 0)
	var hex: Hex = Hex.new()
	hex.coords = vec
	return hex


## Returns a new Hex from axial coordinates
static func from_axial(vec: Vector2i) -> Hex:
	return from_cube(Vector3i(vec.x, vec.y, -vec.x - vec.y)) # s = -q -r


## Sometimes you have float coords and those need to be converted to ints. You can't just round normally. See hex_round() for more info
static func from_fractional_cube(vec: Vector3) -> Hex:
	return from_cube(hex_round(vec))


## Hex rounding isn't as simple as normal rounding. You have to preserve the relationship that q + r + s = 0, hence the little bit at the end
static func hex_round(vec: Vector3) -> Vector3i:
	var coords: Vector3i = vec.round()
	var diffs: Vector3 = (Vector3(coords) - vec).abs()
	var max_diff: int = diffs.max_axis_index()
	
	# now that we know which one was changed the most during the round operation, 
	# we override that one to equal the negative sum of the other two, preserving the relationship
	match max_diff:
		0: # q is most off
			coords = Vector3i(-coords.y - coords.z, coords.y, coords.z)
		1: # r is most off
			coords = Vector3i(coords.x, -coords.x - coords.z, coords.z)
		2: # s is most off
			coords = Vector3i(coords.x, coords.y, -coords.x - coords.y)
	return coords


## helper func that sums a Vector3 because I can't believe GDScript doesn't already have this???
static func sum_vec(vec: Vector3) -> int:
	return vec.x + vec.y + vec.z


## Returns the equivalent axial coordinates of this Hex
func get_axial() -> Vector2:
	return Vector2(coords.x, coords.y)


#region basic operators
## Returns true if both Hexes are at the same coordinates
func equals(other: Hex) -> bool:
	return coords == other.coords


## Returns the sum of coordinates of 2 Hexes
func add(other: Hex) -> Hex:
	return from_cube(coords + other.coords)


## Returns the difference of coordinates of 2 Hexes
func subtract(other: Hex) -> Hex:
	return from_cube(coords - other.coords)


## Returns the coordinates of this Hex multiplied by scalar
func multiply(scalar: int) -> Hex:
	return from_cube(coords * scalar)
#endregion

#region distance
## Returns the distance of this Hex from the origin
func length() -> int:
	return sum_vec(coords.abs())/2


## Returns the distance from this Hex to other Hex
func distance_to(other: Hex) -> int:
	return subtract(other).length()
#endregion

#region neighbors & diagonals
## Returns the specified neighbor of this pointy Hex
func get_pointy_neighbor(neighbor: HexOrientation.PointyNeighbor) -> Hex:
	return _get_neighbor(neighbor)


## Returns the specified neighbor of this flat Hex
func get_flat_neighbor(neighbor: HexOrientation.FlatNeighbor) -> Hex:
	return _get_neighbor(neighbor)


## Returns the specified (by index) neighbor of this Hex. Probably don't use this.
func _get_neighbor(neighbor: int) -> Hex:
	return from_cube(HexOrientation.NEIGHBOR_VECS[neighbor] + coords)


## Returns the specified diagonal of this pointy Hex
func get_pointy_diagonal(diagonal: HexOrientation.PointyDiagonal) -> Hex:
	return _get_diagonal(diagonal)


## Returns the specified diagonal of this flat Hex
func get_flat_diagonal(diagonal: HexOrientation.FlatDiagonal) -> Hex:
	return _get_diagonal(diagonal)


## Returns the specified (by index) diagonal of this Hex. Probably don't use this.
func _get_diagonal(diagonal: int) -> Hex:
	return from_cube(HexOrientation.DIAGONAL_VECS[diagonal] + coords)
#endregion

#region line drawing
# the epsilon vector gets added to the "from" point in linedraw to prevent points straddling the sides between hexes
var _epsilon_vec: Vector3 = Vector3(1e-6, 2e-6, -3e-6) 

func linedraw(to_hex: Hex) -> Array[Hex]:
	var line_hexes: Array[Hex] = []
	var float_coords: Vector3 = Vector3(coords) + _epsilon_vec
	var num_points: int = distance_to(to_hex)
	for i in range(num_points):
		var lerp_coords: Vector3i = float_coords.lerp(to_hex.coords, i/num_points).round()
		line_hexes.append(from_cube(lerp_coords))
	return line_hexes
#endregion

