extends Panel


@onready var origin: Control = $Control/OriginHex
@onready var hex_map: HexMap2D = $Control/HexMap2D

var skill_tile_scene: PackedScene = preload("res://UI/skill_builder/skill_tile/SkillTile.tscn")
var hexes: Array[SkillTile] = []


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_initiate_drag()


func _initiate_drag() -> void:
	if not get_viewport().gui_is_dragging():
		var clicked_hex: Hex = hex_map.get_hex_at_pixel(origin.get_local_mouse_position())
		var clicked_tile: SkillTile = get_tile_at(clicked_hex)
		if clicked_tile != null:
			remove_tile_at(clicked_hex)
			clicked_tile.hex = null
			var draggable: Draggable = clicked_tile.start_drag()
			draggable.drag_completed.connect(_on_drag_end)


#region hex array manipulation
func get_tile_at(hex: Hex) -> SkillTile:
	var index: int = _hex_to_index(hex)
	var tile: SkillTile = hexes[index] if hexes.size() > index else null
	return tile


func remove_tile_at(hex: Hex) -> void:
	var index: int = _hex_to_index(hex)
	hexes.remove_at(index)
	for i in range(index, hexes.size()):
		var i_hex: Hex = _index_to_hex(i)
		hexes[i].move(i_hex, hex_map.layout.hex_to_pixel(i_hex))


func has_tile_at(hex: Hex) -> bool:
	return hexes.size() > _hex_to_index(hex)


func add_tile(tile: SkillTile) -> void:
	var hex: Hex = _index_to_hex(hexes.size())
	tile.move(hex, hex_map.layout.hex_to_pixel(hex))
	hexes.append(tile)


func _hex_to_index(hex: Hex) -> int:
	var q: int = hex.coords.x
	var r: int = hex.coords.y
	return (2 * q) + r


func _index_to_hex(index: int) -> Hex:
	var q: int = floor(index / 2)
	var r: int = index % 2
	return Hex.from_axial(Vector2(q, r))
#endregion

#region drag and drop
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var at_position_global: Vector2 = at_position + global_position
	print(at_position_global, get_rect().has_point(at_position_global))
	return get_rect().has_point(at_position_global)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var tile: SkillTile = data
	add_tile(tile)
	if tile.get_parent() != origin: # tile is from somewhere outside this inventory (probably the map)
		tile.reparent(origin, false)


func _on_drag_end(draggable: Draggable) -> void:
	if not is_drag_successful():
		add_tile(draggable.object as SkillTile)
#endregion


func _on_add_hex_tile_button_pressed() -> void:
	var skill_tile: SkillTile = skill_tile_scene.instantiate()
	HexDraw.draw_hex(Hex.from_axial(Vector2(0,0)), hex_map.layout, skill_tile.polygon)
	add_tile(skill_tile)
	origin.add_child(skill_tile)
