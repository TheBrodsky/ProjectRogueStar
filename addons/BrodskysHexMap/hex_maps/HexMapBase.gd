extends RefCounted
class_name HexMap


## The data structure that represents a tiling of hexagons.
## There are many different shapes of hexagon tilings, so this is only a base class.
##
## By default, this is just an unordered set of Hex objects.
## That is to say, the keys are Hex objects and the values are null.


var map: Dictionary = {} ## {Hex : Variant}


## Abstract method that MUST be implemented by maps which extend HexMap. Populates the map with Hexes.
func _populate_map() -> void:
	push_error("UNIMPLEMENTED ERROR: HexMap._populate_map() MUST be implemented by inheriting classes.")


## Inserts a new Hex into the map along with a Variant object as its value. 
## If the Hex already exists, the Variant object replaces any existing one as its value.
func insert(hex: Hex, data: Variant = null, replaces_value: bool = true) -> void:
	if not replaces_value and hex in map and map[hex] == null:
		return # there's already a non-null key-value pair and replaces_value is false, so do nothing
	else:
		map[hex] = data


func get_hexes() -> Array:
	return map.keys()
