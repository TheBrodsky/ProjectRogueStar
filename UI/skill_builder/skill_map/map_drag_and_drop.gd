extends Control


@onready var origin: Control = $MapCenter
@onready var hex_map: HexMap2D = $MapCenter/TriangularHexMap2d

var skill_tile_scene: PackedScene = preload("res://UI/skill_builder/skill_tile/SkillTile.tscn")
var _currently_previewed_tile: SkillTile


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		var origin_tile: SkillTile = hex_map.map.get_data(Hex.from_axial(Vector2(0,0)))
		origin_tile.check_connections(hex_map.map)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_initiate_drag()


#region drag and drop
func _initiate_drag() -> void:
	if not get_viewport().gui_is_dragging():
		var clicked_hex: Hex = hex_map.get_hex_at_pixel(origin.get_local_mouse_position())
		var clicked_tile: SkillTile = hex_map.map.get_data(clicked_hex)
		if clicked_tile != null:
			hex_map.map.remove_data(clicked_tile.hex)
			var draggable: Draggable = clicked_tile.start_drag()
			draggable.drag_completed.connect(_on_drag_end)


## Moves a tile (a Control with a Polygon2D child) to the hex.
## If one already existed, it's replaced and returned. Returns null otherwise.
func _move_tile(tile: SkillTile, hex: Hex) -> SkillTile:
	var existing_tile: SkillTile = hex_map.map.get_data(hex) # get the tile at current hex before replacing it
	existing_tile = null if existing_tile == tile else existing_tile
	
	hex_map.map.insert(hex, tile) # add tile to map at new hex
	tile.move(hex, hex_map.layout.hex_to_pixel(hex)) # move tile physically to new hex
	return existing_tile


func _safe_move_tile(tile: SkillTile, hex: Hex) -> void:
	var occupying_tile: SkillTile = _move_tile(tile, hex)
	if occupying_tile != null: # a tile already exists in that spot, start a drag operation on that one to remove the conflict
		var draggable: Draggable = occupying_tile.start_drag()
		draggable.drag_completed.connect(_on_drag_end)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var at_position_local: Vector2 = at_position - origin.global_position
	var hovered_hex: Hex = hex_map.get_hex_at_pixel(at_position_local)
	return hex_map.map.has(hovered_hex)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var tile: SkillTile = data
	var at_position_local: Vector2 = at_position - origin.global_position
	var drop_hex: Hex = hex_map.get_hex_at_pixel(at_position_local)
	_safe_move_tile(tile, drop_hex)
	
	if tile.get_parent() != origin: # tile is from somewhere outside this map (probably the inventory)
		tile.reparent(origin, false)


func _on_drag_end(draggable: Draggable) -> void:
	if not is_drag_successful():
		var tile: SkillTile = draggable.object
		var hex: Hex = tile.hex
		_safe_move_tile(tile, hex)
#endregion
