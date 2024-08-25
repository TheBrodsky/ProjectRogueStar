extends Node2D

@export var size: Vector2 = Vector2(40, 40)

@onready var origin: Marker2D = $Origin


func _ready() -> void:
	var map: HexMap = TriangleHexMap.new_map(3, 1)
	var layout: HexLayout = HexLayout.new_layout(HexLayout.Orientation.POINTY as int, size, origin.position)
	var line_style: Line2D = Line2D.new()
	line_style.width = 3
	
	var drawn_hexes: Array[Line2D] = HexDraw.draw_map(map, layout, line_style)
	for hex in drawn_hexes:
		add_child(hex)
