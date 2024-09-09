extends Node2D
class_name SkillTileSides


@export_group(Globals.INSPECTOR_CATEGORY)
@export var east: TileSide
@export var north_east: TileSide
@export var north_west: TileSide
@export var west: TileSide
@export var south_west: TileSide
@export var south_east: TileSide


func get_sides() -> Array[TileSide]:
	return [east, north_east, north_west, west, south_west, south_east]
