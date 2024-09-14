extends Control
class_name SkillTile


@export var skill_component: PackedScene

@export_group(Globals.INSPECTOR_CATEGORY)
@export var polygon: TileStyle

@onready var sides: SkillTileSides = $SkillTileSides
@onready var info_panel: Control = $InfoPanel

var hex: Hex


func _ready() -> void:
	sides.north_east.type = TileSide.SideType.OUTPUT
	sides.north_west.type = TileSide.SideType.OUTPUT
	sides.south_east.type = TileSide.SideType.INPUT
	sides.south_west.type = TileSide.SideType.INPUT
	polygon.area.mouse_entered.connect(_on_mouse_hover)
	polygon.area.mouse_exited.connect(_on_mouse_exit)
	info_panel.hide()


#region hover info panel
func _on_mouse_hover() -> void:
	info_panel.show()


func _on_mouse_exit() -> void:
	info_panel.hide()
#endregion


#region drag and drop
func start_drag() -> Draggable:
	info_panel.hide() # hide info panel first so that it gets duplicated as hidden for the preview
	var drag_object: Draggable = Draggable.new(null, self, duplicate(0) as Control)
	drag_object.z_index += 1
	drag_object.drag_completed.connect(_on_drag_end)
	hide()
	call_deferred("force_drag", self, drag_object)
	return drag_object


func move(hex: Hex, at_pos: Vector2) -> void:
	self.hex = hex
	position = at_pos


func _on_drag_end(draggable: Draggable) -> void:
	var tile: SkillTile = draggable.object
	tile.show()
#endregion

#region chain building
func check_connections(map: HexMapStruct) -> void:
	for side: TileSide in sides.get_sides():
		if side.type == TileSide.SideType.OUTPUT:
			var neighbor_hex: Hex = side.get_neighbor(hex)
			var neighbor_tile: SkillTile = map.get_data(neighbor_hex)
			_connect_to_neighbor(neighbor_tile, side, map)


func _connect_to_neighbor(neighbor: SkillTile, side: TileSide, map: HexMapStruct) -> void:
	if neighbor != null:
		for neighbor_side: TileSide in neighbor.sides.get_sides():
			if side.does_connect(neighbor_side):
				print("Connecting to %s through %s" % [neighbor, side])
				neighbor.check_connections(map)
				break
#endregion


