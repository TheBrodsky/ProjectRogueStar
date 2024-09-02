extends Control


@export var hex_map: HexMap2D

@onready var map_center: Control = $MapCenter

var tile_style: PackedScene = preload("res://addons/BrodskysHexMap/demos/drag_and_drop/TilePolygonStyle.tscn")


## Moves a tile (a Control with a Polygon2D child) to the hex.
## If one already existed, it's replaced and returned. Returns null otherwise.
func move_tile(tile: DraggableTile, hex: Hex) -> DraggableTile:
	var existing_tile: DraggableTile = hex_map.map.get_data(hex) # get the tile at current hex before replacing it
	
	if hex_map.map.get_data(tile.hex) == tile:
		hex_map.map.remove_data(tile.hex) # remove tile from its previous hex
	
	hex_map.map.insert(hex, tile) # add tile to map at new hex
	tile.move(hex, hex_map.layout.hex_to_pixel(hex)) # move tile physically to new hex
	return existing_tile


## Creates a new tile (a Control with a Polygon2D child)
func add_tile() -> DraggableTile:
	var origin_hex: Hex = Hex.from_axial(Vector2(0,0))
	var tile_polygon: Polygon2D = HexDraw.draw_hex(origin_hex, hex_map.layout, tile_style.instantiate())
	var tile: DraggableTile = DraggableTile.new()
	tile.initialize(origin_hex, tile_polygon)
	return tile


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT and not get_viewport().gui_is_dragging():
			var clicked_hex: Hex = hex_map.get_hex_at_pixel(map_center.get_local_mouse_position())
			var clicked_tile: DraggableTile = hex_map.map.get_data(clicked_hex)
			if clicked_tile != null:
				_start_drag(clicked_tile)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var at_position_local: Vector2 = at_position - map_center.global_position
	var hovered_hex: Hex = hex_map.get_hex_at_pixel(at_position_local)
	return hex_map.map.has(hovered_hex)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	var at_position_local: Vector2 = at_position - map_center.global_position
	var drop_hex: Hex = hex_map.get_hex_at_pixel(at_position_local)
	var occupying_tile: DraggableTile = move_tile(data, drop_hex)
	if occupying_tile != null:
		_start_drag(occupying_tile)


func _start_drag(tile: DraggableTile) -> void:
	var drag_preview: Draggable = Draggable.new(null, tile, tile.duplicate() as DraggableTile)
	drag_preview.drag_completed.connect(_on_drag_end)
	tile.hide()
	call_deferred("force_drag", tile, drag_preview)


## Since _drop_data only gets called when a drag-and-drop is successful, this allows (in combo with Draggable)
## to do things we might want to do at the end of any drag, successful or not
func _on_drag_end(draggable: Draggable) -> void:
	draggable.object.show()


func _on_add_hex_tile_button_pressed() -> void:
	var origin_hex: Hex = Hex.from_axial(Vector2(0,0))
	var tile: DraggableTile = add_tile()
	var occupying_tile: DraggableTile = move_tile(tile, origin_hex)
	
	if occupying_tile != null:
		_start_drag(occupying_tile)

	map_center.add_child(tile)
