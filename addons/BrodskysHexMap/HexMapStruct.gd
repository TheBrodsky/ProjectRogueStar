extends RefCounted
class_name HexMapStruct


## The data structure that represents a tiling of hexagons.
## There are many different shapes of hexagon tilings, so this is only a base class.
##
## By default, this is just an unordered set of Hex objects.
## That is to say, the keys are Hex objects and the values are null.
## Data can optionally be stored in the key-value pairs, which makes this class operate
## as a glorified Dictionary wrapper.


var map: Dictionary = {} ## {Hex : Variant}


## Inserts a new Hex into the map along with a Variant object as its value. 
## If the Hex already exists, the Variant object replaces any existing one as its value.
func insert(hex: Hex, data: Variant = null, replaces_value: bool = true) -> void:
	if not replaces_value and hex in map and map[hex.coords] == null:
		return # there's already a non-null key-value pair and replaces_value is false, so do nothing
	else:
		map[hex.coords] = data


func remove_data(hex: Hex) -> void:
	if hex.coords in map:
		map[hex.coords] = null


func has(hex: Hex) -> bool:
	return hex.coords in map


## Returns the value in the key-value pair where the key is hex. Returns null if key doesnt exist
func get_data(hex: Hex) -> Variant:
	return map.get(hex.coords)


func get_hexes() -> Array[Hex]:
	var hexes: Array[Hex] = []
	for coords in map.keys():
		hexes.append(Hex.from_cube(coords))
	return hexes
