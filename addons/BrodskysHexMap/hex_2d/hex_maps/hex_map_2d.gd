extends Node2D
class_name HexMap2D

# Becausae of the q+r+s=0 relationship, we usually only iterate over 2 (q and r) and infer the third.
# For some map shapes, which two you pick changes how the map looks. 
# So this is effectively asking how you want to map the 2 axial values to the 3 possible axes.
# TL;DR - some maps have 3 different "directions"
enum PrimaryAxes {QR, QS, RS}

@export var tile_size: Vector2 = Vector2(100, 100)
@export var orientation: HexLayout.Orientation = HexLayout.Orientation.FLAT
@export var polygon_style: PackedScene = preload("res://addons/BrodskysHexMap/hex_2d/OutlinedPolygon.tscn")
@export var primary_axes: PrimaryAxes = PrimaryAxes.QR

var map: HexMapStruct
var layout: HexLayout
var _drawn_hexes: Array[Polygon2D] = []


## Abstract method that MUST be implemented by maps which extend HexMap. Populates the map with Hexes.
func _populate_map() -> void:
	push_error("UNIMPLEMENTED ERROR: HexMap._populate_map() MUST be implemented by inheriting classes.")


func _ready() -> void:
	map = HexMapStruct.new()
	layout = HexLayout.new_layout(orientation, tile_size, Vector2.ZERO)
	_populate_map()
	draw_map()


func get_hex_at_pixel(at_position: Vector2) -> Hex:
	return layout.pixel_to_hex(at_position)


func draw_map() -> void:
	for hex in _drawn_hexes:
		hex.queue_free()
	_drawn_hexes = HexDraw.draw_map(map, layout, polygon_style)
	for hex in _drawn_hexes:
		add_child(hex)


## Maps axial coords to cube coords along specific axes. See comments on "PrimaryAxes" for more details.
## This probably fits better in another class, but currently only HexMaps use this
func map_to_axes(coords: Vector2, to_axes: PrimaryAxes) -> Vector3:
	# the only difference between these 3 is where the inferred axis is (-q-r)
	match to_axes:
		PrimaryAxes.QR:
			return Vector3(coords.x, coords.y, (-coords.x - coords.y))
		PrimaryAxes.QS:
			return Vector3(coords.x, (-coords.x - coords.y), coords.y)
		PrimaryAxes.RS:
			return Vector3((-coords.x - coords.y), coords.x, coords.y)
		_:
			# this should never get reached, but if it does we default to QR
			return Vector3(coords.x, coords.y, (-coords.x - coords.y))
