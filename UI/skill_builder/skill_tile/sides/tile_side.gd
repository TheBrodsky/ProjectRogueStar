@tool
extends Node2D
class_name TileSide


enum SideType {NONE, INPUT, OUTPUT}

static var input_texture: Texture2D = preload("res://UI/skill_builder/skill_tile/sides/input_arrow.png")
static var output_texture: Texture2D = preload("res://UI/skill_builder/skill_tile/sides/output_arrow.png")
const ROTATION_OFFSET: float = PI / 6

@export var side: HexOrientation.PointyNeighbor:
	set(value):
		side = value
		_rotate_to_side()

@export var type: SideType:
	set(value):
		type = value
		(get_node("IOSprite") as Sprite2D).texture = _get_texture()



func does_connect(to: TileSide) -> bool:
	return type != to.type and type != SideType.NONE and to.type != SideType.NONE


func get_neighbor(of: Hex) -> Hex:
	return of.add(Hex.from_cube(HexOrientation.NEIGHBOR_VECS[side]))


func _get_texture() -> Texture2D:
	match type:
		SideType.NONE:
			return null
		SideType.INPUT:
			return input_texture
		SideType.OUTPUT:
			return output_texture
		_:
			return null


func _rotate_to_side() -> void:
	var side_index: int = (side + 4) % 6 # the neighbors enum's index is offset by +4/-2 from the way rotation would index the sides
	rotation = - ((TAU / 6) * side_index + ROTATION_OFFSET) # the neighbors enum index also moves counterclockwise, so negative rotation
